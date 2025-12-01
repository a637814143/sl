package com.eightam.lab.service;

import com.eightam.lab.dto.ProfileUpdateRequest;
import com.eightam.lab.dto.UserResponse;
import com.eightam.lab.entity.LabUser;
import com.eightam.lab.repository.LabUserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class UserProfileService {

    private final LabUserRepository labUserRepository;
    private final UserResponseMapper userResponseMapper;

    public UserProfileService(LabUserRepository labUserRepository,
                              UserResponseMapper userResponseMapper) {
        this.labUserRepository = labUserRepository;
        this.userResponseMapper = userResponseMapper;
    }

    @Transactional(readOnly = true)
    public UserResponse findById(Long id) {
        LabUser user = labUserRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "用户不存在"));
        return userResponseMapper.from(user);
    }

    @Transactional
    public UserResponse updateProfile(Long id, ProfileUpdateRequest request) {
        LabUser user = labUserRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "用户不存在"));
        user.setDisplayName(request.getDisplayName().trim());
        user.setFamilyName(request.getFamilyName());
        user.setGivenName(request.getGivenName());
        user.setGender(request.getGender());
        user.setPhone(request.getPhone());
        user.setBirthday(request.getBirthday());
        user.setAvatar(request.getAvatar());
        LabUser saved = labUserRepository.save(user);
        return userResponseMapper.from(saved);
    }
}
