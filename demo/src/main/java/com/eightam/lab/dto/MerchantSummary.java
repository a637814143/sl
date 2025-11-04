package com.eightam.lab.dto;

public record MerchantSummary(
        Long id,
        String name,
        String contact,
        String location,
        String signatureStory
) {
}
