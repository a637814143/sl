package com.eightam.lab.domain.product;

import java.util.List;

public class ProductOptionSettings {

    private ProductOptionGroup sugar;
    private ProductOptionGroup tableware;
    private ProductOptionGroup pourDemo;

    public ProductOptionGroup getSugar() {
        return sugar;
    }

    public void setSugar(ProductOptionGroup sugar) {
        this.sugar = sugar;
    }

    public ProductOptionGroup getTableware() {
        return tableware;
    }

    public void setTableware(ProductOptionGroup tableware) {
        this.tableware = tableware;
    }

    public ProductOptionGroup getPourDemo() {
        return pourDemo;
    }

    public void setPourDemo(ProductOptionGroup pourDemo) {
        this.pourDemo = pourDemo;
    }

    public ProductOptionSettings copy() {
        ProductOptionSettings clone = new ProductOptionSettings();
        clone.setSugar(sugar != null ? sugar.copy() : null);
        clone.setTableware(tableware != null ? tableware.copy() : null);
        clone.setPourDemo(pourDemo != null ? pourDemo.copy() : null);
        return clone;
    }

    public static ProductOptionSettings defaultsForCategory(String category) {
        return prepareForCategory(category, null);
    }

    public static ProductOptionSettings prepareForCategory(String category, ProductOptionSettings provided) {
        boolean dessert = isDessert(category);
        boolean pour = isPour(category);
        boolean sugarEnabled = !dessert && !pour;

        ProductOptionSettings defaults = new ProductOptionSettings();
        defaults.setSugar(buildSugarGroup(sugarEnabled));
        defaults.setTableware(buildTablewareGroup(dessert));
        defaults.setPourDemo(buildPourDemoGroup(pour));

        ProductOptionSettings resolved = defaults.copy();
        if (provided == null) {
            return resolved;
        }

        if (sugarEnabled && provided.getSugar() != null) {
            resolved.setSugar(provided.getSugar().copy());
        }
        if (dessert && provided.getTableware() != null) {
            resolved.setTableware(provided.getTableware().copy());
        }
        if (pour && provided.getPourDemo() != null) {
            resolved.setPourDemo(provided.getPourDemo().copy());
        }
        return resolved;
    }

    private static ProductOptionGroup buildSugarGroup(boolean enabled) {
        ProductOptionGroup group = new ProductOptionGroup();
        group.setEnabled(enabled);
        group.setDefaultValue("seven");
        group.setOptions(List.of(
                new ProductOptionItem("seven", "店主推荐", true),
                new ProductOptionItem("five", "半糖", true),
                new ProductOptionItem("zero", "无糖", true)
        ));
        return group;
    }

    private static ProductOptionGroup buildTablewareGroup(boolean enabled) {
        ProductOptionGroup group = new ProductOptionGroup();
        group.setEnabled(enabled);
        group.setDefaultValue("one");
        group.setOptions(List.of(
                new ProductOptionItem("one", "1份", true),
                new ProductOptionItem("two", "2份", true),
                new ProductOptionItem("none", "不需要", true)
        ));
        return group;
    }

    private static ProductOptionGroup buildPourDemoGroup(boolean enabled) {
        ProductOptionGroup group = new ProductOptionGroup();
        group.setEnabled(enabled);
        group.setDefaultValue("skip");
        group.setOptions(List.of(
                new ProductOptionItem("show", "需要现场演示", true),
                new ProductOptionItem("skip", "不需要演示", true)
        ));
        return group;
    }

    private static boolean isDessert(String category) {
        if (category == null) {
            return false;
        }
        return "DESSERT".equalsIgnoreCase(category.trim());
    }

    private static boolean isPour(String category) {
        if (category == null) {
            return false;
        }
        return "POUR".equalsIgnoreCase(category.trim());
    }
}
