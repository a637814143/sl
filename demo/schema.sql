-- Demo schema for 8am Lab commerce platform

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
    role ENUM ('ADMIN','MERCHANT','CUSTOMER') NOT NULL,
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
    status ENUM ('RECEIVED','PREPARING','READY','COMPLETED','CANCELED') NOT NULL,
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

    create table drink_orders (
        payment_amount decimal(10,2),
        price_snapshot decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        merchant_product_id bigint not null,
        paid_at datetime(6),
        product_id bigint not null,
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        product_name_snapshot varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        birthday date,
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        gender varchar(32),
        phone varchar(32),
        family_name varchar(64),
        given_name varchar(64),
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchant_products (
        available_end time(6),
        available_start time(6),
        available_stock integer,
        custom_price decimal(10,2),
        daily_stock_limit integer,
        display_order integer,
        is_available bit not null,
        created_at datetime(6) not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        product_id bigint not null,
        updated_at datetime(6) not null,
        alias_code varchar(64),
        custom_name varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        latitude float(53),
        longitude float(53),
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price decimal(10,2) not null,
        is_active bit not null,
        created_at datetime(6) not null,
        id bigint not null auto_increment,
        updated_at datetime(6) not null,
        category varchar(64),
        sku_code varchar(64) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table merchant_products 
       add constraint uk_merchant_products unique (merchant_id, product_id);

    alter table products 
       add constraint uk_products_sku unique (sku_code);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drink_orders 
       add constraint FKnoya843oc34tc9rdt5yx84ieh 
       foreign key (merchant_product_id) 
       references merchant_products (id);

    alter table drink_orders 
       add constraint FK6t8441jfdn58hd3i68ila0069 
       foreign key (product_id) 
       references products (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    alter table merchant_products 
       add constraint FK3j54ntnfgl2t99r7d6608mksi 
       foreign key (merchant_id) 
       references merchants (id);

    alter table merchant_products 
       add constraint FKwgrq0admm837qwhefe7n1rab 
       foreign key (product_id) 
       references products (id);
