package com.eightam.lab.service;

import com.eightam.lab.dto.MerchantBannerRequest;
import com.eightam.lab.dto.MerchantBannerResponse;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.entity.MerchantBanner;
import com.eightam.lab.repository.MerchantBannerRepository;
import com.eightam.lab.repository.MerchantRepository;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.server.ResponseStatusException;

@Service
public class MerchantBannerService {

    private static final int MAX_BANNERS_PER_MERCHANT = 5;

    private final MerchantBannerRepository bannerRepository;
    private final MerchantRepository merchantRepository;

    public MerchantBannerService(MerchantBannerRepository bannerRepository,
                                 MerchantRepository merchantRepository) {
        this.bannerRepository = bannerRepository;
        this.merchantRepository = merchantRepository;
    }

    public List<MerchantBannerResponse> listByMerchant(Long merchantId) {
        requireMerchant(merchantId);
        return bannerRepository.findByMerchantIdOrderByDisplayOrderAscCreatedAtAsc(merchantId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    public MerchantBannerResponse create(Long merchantId, MerchantBannerRequest request) {
        Merchant merchant = requireMerchant(merchantId);
        if (!StringUtils.hasText(request.getImageUrl())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "请上传轮播图");
        }
        long currentCount = bannerRepository.countByMerchantId(merchantId);
        if (currentCount >= MAX_BANNERS_PER_MERCHANT) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "轮播图最多保存 5 张");
        }
        MerchantBanner banner = new MerchantBanner();
        banner.setMerchant(merchant);
        banner.setImageUrl(request.getImageUrl());
        banner.setCaption(request.getCaption());
        banner.setDisplayOrder(request.getDisplayOrder() != null
                ? request.getDisplayOrder()
                : (int) currentCount + 1);
        MerchantBanner saved = bannerRepository.save(banner);
        return toResponse(saved);
    }

    public void delete(Long merchantId, Long bannerId) {
        MerchantBanner banner = bannerRepository.findByIdAndMerchantId(bannerId, merchantId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "该轮播图不存在"));
        bannerRepository.delete(banner);
    }

    private Merchant requireMerchant(Long merchantId) {
        return merchantRepository.findById(merchantId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "门店不存在"));
    }

    private MerchantBannerResponse toResponse(MerchantBanner banner) {
        return new MerchantBannerResponse(
                banner.getId(),
                banner.getMerchant().getId(),
                banner.getImageUrl(),
                banner.getCaption(),
                banner.getDisplayOrder(),
                banner.getCreatedAt(),
                banner.getUpdatedAt()
        );
    }
}
