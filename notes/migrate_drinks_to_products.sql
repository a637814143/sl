-- 将旧版 drinks 数据迁移至新版商品主表 / 门店商品表结构的示例脚本

-- 1. 先把旧 drinks 表中的基础信息写入 products（总部 SKU 仓）
INSERT INTO products (sku_code, name, base_price, description, image_url, flavor_profile, category, is_active, created_at, updated_at)
SELECT CONCAT('LEGACY-', LPAD(d.id, 5, '0')),
       d.name,
       d.price,
       d.description,
       d.image_url,
       d.flavor_profile,
       'legacy',
       d.is_available,
       NOW(6),
       NOW(6)
FROM drinks d;

-- 2. 为每个门店构建 merchant_products，沿用原 merchant_id 与商品可售状态
INSERT INTO merchant_products (merchant_id, product_id, custom_name, custom_price, alias_code,
                               daily_stock_limit, available_stock, available_start, available_end,
                               is_available, display_order, created_at, updated_at)
SELECT COALESCE(d.merchant_id, m.id) AS merchant_id,
       p.id                         AS product_id,
       d.name                       AS custom_name,
       d.price                      AS custom_price,
       CONCAT('SKU-', d.id)         AS alias_code,
       50                            AS daily_stock_limit,
       50                            AS available_stock,
       NULL,
       NULL,
       d.is_available,
       d.id,
       NOW(6),
       NOW(6)
FROM drinks d
JOIN products p ON p.name = d.name
LEFT JOIN merchants m ON d.merchant_id = m.id;

-- 3. 补齐历史订单引用，确保订单指向新的门店 SKU 和总部 SKU
UPDATE drink_orders o
JOIN merchant_products mp ON mp.alias_code = CONCAT('SKU-', o.drink_id)
JOIN products p ON p.id = mp.product_id
SET o.merchant_product_id   = mp.id,
    o.product_id            = p.id,
    o.price_snapshot        = mp.custom_price,
    o.product_name_snapshot = mp.custom_name;

-- 4. 清理旧 drinks 表（可选，待确认后删除）
-- DROP TABLE drinks;
