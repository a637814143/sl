package com.eightam.lab.repository;

import com.eightam.lab.entity.DrinkOrder;
import com.eightam.lab.entity.OrderStatus;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface DrinkOrderRepository extends JpaRepository<DrinkOrder, Long> {

    long countByStatus(OrderStatus status);

    long countByMerchantIdAndStatus(Long merchantId, OrderStatus status);

    List<DrinkOrder> findByMerchantIdOrderByCreatedAtDesc(Long merchantId);

    Optional<DrinkOrder> findByIdAndMerchantId(Long id, Long merchantId);

    @Query("SELECT o.drink.name FROM DrinkOrder o GROUP BY o.drink.name ORDER BY SUM(o.quantity) DESC")
    List<String> findTopSellingDrinkNames(Pageable pageable);
}
