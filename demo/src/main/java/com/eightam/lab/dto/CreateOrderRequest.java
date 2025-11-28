package com.eightam.lab.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class CreateOrderRequest {

    @NotBlank(message = "请填写称呼")
    private String customerName;

    @NotBlank(message = "请输入联系电话")
    private String contactPhone;

    @NotNull(message = "请选择饮品")
    private Long drinkId;

    @NotNull(message = "请选择门店")
    private Long merchantId;

    @Min(value = 1, message = "至少选择一杯")
    private int quantity;

    private String pickupTime;

    public CreateOrderRequest() {
    }

    public CreateOrderRequest(String customerName,
                              String contactPhone,
                              Long drinkId,
                              Long merchantId,
                              int quantity,
                              String pickupTime) {
        this.customerName = customerName;
        this.contactPhone = contactPhone;
        this.drinkId = drinkId;
        this.merchantId = merchantId;
        this.quantity = quantity;
        this.pickupTime = pickupTime;
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

    public Long getDrinkId() {
        return drinkId;
    }

    public void setDrinkId(Long drinkId) {
        this.drinkId = drinkId;
    }

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
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
}
