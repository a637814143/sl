package com.eightam.lab.web;

import com.eightam.lab.dto.DrinkSummary;
import com.eightam.lab.dto.MerchantProductRequest;
import com.eightam.lab.service.AuthTokenService;
import com.eightam.lab.service.MerchantProductService;
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
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/merchant/products")
@CrossOrigin
public class MerchantProductController {

    private final MerchantProductService merchantProductService;
    private final AuthTokenService authTokenService;

    public MerchantProductController(MerchantProductService merchantProductService,
                                     AuthTokenService authTokenService) {
        this.merchantProductService = merchantProductService;
        this.authTokenService = authTokenService;
    }

    @GetMapping
    public List<DrinkSummary> list(@RequestHeader("Authorization") String authorization,
                                   @RequestParam(value = "merchantId", required = false) Long merchantId) {
        var principal = authTokenService.requireMerchant(authorization);
        Long effectiveMerchantId = ensureMerchantAccess(principal, merchantId);
        return merchantProductService.list(effectiveMerchantId);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public DrinkSummary create(@RequestHeader("Authorization") String authorization,
                               @Valid @RequestBody MerchantProductRequest request) {
        var principal = authTokenService.requireMerchant(authorization);
        request.setMerchantId(ensureMerchantAccess(principal, request.getMerchantId()));
        return merchantProductService.create(request);
    }

    @PutMapping("/{id}")
    public DrinkSummary update(@RequestHeader("Authorization") String authorization,
                               @PathVariable Long id,
                               @Valid @RequestBody MerchantProductRequest request) {
        var principal = authTokenService.requireMerchant(authorization);
        request.setMerchantId(ensureMerchantAccess(principal, request.getMerchantId()));
        return merchantProductService.update(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@RequestHeader("Authorization") String authorization,
                       @PathVariable Long id,
                       @RequestParam(value = "merchantId", required = false) Long merchantId) {
        var principal = authTokenService.requireMerchant(authorization);
        Long effectiveMerchantId = ensureMerchantAccess(principal, merchantId);
        merchantProductService.delete(id, effectiveMerchantId);
    }

    private Long ensureMerchantAccess(AuthTokenService.AuthPrincipal principal, Long requestedMerchantId) {
        Long merchantId = principal.merchantId();
        if (merchantId == null) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "éœ€è¦è®¤è¯çš„å•†å®¶è´¦å·");
        }
        if (requestedMerchantId != null && !merchantId.equals(requestedMerchantId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "æ­¤æ“ä½œä¸åŒæ­£å½“å‰é—¨åº—");
        }
        return merchantId;
    }
}
