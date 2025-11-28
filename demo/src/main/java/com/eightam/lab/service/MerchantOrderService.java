package com.eightam.lab.service;

import com.eightam.lab.dto.MerchantOrderView;
import com.eightam.lab.dto.MerchantOrdersResponse;
import com.eightam.lab.entity.DrinkOrder;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.entity.OrderStatus;
import com.eightam.lab.repository.DrinkOrderRepository;
import com.eightam.lab.repository.MerchantRepository;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class MerchantOrderService {

    private final DrinkOrderRepository drinkOrderRepository;
    private final MerchantRepository merchantRepository;

    public MerchantOrderService(DrinkOrderRepository drinkOrderRepository,
                                MerchantRepository merchantRepository) {
        this.drinkOrderRepository = drinkOrderRepository;
        this.merchantRepository = merchantRepository;
    }

    @Transactional(readOnly = true)
    public MerchantOrdersResponse fetchOrders(Long merchantId) {
        Merchant merchant = merchantRepository.findById(merchantId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "门店不存在"));

        List<MerchantOrderView> orders = drinkOrderRepository.findByMerchantIdOrderByCreatedAtDesc(merchantId)
                .stream()
                .map(this::toView)
                .collect(Collectors.toList());

        long received = drinkOrderRepository.countByMerchantIdAndStatus(merchantId, OrderStatus.RECEIVED);
        long preparing = drinkOrderRepository.countByMerchantIdAndStatus(merchantId, OrderStatus.PREPARING);
        long ready = drinkOrderRepository.countByMerchantIdAndStatus(merchantId, OrderStatus.READY);
        long completed = drinkOrderRepository.countByMerchantIdAndStatus(merchantId, OrderStatus.COMPLETED);

        return new MerchantOrdersResponse(merchant.getName(), received, preparing, ready, completed, orders);
    }

    @Transactional
    public MerchantOrderView updateStatus(Long orderId, Long merchantId, OrderStatus status) {
        DrinkOrder order = drinkOrderRepository.findByIdAndMerchantId(orderId, merchantId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "订单不存在"));
        order.setStatus(status);
        return toView(order);
    }

    private MerchantOrderView toView(DrinkOrder order) {
        return new MerchantOrderView(
                order.getId(),
                order.getDrink().getName(),
                order.getQuantity(),
                order.getStatus().name(),
                order.getPickupTime(),
                order.getCreatedAt(),
                order.getCustomerName(),
                order.getContactPhone()
        );
    }
}
