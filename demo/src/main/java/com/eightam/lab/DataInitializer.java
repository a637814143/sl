package com.eightam.lab;

import com.eightam.lab.entity.Drink;
import com.eightam.lab.entity.DrinkOrder;
import com.eightam.lab.entity.LabUser;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.entity.OrderStatus;
import com.eightam.lab.entity.UserRole;
import com.eightam.lab.repository.DrinkOrderRepository;
import com.eightam.lab.repository.DrinkRepository;
import com.eightam.lab.repository.LabUserRepository;
import com.eightam.lab.repository.MerchantRepository;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataInitializer {

    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);

    @Bean
    CommandLineRunner loadSampleData(DrinkRepository drinkRepository,
                                     MerchantRepository merchantRepository,
                                     LabUserRepository labUserRepository,
                                     DrinkOrderRepository drinkOrderRepository,
                                     PasswordEncoder passwordEncoder) {
        return args -> {
            if (merchantRepository.count() > 0) {
                log.info("Skip data initialization");
                return;
            }

            Merchant labBar = merchantRepository.save(new Merchant(
                    "8am实验室Lab Bar",
                    "138-0000-0001",
                    "广州·珠江新城IFS北塔1F",
                    "晨间灵感在此觉醒"
            ));

            Merchant coCreation = merchantRepository.save(new Merchant(
                    "8am共创栈",
                    "138-0000-0002",
                    "深圳·后海万象城L3",
                    "和创作者一起发明咖啡与甜品风味"
            ));

            drinkRepository.save(new Drink(
                    "冷压蓝山精萃",
                    new BigDecimal("28.00"),
                    "严选蓝山冷泡12小时，搭配蜜桃气泡，唤醒温柔晨光。",
                    "https://images.8amlab.cn/drink-blue-mountain.png",
                    "果香·花香·轻气泡",
                    true,
                    labBar
            ));

            drinkRepository.save(new Drink(
                    "黑芝麻豆乳拿铁",
                    new BigDecimal("26.00"),
                    "炭焙浓缩叠加黑芝麻酱与豆乳泡沫，厚实又顺滑。",
                    "https://images.8amlab.cn/drink-sesame-latte.png",
                    "坚果·豆乳·丝滑泡沫",
                    true,
                    labBar
            ));

            drinkRepository.save(new Drink(
                    "流心巴斯克芝士",
                    new BigDecimal("36.00"),
                    "使用北海道奶油芝士，低温烘烤保留流心质地，适合搭配手冲。",
                    "https://images.8amlab.cn/dessert-basque.png",
                    "芝香·焦糖·轻咸",
                    true,
                    coCreation
            ));

            LabUser admin = new LabUser("Evelyn", UserRole.ADMIN,
                    "https://images.8amlab.cn/avatars/admin-evelyn.png");
            admin.setUsername("admin");
            admin.setPasswordHash(passwordEncoder.encode("admin123"));
            labUserRepository.save(admin);

            LabUser merchant = new LabUser("Noah", UserRole.MERCHANT,
                    "https://images.8amlab.cn/avatars/merchant-noah.png");
            merchant.setUsername("merchant");
            merchant.setPasswordHash(passwordEncoder.encode("merchant123"));
            merchant.setManagedMerchant(labBar);
            labUserRepository.save(merchant);

            LabUser customer = new LabUser("Iris", UserRole.CUSTOMER,
                    "https://images.8amlab.cn/avatars/customer-iris.png");
            customer.setUsername("iris");
            customer.setPasswordHash(passwordEncoder.encode("iris123"));
            labUserRepository.save(customer);

            List<Drink> drinks = drinkRepository.findAll();

            drinkOrderRepository.save(new DrinkOrder(
                    "Evelyn",
                    "13800000001",
                    2,
                    "10:30",
                    OrderStatus.PREPARING,
                    drinks.get(0),
                    labBar,
                    LocalDateTime.now().minusMinutes(25)
            ));
            drinkOrderRepository.save(new DrinkOrder(
                    "Iris",
                    "13800000002",
                    1,
                    "11:00",
                    OrderStatus.READY,
                    drinks.get(1),
                    labBar,
                    LocalDateTime.now().minusMinutes(10)
            ));
        };
    }
}
