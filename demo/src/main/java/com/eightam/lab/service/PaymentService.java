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
        Map<String, String> gatewayParams = buildGatewayParams(tradeNo, subject, body, totalAmount, returnUrl);
        String payUrl = buildPayUrl(gatewayParams);
        String payPageHtml = alipayProperties.isFetchPage() ? fetchPayPage(gatewayParams) : null;

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
