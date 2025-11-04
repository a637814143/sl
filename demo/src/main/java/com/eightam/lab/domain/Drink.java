package com.eightam.lab.domain;

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

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private BigDecimal price;

    @Column(length = 1024)
    private String description;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "flavor_profile")
    private String flavorProfile;

    @Column(name = "is_available")
    private boolean available;

    @ManyToOne
    private Merchant merchant;

    protected Drink() {
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

    public BigDecimal getPrice() {
        return price;
    }

    public String getDescription() {
        return description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public String getFlavorProfile() {
        return flavorProfile;
    }

    public boolean isAvailable() {
        return available;
    }

    public Merchant getMerchant() {
        return merchant;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }
}
