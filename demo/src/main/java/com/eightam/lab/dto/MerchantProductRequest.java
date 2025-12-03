package com.eightam.lab.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalTime;

public class MerchantProductRequest {

    @NotNull(message = "请选择店铺")
    private Long merchantId;

    @NotBlank(message = "请填写商品名称")
    @Size(max = 255, message = "商品名称不能超过 255 个字符")
    private String name;

    @NotNull(message = "请填写商品价格")
    @DecimalMin(value = "0.01", message = "商品价格需大于 0")
    private BigDecimal price;

    @Size(max = 1024, message = "描述长度不能超过 1024 个字符")
    private String description;

    @Size(max = 255, message = "图片地址过长")
    private String imageUrl;

    @Size(max = 64, message = "分类长度不能超过 64 个字符")
    private String category;

    @Size(max = 255, message = "风味信息过长")
    private String flavorProfile;

    private Integer dailyStockLimit;

    private Integer availableStock;

    private LocalTime availableStart;

    private LocalTime availableEnd;

    private Boolean available;

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getFlavorProfile() {
        return flavorProfile;
    }

    public void setFlavorProfile(String flavorProfile) {
        this.flavorProfile = flavorProfile;
    }

    public Integer getDailyStockLimit() {
        return dailyStockLimit;
    }

    public void setDailyStockLimit(Integer dailyStockLimit) {
        this.dailyStockLimit = dailyStockLimit;
    }

    public Integer getAvailableStock() {
        return availableStock;
    }

    public void setAvailableStock(Integer availableStock) {
        this.availableStock = availableStock;
    }

    public LocalTime getAvailableStart() {
        return availableStart;
    }

    public void setAvailableStart(LocalTime availableStart) {
        this.availableStart = availableStart;
    }

    public LocalTime getAvailableEnd() {
        return availableEnd;
    }

    public void setAvailableEnd(LocalTime availableEnd) {
        this.availableEnd = availableEnd;
    }

    public Boolean getAvailable() {
        return available;
    }

    public void setAvailable(Boolean available) {
        this.available = available;
    }
}
