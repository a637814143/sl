package com.eightam.lab.controller;

import com.eightam.lab.dto.MerchantOrderView;
import com.eightam.lab.dto.MerchantOrdersResponse;
import com.eightam.lab.dto.UpdateOrderStatusRequest;
import com.eightam.lab.entity.OrderStatus;
import com.eightam.lab.service.MerchantOrderService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/merchant/orders")
@CrossOrigin
public class MerchantOrderController {

    private final MerchantOrderService merchantOrderService;

    public MerchantOrderController(MerchantOrderService merchantOrderService) {
        this.merchantOrderService = merchantOrderService;
    }

    @GetMapping
    public MerchantOrdersResponse list(@RequestParam Long merchantId) {
        return merchantOrderService.fetchOrders(merchantId);
    }

    @PatchMapping("/{orderId}/status")
    @ResponseStatus(HttpStatus.OK)
    public MerchantOrderView updateStatus(@PathVariable Long orderId,
                                          @RequestParam Long merchantId,
                                          @Valid @RequestBody UpdateOrderStatusRequest request) {
        OrderStatus status = OrderStatus.valueOf(request.getStatus().toUpperCase());
        return merchantOrderService.updateStatus(orderId, merchantId, status);
    }
}
