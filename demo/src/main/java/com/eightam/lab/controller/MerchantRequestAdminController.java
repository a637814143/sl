package com.eightam.lab.controller;

import com.eightam.lab.dto.MerchantRequestResponse;
import com.eightam.lab.service.MerchantRequestService;
import java.util.List;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/merchant-requests")
@CrossOrigin
public class MerchantRequestAdminController {

    private final MerchantRequestService merchantRequestService;

    public MerchantRequestAdminController(MerchantRequestService merchantRequestService) {
        this.merchantRequestService = merchantRequestService;
    }

    @GetMapping
    public List<MerchantRequestResponse> list() {
        return merchantRequestService.listAll();
    }

    @PostMapping("/{id}/approve")
    public MerchantRequestResponse approve(@PathVariable Long id) {
        return merchantRequestService.approve(id);
    }

    @PostMapping("/{id}/reject")
    public MerchantRequestResponse reject(@PathVariable Long id) {
        return merchantRequestService.reject(id);
    }
}
