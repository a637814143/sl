package com.eightam.lab.dto;

import java.math.BigDecimal;

public record DrinkSummary(
        Long id,
        String name,
        BigDecimal price,
        String description,
        String imageUrl,
        String flavorProfile,
        String merchantName
) {
}
