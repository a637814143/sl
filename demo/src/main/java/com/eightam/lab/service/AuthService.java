package com.eightam.lab.service;

import com.eightam.lab.domain.loyalty.MembershipTier;
import com.eightam.lab.dto.LoginRequest;
import com.eightam.lab.dto.RegisterRequest;
import com.eightam.lab.entity.LabUser;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.entity.UserRole;
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
    public LabUser register(RegisterRequest request) {
        labUserRepository.findByUsername(request.getUsername())
                .ifPresent(existing -> {
                    throw new ResponseStatusException(HttpStatus.CONFLICT, "ç”¨æˆ·åå·²å­˜åœ¨");
                });

        LabUser user = new LabUser();
        user.setUsername(request.getUsername());
        user.setDisplayName(request.getDisplayName());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setMembershipLevel(MembershipTier.EXPERIENCE.getCode());
        UserRole role;
        try {
            role = request.resolveRole();
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "è§’è‰²ä¸åˆæ³?");
        }
        user.setRole(role);

        if (role == UserRole.MERCHANT) {
            if (request.getMerchantId() == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "å•†æˆ·ç¼–å·ä¸èƒ½ä¸ºç©º");
            }
            Merchant merchant = merchantRepository.findById(request.getMerchantId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "å•†æˆ·ä¸å­˜åœ¨"));
            user.setManagedMerchant(merchant);
        }

        return labUserRepository.save(user);
    }

    @Transactional(readOnly = true)
    public LabUser login(LoginRequest request) {
        LabUser user = labUserRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "ç”¨æˆ·åæˆ–å¯†ç é”™è¯¯"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "ç”¨æˆ·åæˆ–å¯†ç é”™è¯¯");
        }

        UserRole requestedRole;
        try {
            requestedRole = request.resolveRole();
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "è§’è‰²ä¸åˆæ³?");
        }
        if (requestedRole != null && user.getRole() != requestedRole) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "è¯¥è´¦å·æ— æƒä»¥æ­¤è§’è‰²ç™»å½?");
        }

        return user;
    }
}
