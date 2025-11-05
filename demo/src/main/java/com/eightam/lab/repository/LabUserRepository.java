package com.eightam.lab.repository;

import com.eightam.lab.domain.LabUser;
import com.eightam.lab.domain.UserRole;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LabUserRepository extends JpaRepository<LabUser, Long> {
    Optional<LabUser> findByUsername(String username);

    List<LabUser> findByRoleOrderByDisplayNameAsc(UserRole role);
}
