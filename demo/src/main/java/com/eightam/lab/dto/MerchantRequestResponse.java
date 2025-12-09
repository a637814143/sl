package com.eightam.lab.dto;

import java.time.LocalDateTime;

public record MerchantRequestResponse(
        Long id,
        String merchantName,
        String applicantName,
        String contactPhone,
        String location,
        String note,
        String status,
        LocalDateTime createdAt,
        LocalDateTime processedAt
) {
}
