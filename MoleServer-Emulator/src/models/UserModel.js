const pool = require("../config/database");

class UserModel {
    constructor() {
        this.users = new Map();
        this.userSessions = new Map();
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
