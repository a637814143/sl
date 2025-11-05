package com.eightam.lab.dto;

import java.time.LocalDateTime;

public class MerchantOrderView {

    private Long id;
    private String drinkName;
    private int quantity;
    private String status;
    private String pickupTime;
    private LocalDateTime createdAt;
    private String customerName;
    private String contactPhone;

    public MerchantOrderView() {
    }

    public MerchantOrderView(Long id,
                             String drinkName,
                             int quantity,
                             String status,
                             String pickupTime,
                             LocalDateTime createdAt,
                             String customerName,
                             String contactPhone) {
        this.id = id;
        this.drinkName = drinkName;
        this.quantity = quantity;
        this.status = status;
        this.pickupTime = pickupTime;
        this.createdAt = createdAt;
        this.customerName = customerName;
        this.contactPhone = contactPhone;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDrinkName() {
        return drinkName;
    }

    public void setDrinkName(String drinkName) {
        this.drinkName = drinkName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(String pickupTime) {
        this.pickupTime = pickupTime;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
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
}
