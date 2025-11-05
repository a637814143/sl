package com.eightam.lab.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;

@Entity
@Table(name = "drinks")
public class Drink {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 128)
    private String name;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(length = 1024)
    private String description;

    @Column(name = "image_url", length = 255)
    private String imageUrl;

    @Column(name = "flavor_profile", length = 255)
    private String flavorProfile;

    @Column(name = "is_available", nullable = false)
    private boolean available = true;

    @ManyToOne
    private Merchant merchant;

    public Drink() {
    }

    public Drink(String name, BigDecimal price, String description, String imageUrl,
                 String flavorProfile, boolean available, Merchant merchant) {
        this.name = name;
        this.price = price;
        this.description = description;
        this.imageUrl = imageUrl;
        this.flavorProfile = flavorProfile;
        this.available = available;
        this.merchant = merchant;
    }

    public Long getId() {
        return id;
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

    public String getFlavorProfile() {
        return flavorProfile;
    }

    public void setFlavorProfile(String flavorProfile) {
        this.flavorProfile = flavorProfile;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public Merchant getMerchant() {
        return merchant;
    }

    public void setMerchant(Merchant merchant) {
        this.merchant = merchant;
    }
}
