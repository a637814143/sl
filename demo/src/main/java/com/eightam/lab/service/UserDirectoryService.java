package com.eightam.lab.service;

import com.eightam.lab.entity.UserRole;
import com.eightam.lab.dto.UserProfile;
import com.eightam.lab.repository.LabUserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserDirectoryService {

    private final LabUserRepository labUserRepository;

    public UserDirectoryService(LabUserRepository labUserRepository) {
        this.labUserRepository = labUserRepository;
    }

    public List<UserProfile> findByRole(UserRole role) {
        return labUserRepository.findByRoleOrderByDisplayNameAsc(role)
                .stream()
                .map(user -> new UserProfile(
                        user.getId(),
                        user.getDisplayName(),
                        user.getRole().name(),
                        user.getAvatar()
                ))
                .collect(Collectors.toList());
    }
}
