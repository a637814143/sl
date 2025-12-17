package com.eightam.lab.dto;

import java.time.LocalDateTime;

public record MerchantBannerResponse(
        Long id,
        Long merchantId,
        String imageUrl,
        String caption,
        Integer displayOrder,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
}
