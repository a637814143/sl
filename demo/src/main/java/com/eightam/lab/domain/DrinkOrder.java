package com.eightam.lab.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

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
    private Drink drink;

    @ManyToOne(optional = false)
    private Merchant merchant;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    protected DrinkOrder() {
    }

    public DrinkOrder(String customerName, String contactPhone, int quantity, String pickupTime,
                      OrderStatus status, Drink drink, Merchant merchant, LocalDateTime createdAt) {
        this.customerName = customerName;
        this.contactPhone = contactPhone;
        this.quantity = quantity;
        this.pickupTime = pickupTime;
        this.status = status;
        this.drink = drink;
        this.merchant = merchant;
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

    public Drink getDrink() {
        return drink;
    }

    public Merchant getMerchant() {
        return merchant;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setStatus(OrderStatus status) {
        this.status = status;
    }
}
