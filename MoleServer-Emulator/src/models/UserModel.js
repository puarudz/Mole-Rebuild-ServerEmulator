const pool = require("../config/database");

class UserModel {
    constructor() {
        this.users = new Map();
        this.userSessions = new Map();
        this.userPets = new Map();
        this.petTableReady = false;
        this.petTableInitPromise = null;
    }

    async ensurePetTable() {
        if (this.petTableReady) return;
        if (!this.petTableInitPromise) {
            this.petTableInitPromise = pool.query(`
                CREATE TABLE IF NOT EXISTS user_pets (
                    user_id INT UNSIGNED PRIMARY KEY,
                    sprite_id INT UNSIGNED NOT NULL,
                    flag INT UNSIGNED DEFAULT 0,
                    birthday INT UNSIGNED DEFAULT 0,
                    pet_value INT UNSIGNED DEFAULT 0,
                    nick VARCHAR(16) DEFAULT 'Dau Dau',
                    color INT UNSIGNED DEFAULT 16763904,
                    sick_time INT UNSIGNED DEFAULT 0,
                    pos_x TINYINT UNSIGNED DEFAULT 8,
                    pos_y TINYINT UNSIGNED DEFAULT 8,
                    hungry TINYINT UNSIGNED DEFAULT 100,
                    thirsty TINYINT UNSIGNED DEFAULT 100,
                    dirty TINYINT UNSIGNED DEFAULT 100,
                    spirit TINYINT UNSIGNED DEFAULT 100,
                    level INT UNSIGNED DEFAULT 1,
                    skill INT UNSIGNED DEFAULT 0,
                    sick_type INT UNSIGNED DEFAULT 0,
                    skill_fire INT UNSIGNED DEFAULT 0,
                    skill_water INT UNSIGNED DEFAULT 0,
                    skill_wood INT UNSIGNED DEFAULT 0,
                    skill_type INT UNSIGNED DEFAULT 0,
                    skill_value INT UNSIGNED DEFAULT 0,
                    item1 TINYINT UNSIGNED DEFAULT 0,
                    item2 TINYINT UNSIGNED DEFAULT 0,
                    item3 TINYINT UNSIGNED DEFAULT 0,
                    cloth INT UNSIGNED DEFAULT 0,
                    honor INT UNSIGNED DEFAULT 0,
                    follow_flag TINYINT UNSIGNED DEFAULT 0,
                    on_map TINYINT UNSIGNED DEFAULT 0,
                    exp INT UNSIGNED DEFAULT 0,
                    is_super TINYINT UNSIGNED DEFAULT 0,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    CONSTRAINT fk_user_pets_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            `).then(() => {
                this.petTableReady = true;
            }).catch((error) => {
                this.petTableInitPromise = null;
                throw error;
            });
        }
        await this.petTableInitPromise;
    }

    // Lấy user đang online
    getUser(userID) {
        return this.users.get(userID);
    }

    // Lưu user đang online
    setUser(userID, data) {
        this.users.set(userID, data);
    }

    removeUser(userID) {
        this.users.delete(userID);
    }

    createDefaultPet(userID) {
        const numericUserID = parseInt(userID, 10) || 0;
        return {
            userID: numericUserID,
            spriteID: 100000 + (numericUserID % 900000),
            flag: 0,
            birthday: Math.floor(Date.now() / 1000),
            value: 0,
            nick: "Dau Dau",
            color: 0xFFCC00,
            sickTime: 0,
            posX: 8,
            posY: 8,
            hungry: 100,
            thirsty: 100,
            dirty: 100,
            spirit: 100,
            level: 1,
            skill: 0,
            sickType: 0,
            skillFire: 0,
            skillWater: 0,
            skillWood: 0,
            skillType: 0,
            skillValue: 0,
            item1: 0,
            item2: 0,
            item3: 0,
            cloth: 0,
            honor: 0,
            follow: false,
            onMap: false,
            exp: 0,
            isSuper: false
        };
    }

    createUserPet(userID) {
        const pet = this.createDefaultPet(userID);
        this.setUserPet(userID, pet);
        return pet;
    }

    ensureUserPet(userID) {
        const key = String(userID);
        if (!this.userPets.has(key)) {
            this.userPets.set(key, this.createDefaultPet(userID));
        }
        return this.userPets.get(key);
    }

    setUserPet(userID, pet) {
        this.userPets.set(String(userID), pet);
    }

    getUserPet(userID) {
        return this.userPets.get(String(userID));
    }

    getAllPets() {
        return Array.from(this.userPets.values());
    }

