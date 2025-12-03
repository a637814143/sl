package com.eightam.lab.dto;

public class AuthSessionResponse {

    private final String token;
    private final UserResponse user;

    public AuthSessionResponse(String token, UserResponse user) {
        this.token = token;
        this.user = user;
    }

    public String getToken() {
        return token;
    }

    public UserResponse getUser() {
        return user;
    }
}
