package com.eightam.lab.repository;

import com.eightam.lab.entity.Drink;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DrinkRepository extends JpaRepository<Drink, Long> {
    List<Drink> findByAvailableTrueOrderByNameAsc();
}
