package com.eightam.lab.service;

import com.eightam.lab.domain.Drink;
import com.eightam.lab.dto.DrinkRequest;
import com.eightam.lab.dto.DrinkResponse;
import com.eightam.lab.repository.DrinkRepository;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class DrinkService {

    private final DrinkRepository drinkRepository;

    public DrinkService(DrinkRepository drinkRepository) {
        this.drinkRepository = drinkRepository;
    }

    @Transactional(readOnly = true)
    public List<DrinkResponse> listAll() {
        return drinkRepository.findAll().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public DrinkResponse findById(Long id) {
        Drink drink = drinkRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "饮品不存在"));
        return toResponse(drink);
    }

    @Transactional
    public DrinkResponse create(DrinkRequest request) {
        Drink drink = new Drink();
        apply(drink, request);
        return toResponse(drinkRepository.save(drink));
    }

    @Transactional
    public DrinkResponse update(Long id, DrinkRequest request) {
        Drink drink = drinkRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "饮品不存在"));
        apply(drink, request);
        Drink saved = drinkRepository.save(drink);
        return toResponse(saved);
    }

    @Transactional
    public void delete(Long id) {
        if (!drinkRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "饮品不存在");
        }
        drinkRepository.deleteById(id);
    }

    private void apply(Drink drink, DrinkRequest request) {
        drink.setName(request.getName());
        drink.setPrice(request.getPrice());
        drink.setDescription(request.getDescription());
        drink.setImageUrl(request.getImageUrl());
        drink.setFlavorProfile(request.getFlavorProfile());
        drink.setAvailable(request.isAvailable());
    }

    private DrinkResponse toResponse(Drink drink) {
        DrinkResponse response = new DrinkResponse();
        response.setId(drink.getId());
        response.setName(drink.getName());
        response.setPrice(drink.getPrice());
        response.setDescription(drink.getDescription());
        response.setImageUrl(drink.getImageUrl());
        response.setFlavorProfile(drink.getFlavorProfile());
        response.setAvailable(drink.isAvailable());
        return response;
    }
}
