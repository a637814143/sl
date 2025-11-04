package com.eightam.lab.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateOrderRequest(
        @NotBlank(message = "请填写称呼")
        String customerName,
        @NotBlank(message = "请输入联系电话")
        String contactPhone,
        @NotNull(message = "请选择饮品")
        Long drinkId,
        @NotNull(message = "请选择门店")
        Long merchantId,
        @Min(value = 1, message = "至少选择一杯")
        int quantity,
        String pickupTime
) {
}
