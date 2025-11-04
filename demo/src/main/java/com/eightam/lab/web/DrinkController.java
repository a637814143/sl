package com.eightam.lab.web;

import com.eightam.lab.dto.DrinkSummary;
import com.eightam.lab.service.DrinkCatalogService;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/drinks")
@CrossOrigin
public class DrinkController {

    private final DrinkCatalogService drinkCatalogService;

    public DrinkController(DrinkCatalogService drinkCatalogService) {
        this.drinkCatalogService = drinkCatalogService;
    }

    @GetMapping
    public List<DrinkSummary> list() {
        return drinkCatalogService.getAvailableDrinks();
    }
}
