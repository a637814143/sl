package com.eightam.lab.dto;

import com.eightam.lab.entity.UserRole;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public class LoginRequest {

    @NotBlank(message = "请输入用户名")
    private String username;

    @NotBlank(message = "请输入密码")
    private String password;

    @Pattern(regexp = "(?i)ADMIN|MERCHANT|CUSTOMER", message = "角色不合法")
    private String role;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public UserRole resolveRole() {
        return role == null ? null : UserRole.valueOf(role.toUpperCase());
    }
}
