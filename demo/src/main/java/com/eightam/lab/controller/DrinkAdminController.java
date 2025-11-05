package com.eightam.lab.controller;

import com.eightam.lab.dto.DrinkRequest;
import com.eightam.lab.dto.DrinkResponse;
import com.eightam.lab.service.DrinkService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/drinks")
@CrossOrigin
public class DrinkAdminController {

    private final DrinkService drinkService;

    public DrinkAdminController(DrinkService drinkService) {
        this.drinkService = drinkService;
    }

    @GetMapping
    public List<DrinkResponse> list() {
        return drinkService.listAll();
    }

    @GetMapping("/{id}")
    public DrinkResponse findOne(@PathVariable Long id) {
        return drinkService.findById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public DrinkResponse create(@Valid @RequestBody DrinkRequest request) {
        return drinkService.create(request);
    }

    @PutMapping("/{id}")
    public DrinkResponse update(@PathVariable Long id, @Valid @RequestBody DrinkRequest request) {
        return drinkService.update(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        drinkService.delete(id);
    }
}
