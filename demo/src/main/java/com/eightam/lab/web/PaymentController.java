package com.eightam.lab.web;

import com.eightam.lab.dto.AlipayPaymentResponse;
import com.eightam.lab.dto.CreateAlipayPaymentRequest;
import com.eightam.lab.service.PaymentService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/payments")
@CrossOrigin
public class PaymentController {

    private static final Logger log = LoggerFactory.getLogger(PaymentController.class);

    private final PaymentService paymentService;

    public PaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @PostMapping("/alipay")
    public AlipayPaymentResponse createPayment(@Valid @RequestBody CreateAlipayPaymentRequest request) {
        AlipayPaymentResponse response = paymentService.createAlipayPayment(request);
        // log.info("Created payment: tradeNo={}, payUrl={}, hasHtml={}", response.tradeNo(), response.payUrl(),
        //         response.payPageHtml() != null);
        return response;
    }

    @PostMapping(value = "/alipay/notify", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    public String handleNotify(HttpServletRequest request) {
        Map<String, String> params = extractParams(request);
        return paymentService.handleAlipayNotify(params);
    }

    @GetMapping("/alipay/return")
    public ResponseEntity<String> handleReturn(@RequestParam Map<String, String> params) {
        boolean verified = paymentService.verifyReturn(params);
        if (verified) {
            return ResponseEntity.ok("支付请求已提交，返回应用即可查看最新状态");
        }
        return ResponseEntity.badRequest().body("验签失败，请联系客服确认支付结果");
    }

    @PostMapping("/alipay/mock-success")
    public ResponseEntity<String> mockSuccess(@RequestParam("tradeNo") String tradeNo) {
        paymentService.confirmMockPayment(tradeNo);
        return ResponseEntity.ok("success");
    }

    private Map<String, String> extractParams(HttpServletRequest request) {
        Map<String, String[]> parameterMap = request.getParameterMap();
        Map<String, String> flat = new HashMap<>(parameterMap.size());
        parameterMap.forEach((key, values) -> {
            if (values != null && values.length > 0) {
                flat.put(key, values[0]);
            }
        });
        return flat;
    }
}
