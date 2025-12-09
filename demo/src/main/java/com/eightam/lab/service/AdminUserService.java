package com.eightam.lab.service;

import com.eightam.lab.dto.AdminUserCreateRequest;
import com.eightam.lab.dto.AdminUserUpdateRequest;
import com.eightam.lab.dto.UserResponse;
import com.eightam.lab.entity.LabUser;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.entity.UserRole;
import com.eightam.lab.repository.LabUserRepository;
import com.eightam.lab.repository.MerchantRepository;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Stream;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AdminUserService {

    private final LabUserRepository labUserRepository;
    private final MerchantRepository merchantRepository;
    private final PasswordEncoder passwordEncoder;
    private final UserResponseMapper userResponseMapper;

    public AdminUserService(LabUserRepository labUserRepository,
                            MerchantRepository merchantRepository,
                            PasswordEncoder passwordEncoder,
                            UserResponseMapper userResponseMapper) {
        this.labUserRepository = labUserRepository;
        this.merchantRepository = merchantRepository;
        this.passwordEncoder = passwordEncoder;
        this.userResponseMapper = userResponseMapper;
    }

    public List<UserResponse> list(String roleCode, String keyword) {
        UserRole role;
        try {
            role = parseRole(roleCode);
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "账号角色不正确");
        }
        Stream<LabUser> stream = role != null
                ? labUserRepository.findByRoleOrderByDisplayNameAsc(role).stream()
                : labUserRepository.findAll().stream();

        if (StringUtils.hasText(keyword)) {
            String lower = keyword.toLowerCase(Locale.ROOT);
            stream = stream.filter(user -> matchesKeyword(user, lower));
        }

        Comparator<LabUser> comparator = Comparator.comparing(
                user -> Optional.ofNullable(user.getDisplayName()).orElse(user.getUsername()),
                String.CASE_INSENSITIVE_ORDER
        );

        return stream
                .sorted(comparator)
                .map(userResponseMapper::from)
                .toList();
    }

    public UserResponse create(AdminUserCreateRequest request) {
        labUserRepository.findByUsername(request.getUsername())
                .ifPresent(existing -> {
                    throw new ResponseStatusException(HttpStatus.CONFLICT, "用户名已被占用");
                });
        LabUser user = new LabUser();
        user.setUsername(request.getUsername());
        user.setDisplayName(request.getDisplayName());
        user.setPhone(request.getPhone());
        user.setGender(request.getGender());
        user.setAvatar(request.getAvatar());

        UserRole role = requireRole(request.getRole());
        user.setRole(role);
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        assignMerchant(user, role, request.getMerchantId());
        LabUser saved = labUserRepository.save(user);
        return userResponseMapper.from(saved);
    }

    public UserResponse update(Long id, AdminUserUpdateRequest request) {
        LabUser user = labUserRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "账号不存在"));
        user.setDisplayName(request.getDisplayName());
        user.setPhone(request.getPhone());
        user.setGender(request.getGender());
        if (StringUtils.hasText(request.getAvatar())) {
            user.setAvatar(request.getAvatar());
        }
        if (StringUtils.hasText(request.getPassword())) {
            user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        }
        UserRole role = requireRole(request.getRole());
        user.setRole(role);
        assignMerchant(user, role, request.getMerchantId());
        LabUser saved = labUserRepository.save(user);
        return userResponseMapper.from(saved);
    }

    public void delete(Long id, Long operatorId) {
        if (id.equals(operatorId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "不能删除当前登录账号");
        }
        if (!labUserRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "账号不存在");
        }
        labUserRepository.deleteById(id);
    }

    private boolean matchesKeyword(LabUser user, String keyword) {
        return (user.getUsername() != null && user.getUsername().toLowerCase(Locale.ROOT).contains(keyword))
                || (user.getDisplayName() != null && user.getDisplayName().toLowerCase(Locale.ROOT).contains(keyword))
                || (user.getPhone() != null && user.getPhone().toLowerCase(Locale.ROOT).contains(keyword));
    }

    private UserRole requireRole(String rawRole) {
        try {
            UserRole role = parseRole(rawRole);
            if (role == null) {
                throw new IllegalArgumentException("role missing");
            }
            return role;
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "账号角色不正确");
        }
    }

    private UserRole parseRole(String rawRole) {
        if (!StringUtils.hasText(rawRole)) {
            return null;
        }
        return UserRole.valueOf(rawRole.trim().toUpperCase(Locale.ROOT));
    }

    private void assignMerchant(LabUser user, UserRole role, Long merchantId) {
        if (role == UserRole.MERCHANT) {
            if (merchantId == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "商家账号需要绑定门店");
            }
            Merchant merchant = merchantRepository.findById(merchantId)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "门店不存在"));
            user.setManagedMerchant(merchant);
        } else {
            user.setManagedMerchant(null);
        }
    }
}
