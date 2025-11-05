package com.eightam.lab.dto;

public class AdminDashboardResponse {

    private long drinkCount;
    private long merchantCount;
    private long orderCount;
    private long userCount;
    private String topDrink;

    public AdminDashboardResponse() {
    }

    public AdminDashboardResponse(long drinkCount,
                                  long merchantCount,
                                  long orderCount,
                                  long userCount,
                                  String topDrink) {
        this.drinkCount = drinkCount;
        this.merchantCount = merchantCount;
        this.orderCount = orderCount;
        this.userCount = userCount;
        this.topDrink = topDrink;
    }

    public long getDrinkCount() {
        return drinkCount;
    }

    public void setDrinkCount(long drinkCount) {
        this.drinkCount = drinkCount;
    }

    public long getMerchantCount() {
        return merchantCount;
    }

    public void setMerchantCount(long merchantCount) {
        this.merchantCount = merchantCount;
    }

    public long getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(long orderCount) {
        this.orderCount = orderCount;
    }

    public long getUserCount() {
        return userCount;
    }

    public void setUserCount(long userCount) {
        this.userCount = userCount;
    }

    public String getTopDrink() {
        return topDrink;
    }

    public void setTopDrink(String topDrink) {
        this.topDrink = topDrink;
    }
}
