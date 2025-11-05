package com.eightam.lab.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class RegisterRequest {

    @NotBlank(message = "请输入用户名")
    @Size(min = 3, max = 32, message = "用户名需在3-32个字符之间")
    private String username;

    @NotBlank(message = "请输入显示昵称")
    @Size(max = 64, message = "昵称需在64字符以内")
    private String displayName;

    @NotBlank(message = "请输入密码")
    @Size(min = 6, max = 64, message = "密码需在6-64字符之间")
    private String password;

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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
