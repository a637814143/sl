package com.eightam.lab.dto;

import java.time.LocalDateTime;

public record MerchantOrderView(
        Long id,
        String drinkName,
        int quantity,
        String status,
        String pickupTime,
        LocalDateTime createdAt,
        String customerName,
        String contactPhone
) {
}
