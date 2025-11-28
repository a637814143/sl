package com.eightam.lab.dto;

import java.time.LocalDateTime;

public class OrderResponse {

    private Long id;
    private String customerName;
    private String contactPhone;
    private int quantity;
    private String pickupTime;
    private String status;
    private String drinkName;
    private String merchantName;
    private LocalDateTime createdAt;

    public OrderResponse() {
    }

    public OrderResponse(Long id,
                         String customerName,
                         String contactPhone,
                         int quantity,
                         String pickupTime,
                         String status,
                         String drinkName,
                         String merchantName,
                         LocalDateTime createdAt) {
        this.id = id;
        this.customerName = customerName;
        this.contactPhone = contactPhone;
        this.quantity = quantity;
        this.pickupTime = pickupTime;
        this.status = status;
        this.drinkName = drinkName;
        this.merchantName = merchantName;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(String pickupTime) {
        this.pickupTime = pickupTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDrinkName() {
        return drinkName;
    }

    public void setDrinkName(String drinkName) {
        this.drinkName = drinkName;
    }

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
