package com.eightam.lab.repository;

import com.eightam.lab.entity.MerchantProduct;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MerchantProductRepository extends JpaRepository<MerchantProduct, Long> {

    List<MerchantProduct> findByAvailableTrueOrderByDisplayOrderAscIdAsc();

    List<MerchantProduct> findByMerchantIdAndAvailableTrueOrderByDisplayOrderAscIdAsc(Long merchantId);

    Optional<MerchantProduct> findByIdAndMerchantId(Long id, Long merchantId);
}
