package com.eightam.lab.service;

import com.eightam.lab.dto.MerchantAdminRequest;
import com.eightam.lab.dto.MerchantSummary;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.repository.LabUserRepository;
import com.eightam.lab.repository.MerchantProductRepository;
import com.eightam.lab.repository.MerchantRepository;
import java.util.List;
import java.util.Locale;
import java.util.stream.Stream;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.server.ResponseStatusException;

@Service
public class MerchantAdminService {

    private final MerchantRepository merchantRepository;
    private final LabUserRepository labUserRepository;
    private final MerchantProductRepository merchantProductRepository;

    public MerchantAdminService(MerchantRepository merchantRepository,
                                LabUserRepository labUserRepository,
                                MerchantProductRepository merchantProductRepository) {
        this.merchantRepository = merchantRepository;
        this.labUserRepository = labUserRepository;
        this.merchantProductRepository = merchantProductRepository;
    }

    public List<MerchantSummary> list(String keyword) {
        Stream<Merchant> stream = merchantRepository.findAll().stream();
        if (StringUtils.hasText(keyword)) {
            String lower = keyword.toLowerCase(Locale.ROOT);
            stream = stream.filter(merchant ->
                    matches(merchant.getName(), lower) ||
                            matches(merchant.getContact(), lower) ||
                            matches(merchant.getLocation(), lower));
        }
        return stream
                .map(this::toSummary)
                .toList();
    }

    public MerchantSummary findOne(Long id) {
        Merchant merchant = merchantRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "门店不存在"));
        return toSummary(merchant);
    }

    public MerchantSummary create(MerchantAdminRequest request) {
        Merchant merchant = new Merchant(
                request.getName(),
                request.getContact(),
                request.getLocation(),
                request.getSignatureStory(),
                request.getLatitude(),
                request.getLongitude()
        );
        Merchant saved = merchantRepository.save(merchant);
        return toSummary(saved);
    }

    public MerchantSummary update(Long id, MerchantAdminRequest request) {
        Merchant merchant = merchantRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "门店不存在"));
        merchant.setName(request.getName());
        merchant.setContact(request.getContact());
        merchant.setLocation(request.getLocation());
        merchant.setSignatureStory(request.getSignatureStory());
        merchant.setLatitude(request.getLatitude());
        merchant.setLongitude(request.getLongitude());
        Merchant saved = merchantRepository.save(merchant);
        return toSummary(saved);
    }

    public void delete(Long id) {
        Merchant merchant = merchantRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "门店不存在"));
        long linkedUsers = labUserRepository.countByManagedMerchantId(id);
        long linkedProducts = merchantProductRepository.countByMerchantId(id);
        if (linkedUsers > 0 || linkedProducts > 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "门店仍有关联账号或商品，暂不可删除");
        }
        merchantRepository.delete(merchant);
    }

    private boolean matches(String field, String keyword) {
        return field != null && field.toLowerCase(Locale.ROOT).contains(keyword);
    }

    private MerchantSummary toSummary(Merchant merchant) {
        return new MerchantSummary(
                merchant.getId(),
                merchant.getName(),
                merchant.getContact(),
                merchant.getLocation(),
                merchant.getSignatureStory(),
                merchant.getLatitude(),
                merchant.getLongitude()
        );
    }
}
