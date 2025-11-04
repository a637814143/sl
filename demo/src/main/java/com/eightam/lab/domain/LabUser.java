package com.eightam.lab.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "lab_users")
public class LabUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String displayName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserRole role;

    private String avatar;

    protected LabUser() {
    }

    public LabUser(String displayName, UserRole role, String avatar) {
        this.displayName = displayName;
        this.role = role;
        this.avatar = avatar;
    }

    public Long getId() {
        return id;
    }

    public String getDisplayName() {
        return displayName;
    }

    public UserRole getRole() {
        return role;
    }

    public String getAvatar() {
        return avatar;
    }
}
