package com.eightam.lab.service;

import com.eightam.lab.entity.LabUser;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.entity.UserRole;
import com.eightam.lab.dto.LoginRequest;
import com.eightam.lab.dto.RegisterRequest;
import com.eightam.lab.dto.UserResponse;
import com.eightam.lab.repository.LabUserRepository;
import com.eightam.lab.repository.MerchantRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AuthService {

    private final LabUserRepository labUserRepository;
    private final PasswordEncoder passwordEncoder;
    private final MerchantRepository merchantRepository;

    public AuthService(LabUserRepository labUserRepository,
                       PasswordEncoder passwordEncoder,
                       MerchantRepository merchantRepository) {
        this.labUserRepository = labUserRepository;
        this.passwordEncoder = passwordEncoder;
        this.merchantRepository = merchantRepository;
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
        UserRole role;
        try {
            role = request.resolveRole();
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "角色不合法");
        }
        user.setRole(role);

        if (role == UserRole.MERCHANT) {
            if (request.getMerchantId() == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "商户编号不能为空");
            }
            Merchant merchant = merchantRepository.findById(request.getMerchantId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "商户不存在"));
            user.setManagedMerchant(merchant);
        }

        LabUser saved = labUserRepository.save(user);
        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public UserResponse login(LoginRequest request) {
        LabUser user = labUserRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "用户名或密码错误"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "用户名或密码错误");
        }

        UserRole requestedRole;
        try {
            requestedRole = request.resolveRole();
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "角色不合法");
        }
        if (requestedRole != null && user.getRole() != requestedRole) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "该账号无权以此角色登录");
        }

        return toResponse(user);
    }

    private UserResponse toResponse(LabUser user) {
        Merchant merchant = user.getManagedMerchant();
        return new UserResponse(
                user.getId(),
                user.getUsername(),
                user.getDisplayName(),
                user.getRole().name(),
                user.getAvatar(),
                merchant != null ? merchant.getId() : null,
                merchant != null ? merchant.getName() : null
        );
    }
}
