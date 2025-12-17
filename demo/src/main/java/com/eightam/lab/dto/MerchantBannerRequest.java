package com.eightam.lab.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class MerchantBannerRequest {

    @NotBlank(message = "è¯·æä¾›è½®æ’­å›¾åœ°å€")
    private String imageUrl;

    @Size(max = 255, message = "æ ‡é¢˜æœ€å¤255ä¸ªå­ç¬¦")
    private String caption;

    private Integer displayOrder;

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }
}
