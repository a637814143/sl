package com.eightam.lab.repository;

import com.eightam.lab.entity.MerchantBanner;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MerchantBannerRepository extends JpaRepository<MerchantBanner, Long> {

    List<MerchantBanner> findByMerchantIdOrderByDisplayOrderAscCreatedAtAsc(Long merchantId);

    long countByMerchantId(Long merchantId);

    Optional<MerchantBanner> findByIdAndMerchantId(Long id, Long merchantId);
}
