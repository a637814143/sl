package com.eightam.lab.service;

import com.eightam.lab.dto.DrinkSummary;
import com.eightam.lab.entity.MerchantProduct;
import com.eightam.lab.repository.MerchantProductRepository;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DrinkCatalogService {

    private final MerchantProductRepository merchantProductRepository;

    public DrinkCatalogService(MerchantProductRepository merchantProductRepository) {
        this.merchantProductRepository = merchantProductRepository;
    }

    @Transactional(readOnly = true)
    public List<DrinkSummary> getAvailableDrinks(Long merchantId) {
        List<MerchantProduct> merchantProducts = merchantId != null
                ? merchantProductRepository.findByMerchantIdAndAvailableTrueOrderByDisplayOrderAscIdAsc(merchantId)
                : merchantProductRepository.findByAvailableTrueOrderByDisplayOrderAscIdAsc();
        return merchantProducts.stream()
                .map(this::toSummary)
                .toList();
    }

    private DrinkSummary toSummary(MerchantProduct merchantProduct) {
        var merchant = merchantProduct.getMerchant();
        var product = merchantProduct.getProduct();
        return new DrinkSummary(
                merchantProduct.getId(),
                product != null ? product.getId() : null,
                merchant != null ? merchant.getId() : null,
                merchant != null ? merchant.getName() : "8AM 灵感实验室",
                product != null ? product.getSkuCode() : null,
                merchantProduct.getDisplayName(),
                product != null ? product.getBasePrice() : null,
                merchantProduct.getEffectivePrice(),
                merchantProduct.getDescription(),
                merchantProduct.getImageUrl(),
                merchantProduct.getFlavorProfile(),
                merchantProduct.getCategory(),
                merchantProduct.isAvailable(),
                merchantProduct.getDailyStockLimit(),
                merchantProduct.getAvailableStock(),
                merchantProduct.getAvailableStart(),
                merchantProduct.getAvailableEnd()
        );
    }
}
