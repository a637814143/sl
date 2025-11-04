package com.eightam.lab.service;

import com.eightam.lab.domain.Drink;
import com.eightam.lab.domain.DrinkOrder;
import com.eightam.lab.domain.Merchant;
import com.eightam.lab.domain.OrderStatus;
import com.eightam.lab.dto.CreateOrderRequest;
import com.eightam.lab.dto.OrderOverview;
import com.eightam.lab.dto.OrderResponse;
import com.eightam.lab.repository.DrinkOrderRepository;
import com.eightam.lab.repository.DrinkRepository;
import com.eightam.lab.repository.MerchantRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class OrderService {

    private final DrinkOrderRepository drinkOrderRepository;
    private final DrinkRepository drinkRepository;
    private final MerchantRepository merchantRepository;

    public OrderService(DrinkOrderRepository drinkOrderRepository,
                        DrinkRepository drinkRepository,
                        MerchantRepository merchantRepository) {
        this.drinkOrderRepository = drinkOrderRepository;
        this.drinkRepository = drinkRepository;
        this.merchantRepository = merchantRepository;
    }

    @Transactional
    public OrderResponse placeOrder(CreateOrderRequest request) {
        Drink drink = drinkRepository.findById(request.drinkId())
                .orElseThrow(() -> new IllegalArgumentException("找不到对应的饮品"));
        if (!drink.isAvailable()) {
            throw new IllegalStateException("该饮品暂时无法购买");
        }
        Merchant merchant = merchantRepository.findById(request.merchantId())
                .orElseThrow(() -> new IllegalArgumentException("找不到对应的门店"));

        DrinkOrder newOrder = new DrinkOrder(
                request.customerName(),
                request.contactPhone(),
                request.quantity(),
                request.pickupTime(),
                OrderStatus.RECEIVED,
                drink,
                merchant,
                LocalDateTime.now()
        );

        DrinkOrder saved = drinkOrderRepository.save(newOrder);
        return toResponse(saved);
    }

    public OrderOverview loadOverview() {
        long received = drinkOrderRepository.countByStatus(OrderStatus.RECEIVED);
        long preparing = drinkOrderRepository.countByStatus(OrderStatus.PREPARING);
        long ready = drinkOrderRepository.countByStatus(OrderStatus.READY);
        long completed = drinkOrderRepository.countByStatus(OrderStatus.COMPLETED);
        String topDrink = drinkOrderRepository.findTopSellingDrinkNames(PageRequest.of(0, 1))
                .stream()
                .findFirst()
                .orElse("探索8am人气风味");
        return new OrderOverview(received, preparing, ready, completed, topDrink);
    }

    private OrderResponse toResponse(DrinkOrder order) {
        return new OrderResponse(
                order.getId(),
                order.getCustomerName(),
                order.getContactPhone(),
                order.getQuantity(),
                order.getPickupTime(),
                order.getStatus().name(),
                order.getDrink().getName(),
                order.getMerchant().getName(),
                order.getCreatedAt()
        );
    }
}
