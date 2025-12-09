package com.eightam.lab.repository;

import com.eightam.lab.entity.LabUser;
import com.eightam.lab.entity.UserRole;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LabUserRepository extends JpaRepository<LabUser, Long> {
    Optional<LabUser> findByUsername(String username);

    List<LabUser> findByRoleOrderByDisplayNameAsc(UserRole role);

    long countByManagedMerchantId(Long merchantId);
}
