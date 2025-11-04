package com.eightam.lab.repository;

import com.eightam.lab.domain.Merchant;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MerchantRepository extends JpaRepository<Merchant, Long> {
}
