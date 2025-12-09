package com.eightam.lab.controller;

import com.eightam.lab.dto.MerchantAdminRequest;
import com.eightam.lab.dto.MerchantSummary;
import com.eightam.lab.service.AuthTokenService;
import com.eightam.lab.service.MerchantAdminService;
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
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/merchants")
@CrossOrigin
public class AdminMerchantController {

    private final MerchantAdminService merchantAdminService;
    private final AuthTokenService authTokenService;

    public AdminMerchantController(MerchantAdminService merchantAdminService,
                                   AuthTokenService authTokenService) {
        this.merchantAdminService = merchantAdminService;
        this.authTokenService = authTokenService;
    }

    @GetMapping
    public List<MerchantSummary> list(@RequestHeader("Authorization") String authorization,
                                      @RequestParam(value = "keyword", required = false) String keyword) {
        authTokenService.requireAdmin(authorization);
        return merchantAdminService.list(keyword);
    }

    @GetMapping("/{id}")
    public MerchantSummary findOne(@RequestHeader("Authorization") String authorization,
                                   @PathVariable Long id) {
        authTokenService.requireAdmin(authorization);
        return merchantAdminService.findOne(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public MerchantSummary create(@RequestHeader("Authorization") String authorization,
                                  @Valid @RequestBody MerchantAdminRequest request) {
        authTokenService.requireAdmin(authorization);
        return merchantAdminService.create(request);
    }

    @PutMapping("/{id}")
    public MerchantSummary update(@RequestHeader("Authorization") String authorization,
                                  @PathVariable Long id,
                                  @Valid @RequestBody MerchantAdminRequest request) {
        authTokenService.requireAdmin(authorization);
        return merchantAdminService.update(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@RequestHeader("Authorization") String authorization,
                       @PathVariable Long id) {
        authTokenService.requireAdmin(authorization);
        merchantAdminService.delete(id);
    }
}
