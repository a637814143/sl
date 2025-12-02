package com.eightam.lab.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;

public class DrinkRequest {

    @Size(max = 64, message = "SKU 需在64字符以内")
    private String skuCode;

    @NotBlank(message = "饮品名称不能为空")
    @Size(max = 128, message = "饮品名称长度需在128字符以内")
    private String name;

    @NotNull(message = "请设置饮品价格")
    @DecimalMin(value = "0.0", inclusive = false, message = "饮品价格需大于0")
    private BigDecimal price;

    @Size(max = 64, message = "饮品分类需在64字符以内")
    private String category;

    @Size(max = 512, message = "饮品描述需在512字符以内")
    private String description;

    @Size(max = 255, message = "图片地址需在255字符以内")
    private String imageUrl;

    @Size(max = 255, message = "风味描述需在255字符以内")
    private String flavorProfile;

    private boolean available;

    public String getSkuCode() {
        return skuCode;
    }

    public void setSkuCode(String skuCode) {
        this.skuCode = skuCode;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
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
}
