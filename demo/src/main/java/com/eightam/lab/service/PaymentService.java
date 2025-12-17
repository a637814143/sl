package com.eightam.lab.service;

import com.eightam.lab.config.AlipayProperties;
import com.eightam.lab.dto.AlipayPaymentResponse;
import com.eightam.lab.dto.CreateAlipayPaymentRequest;
import com.eightam.lab.entity.DrinkOrder;
import com.eightam.lab.repository.DrinkOrderRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.Comparator;
import java.time.Duration;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.stream.Collectors;

@Service
public class PaymentService {

    private static final Logger log = LoggerFactory.getLogger(PaymentService.class);
    private static final DateTimeFormatter ALIPAY_DATETIME =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss", Locale.CHINA);

    private final DrinkOrderRepository orderRepository;
    private final AlipayProperties alipayProperties;
    private volatile PrivateKey cachedPrivateKey;
    private volatile PublicKey cachedPublicKey;

    public PaymentService(DrinkOrderRepository orderRepository, AlipayProperties alipayProperties) {
        this.orderRepository = orderRepository;
        this.alipayProperties = alipayProperties;
    }

    @Transactional
    public AlipayPaymentResponse createAlipayPayment(CreateAlipayPaymentRequest request) {
        List<Long> orderIds = request.orderIds()
                .stream()
                .filter(id -> id != null && id > 0)
                .distinct()
                .toList();
        if (orderIds.isEmpty()) {
            throw new IllegalArgumentException("未提供有效的订单编号");
        }
        List<DrinkOrder> orders = orderRepository.findAllById(orderIds);
        if (orders.size() != orderIds.size()) {
            throw new IllegalArgumentException("部分订单不存在，请刷新后重试");
        }
        if (orders.stream().anyMatch(order -> "SUCCESS".equalsIgnoreCase(order.getPaymentStatus()))) {
            throw new IllegalStateException("部分订单已支付，请勿重复付款");
        }

        BigDecimal totalAmount = calculateTotalAmount(orders);
        if (totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalStateException("订单金额无效，无法发起支付");
        }

        String tradeNo = resolveTradeNo(orders);
        orders.forEach(order -> {
            order.setPaymentTradeNo(tradeNo);
            order.setPaymentStatus("PENDING");
            order.setPaymentAmount(totalAmount);
        });
        orderRepository.saveAll(orders);

        String subject = buildSubject(orders);
        String body = buildBody(orders, totalAmount);
        String returnUrl = StringUtils.hasText(request.returnUrl())
                ? request.returnUrl()
                : alipayProperties.getReturnUrl();
        if (alipayProperties.isMockMode()) {
            String mockPage = buildMockPayPage(tradeNo, totalAmount, returnUrl);
            return new AlipayPaymentResponse(tradeNo, totalAmount, null, orders.size(), mockPage);
        }
        Map<String, String> gatewayParams = buildGatewayParams(tradeNo, subject, body, totalAmount, returnUrl);
        String payUrl = buildPayUrl(gatewayParams);
        String payPageHtml = resolvePayPageHtml(gatewayParams);

        return new AlipayPaymentResponse(tradeNo, totalAmount, payUrl, orders.size(), payPageHtml);
    }

