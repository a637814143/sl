package com.eightam.lab.repository;

import com.eightam.lab.entity.MerchantRequest;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MerchantRequestRepository extends JpaRepository<MerchantRequest, Long> {

    List<MerchantRequest> findAllByOrderByCreatedAtDesc();
}
