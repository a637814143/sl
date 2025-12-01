package com.eightam.lab;

import com.eightam.lab.config.AlipayProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties(AlipayProperties.class)
public class EightAmLabApplication {

    public static void main(String[] args) {
        SpringApplication.run(EightAmLabApplication.class, args);
    }
}
