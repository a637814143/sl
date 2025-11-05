package com.eightam.lab.dto;

public record AdminDashboardResponse(
        long drinkCount,
        long merchantCount,
        long orderCount,
        long userCount,
        String topDrink
) {
}
