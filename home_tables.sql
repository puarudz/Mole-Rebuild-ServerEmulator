-- Tạo bảng cấu hình chính của nhà (nền nhà, ngôi nhà)
CREATE TABLE IF NOT EXISTS `home_state` (
    `user_id`    INT UNSIGNED NOT NULL,
    `house_id`   INT UNSIGNED NOT NULL DEFAULT 160030,
    `terrain_id` INT UNSIGNED NOT NULL DEFAULT 1220001,
    `house_x`    SMALLINT NOT NULL DEFAULT 114,
    `house_y`    SMALLINT NOT NULL DEFAULT 262,
    `house_dir`  TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Đồ đang đặt trong sân
CREATE TABLE IF NOT EXISTS `home_used_items` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id`     INT UNSIGNED NOT NULL,
    `slot_index`  SMALLINT    NOT NULL DEFAULT 0,
    `item_id`     INT UNSIGNED NOT NULL,
    `pos_x`       SMALLINT    NOT NULL DEFAULT 0,
    `pos_y`       SMALLINT    NOT NULL DEFAULT 0,
    `direction`   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `visible`     TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `layer`       TINYINT UNSIGNED NOT NULL DEFAULT 4,
    `type`        TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `other`       INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    INDEX `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Đồ đặt trong nhà
CREATE TABLE IF NOT EXISTS `home_room_items` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id`     INT UNSIGNED NOT NULL,
    `slot_index`  SMALLINT    NOT NULL DEFAULT 0,
    `item_id`     INT UNSIGNED NOT NULL,
    `pos_x`       SMALLINT    NOT NULL DEFAULT 0,
    `pos_y`       SMALLINT    NOT NULL DEFAULT 0,
    `direction`   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `visible`     TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `layer`       TINYINT UNSIGNED NOT NULL DEFAULT 4,
    `type`        TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `rotation`    TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    INDEX `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Kho đồ trang trí (chưa đặt)
CREATE TABLE IF NOT EXISTS `home_depot` (
    `user_id`  INT UNSIGNED NOT NULL,
    `item_id`  INT UNSIGNED NOT NULL,
    `count`    INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`user_id`, `item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Cây đang trồng
CREATE TABLE IF NOT EXISTS `home_plants` (
    `user_id`          INT UNSIGNED NOT NULL,
    `plant_id`         INT UNSIGNED NOT NULL,
    `seed_id`          INT UNSIGNED NOT NULL,
    `pos_x`            SMALLINT    NOT NULL DEFAULT 0,
    `pos_y`            SMALLINT    NOT NULL DEFAULT 0,
    `growth`           INT UNSIGNED NOT NULL DEFAULT 1,
    `sick_flag`        INT UNSIGNED NOT NULL DEFAULT 0,
    `fruit_num`        INT UNSIGNED NOT NULL DEFAULT 0,
    `fruit_status`     INT UNSIGNED NOT NULL DEFAULT 0,
    `mature_time`      INT UNSIGNED NOT NULL DEFAULT 7200,
    `diff_mature_time` INT UNSIGNED NOT NULL DEFAULT 7200,
    `cur_grow_rate`    INT UNSIGNED NOT NULL DEFAULT 100,
    `earth_state`      INT UNSIGNED NOT NULL DEFAULT 0,
    `pollination`      INT UNSIGNED NOT NULL DEFAULT 0,
    `can_thief`        INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`user_id`, `plant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
