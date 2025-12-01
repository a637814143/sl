package com.eightam.lab.dto;

import jakarta.validation.constraints.NotEmpty;

import java.util.List;

public record CreateAlipayPaymentRequest(
        @NotEmpty(message = "至少需要一个订单用于支付")
        List<Long> orderIds,
        String returnUrl
) {
}
