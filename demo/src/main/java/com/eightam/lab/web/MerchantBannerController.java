package com.eightam.lab.web;

import com.eightam.lab.dto.MerchantBannerRequest;
import com.eightam.lab.dto.MerchantBannerResponse;
import com.eightam.lab.service.AuthTokenService;
import com.eightam.lab.service.MerchantBannerService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/merchant/banners")
@CrossOrigin
public class MerchantBannerController {

    private final MerchantBannerService merchantBannerService;
    private final AuthTokenService authTokenService;

    public MerchantBannerController(MerchantBannerService merchantBannerService,
                                    AuthTokenService authTokenService) {
        this.merchantBannerService = merchantBannerService;
        this.authTokenService = authTokenService;
    }

    @GetMapping
    public List<MerchantBannerResponse> list(@RequestHeader("Authorization") String authorization) {
        var principal = authTokenService.requireMerchant(authorization);
        return merchantBannerService.listByMerchant(principal.merchantId());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public MerchantBannerResponse create(@RequestHeader("Authorization") String authorization,
                                         @Valid @RequestBody MerchantBannerRequest request) {
        var principal = authTokenService.requireMerchant(authorization);
        return merchantBannerService.create(principal.merchantId(), request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@RequestHeader("Authorization") String authorization,
                       @PathVariable Long id) {
        var principal = authTokenService.requireMerchant(authorization);
        merchantBannerService.delete(principal.merchantId(), id);
    }
}
