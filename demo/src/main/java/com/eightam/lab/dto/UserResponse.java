package com.eightam.lab.dto;

public class UserResponse {
    private Long id;
    private String username;
    private String displayName;
    private String role;
    private String avatar;
    private Long merchantId;
    private String merchantName;

    public UserResponse() {
    }

    public UserResponse(Long id, String username, String displayName, String role,
                        String avatar, Long merchantId, String merchantName) {
        this.id = id;
        this.username = username;
        this.displayName = displayName;
        this.role = role;
        this.avatar = avatar;
        this.merchantId = merchantId;
        this.merchantName = merchantName;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
    }

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
    }
}
