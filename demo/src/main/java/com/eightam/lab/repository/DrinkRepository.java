package com.eightam.lab.repository;

import com.eightam.lab.domain.Drink;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DrinkRepository extends JpaRepository<Drink, Long> {
    List<Drink> findByAvailableTrueOrderByNameAsc();
}
