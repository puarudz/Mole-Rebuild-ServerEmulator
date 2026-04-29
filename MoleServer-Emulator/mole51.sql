-- Tạo CSDL
CREATE DATABASE IF NOT EXISTS mole51 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mole51;

-- Bảng Người chơi (users)
CREATE TABLE IF NOT EXISTS users (
    user_id INT UNSIGNED PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    nick VARCHAR(16) DEFAULT 'NewMole',
    color INT UNSIGNED DEFAULT 8028160, -- Màu đỏ mặc định (0x7A0000)
    vip TINYINT UNSIGNED DEFAULT 0,
    super_lamu TINYINT UNSIGNED DEFAULT 0,
    coins INT UNSIGNED DEFAULT 10000,
    exp INT UNSIGNED DEFAULT 0,
    strong INT UNSIGNED DEFAULT 0,
    iq INT UNSIGNED DEFAULT 0,
    charm INT UNSIGNED DEFAULT 0,
    qu INT UNSIGNED DEFAULT 0,
    job INT UNSIGNED DEFAULT 0,
    role_type INT UNSIGNED DEFAULT 0,
    -- VIP System
    vip_flags INT UNSIGNED DEFAULT 33 COMMENT 'Bitmask: bit0=đang VIP, bit5=từng VIP. 33=VIP+từng VIP',
    vip_level TINYINT UNSIGNED DEFAULT 8 COMMENT 'Cấp VIP 0-8',
    vip_month INT UNSIGNED DEFAULT 12 COMMENT 'Số tháng đã mua VIP',
    vip_value INT UNSIGNED DEFAULT 9999 COMMENT 'Điểm tích lũy VIP',
    vip_end_time INT UNSIGNED DEFAULT 2145916800 COMMENT 'Unix timestamp hết hạn VIP (2037-12-31)',
    auto_pay_vip TINYINT UNSIGNED DEFAULT 1 COMMENT 'Tự động gia hạn VIP',
    -- Tiền tệ bổ sung
    jd_coins INT UNSIGNED DEFAULT 99999 COMMENT 'Đậu Vàng (premium currency)',
    dian_coins INT UNSIGNED DEFAULT 99999 COMMENT 'Đậu Điểm',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng Vật phẩm của người chơi (Túi đồ, Quần áo...)
CREATE TABLE IF NOT EXISTS user_items (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    item_id INT UNSIGNED NOT NULL,
    amount INT UNSIGNED DEFAULT 1,
    is_wearing TINYINT(1) DEFAULT 0, -- 1 nếu đang mặc trên người
    UNIQUE KEY unique_user_item (user_id, item_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng Trang trí nhà cửa
CREATE TABLE IF NOT EXISTS user_home_items (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    item_id INT UNSIGNED NOT NULL,
    amount INT UNSIGNED DEFAULT 1,
    pos_x SMALLINT DEFAULT 0,
    pos_y SMALLINT DEFAULT 0,
    direction TINYINT UNSIGNED DEFAULT 0,
    visible TINYINT UNSIGNED DEFAULT 1,
    layer TINYINT UNSIGNED DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng Bạn bè
CREATE TABLE IF NOT EXISTS user_friends (
    user_id INT UNSIGNED NOT NULL,
    friend_id INT UNSIGNED NOT NULL,
    status TINYINT DEFAULT 1, -- 1: Friend, 2: Blocked (Blacklist)
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng Nhiệm vụ đã hoàn thành
CREATE TABLE IF NOT EXISTS user_tasks (
    user_id INT UNSIGNED NOT NULL,
    task_id INT UNSIGNED NOT NULL,
    status TINYINT DEFAULT 1, -- 1: Completed
    PRIMARY KEY (user_id, task_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng cửa hàng Đậu Vàng (JDGoodsXmlData)
CREATE TABLE IF NOT EXISTS shop_jd_goods (
    commodity_id INT UNSIGNED PRIMARY KEY COMMENT 'ID giao dịch backend',
    item_ids VARCHAR(255) NOT NULL COMMENT 'Item IDs, phân cách bằng | cho combo',
    name VARCHAR(128) NOT NULL COMMENT 'Tên vật phẩm',
    price INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Giá Đậu Vàng',
    vip_discount TINYINT UNSIGNED DEFAULT 100 COMMENT 'Giảm giá VIP (100=full, 80=giảm 20%)',
    nonvip_discount TINYINT UNSIGNED DEFAULT 100 COMMENT 'Giảm giá non-VIP',
    must_vip TINYINT UNSIGNED DEFAULT 0 COMMENT '1=chỉ VIP mới mua được',
    enabled TINYINT UNSIGNED DEFAULT 1 COMMENT '1=đang bán, 0=tắt'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng cửa hàng Đậu Điểm (diandianShop)
CREATE TABLE IF NOT EXISTS shop_diandian (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    item_id INT UNSIGNED NOT NULL COMMENT 'Item ID',
    price INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Giá Đậu Điểm',
    type TINYINT UNSIGNED DEFAULT 1 COMMENT 'Loại: 1=Trang phục, 2=Lamu, 3=Hạt giống, 4=Động vật, 5=Khác',
    type_name VARCHAR(64) DEFAULT '' COMMENT 'Tên loại',
    enabled TINYINT UNSIGNED DEFAULT 1,
    UNIQUE KEY unique_item (item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tạo một User mẫu
INSERT IGNORE INTO users (user_id, password, nick, color, coins, vip_flags, vip_level, vip_month, vip_value, vip_end_time, auto_pay_vip, jd_coins, dian_coins, beangold) VALUES 
(20000001, MD5('123123'), 'AdminMole', 8028160, 999999, 33, 8, 12, 9999, 2145916800, 1, 99999, 99999, 99999);
