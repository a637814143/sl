package com.eightam.lab.repository;

import com.eightam.lab.domain.LabUser;
import com.eightam.lab.domain.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LabUserRepository extends JpaRepository<LabUser, Long> {
    List<LabUser> findByRoleOrderByDisplayNameAsc(UserRole role);
}
