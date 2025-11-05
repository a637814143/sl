package com.eightam.lab.service;

import com.eightam.lab.dto.AdminDashboardResponse;
import com.eightam.lab.repository.DrinkOrderRepository;
import com.eightam.lab.repository.DrinkRepository;
import com.eightam.lab.repository.LabUserRepository;
import com.eightam.lab.repository.MerchantRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {

    private final DrinkRepository drinkRepository;
    private final MerchantRepository merchantRepository;
    private final DrinkOrderRepository drinkOrderRepository;
    private final LabUserRepository labUserRepository;

    public DashboardService(DrinkRepository drinkRepository,
                            MerchantRepository merchantRepository,
                            DrinkOrderRepository drinkOrderRepository,
                            LabUserRepository labUserRepository) {
        this.drinkRepository = drinkRepository;
        this.merchantRepository = merchantRepository;
        this.drinkOrderRepository = drinkOrderRepository;
        this.labUserRepository = labUserRepository;
    }

    public AdminDashboardResponse loadAdminSummary() {
        long drinkCount = drinkRepository.count();
        long merchantCount = merchantRepository.count();
        long orderCount = drinkOrderRepository.count();
        long userCount = labUserRepository.count();
        String topDrink = drinkOrderRepository.findTopSellingDrinkNames(PageRequest.of(0, 1))
                .stream()
                .findFirst()
                .orElse("探索8am人气风味");
        return new AdminDashboardResponse(drinkCount, merchantCount, orderCount, userCount, topDrink);
    }
}
