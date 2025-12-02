
    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
    managed_merchant_id bigint,
    username varchar(64) not null,
    display_name varchar(128) not null,
    family_name varchar(64),
    given_name varchar(64),
    gender varchar(32),
    phone varchar(32),
    birthday date,
    avatar varchar(255),
    password_hash varchar(255) not null,
    role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
    signature_story varchar(512),
    latitude double,
    longitude double,
    contact varchar(255),
    location varchar(255),
    name varchar(255) not null,
    primary key (id)
) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
        primary key (id)
    ) engine=InnoDB;

    create table lab_users (
        id bigint not null auto_increment,
        managed_merchant_id bigint,
        username varchar(64) not null,
        display_name varchar(128) not null,
        avatar varchar(255),
        password_hash varchar(255) not null,
        role enum ('ADMIN','MERCHANT','CUSTOMER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    create table merchants (
        id bigint not null auto_increment,
        signature_story varchar(512),
        contact varchar(255),
        location varchar(255),
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);

    create table drink_orders (
        payment_amount decimal(10,2),
        quantity integer not null,
        created_at datetime(6) not null,
        drink_id bigint not null,
        id bigint not null auto_increment,
        merchant_id bigint not null,
        paid_at datetime(6),
        payment_status varchar(32),
        payment_trade_no varchar(64),
        contact_phone varchar(255) not null,
        customer_name varchar(255) not null,
        pickup_time varchar(255),
        status enum ('RECEIVED','PREPARING','READY','COMPLETED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table drinks (
        is_available bit not null,
        price decimal(10,2) not null,
        id bigint not null auto_increment,
        merchant_id bigint,
        name varchar(128) not null,
        description varchar(1024),
        flavor_profile varchar(255),
        image_url varchar(255),
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

    alter table lab_users 
       add constraint UK_2f17fnuw0d0kbqwa4li7xygx1 unique (username);

    alter table drink_orders 
       add constraint FK33tesw3w9gv4dxac2p6kv92va 
       foreign key (drink_id) 
       references drinks (id);

    alter table drink_orders 
       add constraint FK2pcst7l5x6a864hdtddfv31mx 
       foreign key (merchant_id) 
       references merchants (id);

    alter table drinks 
       add constraint FK7r6ffeabq47xnijujci0ug6dn 
       foreign key (merchant_id) 
       references merchants (id);

    alter table lab_users 
       add constraint FKnfywwe07n8lly6liqmjd014bv 
       foreign key (managed_merchant_id) 
       references merchants (id);
