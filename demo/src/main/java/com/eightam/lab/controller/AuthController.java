package com.eightam.lab.controller;

import com.eightam.lab.dto.AuthSessionResponse;
import com.eightam.lab.dto.LoginRequest;
import com.eightam.lab.dto.RegisterRequest;
import com.eightam.lab.dto.UserResponse;
import com.eightam.lab.entity.LabUser;
import com.eightam.lab.service.AuthService;
import com.eightam.lab.service.AuthTokenService;
import com.eightam.lab.service.UserResponseMapper;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;
    private final AuthTokenService authTokenService;
    private final UserResponseMapper userResponseMapper;

    public AuthController(AuthService authService,
                          AuthTokenService authTokenService,
                          UserResponseMapper userResponseMapper) {
        this.authService = authService;
        this.authTokenService = authTokenService;
        this.userResponseMapper = userResponseMapper;
    }

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public AuthSessionResponse register(@Valid @RequestBody RegisterRequest request) {
        LabUser user = authService.register(request);
        return buildSession(user);
    }

    @PostMapping("/login")
    public AuthSessionResponse login(@Valid @RequestBody LoginRequest request) {
        LabUser user = authService.login(request);
        return buildSession(user);
    }

    private AuthSessionResponse buildSession(LabUser user) {
        String token = authTokenService.issueToken(user);
        UserResponse response = userResponseMapper.from(user);
        return new AuthSessionResponse(token, response);
    }
}
