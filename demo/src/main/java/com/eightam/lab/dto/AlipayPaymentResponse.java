package com.eightam.lab.dto;

import java.math.BigDecimal;

public record AlipayPaymentResponse(
        String tradeNo,
        BigDecimal totalAmount,
        String payUrl,
        int orderCount
) {
}
