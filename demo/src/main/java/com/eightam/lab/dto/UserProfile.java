package com.eightam.lab.dto;

public class UserProfile {

    private Long id;
    private String displayName;
    private String role;
    private String avatar;

    public UserProfile() {
    }

    public UserProfile(Long id, String displayName, String role, String avatar) {
        this.id = id;
        this.displayName = displayName;
        this.role = role;
        this.avatar = avatar;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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
}
