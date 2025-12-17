package com.eightam.lab.dto;

import java.time.LocalDateTime;
import java.util.Map;

public record MerchantOrderView(
        Long id,
        String drinkName,
        int quantity,
        String status,
        String pickupTime,
        LocalDateTime createdAt,
        String customerName,
        String contactPhone,
        String customSummary,
        Map<String, String> customizations
) {
}
