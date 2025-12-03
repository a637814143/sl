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
    private final DrinkSummaryMapper drinkSummaryMapper;

    public DrinkCatalogService(MerchantProductRepository merchantProductRepository,
                               DrinkSummaryMapper drinkSummaryMapper) {
        this.merchantProductRepository = merchantProductRepository;
        this.drinkSummaryMapper = drinkSummaryMapper;
    }

    @Transactional(readOnly = true)
    public List<DrinkSummary> getAvailableDrinks(Long merchantId) {
        List<MerchantProduct> merchantProducts = merchantId != null
                ? merchantProductRepository.findByMerchantIdAndAvailableTrueOrderByDisplayOrderAscIdAsc(merchantId)
                : merchantProductRepository.findByAvailableTrueOrderByDisplayOrderAscIdAsc();
        return merchantProducts.stream()
                .map(drinkSummaryMapper::toSummary)
                .toList();
    }
}
