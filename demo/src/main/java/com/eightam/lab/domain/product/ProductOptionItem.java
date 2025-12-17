package com.eightam.lab.domain.product;

import java.util.Objects;

public class ProductOptionItem {

    private String value;
    private String label;
    private boolean visible = true;

    public ProductOptionItem() {
    }

    public ProductOptionItem(String value, String label, boolean visible) {
        this.value = value;
        this.label = label;
        this.visible = visible;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public boolean isVisible() {
        return visible;
    }

    public void setVisible(boolean visible) {
        this.visible = visible;
    }

    public ProductOptionItem copy() {
        return new ProductOptionItem(value, label, visible);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ProductOptionItem that)) return false;
        return visible == that.visible
                && Objects.equals(value, that.value)
                && Objects.equals(label, that.label);
    }

    @Override
    public int hashCode() {
        return Objects.hash(value, label, visible);
    }
}
