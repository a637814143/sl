package com.eightam.lab.service;

import com.eightam.lab.domain.Drink;
import com.eightam.lab.dto.DrinkSummary;
import com.eightam.lab.repository.DrinkRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DrinkCatalogService {

    private final DrinkRepository drinkRepository;

    public DrinkCatalogService(DrinkRepository drinkRepository) {
        this.drinkRepository = drinkRepository;
    }

    public List<DrinkSummary> getAvailableDrinks() {
        return drinkRepository.findByAvailableTrueOrderByNameAsc()
                .stream()
                .map(this::toSummary)
                .toList();
    }

    private DrinkSummary toSummary(Drink drink) {
        return new DrinkSummary(
                drink.getId(),
                drink.getName(),
                drink.getPrice(),
                drink.getDescription(),
                drink.getImageUrl(),
                drink.getFlavorProfile(),
                drink.getMerchant().getName()
        );
    }
}
