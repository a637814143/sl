package com.eightam.lab.domain.product;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class ProductOptionGroup {

    private boolean enabled;
    private String defaultValue;
    private List<ProductOptionItem> options = new ArrayList<>();

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    public List<ProductOptionItem> getOptions() {
        return options;
    }

    public void setOptions(List<ProductOptionItem> options) {
        this.options = options == null ? new ArrayList<>() : new ArrayList<>(options);
    }

    public ProductOptionGroup copy() {
        ProductOptionGroup clone = new ProductOptionGroup();
        clone.setEnabled(enabled);
        clone.setDefaultValue(defaultValue);
        if (options != null) {
            clone.setOptions(options.stream().map(ProductOptionItem::copy).collect(Collectors.toList()));
        }
        return clone;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ProductOptionGroup that)) return false;
        return enabled == that.enabled
                && Objects.equals(defaultValue, that.defaultValue)
                && Objects.equals(options, that.options);
    }

    @Override
    public int hashCode() {
        return Objects.hash(enabled, defaultValue, options);
    }
}
