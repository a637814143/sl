package com.eightam.lab.dto;

public class UserResponse {
    private Long id;
    private String username;
    private String displayName;
    private String familyName;
    private String givenName;
    private String gender;
    private String phone;
    private String birthday;
    private String role;
    private String avatar;
    private Long merchantId;
    private String merchantName;
    private int points;
    private String membershipLevel;
    private String membershipLabel;

    public UserResponse() {
    }

    public UserResponse(Long id, String username, String displayName,
                        String familyName, String givenName,
                        String gender, String phone, String birthday,
                        String role, String avatar, Long merchantId, String merchantName,
                        int points, String membershipLevel, String membershipLabel) {
        this.id = id;
        this.username = username;
        this.displayName = displayName;
        this.familyName = familyName;
        this.givenName = givenName;
        this.gender = gender;
        this.phone = phone;
        this.birthday = birthday;
        this.role = role;
        this.avatar = avatar;
        this.merchantId = merchantId;
        this.merchantName = merchantName;
        this.points = points;
        this.membershipLevel = membershipLevel;
        this.membershipLabel = membershipLabel;
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

    public String getFamilyName() {
        return familyName;
    }

    public void setFamilyName(String familyName) {
        this.familyName = familyName;
    }

    public String getGivenName() {
        return givenName;
    }

    public void setGivenName(String givenName) {
        this.givenName = givenName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
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

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public String getMembershipLevel() {
        return membershipLevel;
    }

    public void setMembershipLevel(String membershipLevel) {
        this.membershipLevel = membershipLevel;
    }

    public String getMembershipLabel() {
        return membershipLabel;
    }

    public void setMembershipLabel(String membershipLabel) {
        this.membershipLabel = membershipLabel;
    }
}
