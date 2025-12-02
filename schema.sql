-- Schema generated for 8am Lab commerce platform

DROP TABLE IF EXISTS drink_orders;
DROP TABLE IF EXISTS merchant_products;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS lab_users;
DROP TABLE IF EXISTS merchants;

CREATE TABLE merchants (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    contact VARCHAR(255),
    location VARCHAR(255),
    latitude DOUBLE,
    longitude DOUBLE,
    signature_story VARCHAR(512),
    CONSTRAINT pk_merchants PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE lab_users (
    id BIGINT NOT NULL AUTO_INCREMENT,
    username VARCHAR(64) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    family_name VARCHAR(64),
    given_name VARCHAR(64),
    gender VARCHAR(32),
    phone VARCHAR(32),
    birthday DATE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(32) NOT NULL,
    avatar VARCHAR(255),
    managed_merchant_id BIGINT,
    CONSTRAINT pk_lab_users PRIMARY KEY (id),
    CONSTRAINT uk_lab_users_username UNIQUE (username),
    CONSTRAINT fk_lab_users_merchant FOREIGN KEY (managed_merchant_id) REFERENCES merchants (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products (
    id BIGINT NOT NULL AUTO_INCREMENT,
    sku_code VARCHAR(64) NOT NULL,
    name VARCHAR(255) NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    description VARCHAR(1024),
    image_url VARCHAR(255),
    flavor_profile VARCHAR(255),
    category VARCHAR(64),
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT pk_products PRIMARY KEY (id),
    CONSTRAINT uk_products_sku UNIQUE (sku_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE merchant_products (
    id BIGINT NOT NULL AUTO_INCREMENT,
    merchant_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    custom_name VARCHAR(255),
    custom_price DECIMAL(10,2),
    alias_code VARCHAR(64),
    daily_stock_limit INT,
    available_stock INT,
    available_start TIME,
    available_end TIME,
    is_available TINYINT(1) NOT NULL DEFAULT 1,
    display_order INT DEFAULT 0,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT pk_merchant_products PRIMARY KEY (id),
    CONSTRAINT fk_merchant_products_merchant FOREIGN KEY (merchant_id) REFERENCES merchants (id),
    CONSTRAINT fk_merchant_products_product FOREIGN KEY (product_id) REFERENCES products (id),
    CONSTRAINT uk_merchant_products UNIQUE (merchant_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE drink_orders (
    id BIGINT NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(255) NOT NULL,
    contact_phone VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    pickup_time VARCHAR(255),
    status VARCHAR(32) NOT NULL,
    merchant_id BIGINT NOT NULL,
    merchant_product_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    price_snapshot DECIMAL(10,2),
    product_name_snapshot VARCHAR(255),
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT pk_drink_orders PRIMARY KEY (id),
    CONSTRAINT fk_drink_orders_merchant FOREIGN KEY (merchant_id) REFERENCES merchants (id),
    CONSTRAINT fk_drink_orders_merchant_product FOREIGN KEY (merchant_product_id) REFERENCES merchant_products (id),
    CONSTRAINT fk_drink_orders_product FOREIGN KEY (product_id) REFERENCES products (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