    @Transactional
    public String handleAlipayNotify(Map<String, String> params) {
        if (params == null || params.isEmpty()) {
            return "failure";
        }
        if (!verifySignature(params)) {
            log.warn("支付宝通知验签失败：{}", params);
            return "failure";
        }
        String tradeStatus = params.get("trade_status");
        if (!"TRADE_SUCCESS".equalsIgnoreCase(tradeStatus)
                && !"TRADE_FINISHED".equalsIgnoreCase(tradeStatus)) {
            return "success";
        }
        String tradeNo = params.get("out_trade_no");
        if (!StringUtils.hasText(tradeNo)) {
            return "failure";
        }
        List<DrinkOrder> orders = orderRepository.findAllByPaymentTradeNo(tradeNo);
        if (orders.isEmpty()) {
            log.warn("未找到支付单对应的订单，tradeNo={}", tradeNo);
            return "success";
        }
        BigDecimal notifyAmount = parseAmount(params.get("total_amount"));
        BigDecimal localAmount = calculateTotalAmount(orders);
        if (notifyAmount.compareTo(localAmount) != 0) {
            log.error("支付金额不一致，tradeNo={} local={} notify={}", tradeNo, localAmount, notifyAmount);
            return "failure";
        }
        LocalDateTime paidAt = parseTime(params.get("gmt_payment"));
        orders.forEach(order -> {
            order.setPaymentStatus(tradeStatus);
            order.setPaidAt(paidAt != null ? paidAt : LocalDateTime.now());
        });
        orderRepository.saveAll(orders);
        return "success";
    }

    @Transactional
    public void confirmMockPayment(String tradeNo) {
        if (!alipayProperties.isMockMode()) {
            throw new IllegalStateException("未开启模拟支付模式");
        }
        if (!StringUtils.hasText(tradeNo)) {
            throw new IllegalArgumentException("tradeNo 不能为空");
        }
        List<DrinkOrder> orders = orderRepository.findAllByPaymentTradeNo(tradeNo);
        if (orders.isEmpty()) {
            throw new IllegalArgumentException("未找到需要更新的订单");
        }
        LocalDateTime now = LocalDateTime.now();
        orders.forEach(order -> {
            order.setPaymentStatus("SUCCESS");
            order.setPaidAt(now);
        });
        orderRepository.saveAll(orders);
    }

    public boolean verifyReturn(Map<String, String> params) {
        return verifySignature(params);
    }

