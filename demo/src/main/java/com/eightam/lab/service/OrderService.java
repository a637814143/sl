package com.eightam.lab.service;

import com.eightam.lab.dto.CreateOrderRequest;
import com.eightam.lab.dto.OrderOverview;
import com.eightam.lab.dto.OrderResponse;
import com.eightam.lab.entity.DrinkOrder;
import com.eightam.lab.entity.LabUser;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.entity.MerchantProduct;
import com.eightam.lab.entity.OrderStatus;
import com.eightam.lab.entity.Product;
import com.eightam.lab.repository.DrinkOrderRepository;
import com.eightam.lab.repository.LabUserRepository;
import com.eightam.lab.repository.MerchantProductRepository;
import com.eightam.lab.repository.MerchantRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.Objects;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class OrderService {

    private final DrinkOrderRepository drinkOrderRepository;
    private final MerchantProductRepository merchantProductRepository;
    private final MerchantRepository merchantRepository;
    private final LabUserRepository labUserRepository;
    private final LoyaltyService loyaltyService;

    public OrderService(DrinkOrderRepository drinkOrderRepository,
                        MerchantProductRepository merchantProductRepository,
                        MerchantRepository merchantRepository,
                        LabUserRepository labUserRepository,
                        LoyaltyService loyaltyService) {
        this.drinkOrderRepository = drinkOrderRepository;
        this.merchantProductRepository = merchantProductRepository;
        this.merchantRepository = merchantRepository;
        this.labUserRepository = labUserRepository;
        this.loyaltyService = loyaltyService;
    }

    @Transactional
    public OrderResponse placeOrder(CreateOrderRequest request) {
        MerchantProduct merchantProduct = merchantProductRepository.findById(request.drinkId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "未找到对应的商品"));
        Merchant merchant = merchantProduct.getMerchant();
        if (merchant == null || !Objects.equals(merchant.getId(), request.merchantId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "请选择当前门店下的商品");
        }
        if (!merchantProduct.isAvailable()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "该商品暂不可售");
        }
        Product product = merchantProduct.getProduct();
        LabUser customerUser = null;
        if (request.userId() != null) {
            customerUser = labUserRepository.findById(request.userId()).orElse(null);
        }

        DrinkOrder newOrder = new DrinkOrder(
                request.customerName(),
                request.contactPhone(),
                request.quantity(),
                request.pickupTime(),
                OrderStatus.RECEIVED,
                merchant,
                merchantProduct,
                product,
                merchantProduct.getEffectivePrice(),
                merchantProduct.getDisplayName(),
                LocalDateTime.now()
        );
        newOrder.setCustomerUser(customerUser);
        newOrder.setCustomSummary(request.customSummary());
        newOrder.setCustomOptions(request.customizations());

        DrinkOrder saved = drinkOrderRepository.save(newOrder);
        if (customerUser != null) {
            int earnedPoints = calculatePoints(saved);
            loyaltyService.recordEarnedPoints(customerUser.getId(), earnedPoints);
        }
        return toResponse(saved);
    }

    public OrderOverview loadOverview() {
        long received = drinkOrderRepository.countByStatus(OrderStatus.RECEIVED);
        long preparing = drinkOrderRepository.countByStatus(OrderStatus.PREPARING);
        long ready = drinkOrderRepository.countByStatus(OrderStatus.READY);
        long completed = drinkOrderRepository.countByStatus(OrderStatus.COMPLETED);
        String topDrink = drinkOrderRepository.findTopSellingDrinkNames(PageRequest.of(0, 1))
                .stream()
                .filter(Objects::nonNull)
                .findFirst()
                .orElse("探索8AM人气风味");
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
                order.resolveProductName(),
                order.getMerchant().getName(),
                order.getCreatedAt(),
                order.getCustomSummary(),
                order.getCustomOptions()
        );
    }

    private int calculatePoints(DrinkOrder order) {
        BigDecimal unitPrice = order.resolveUnitPrice();
        if (unitPrice == null) {
            return 0;
        }
        BigDecimal total = unitPrice.multiply(BigDecimal.valueOf(order.getQuantity()));
        if (total.signum() <= 0) {
            return 0;
        }
        return total.setScale(0, RoundingMode.DOWN).intValue();
    }
}
