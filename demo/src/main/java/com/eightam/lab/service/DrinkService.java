package com.eightam.lab.service;

import com.eightam.lab.dto.DrinkRequest;
import com.eightam.lab.dto.DrinkResponse;
import com.eightam.lab.entity.Product;
import com.eightam.lab.repository.ProductRepository;
import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.server.ResponseStatusException;

@Service
public class DrinkService {

    private final ProductRepository productRepository;

    public DrinkService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Transactional(readOnly = true)
    public List<DrinkResponse> listAll() {
        return productRepository.findAll(Sort.by(Sort.Direction.ASC, "name"))
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public DrinkResponse findById(Long id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "商品不存在"));
        return toResponse(product);
    }

    @Transactional
    public DrinkResponse create(DrinkRequest request) {
        Product product = new Product();
        apply(product, request);
        return toResponse(productRepository.save(product));
    }

    @Transactional
    public DrinkResponse update(Long id, DrinkRequest request) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "商品不存在"));
        apply(product, request);
        return toResponse(productRepository.save(product));
    }

    @Transactional
    public void delete(Long id) {
        if (!productRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "商品不存在");
        }
        productRepository.deleteById(id);
    }

    private void apply(Product product, DrinkRequest request) {
        String desiredSku = StringUtils.hasText(request.getSkuCode()) ? request.getSkuCode().trim() : null;
        if (!StringUtils.hasText(desiredSku)) {
            desiredSku = generateSku(product.getSkuCode());
        }
        product.setSkuCode(desiredSku);
        product.setName(request.getName());
        product.setBasePrice(request.getPrice());
        product.setDescription(request.getDescription());
        product.setImageUrl(request.getImageUrl());
        product.setFlavorProfile(request.getFlavorProfile());
        product.setCategory(request.getCategory());
        product.setActive(request.isAvailable());
    }

    private String generateSku(String fallback) {
        if (StringUtils.hasText(fallback)) {
            return fallback;
        }
        return "SKU-" + Instant.now().toEpochMilli();
    }

    private DrinkResponse toResponse(Product product) {
        DrinkResponse response = new DrinkResponse();
        response.setId(product.getId());
        response.setSkuCode(product.getSkuCode());
        response.setName(product.getName());
        response.setPrice(product.getBasePrice());
        response.setDescription(product.getDescription());
        response.setImageUrl(product.getImageUrl());
        response.setFlavorProfile(product.getFlavorProfile());
        response.setCategory(product.getCategory());
        response.setAvailable(product.isActive());
        response.setCreatedAt(product.getCreatedAt());
        response.setUpdatedAt(product.getUpdatedAt());
        return response;
    }
}