    private BigDecimal calculateTotalAmount(List<DrinkOrder> orders) {
        return orders.stream()
                .map(order -> order.resolveUnitPrice()
                        .multiply(BigDecimal.valueOf(order.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private String buildSubject(List<DrinkOrder> orders) {
        if (orders.size() == 1) {
            return "8AM灵感饮品-" + orders.get(0).resolveProductName();
        }
        return "8AM灵感饮品等" + orders.size() + "件";
    }

    private String buildBody(List<DrinkOrder> orders, BigDecimal totalAmount) {
        return "门店:" + orders.get(0).getMerchant().getName() + "，共" + orders.size() + "笔，金额¥" + totalAmount;
    }

    private String resolveTradeNo(List<DrinkOrder> orders) {
        Set<String> existingTradeNos = orders.stream()
                .map(DrinkOrder::getPaymentTradeNo)
                .filter(StringUtils::hasText)
                .collect(Collectors.toSet());
        if (existingTradeNos.size() == 1) {
            return existingTradeNos.iterator().next();
        }
        long baseId = orders.stream()
                .map(DrinkOrder::getId)
                .filter(id -> id != null && id > 0)
                .min(Comparator.naturalOrder())
                .orElse(System.currentTimeMillis());
        return "PAY" + baseId + System.currentTimeMillis();
    }

    private Map<String, String> buildGatewayParams(
            String tradeNo,
            String subject,
            String body,
            BigDecimal amount,
            String returnUrl
    ) {
        Map<String, String> params = new TreeMap<>();
        params.put("app_id", require(alipayProperties.getAppId(), "未配置支付宝 APP_ID"));
        params.put("method", "alipay.trade.page.pay");
        params.put("format", "JSON");
        params.put("charset", "utf-8");
        params.put("sign_type", alipayProperties.getSignType());
        params.put("timestamp", LocalDateTime.now().format(ALIPAY_DATETIME));
        params.put("version", "1.0");
        params.put("return_url", require(returnUrl, "未配置 return_url"));
        params.put("notify_url", require(alipayProperties.getNotifyUrl(), "未配置 notify_url"));
        params.put("biz_content", buildBizContent(tradeNo, subject, body, amount));

        String content = buildSignContent(params);
        String signature = sign(content);
        params.put("sign", signature);
        return params;
    }

    private String buildPayUrl(Map<String, String> params) {
        return alipayProperties.getGateway() + "?" + buildQuery(params);
    }

    private String buildBizContent(String tradeNo, String subject, String body, BigDecimal amount) {
        return new StringBuilder("{")
                .append("\"out_trade_no\":\"").append(tradeNo).append("\",")
                .append("\"product_code\":\"FAST_INSTANT_TRADE_PAY\",")
                .append("\"total_amount\":\"").append(amount.toPlainString()).append("\",")
                .append("\"subject\":\"").append(escapeJson(subject)).append("\",")
                .append("\"body\":\"").append(escapeJson(body)).append("\"}")
                .toString();
    }

    private String escapeJson(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private String buildSignContent(Map<String, String> params) {
        return params.entrySet().stream()
                .filter(entry -> StringUtils.hasText(entry.getValue()))
                .map(entry -> entry.getKey() + "=" + entry.getValue())
                .collect(Collectors.joining("&"));
    }

    private String buildQuery(Map<String, String> params) {
        return params.entrySet().stream()
                .filter(entry -> entry.getValue() != null)
                .map(entry -> entry.getKey() + "=" + urlEncode(entry.getValue()))
                .collect(Collectors.joining("&"));
    }

    private String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private String fetchPayPage(Map<String, String> params) {
        try {
            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(5))
                    .build();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(alipayProperties.getGateway()))
                    .header("Content-Type", "application/x-www-form-urlencoded;charset=utf-8")
                    .POST(HttpRequest.BodyPublishers.ofString(buildQuery(params)))
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            if (response.statusCode() == 200) {
                return response.body();
            }
            log.warn("Failed to fetch Alipay page, status={}", response.statusCode());
        } catch (Exception ex) {
            log.warn("Fetch Alipay page failed", ex);
        }
        return null;
    }

    private String resolvePayPageHtml(Map<String, String> gatewayParams) {
        String html = null;
        if (alipayProperties.isFetchPage()) {
            html = fetchPayPage(gatewayParams);
        }
        if (!StringUtils.hasText(html)) {
            html = buildAutoSubmitForm(gatewayParams);
        }
        return html;
    }

    private String buildAutoSubmitForm(Map<String, String> params) {
        String action = alipayProperties.getGateway();
        if (!StringUtils.hasText(action)) {
            action = "https://openapi.alipaydev.com/gateway.do";
        }
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>");
        html.append("<html lang='zh-CN'>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<meta name='viewport' content='width=device-width, initial-scale=1'>");
        html.append("<title>正在跳转支付宝</title>");
        html.append("<style>body{font-family:-apple-system,BlinkMacSystemFont,'PingFang SC','Microsoft YaHei',sans-serif;background:#f5f5f5;margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;color:#333;} .panel{background:#fff;padding:32px;border-radius:18px;box-shadow:0 10px 40px rgba(17,38,146,0.15);text-align:center;max-width:420px;margin:24px;} h1{font-size:20px;margin:0 0 12px;} p{margin:0 0 24px;color:#666;} button{background:#1677ff;color:#fff;border:none;border-radius:999px;padding:12px 28px;font-size:16px;cursor:pointer;} button:focus{outline:none;} </style>");
        html.append("</head>");
        html.append("<body>");
        html.append("<div class='panel'>");
        html.append("<h1>正在拉起支付宝</h1>");
        html.append("<p>请稍候，若未自动跳转可点击下方按钮。</p>");
        html.append("<form id='alipayForm' method='post' action='").append(escapeHtml(action)).append("'>");
        params.forEach((key, value) -> {
            if (value != null) {
                html.append("<input type='hidden' name='")
                        .append(escapeHtml(key))
                        .append("' value='")
                        .append(escapeHtml(value))
                        .append("'/>");
            }
        });
        html.append("<button type='submit'>立即前往支付</button>");
        html.append("</form>");
        html.append("</div>");
        html.append("<script>setTimeout(function(){var form=document.getElementById('alipayForm');if(form){form.submit();}},300);</script>");
        html.append("</body>");
        html.append("</html>");
        return html.toString();
    }

    private String buildMockPayPage(String tradeNo, BigDecimal totalAmount, String returnUrl) {
        String safeReturn = StringUtils.hasText(returnUrl) ? returnUrl : "/";
        String amountText = totalAmount != null ? totalAmount.toPlainString() : "0.00";
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>");
        html.append("<html lang='zh-CN'>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1'>");
        html.append("<title>模拟支付宝支付</title>");
        html.append("<style>");
        html.append(
                "body{font-family:-apple-system,BlinkMacSystemFont,'PingFang SC','Microsoft YaHei',sans-serif;background:#f5f7fb;margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;color:#1d2129;}");
        html.append(
                ".panel{background:#fff;padding:32px 28px;border-radius:24px;box-shadow:0 20px 60px rgba(15,23,42,0.12);max-width:460px;width:92%;text-align:center;}");
        html.append(".badge{display:inline-flex;padding:6px 12px;border-radius:999px;background:#e8f3ff;color:#1677ff;font-size:12px;margin-bottom:20px;}");
        html.append("h1{font-size:22px;margin:0 0 12px;}");
        html.append(".amount{font-size:32px;margin:8px 0 24px;font-weight:600;color:#1677ff;}");
        html.append(".status{color:#666;font-size:14px;margin-bottom:24px;}");
        html.append("button{width:100%;border:none;border-radius:16px;padding:14px 18px;font-size:16px;font-weight:600;margin-bottom:12px;cursor:pointer;}");
        html.append(".primary{background:linear-gradient(135deg,#1677ff,#4096ff);color:#fff;}");
        html.append(".ghost{background:#f2f5fb;color:#3a3d45;}");
        html.append(".tips{font-size:12px;color:#999;margin-top:12px;}");
        html.append("</style>");
        html.append("</head>");
        html.append("<body>");
        html.append("<div class='panel'>");
        html.append("<div class='badge'>模拟支付</div>");
        html.append("<h1>模拟支付宝支付</h1>");
        html.append("<div class='amount'>¥ ").append(escapeHtml(amountText)).append("</div>");
        html.append("<p class='status'>将模拟扣款并返回小程序</p>");
        html.append("<button class='primary' onclick=\"mockPay()\">确认支付（模拟）</button>");
        html.append("<button class='ghost' onclick=\"backToApp()\">取消并返回</button>");
        html.append("<p class='tips'>提示：仅用于演示，不会真实扣款</p>");
        html.append("<form id='mockFallbackForm' target='_blank' method='post' action='/api/payments/alipay/mock-success'>");
        html.append("<input type='hidden' name='tradeNo' value='").append(escapeHtml(tradeNo)).append("'/>");
        html.append("</form>");
        html.append("</div>");
        html.append("<script>");
        html.append("const tradeNo=").append(jsStringLiteral(tradeNo)).append(";");
        html.append("const returnUrl=").append(jsStringLiteral(safeReturn)).append(";");
        html.append("function mockPay(){");
        html.append("const btn=document.querySelector('.primary');if(btn){btn.disabled=true;btn.innerText='支付处理中...';}");
        html.append("fetch('/api/payments/alipay/mock-success?tradeNo='+encodeURIComponent(tradeNo),{method:'POST'})");
        html.append(".then(()=>{const status=document.querySelector('.status');if(status){status.innerText='支付成功（模拟），即将返回';}");
        html.append("setTimeout(()=>{if(returnUrl&&returnUrl!=='null'){window.location.href=returnUrl;}},700);})");
        html.append(".catch(()=>{alert('同步失败，请稍后在“我的-订单中心”查看状态');if(btn){btn.disabled=false;btn.innerText='确认支付（模拟）';}});}");
        html.append("function backToApp(){if(returnUrl&&returnUrl!=='null'){window.location.href=returnUrl;}}");
        html.append("</script>");
        html.append("</body>");
        html.append("</html>");
        return html.toString();
    }

    private String escapeHtml(String text) {
        if (text == null) {
            return "";
        }
        return text
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String jsStringLiteral(String text) {
        if (text == null) {
            return "null";
        }
        String escaped = text
                .replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
        return "'" + escaped + "'";
    }

    private String sign(String content) {
        try {
            Signature signature = Signature.getInstance("SHA256withRSA");
            signature.initSign(resolvePrivateKey());
            signature.update(content.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(signature.sign());
        } catch (Exception ex) {
            throw new IllegalStateException("签名失败，请检查私钥配置", ex);
        }
    }

    private boolean verifySignature(Map<String, String> params) {
        try {
            String sign = params.get("sign");
            if (!StringUtils.hasText(sign)) {
                return false;
            }
            Map<String, String> sorted = new TreeMap<>();
            params.forEach((key, value) -> {
                if (!"sign".equals(key) && value != null) {
                    sorted.put(key, value);
                }
            });
            String content = buildSignContent(sorted);
            Signature signature = Signature.getInstance("SHA256withRSA");
            signature.initVerify(resolvePublicKey());
            signature.update(content.getBytes(StandardCharsets.UTF_8));
            return signature.verify(Base64.getDecoder().decode(sign));
        } catch (Exception ex) {
            log.error("支付宝签名验证异常", ex);
            return false;
        }
    }

    private PrivateKey resolvePrivateKey() {
        if (cachedPrivateKey == null) {
            synchronized (this) {
                if (cachedPrivateKey == null) {
                    cachedPrivateKey = loadPrivateKey(alipayProperties.getPrivateKey());
                }
            }
        }
        return cachedPrivateKey;
    }

    private PublicKey resolvePublicKey() {
        if (cachedPublicKey == null) {
            synchronized (this) {
                if (cachedPublicKey == null) {
                    cachedPublicKey = loadPublicKey(alipayProperties.getPublicKey());
                }
            }
        }
        return cachedPublicKey;
    }

    private PrivateKey loadPrivateKey(String key) {
        try {
            String cleaned = stripKeyHeader(key, "-----BEGIN PRIVATE KEY-----", "-----END PRIVATE KEY-----");
            byte[] decoded = Base64.getDecoder().decode(cleaned);
            PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(decoded);
            return KeyFactory.getInstance("RSA").generatePrivate(keySpec);
        } catch (Exception ex) {
            throw new IllegalStateException("解析支付宝私钥失败，请确认配置", ex);
        }
    }

    private PublicKey loadPublicKey(String key) {
        try {
            String cleaned = stripKeyHeader(key, "-----BEGIN PUBLIC KEY-----", "-----END PUBLIC KEY-----");
            byte[] decoded = Base64.getDecoder().decode(cleaned);
            X509EncodedKeySpec keySpec = new X509EncodedKeySpec(decoded);
            return KeyFactory.getInstance("RSA").generatePublic(keySpec);
        } catch (Exception ex) {
            throw new IllegalStateException("解析支付宝公钥失败，请确认配置", ex);
        }
    }

    private String stripKeyHeader(String key, String prefix, String suffix) {
        if (!StringUtils.hasText(key)) {
            throw new IllegalStateException("未配置支付宝密钥");
        }
        return key
                .replace(prefix, "")
                .replace(suffix, "")
                .replaceAll("\\s", "");
    }

    private BigDecimal parseAmount(String text) {
        try {
            return new BigDecimal(text);
        } catch (Exception ex) {
            return BigDecimal.ZERO;
        }
    }

    private LocalDateTime parseTime(String text) {
        if (!StringUtils.hasText(text)) {
            return null;
        }
        try {
            return LocalDateTime.parse(text, ALIPAY_DATETIME);
        } catch (Exception ex) {
            return null;
        }
    }

    private String require(String value, String message) {
        if (!StringUtils.hasText(value)) {
            throw new IllegalStateException(message);
        }
        return value;
    }
}
