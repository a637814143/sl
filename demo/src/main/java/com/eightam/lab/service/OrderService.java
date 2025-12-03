package com.eightam.lab.service;

import com.eightam.lab.dto.CreateOrderRequest;
import com.eightam.lab.dto.OrderOverview;
import com.eightam.lab.dto.OrderResponse;
import com.eightam.lab.entity.DrinkOrder;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.entity.MerchantProduct;
import com.eightam.lab.entity.OrderStatus;
import com.eightam.lab.entity.Product;
import com.eightam.lab.repository.DrinkOrderRepository;
import com.eightam.lab.repository.MerchantProductRepository;
import com.eightam.lab.repository.MerchantRepository;
import java.time.LocalDateTime;
import java.util.Objects;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

@Service
public class OrderService {

    private final DrinkOrderRepository drinkOrderRepository;
    private final MerchantProductRepository merchantProductRepository;
    private final MerchantRepository merchantRepository;

    public OrderService(DrinkOrderRepository drinkOrderRepository,
                        MerchantProductRepository merchantProductRepository,
                        MerchantRepository merchantRepository) {
        this.drinkOrderRepository = drinkOrderRepository;
        this.merchantProductRepository = merchantProductRepository;
        this.merchantRepository = merchantRepository;
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
                order.getCreatedAt()
        );
    }
}
