package com.eightam.lab.controller;

import com.eightam.lab.dto.AdminUserCreateRequest;
import com.eightam.lab.dto.AdminUserUpdateRequest;
import com.eightam.lab.dto.UserResponse;
import com.eightam.lab.service.AdminUserService;
import com.eightam.lab.service.AuthTokenService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/users")
@CrossOrigin
public class AdminUserController {

    private final AdminUserService adminUserService;
    private final AuthTokenService authTokenService;

    public AdminUserController(AdminUserService adminUserService,
                               AuthTokenService authTokenService) {
        this.adminUserService = adminUserService;
        this.authTokenService = authTokenService;
    }

    @GetMapping
    public List<UserResponse> list(@RequestHeader("Authorization") String authorization,
                                   @RequestParam(value = "role", required = false) String role,
                                   @RequestParam(value = "keyword", required = false) String keyword) {
        authTokenService.requireAdmin(authorization);
        return adminUserService.list(role, keyword);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public UserResponse create(@RequestHeader("Authorization") String authorization,
                               @Valid @RequestBody AdminUserCreateRequest request) {
        authTokenService.requireAdmin(authorization);
        return adminUserService.create(request);
    }

    @PutMapping("/{id}")
    public UserResponse update(@RequestHeader("Authorization") String authorization,
                               @PathVariable Long id,
                               @Valid @RequestBody AdminUserUpdateRequest request) {
        authTokenService.requireAdmin(authorization);
        return adminUserService.update(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@RequestHeader("Authorization") String authorization,
                       @PathVariable Long id) {
        AuthTokenService.AuthPrincipal admin = authTokenService.requireAdmin(authorization);
        adminUserService.delete(id, admin.userId());
    }
}
