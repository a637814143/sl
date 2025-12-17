package com.eightam.lab.dto;

import java.time.LocalDateTime;
import java.util.Map;

public record OrderResponse(
        Long id,
        String customerName,
        String contactPhone,
        int quantity,
        String pickupTime,
        String status,
        String drinkName,
        String merchantName,
        LocalDateTime createdAt,
        String customSummary,
        Map<String, String> customizations
) {
}
