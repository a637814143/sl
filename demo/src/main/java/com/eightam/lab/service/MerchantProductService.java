package com.eightam.lab.service;

import com.eightam.lab.dto.DrinkSummary;
import com.eightam.lab.dto.MerchantProductRequest;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.entity.MerchantProduct;
import com.eightam.lab.entity.Product;
import com.eightam.lab.repository.MerchantProductRepository;
import com.eightam.lab.repository.MerchantRepository;
import com.eightam.lab.repository.ProductRepository;
import java.time.Instant;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.server.ResponseStatusException;

@Service
public class MerchantProductService {

    private final MerchantProductRepository merchantProductRepository;
    private final MerchantRepository merchantRepository;
    private final ProductRepository productRepository;
    private final DrinkSummaryMapper drinkSummaryMapper;

    public MerchantProductService(MerchantProductRepository merchantProductRepository,
                                  MerchantRepository merchantRepository,
                                  ProductRepository productRepository,
                                  DrinkSummaryMapper drinkSummaryMapper) {
        this.merchantProductRepository = merchantProductRepository;
        this.merchantRepository = merchantRepository;
        this.productRepository = productRepository;
        this.drinkSummaryMapper = drinkSummaryMapper;
    }

    @Transactional(readOnly = true)
    public List<DrinkSummary> list(Long merchantId) {
        Merchant merchant = merchantRepository.findById(merchantId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "门店不存在"));
        return merchantProductRepository.findByMerchantIdOrderByDisplayOrderAscIdAsc(merchant.getId())
                .stream()
                .map(drinkSummaryMapper::toSummary)
                .toList();
    }

    @Transactional
    public DrinkSummary create(MerchantProductRequest request) {
        Merchant merchant = merchantRepository.findById(request.getMerchantId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "门店不存在"));
        Product product = new Product();
        product.setSkuCode(generateSku(null));
        applyProduct(product, request);
        productRepository.save(product);

        MerchantProduct merchantProduct = new MerchantProduct();
        merchantProduct.setMerchant(merchant);
        merchantProduct.setProduct(product);
        applyMerchantProduct(merchantProduct, request);
        merchantProductRepository.save(merchantProduct);

        return drinkSummaryMapper.toSummary(merchantProduct);
    }

    @Transactional
    public DrinkSummary update(Long id, MerchantProductRequest request) {
        MerchantProduct merchantProduct = merchantProductRepository.findByIdAndMerchantId(id, request.getMerchantId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "商品不存在或不属于该门店"));
        Product product = ensureProduct(merchantProduct);
        applyProduct(product, request);
        productRepository.save(product);
        applyMerchantProduct(merchantProduct, request);
        return drinkSummaryMapper.toSummary(merchantProduct);
    }

    @Transactional
    public void delete(Long id, Long merchantId) {
        MerchantProduct merchantProduct = merchantProductRepository.findByIdAndMerchantId(id, merchantId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "商品不存在或不属于该门店"));
        Long productId = merchantProduct.getProduct() != null ? merchantProduct.getProduct().getId() : null;
        merchantProductRepository.delete(merchantProduct);
        if (productId != null && merchantProductRepository.countByProductId(productId) == 0) {
            productRepository.deleteById(productId);
        }
    }

    private void applyProduct(Product product, MerchantProductRequest request) {
        if (!StringUtils.hasText(product.getSkuCode())) {
            product.setSkuCode(generateSku(null));
        }
        product.setName(request.getName());
        product.setBasePrice(request.getPrice());
        product.setDescription(request.getDescription());
        product.setImageUrl(request.getImageUrl());
        product.setFlavorProfile(request.getFlavorProfile());
        product.setCategory(request.getCategory());
        product.setActive(request.getAvailable() == null || request.getAvailable());
    }

    private void applyMerchantProduct(MerchantProduct merchantProduct, MerchantProductRequest request) {
        merchantProduct.setCustomName(request.getName());
        merchantProduct.setCustomPrice(request.getPrice());
        merchantProduct.setDailyStockLimit(request.getDailyStockLimit());
        merchantProduct.setAvailableStock(request.getAvailableStock());
        merchantProduct.setAvailableStart(request.getAvailableStart());
        merchantProduct.setAvailableEnd(request.getAvailableEnd());
        merchantProduct.setAvailable(request.getAvailable() == null || request.getAvailable());
    }

    private String generateSku(String fallback) {
        if (StringUtils.hasText(fallback)) {
            return fallback;
        }
        return "MP-" + Instant.now().toEpochMilli();
    }

    private Product ensureProduct(MerchantProduct merchantProduct) {
        Product product = merchantProduct.getProduct();
        if (product == null) {
            product = new Product();
            product.setSkuCode(generateSku(null));
            merchantProduct.setProduct(product);
        }
        return product;
    }
}
