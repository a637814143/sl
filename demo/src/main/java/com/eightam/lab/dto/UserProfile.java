package com.eightam.lab.dto;

public record UserProfile(
        Long id,
        String displayName,
        String role,
        String avatar
) {
}
