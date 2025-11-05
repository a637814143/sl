package com.eightam.lab.dto;

import java.math.BigDecimal;

public class DrinkSummary {

    private Long id;
    private String name;
    private BigDecimal price;
    private String description;
    private String imageUrl;
    private String flavorProfile;
    private String merchantName;

    public DrinkSummary() {
    }

    public DrinkSummary(Long id,
                        String name,
                        BigDecimal price,
                        String description,
                        String imageUrl,
                        String flavorProfile,
                        String merchantName) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.description = description;
        this.imageUrl = imageUrl;
        this.flavorProfile = flavorProfile;
        this.merchantName = merchantName;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
    }
}
