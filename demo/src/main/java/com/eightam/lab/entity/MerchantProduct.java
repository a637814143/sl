package com.eightam.lab.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "merchant_products",
        uniqueConstraints = @UniqueConstraint(name = "uk_merchant_products", columnNames = {"merchant_id", "product_id"}))
public class MerchantProduct {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "merchant_id")
    private Merchant merchant;

    @ManyToOne(optional = false)
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "custom_name", length = 255)
    private String customName;

    @Column(name = "custom_price", precision = 10, scale = 2)
    private BigDecimal customPrice;

    @Column(name = "alias_code", length = 64)
    private String aliasCode;

    @Column(name = "daily_stock_limit")
    private Integer dailyStockLimit;

    @Column(name = "available_stock")
    private Integer availableStock;

    @Column(name = "available_start")
    private LocalTime availableStart;

    @Column(name = "available_end")
    private LocalTime availableEnd;

    @Column(name = "is_available", nullable = false)
    private boolean available = true;

    @Column(name = "display_order")
    private Integer displayOrder = 0;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    public void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        createdAt = now;
        updatedAt = now;
    }

    @PreUpdate
    public void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public Merchant getMerchant() {
        return merchant;
    }

    public void setMerchant(Merchant merchant) {
        this.merchant = merchant;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getCustomName() {
        return customName;
    }

    public void setCustomName(String customName) {
        this.customName = customName;
    }

    public BigDecimal getCustomPrice() {
        return customPrice;
    }

    public void setCustomPrice(BigDecimal customPrice) {
        this.customPrice = customPrice;
    }

    public String getAliasCode() {
        return aliasCode;
    }

    public void setAliasCode(String aliasCode) {
        this.aliasCode = aliasCode;
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

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public String getDisplayName() {
        if (customName != null && !customName.isBlank()) {
            return customName;
        }
        return product != null ? product.getName() : null;
    }

    public BigDecimal getEffectivePrice() {
        if (customPrice != null) {
            return customPrice;
        }
        return product != null ? product.getBasePrice() : null;
    }

    public String getDescription() {
        return product != null ? product.getDescription() : null;
    }

    public String getImageUrl() {
        return product != null ? product.getImageUrl() : null;
    }

    public String getFlavorProfile() {
        return product != null ? product.getFlavorProfile() : null;
    }

    public String getCategory() {
        return product != null ? product.getCategory() : null;
    }
}
