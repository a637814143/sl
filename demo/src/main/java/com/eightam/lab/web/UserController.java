package com.eightam.lab.web;

import com.eightam.lab.dto.ProfileUpdateRequest;
import com.eightam.lab.dto.UserResponse;
import com.eightam.lab.dto.UserProfile;
import com.eightam.lab.entity.UserRole;
import com.eightam.lab.service.UserDirectoryService;
import com.eightam.lab.service.UserProfileService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@CrossOrigin
public class UserController {

    private final UserDirectoryService userDirectoryService;
    private final UserProfileService userProfileService;

    public UserController(UserDirectoryService userDirectoryService,
                          UserProfileService userProfileService) {
        this.userDirectoryService = userDirectoryService;
        this.userProfileService = userProfileService;
    }

    @GetMapping("/roles/{role}")
    public List<UserProfile> byRole(@PathVariable("role") String role) {
        UserRole userRole = UserRole.valueOf(role.toUpperCase());
        return userDirectoryService.findByRole(userRole);
    }

    @GetMapping("/{id}")
    public UserResponse profile(@PathVariable("id") Long id) {
        return userProfileService.findById(id);
    }

    @PutMapping("/{id}/profile")
    public UserResponse update(@PathVariable("id") Long id, @Valid @RequestBody ProfileUpdateRequest request) {
        return userProfileService.updateProfile(id, request);
    }
}
