package com.eightam.lab.entity.converter;

import com.eightam.lab.domain.product.ProductOptionSettings;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = false)
public class ProductOptionSettingsConverter implements AttributeConverter<ProductOptionSettings, String> {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    @Override
    public String convertToDatabaseColumn(ProductOptionSettings attribute) {
        if (attribute == null) {
            return null;
        }
        try {
            return OBJECT_MAPPER.writeValueAsString(attribute);
        } catch (JsonProcessingException e) {
            throw new IllegalArgumentException("无法序列化商品自定义配置", e);
        }
    }

    @Override
    public ProductOptionSettings convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isBlank()) {
            return null;
        }
        try {
            return OBJECT_MAPPER.readValue(dbData, ProductOptionSettings.class);
        } catch (JsonProcessingException e) {
            throw new IllegalArgumentException("无法解析商品自定义配置", e);
        }
    }
}
