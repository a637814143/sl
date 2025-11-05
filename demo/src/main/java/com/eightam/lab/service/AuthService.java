package com.eightam.lab.service;

import com.eightam.lab.dto.LoginRequest;
import com.eightam.lab.dto.RegisterRequest;
import com.eightam.lab.dto.UserResponse;
import com.eightam.lab.entity.LabUser;
import com.eightam.lab.repository.LabUserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AuthService {

    private final LabUserRepository labUserRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(LabUserRepository labUserRepository, PasswordEncoder passwordEncoder) {
        this.labUserRepository = labUserRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public UserResponse register(RegisterRequest request) {
        labUserRepository.findByUsername(request.getUsername())
                .ifPresent(existing -> {
                    throw new ResponseStatusException(HttpStatus.CONFLICT, "用户名已存在");
                });

        LabUser user = new LabUser();
        user.setUsername(request.getUsername());
        user.setDisplayName(request.getDisplayName());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setRole("customer");

        LabUser saved = labUserRepository.save(user);
        return new UserResponse(saved.getId(), saved.getUsername(), saved.getDisplayName());
    }

    @Transactional(readOnly = true)
    public UserResponse login(LoginRequest request) {
        LabUser user = labUserRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "用户名或密码错误"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "用户名或密码错误");
        }

        return new UserResponse(user.getId(), user.getUsername(), user.getDisplayName());
    }
}
