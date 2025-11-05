package com.eightam.lab.config;

import com.eightam.lab.entity.Drink;
import com.eightam.lab.repository.DrinkRepository;
import jakarta.annotation.PostConstruct;
import java.math.BigDecimal;
import java.util.Arrays;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer {

    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);

    private final DrinkRepository drinkRepository;

    public DataInitializer(DrinkRepository drinkRepository) {
        this.drinkRepository = drinkRepository;
    }

    @PostConstruct
    public void seed() {
        if (drinkRepository.count() > 0) {
            return;
        }
        log.info("Seeding default drinks");
        Drink sunrise = new Drink();
        sunrise.setName("日出冷萃");
        sunrise.setPrice(new BigDecimal("28.00"));
        sunrise.setDescription("冷萃咖啡搭配柚子果肉，晨光中的微醺酸甜。");
        sunrise.setFlavorProfile("冷萃 · 果酸");
        sunrise.setImageUrl("https://images.example.com/sunrise-coldbrew.png");

        Drink cloud = new Drink();
        cloud.setName("云端芝士抹茶");
        cloud.setPrice(new BigDecimal("32.00"));
        cloud.setDescription("宇治抹茶与轻盈芝士奶盖的分层口感。");
        cloud.setFlavorProfile("抹茶 · 奶香");
        cloud.setImageUrl("https://images.example.com/cloud-matcha.png");

        Drink amber = new Drink();
        amber.setName("琥珀桂花拿铁");
        amber.setPrice(new BigDecimal("30.00"));
        amber.setDescription("烘焙桂花糖浆融入经典拿铁，余味绵长。");
        amber.setFlavorProfile("拿铁 · 花香");
        amber.setImageUrl("https://images.example.com/amber-osmanthus.png");

        drinkRepository.saveAll(Arrays.asList(sunrise, cloud, amber));
    }
}
