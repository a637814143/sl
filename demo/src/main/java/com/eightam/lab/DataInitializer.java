package com.eightam.lab;

import com.eightam.lab.entity.DrinkOrder;
import com.eightam.lab.entity.LabUser;
import com.eightam.lab.entity.Merchant;
import com.eightam.lab.entity.MerchantProduct;
import com.eightam.lab.entity.OrderStatus;
import com.eightam.lab.entity.Product;
import com.eightam.lab.entity.UserRole;
import com.eightam.lab.repository.DrinkOrderRepository;
import com.eightam.lab.repository.LabUserRepository;
import com.eightam.lab.repository.MerchantProductRepository;
import com.eightam.lab.repository.MerchantRepository;
import com.eightam.lab.repository.ProductRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
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
    CommandLineRunner loadSampleData(MerchantRepository merchantRepository,
                                     ProductRepository productRepository,
                                     MerchantProductRepository merchantProductRepository,
                                     LabUserRepository labUserRepository,
                                     DrinkOrderRepository drinkOrderRepository,
                                     PasswordEncoder passwordEncoder) {
        return args -> {
            if (merchantRepository.count() > 0 || productRepository.count() > 0) {
                log.info("Skip data initialization");
                return;
            }

            Merchant labBar = merchantRepository.save(new Merchant(
                    "8AM实验室 Lab Bar",
                    "138-0000-0001",
                    "广州·珠江新城IFC北塔1F",
                    "晨间灵感在此觉醒",
                    23.12911,
                    113.264385
            ));

            Merchant coCreation = merchantRepository.save(new Merchant(
                    "8AM共创社",
                    "138-0000-0002",
                    "深圳·后海万象城L3",
                    "和创作者一起发明饮品风味",
                    22.521307,
                    113.938896
            ));

            Product coldBrew = productRepository.save(buildProduct(
                    "SKU-1001",
                    "冷压蓝山精酿",
                    new BigDecimal("28.00"),
                    "严选蓝山冷萃12小时，搭配蜜桃气泡，唤醒温柔晨光。",
                    "https://images.8amlab.cn/drink-blue-mountain.png",
                    "果香 · 花香 · 轻气泡",
                    "classic"
            ));

            Product oolongLatte = productRepository.save(buildProduct(
                    "SKU-1002",
                    "小序乌龙拿铁",
                    new BigDecimal("24.00"),
                    "手熏乌龙与A2生乳调和，口感层层递进。",
                    "https://images.8amlab.cn/drink-oolong-latte.png",
                    "焙香 · 乳香 · 细腻泡沫",
                    "classic"
            ));

            Product whiteNoise = productRepository.save(buildProduct(
                    "SKU-1003",
                    "白噪音茉莉",
                    new BigDecimal("22.00"),
                    "文火熬煮的蜜渍白茉莉与冷压柠檬，清爽不甜腻。",
                    "https://images.8amlab.cn/drink-white-noise.png",
                    "柑橘 · 花香 · 低糖",
                    "special"
            ));

            MerchantProduct labColdBrew = merchantProductRepository.save(buildMerchantProduct(
                    labBar, coldBrew, "Lab 经典冷萃", new BigDecimal("28.00"), 1));
            MerchantProduct labOolong = merchantProductRepository.save(buildMerchantProduct(
                    labBar, oolongLatte, null, new BigDecimal("25.00"), 2));
            MerchantProduct coWhiteNoise = merchantProductRepository.save(buildMerchantProduct(
                    coCreation, whiteNoise, "白噪音茉莉", null, 1));
            MerchantProduct coColdBrew = merchantProductRepository.save(buildMerchantProduct(
                    coCreation, coldBrew, "山野冷萃", new BigDecimal("29.00"), 2));

            createSampleUsers(labUserRepository, passwordEncoder, labBar);

            createSampleOrders(drinkOrderRepository, labBar, labColdBrew, coldBrew);
            createSampleOrders(drinkOrderRepository, coCreation, coWhiteNoise, whiteNoise);
        };
    }

    private Product buildProduct(String sku, String name, BigDecimal price, String description,
                                 String imageUrl, String flavorProfile, String category) {
        Product product = new Product();
        product.setSkuCode(sku);
        product.setName(name);
        product.setBasePrice(price);
        product.setDescription(description);
        product.setImageUrl(imageUrl);
        product.setFlavorProfile(flavorProfile);
        product.setCategory(category);
        product.setActive(true);
        return product;
    }

    private MerchantProduct buildMerchantProduct(Merchant merchant, Product product,
                                                 String customName, BigDecimal customPrice,
                                                 int displayOrder) {
        MerchantProduct merchantProduct = new MerchantProduct();
        merchantProduct.setMerchant(merchant);
        merchantProduct.setProduct(product);
        merchantProduct.setCustomName(customName);
        merchantProduct.setCustomPrice(customPrice);
        merchantProduct.setDailyStockLimit(50);
        merchantProduct.setAvailableStock(50);
        merchantProduct.setAvailable(true);
        merchantProduct.setDisplayOrder(displayOrder);
        return merchantProduct;
    }

    private void createSampleUsers(LabUserRepository labUserRepository,
                                   PasswordEncoder passwordEncoder,
                                   Merchant managedMerchant) {
        LabUser admin = new LabUser("Evelyn", UserRole.ADMIN,
                "https://images.8amlab.cn/avatars/admin-evelyn.png");
        admin.setUsername("admin");
        admin.setPasswordHash(passwordEncoder.encode("admin123"));
        admin.setFamilyName("Zhang");
        admin.setGivenName("Evelyn");
        admin.setGender("女");
        admin.setPhone("13800000001");
        admin.setBirthday(LocalDate.of(1992, 3, 18));
        labUserRepository.save(admin);

        LabUser merchant = new LabUser("Noah", UserRole.MERCHANT,
                "https://images.8amlab.cn/avatars/merchant-noah.png");
        merchant.setUsername("merchant");
        merchant.setPasswordHash(passwordEncoder.encode("merchant123"));
        merchant.setManagedMerchant(managedMerchant);
        merchant.setFamilyName("Li");
        merchant.setGivenName("Noah");
        merchant.setGender("男");
        merchant.setPhone("13800000002");
        merchant.setBirthday(LocalDate.of(1990, 11, 5));
        labUserRepository.save(merchant);

        LabUser customer = new LabUser("Iris", UserRole.CUSTOMER,
                "https://images.8amlab.cn/avatars/customer-iris.png");
        customer.setUsername("iris");
        customer.setPasswordHash(passwordEncoder.encode("iris123"));
        customer.setFamilyName("Chen");
        customer.setGivenName("Iris");
        customer.setGender("女");
        customer.setPhone("13800000003");
        customer.setBirthday(LocalDate.of(1995, 7, 9));
        labUserRepository.save(customer);
    }

    private void createSampleOrders(DrinkOrderRepository drinkOrderRepository,
                                    Merchant merchant,
                                    MerchantProduct merchantProduct,
                                    Product product) {
        List<DrinkOrder> seed = List.of(
                new DrinkOrder(
                        "Evelyn",
                        "13800000001",
                        2,
                        "10:30",
                        OrderStatus.PREPARING,
                        merchant,
                        merchantProduct,
                        product,
                        merchantProduct.getEffectivePrice(),
                        merchantProduct.getDisplayName(),
                        LocalDateTime.now().minusMinutes(25)
                ),
                new DrinkOrder(
                        "Iris",
                        "13800000002",
                        1,
                        "11:00",
                        OrderStatus.READY,
                        merchant,
                        merchantProduct,
                        product,
                        merchantProduct.getEffectivePrice(),
                        merchantProduct.getDisplayName(),
                        LocalDateTime.now().minusMinutes(10)
                )
        );
        drinkOrderRepository.saveAll(seed);
    }
}
