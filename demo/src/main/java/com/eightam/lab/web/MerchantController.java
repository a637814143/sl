package com.eightam.lab.web;

import com.eightam.lab.dto.MerchantBannerResponse;
import com.eightam.lab.dto.MerchantSummary;
import com.eightam.lab.repository.MerchantRepository;
import com.eightam.lab.service.MerchantBannerService;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/merchants")
@CrossOrigin
public class MerchantController {

    private final MerchantRepository merchantRepository;
    private final MerchantBannerService merchantBannerService;

    public MerchantController(MerchantRepository merchantRepository,
                              MerchantBannerService merchantBannerService) {
        this.merchantRepository = merchantRepository;
        this.merchantBannerService = merchantBannerService;
    }

    @GetMapping
    public List<MerchantSummary> list() {
        return merchantRepository.findAll().stream()
                .map(merchant -> new MerchantSummary(
                        merchant.getId(),
                        merchant.getName(),
                        merchant.getContact(),
                        merchant.getLocation(),
                        merchant.getSignatureStory(),
                        merchant.getLatitude(),
                        merchant.getLongitude()
                ))
                .toList();
    }

    @GetMapping("/{merchantId}/banners")
    public List<MerchantBannerResponse> listBanners(@PathVariable("merchantId") Long merchantId) {
        return merchantBannerService.listByMerchant(merchantId);
    }
}
