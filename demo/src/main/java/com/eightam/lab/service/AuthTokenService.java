package com.eightam.lab.service;

import com.eightam.lab.entity.LabUser;
import com.eightam.lab.entity.UserRole;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AuthTokenService {

    private final Map<String, AuthPrincipal> sessions = new ConcurrentHashMap<>();

    public String issueToken(LabUser user) {
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "ç™»å½•å¤±è´¥");
        }
        revokeUser(user.getId());
        String token = UUID.randomUUID().toString();
        Long merchantId = user.getManagedMerchant() != null ? user.getManagedMerchant().getId() : null;
        sessions.put(token, new AuthPrincipal(user.getId(), user.getRole(), merchantId));
        return token;
    }

    public void revokeUser(Long userId) {
        if (userId == null) {
            return;
        }
        sessions.entrySet().removeIf(entry -> userId.equals(entry.getValue().userId()));
    }

    public AuthPrincipal require(String authorizationHeader) {
        String token = extractToken(authorizationHeader);
        AuthPrincipal principal = sessions.get(token);
        if (principal == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "ç™»å½•ä¿¡æ¯å·²è¿‡æœŸ");
        }
        return principal;
    }

    public AuthPrincipal requireMerchant(String authorizationHeader) {
        AuthPrincipal principal = require(authorizationHeader);
        if (principal.role != UserRole.MERCHANT) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "åªæœ‰å•†å®¶å¯æ‰§è¡Œæ­¤æ“ä½œ");
        }
        if (principal.merchantId == null) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "å•†å®¶è­˜å«ä¿¡æ¯ç¼ºå¤±");
        }
        return principal;
    }

    private String extractToken(String authorizationHeader) {
        if (!StringUtils.hasText(authorizationHeader)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "é¡¹ç›®ä¼šè¯·æ±‚æ£€æµ‹åˆ°ç™»å½•è¯æ®");
        }
        String value = authorizationHeader.trim();
        if (value.toLowerCase(Locale.ROOT).startsWith("bearer ")) {
            value = value.substring(7);
        }
        if (!StringUtils.hasText(value)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "ç™»å½•è¯æ®æ— æ•ˆ");
        }
        return value;
    }

    public record AuthPrincipal(Long userId, UserRole role, Long merchantId) {
    }
}
