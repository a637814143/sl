package com.eightam.lab.service;

import com.eightam.lab.dto.DrinkSummary;
import com.eightam.lab.entity.MerchantProduct;
import org.springframework.stereotype.Component;

@Component
public class DrinkSummaryMapper {

    public DrinkSummary toSummary(MerchantProduct merchantProduct) {
        var merchant = merchantProduct.getMerchant();
        var product = merchantProduct.getProduct();
        return new DrinkSummary(
                merchantProduct.getId(),
                product != null ? product.getId() : null,
                merchant != null ? merchant.getId() : null,
                merchant != null ? merchant.getName() : "8AM Lab",
                product != null ? product.getSkuCode() : null,
                merchantProduct.getDisplayName(),
                product != null ? product.getBasePrice() : null,
                merchantProduct.getEffectivePrice(),
                product != null ? product.getDescription() : null,
                product != null ? product.getImageUrl() : null,
                product != null ? product.getFlavorProfile() : null,
                product != null ? product.getCategory() : null,
                merchantProduct.isAvailable(),
                merchantProduct.getDailyStockLimit(),
                merchantProduct.getAvailableStock(),
                merchantProduct.getAvailableStart(),
                merchantProduct.getAvailableEnd(),
                product != null ? product.getOptionSettings() : null
        );
    }
}
