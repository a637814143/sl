package com.eightam.lab.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "drink_orders")
public class DrinkOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String customerName;

    @Column(nullable = false)
    private String contactPhone;

    @Column(nullable = false)
    private int quantity;

    private String pickupTime;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private OrderStatus status;

    @ManyToOne(optional = false)
    @JoinColumn(name = "merchant_id")
    private Merchant merchant;

    @ManyToOne(optional = false)
    @JoinColumn(name = "merchant_product_id")
    private MerchantProduct merchantProduct;

    @ManyToOne(optional = false)
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "price_snapshot", precision = 10, scale = 2)
    private BigDecimal priceSnapshot;

    @Column(name = "product_name_snapshot", length = 255)
    private String productNameSnapshot;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "payment_trade_no", length = 64)
    private String paymentTradeNo;

    @Column(name = "payment_status", length = 32)
    private String paymentStatus;

    @Column(name = "payment_amount", precision = 10, scale = 2)
    private BigDecimal paymentAmount;

    @Column(name = "paid_at")
    private LocalDateTime paidAt;

    protected DrinkOrder() {
    }

    public DrinkOrder(String customerName, String contactPhone, int quantity, String pickupTime,
                      OrderStatus status, Merchant merchant, MerchantProduct merchantProduct,
                      Product product, BigDecimal priceSnapshot, String productNameSnapshot,
                      LocalDateTime createdAt) {
        this.customerName = customerName;
        this.contactPhone = contactPhone;
        this.quantity = quantity;
        this.pickupTime = pickupTime;
        this.status = status;
        this.merchant = merchant;
        this.merchantProduct = merchantProduct;
        this.product = product;
        this.priceSnapshot = priceSnapshot;
        this.productNameSnapshot = productNameSnapshot;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public int getQuantity() {
        return quantity;
    }

    public String getPickupTime() {
        return pickupTime;
    }

    public OrderStatus getStatus() {
        return status;
    }

    public Merchant getMerchant() {
        return merchant;
    }

    public MerchantProduct getMerchantProduct() {
        return merchantProduct;
    }

    public Product getProduct() {
        return product;
    }

    public BigDecimal getPriceSnapshot() {
        return priceSnapshot;
    }

    public void setPriceSnapshot(BigDecimal priceSnapshot) {
        this.priceSnapshot = priceSnapshot;
    }

    public String getProductNameSnapshot() {
        return productNameSnapshot;
    }

    public void setProductNameSnapshot(String productNameSnapshot) {
        this.productNameSnapshot = productNameSnapshot;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setStatus(OrderStatus status) {
        this.status = status;
    }

    public String getPaymentTradeNo() {
        return paymentTradeNo;
    }

    public void setPaymentTradeNo(String paymentTradeNo) {
        this.paymentTradeNo = paymentTradeNo;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public BigDecimal getPaymentAmount() {
        return paymentAmount;
    }

    public void setPaymentAmount(BigDecimal paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public BigDecimal resolveUnitPrice() {
        if (priceSnapshot != null) {
            return priceSnapshot;
        }
        if (merchantProduct != null && merchantProduct.getEffectivePrice() != null) {
            return merchantProduct.getEffectivePrice();
        }
        return product != null ? product.getBasePrice() : null;
    }

    public String resolveProductName() {
        if (productNameSnapshot != null && !productNameSnapshot.isBlank()) {
            return productNameSnapshot;
        }
        if (merchantProduct != null && merchantProduct.getDisplayName() != null) {
            return merchantProduct.getDisplayName();
        }
        return product != null ? product.getName() : null;
    }
}