    async loadUserPet(userID) {
        const key = String(userID);
        if (this.userPets.has(key)) {
            return this.userPets.get(key);
        }

        try {
            await this.ensurePetTable();
            const [rows] = await pool.query("SELECT * FROM user_pets WHERE user_id = ?", [userID]);
            if (rows.length > 0) {
                const row = rows[0];
                const pet = {
                    userID: row.user_id,
                    spriteID: row.sprite_id,
                    flag: row.flag,
                    birthday: row.birthday,
                    value: row.pet_value,
                    nick: row.nick,
                    color: row.color,
                    sickTime: row.sick_time,
                    posX: row.pos_x,
                    posY: row.pos_y,
                    hungry: row.hungry,
                    thirsty: row.thirsty,
                    dirty: row.dirty,
                    spirit: row.spirit,
                    level: row.level,
                    skill: row.skill,
                    sickType: row.sick_type,
                    skillFire: row.skill_fire,
                    skillWater: row.skill_water,
                    skillWood: row.skill_wood,
                    skillType: row.skill_type,
                    skillValue: row.skill_value,
                    item1: row.item1,
                    item2: row.item2,
                    item3: row.item3,
                    cloth: row.cloth,
                    honor: row.honor,
                    follow: row.follow_flag === 1,
                    onMap: row.on_map === 1,
                    exp: row.exp,
                    isSuper: row.is_super === 1
                };
                this.userPets.set(key, pet);
                return pet;
            }
        } catch (error) {
            console.error("Lỗi khi tải pet từ MySQL:", error);
        }

        return null;
    }

    async saveUserPetToDB(userID) {
        const pet = this.getUserPet(userID);
        if (!pet) {
            return false;
        }
        try {
            await this.ensurePetTable();
            await pool.query(
                `INSERT INTO user_pets (
                    user_id, sprite_id, flag, birthday, pet_value, nick, color, sick_time,
                    pos_x, pos_y, hungry, thirsty, dirty, spirit, level, skill, sick_type,
                    skill_fire, skill_water, skill_wood, skill_type, skill_value,
                    item1, item2, item3, cloth, honor, follow_flag, on_map, exp, is_super
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE
                    sprite_id = VALUES(sprite_id),
                    flag = VALUES(flag),
                    birthday = VALUES(birthday),
                    pet_value = VALUES(pet_value),
                    nick = VALUES(nick),
                    color = VALUES(color),
                    sick_time = VALUES(sick_time),
                    pos_x = VALUES(pos_x),
                    pos_y = VALUES(pos_y),
                    hungry = VALUES(hungry),
                    thirsty = VALUES(thirsty),
                    dirty = VALUES(dirty),
                    spirit = VALUES(spirit),
                    level = VALUES(level),
                    skill = VALUES(skill),
                    sick_type = VALUES(sick_type),
                    skill_fire = VALUES(skill_fire),
                    skill_water = VALUES(skill_water),
                    skill_wood = VALUES(skill_wood),
                    skill_type = VALUES(skill_type),
                    skill_value = VALUES(skill_value),
                    item1 = VALUES(item1),
                    item2 = VALUES(item2),
                    item3 = VALUES(item3),
                    cloth = VALUES(cloth),
                    honor = VALUES(honor),
                    follow_flag = VALUES(follow_flag),
                    on_map = VALUES(on_map),
                    exp = VALUES(exp),
                    is_super = VALUES(is_super)`,
                [
                    pet.userID, pet.spriteID, pet.flag, pet.birthday, pet.value, pet.nick, pet.color, pet.sickTime,
                    pet.posX, pet.posY, pet.hungry, pet.thirsty, pet.dirty, pet.spirit, pet.level, pet.skill, pet.sickType,
                    pet.skillFire, pet.skillWater, pet.skillWood, pet.skillType, pet.skillValue,
                    pet.item1, pet.item2, pet.item3, pet.cloth, pet.honor,
                    pet.follow ? 1 : 0, pet.onMap ? 1 : 0, pet.exp || 0, pet.isSuper ? 1 : 0
                ]
            );
            return true;
        } catch (error) {
            console.error("Lỗi khi lưu pet vào MySQL:", error);
            return false;
        }
    }

    getSession(ip) {
        return this.userSessions.get(ip);
    }

    saveSession(ip, sessionData) {
        this.userSessions.set(ip, sessionData);
    }

    // Fetch user from MySQL Database
    async fetchUserFromDB(userID) {
        try {
            const [rows] = await pool.query("SELECT * FROM users WHERE user_id = ?", [userID]);
            if (rows.length > 0) {
                const user = rows[0];
                user.userID = user.user_id; // Map property for compatibility
                // Map VIP fields cho PacketBuilder
                user.vipFlags = user.vip_flags ?? 33;
                user.vipLevel = user.vip_level ?? 8;
                user.vipMonth = user.vip_month ?? 12;
                user.vipValue = user.vip_value ?? 9999;
                user.vipEndTime = user.vip_end_time ?? 2145916800;
                user.autoPayVip = user.auto_pay_vip ?? 1;
                
                // Fetch equipped items
                const [itemRows] = await pool.query("SELECT item_id FROM user_items WHERE user_id = ? AND is_wearing = 1", [userID]);
                user.items = itemRows.map(row => row.item_id);
                
                return user;
            }
            return null;
        } catch (error) {
            console.error("Lỗi khi truy vấn user từ MySQL:", error);
            return null;
        }
    }

