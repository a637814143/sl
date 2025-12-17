package com.eightam.lab.dto;

import com.eightam.lab.domain.product.ProductOptionSettings;
import java.math.BigDecimal;
import java.time.LocalTime;

public record DrinkSummary(
        Long id,
        Long productId,
        Long merchantId,
        String merchantName,
        String skuCode,
        String name,
        BigDecimal basePrice,
        BigDecimal price,
        String description,
        String imageUrl,
        String flavorProfile,
        String category,
        boolean available,
        Integer dailyStockLimit,
        Integer availableStock,
        LocalTime availableStart,
        LocalTime availableEnd,
        ProductOptionSettings optionSettings
) {
}
