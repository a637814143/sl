package com.eightam.lab.dto;

public record OrderOverview(
        long received,
        long preparing,
        long ready,
        long completed,
        String topDrink
) {
}