    // Verify password for an existing user
    // DB lưu: MD5(plaintext_password) — single hash
    // Client có thể gửi: MD5(plaintext) hoặc MD5(MD5(plaintext))
    async verifyPassword(userID, password) {
        try {
            const CryptoUtils = require("../core/CryptoUtils");
            
            //console.log(`[VERIFY] userID=${userID}, clientPass="${password}"`);
            
            const [rows] = await pool.query(
                "SELECT user_id, password FROM users WHERE user_id = ?",
                [userID]
            );
            if (rows.length === 0) {
                //console.log(`[VERIFY] Không tìm thấy user ${userID} trong DB`);
                return false;
            }
            
            const dbPassword = rows[0].password.toLowerCase();   // MD5(plaintext)
            const md5OfDb = CryptoUtils.md5(dbPassword);          // MD5(MD5(plaintext)) = double hash
            const md5OfClient = CryptoUtils.md5(password);        // MD5 của client gửi
            
            //console.log(`[VERIFY] dbPassword (MD5(plain))  = ${dbPassword}`);
            //console.log(`[VERIFY] md5OfDb   (double hash)  = ${md5OfDb}`);
            //console.log(`[VERIFY] md5OfClient (hash client)  = ${md5OfClient}`);
            //console.log(`[VERIFY] client === dbPassword: ${password === dbPassword}`);
            //console.log(`[VERIFY] client === md5OfDb:    ${password === md5OfDb}`);
            //console.log(`[VERIFY] md5OfClient === dbPassword: ${md5OfClient === dbPassword}`);
            
            // Client gửi single hash = MD5(plaintext)
            // Client gửi double hash = MD5(MD5(plaintext))
            // Client gửi plaintext (hiếm)
            return password === dbPassword           // client gửi single hash
                || password === md5OfDb              // client gửi double hash
                || md5OfClient === dbPassword;       // client gửi plaintext
        } catch (error) {
            console.error("Lỗi khi xác thực mật khẩu:", error);
            return false;
        }
    }

    // Auto create user if not exists
    async createUser(userID, password) {
        try {
            // Check if ID is already used
            const existing = await this.fetchUserFromDB(userID);
            if (existing) {
                // Verify password for existing user
                const valid = await this.verifyPassword(userID, password);
                if (!valid) {
                    //console.log(`Đăng nhập thất bại: Sai mật khẩu cho UserID ${userID}`);
                    return null;
                }
                return existing;
            }

            // Nếu userID = 0 (client không truyền), random một userID mới từ 20000000
            if (userID === 0) {
                const [result] = await pool.query("SELECT MAX(user_id) as maxID FROM users");
                userID = result[0].maxID ? Math.max(20000000, result[0].maxID + 1) : 20000000;
            }

            // Tạo account mới — lưu password client gửi trực tiếp (không MD5 thêm)
            // Client gửi double hash = MD5(MD5(plaintext)), DB lưu giá trị này
            await pool.query(
                `INSERT INTO users (user_id, password, nick, color, coins, vip_flags, vip_level, vip_month, vip_value, vip_end_time, auto_pay_vip, jd_coins, dian_coins)
                 VALUES (?, ?, ?, ?, ?, 33, 8, 12, 9999, 2145916800, 1, 99999, 99999)`,
                [userID, password, "NewMole", 8028160, 10000]
            );
            
            //console.log(`Đã tạo mới nhân vật thành công với UserID: ${userID}`);
            return await this.fetchUserFromDB(userID);
        } catch (error) {
            console.error("Lỗi khi tạo mới user:", error);
            return null;
        }
    }

    // Cập nhật tên vào MySQL
    async updateNickname(userID, nick) {
        try {
            await pool.query(
                "UPDATE users SET nick = ? WHERE user_id = ?",
                [nick, userID]
            );
            return true;
        } catch (error) {
            console.error("Lỗi khi cập nhật nickname:", error);
            return false;
        }
    }

    // Kiểm tra tên có bị trùng không
    async isNicknameTaken(nick, currentUserID) {
        try {
            const [rows] = await pool.query(
                "SELECT user_id FROM users WHERE nick = ? AND user_id != ?",
                [nick, currentUserID]
            );
            return rows.length > 0;
        } catch (error) {
            console.error("Lỗi khi kiểm tra trùng nickname:", error);
            return true; // Giả sử trùng nếu lỗi DB để an toàn
        }
    }
}

module.exports = new UserModel();
