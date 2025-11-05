-- Schema generated for 8am Lab commerce platform

DROP TABLE IF EXISTS drink_orders;
DROP TABLE IF EXISTS drinks;
DROP TABLE IF EXISTS lab_users;
DROP TABLE IF EXISTS merchants;

CREATE TABLE merchants (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    contact VARCHAR(255),
    location VARCHAR(255),
    signature_story VARCHAR(512),
    CONSTRAINT pk_merchants PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE lab_users (
    id BIGINT NOT NULL AUTO_INCREMENT,
    username VARCHAR(64) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(32) NOT NULL,
    avatar VARCHAR(255),
    managed_merchant_id BIGINT,
    CONSTRAINT pk_lab_users PRIMARY KEY (id),
    CONSTRAINT uk_lab_users_username UNIQUE (username),
    CONSTRAINT fk_lab_users_merchant FOREIGN KEY (managed_merchant_id) REFERENCES merchants (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE drinks (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description VARCHAR(1024),
    image_url VARCHAR(255),
    flavor_profile VARCHAR(255),
    is_available TINYINT(1) NOT NULL DEFAULT 1,
    merchant_id BIGINT,
    CONSTRAINT pk_drinks PRIMARY KEY (id),
    CONSTRAINT fk_drinks_merchants FOREIGN KEY (merchant_id) REFERENCES merchants (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE drink_orders (
    id BIGINT NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(255) NOT NULL,
    contact_phone VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    pickup_time VARCHAR(255),
    status VARCHAR(32) NOT NULL,
    drink_id BIGINT NOT NULL,
    merchant_id BIGINT NOT NULL,
    created_at DATETIME(6) NOT NULL,
    CONSTRAINT pk_drink_orders PRIMARY KEY (id),
    CONSTRAINT fk_drink_orders_drink FOREIGN KEY (drink_id) REFERENCES drinks (id),
    CONSTRAINT fk_drink_orders_merchant FOREIGN KEY (merchant_id) REFERENCES merchants (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
