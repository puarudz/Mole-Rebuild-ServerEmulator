const Logger = require("../core/Logger");
const PacketBuilder = require("../core/PacketBuilder");
const UserModel = require("../models/UserModel");
const pool = require("../config/database");

// ============================================================
// Cache shop data từ DB (reload khi cần)
// ============================================================
let JD_GOODS_CACHE = [];     // Array of { commodity_id, item_ids, name, price, vip_discount, nonvip_discount, must_vip }
let DIANDIAN_CACHE = [];     // Array of { item_id, price, type, type_name }
let cacheLoaded = false;

async function loadShopCache() {
    try {
        const [jdRows] = await pool.query("SELECT * FROM shop_jd_goods WHERE enabled=1 ORDER BY commodity_id");
        JD_GOODS_CACHE = jdRows;

        const [dianRows] = await pool.query("SELECT * FROM shop_diandian WHERE enabled=1 ORDER BY type, item_id");
        DIANDIAN_CACHE = dianRows;

        cacheLoaded = true;
        Logger.log("INFO", `Shop cache loaded: ${JD_GOODS_CACHE.length} JD items, ${DIANDIAN_CACHE.length} Diandian items`);
    } catch (err) {
        Logger.log("ERROR", `Không thể load shop cache: ${err.message}`);
    }
}

// Load cache khi module được require
loadShopCache();

/**
 * Tìm JD item theo itemID hoặc commodityID
 */
function findJDItem(itemID) {
    for (const item of JD_GOODS_CACHE) {
        if (item.commodity_id === itemID) return item;
        const ids = String(item.item_ids).split("|").map(Number);
        if (ids.includes(itemID)) return item;
    }
    return null;
}

function findDiandianItem(itemID) {
    for (const item of DIANDIAN_CACHE) {
        if (item.item_id === itemID) return item;
    }
    return null;
}

/**
 * Tính giá sau discount (JD) hoặc giá gốc (Diandian)
 */
function calcPrice(jdItem, dianItem, isVip) {
    if (jdItem) {
        const discount = isVip ? jdItem.vip_discount : jdItem.nonvip_discount;
        return Math.floor(jdItem.price * discount / 100);
    }
    if (dianItem) {
        return dianItem.price;
    }
    return 0;
}

/**
 * Lấy VIP info từ DB user
 */
async function getUserVipInfo(userID) {
    try {
        const [rows] = await pool.query(
            "SELECT vip_flags, vip_level, vip_end_time, coins, jd_coins, dian_coins FROM users WHERE user_id = ?",
            [userID]
        );
        if (rows.length > 0) {
            const u = rows[0];
            return {
                isVip: (u.vip_flags & 1) === 1,
                vipLevel: u.vip_level || 0,
                coins: u.coins || 0,
                jdCoins: u.jd_coins || 0,
                dianCoins: u.dian_coins || 0,
            };
        }
    } catch (err) {
        Logger.log("ERROR", `Lỗi lấy VIP info: ${err.message}`);
    }
    return { isVip: true, vipLevel: 8, coins: 10000, jdCoins: 99999, dianCoins: 99999 };
}

class ShopController {
    /**
     * CMD 509 - Liệt kê vật phẩm trong shop NPC
     */
    static async handleListShopItem(socket, userID, data) {
        Logger.log("ACTION", `Xem danh sách shop (UserID: ${userID})`);
        if (!cacheLoaded) await loadShopCache();

        const vipInfo = await getUserVipInfo(userID);
        const items = JD_GOODS_CACHE;
        const count = Math.min(items.length, 200);

        const body = Buffer.alloc(4 + count * 12);
        let offset = 0;
        body.writeUInt32BE(count, offset); offset += 4;

        for (let i = 0; i < count; i++) {
            const item = items[i];
            const firstItemID = parseInt(String(item.item_ids).split("|")[0]) || 0;
            const price = calcPrice(item, null, vipInfo.isVip);
            body.writeUInt32BE(firstItemID, offset); offset += 4;
            body.writeUInt32BE(price, offset); offset += 4;
            body.writeUInt32BE(1, offset); offset += 4;
        }

        const head = PacketBuilder.makeHead(509, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Gửi danh sách shop (Items: ${count})`);
    }

    /**
     * CMD 1389 - Mua quần áo (Buy Cloth)
     */
    static async handleBuyCloth(socket, userID, data) {
        Logger.log("ACTION", `Mua quần áo (CMD 1389, UserID: ${userID})`);
        
        let count = 0;
        let items = [];
        
        if (data && data.length >= 21) {
            count = data.readUInt32BE(17);
            let offset = 21;
            for (let i = 0; i < count; i++) {
                if (offset + 4 <= data.length) {
                    items.push(data.readUInt32BE(offset));
                    offset += 4;
                }
            }
        }
        
        const vipInfo = await getUserVipInfo(userID);
        
        // Calculate total price
        let costCoins = 0;
        let costJdCoins = 0;
        let costDianCoins = 0;
        let validItems = [];
        for (const itemID of items) {
            const jdItem = findJDItem(itemID);
            const dianItem = findDiandianItem(itemID);
            if (jdItem) {
                costJdCoins += calcPrice(jdItem, null, vipInfo.isVip);
                validItems.push(itemID);
            } else if (dianItem) {
                costDianCoins += calcPrice(null, dianItem, vipInfo.isVip);
                validItems.push(itemID);
            } else {
                costCoins += 0; // Assuming 0 for now for regular items without price table
                validItems.push(itemID);
            }
        }

        if (vipInfo.coins < costCoins || vipInfo.jdCoins < costJdCoins || vipInfo.dianCoins < costDianCoins) {
            Logger.log("ERROR", `Không đủ tiền mua quần áo! Cần: coins=${costCoins}, jd=${costJdCoins}, dian=${costDianCoins}`);
            const errBody = Buffer.alloc(4);
            errBody.writeUInt32BE(vipInfo.coins, 0); // Trả về số dư beans
            const errHead = PacketBuilder.makeHead(1389, userID, 1, errBody.length);
            socket.write(errHead);
            socket.write(errBody);
            return;
        }

        const newCoins = vipInfo.coins - costCoins;
        const newJdCoins = vipInfo.jdCoins - costJdCoins;
        const newDianCoins = vipInfo.dianCoins - costDianCoins;

        try {
            await pool.query("UPDATE users SET coins = ?, jd_coins = ?, dian_coins = ? WHERE user_id = ?", 
                [newCoins, newJdCoins, newDianCoins, userID]);
            const user = UserModel.getUser(userID);
            if (user) { 
                user.coins = newCoins; 
                user.jd_coins = newJdCoins;
                user.dian_coins = newDianCoins;
                UserModel.setUser(userID, user); 
            }

            for (const itemID of validItems) {
                await pool.query(
                    `INSERT INTO user_items (user_id, item_id, amount, is_wearing)
                     VALUES (?, ?, 1, 0)
                     ON DUPLICATE KEY UPDATE amount = amount + 1`,
                    [userID, itemID]
                );
            }
        } catch (err) {
            Logger.log("ERROR", `Lỗi DB khi mua cloth: ${err.message}`);
        }

        const body = Buffer.alloc(8 + count * 4);
        let outOffset = 0;
        body.writeUInt32BE(newCoins, outOffset); outOffset += 4; // Money left
        body.writeUInt32BE(count, outOffset); outOffset += 4;
        for (let i = 0; i < count; i++) {
            body.writeUInt32BE(items[i], outOffset); outOffset += 4;
        }
        
        const head = PacketBuilder.makeHead(1389, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Mua OK quần áo ${items.join(", ")}`);
    }

    /**
     * CMD 501 - Mua vật phẩm
     */
    static async handleBuyItem(socket, userID, data) {
        Logger.log("ACTION", `Mua vật phẩm (UserID: ${userID})`);
        if (data.length < 25) return;
        if (!cacheLoaded) await loadShopCache();

        const itemID = data.readUInt32BE(17);
        const count = data.readUInt32BE(21);
        const vipInfo = await getUserVipInfo(userID);

        const jdItem = findJDItem(itemID);
        const dianItem = findDiandianItem(itemID);

        // Check must_vip
        if (jdItem && jdItem.must_vip === 1 && !vipInfo.isVip) {
            Logger.log("ERROR", `Item ${itemID} chỉ dành cho VIP`);
            const errBody = Buffer.alloc(4);
            errBody.writeUInt32BE(vipInfo.coins, 0);
            const errHead = PacketBuilder.makeHead(501, userID, 2, errBody.length);
            socket.write(errHead);
            socket.write(errBody);
            return;
        }

        let currencyType = "coins";
        let price = 0;

        if (jdItem) {
            currencyType = "jdCoins";
            price = calcPrice(jdItem, null, vipInfo.isVip) * count;
        } else if (dianItem) {
            currencyType = "dianCoins";
            price = calcPrice(null, dianItem, vipInfo.isVip) * count;
        } else {
            // Placeholder cho các item thường nếu có bảng giá
            price = 0; 
        }

        // Trừ tiền
        if (price > 0 && vipInfo[currencyType] < price) {
            Logger.log("ERROR", `Không đủ ${currencyType}! Cần: ${price}, Có: ${vipInfo[currencyType]}`);
            const errBody = Buffer.alloc(4);
            errBody.writeUInt32BE(vipInfo[currencyType], 0);
            const errHead = PacketBuilder.makeHead(501, userID, 1, errBody.length);
            socket.write(errHead);
            socket.write(errBody);
            return;
        }

        const newBalance = vipInfo[currencyType] - price;

        try {
            if (currencyType === "jdCoins") {
                await pool.query("UPDATE users SET jd_coins = ? WHERE user_id = ?", [newBalance, userID]);
            } else if (currencyType === "dianCoins") {
                await pool.query("UPDATE users SET dian_coins = ? WHERE user_id = ?", [newBalance, userID]);
            } else {
                await pool.query("UPDATE users SET coins = ? WHERE user_id = ?", [newBalance, userID]);
            }

            // Thêm items (hỗ trợ combo)
            const itemsToAdd = jdItem ? String(jdItem.item_ids).split("|").map(Number) : [itemID];
            for (const addID of itemsToAdd) {
                await pool.query(
                    `INSERT INTO user_items (user_id, item_id, amount, is_wearing)
                     VALUES (?, ?, ?, 0)
                     ON DUPLICATE KEY UPDATE amount = amount + ?`,
                    [userID, addID, count, count]
                );
            }

            // Cập nhật cache UserModel
            const user = UserModel.getUser(userID);
            if (user) { 
                if (currencyType === "jdCoins") user.jd_coins = newBalance;
                else if (currencyType === "dianCoins") user.dian_coins = newBalance;
                else user.coins = newBalance;
                UserModel.setUser(userID, user); 
            }
        } catch (err) {
            Logger.log("ERROR", `Lỗi DB khi mua item: ${err.message}`);
        }

        const body = Buffer.alloc(4);
        body.writeUInt32BE(newBalance, 0);
        const head = PacketBuilder.makeHead(501, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Mua OK item ${itemID} x${count}, còn ${newBalance} ${currencyType}`);
    }

    /**
     * CMD 507 - Xem túi đồ (Inventory)
     */
    static async handleViewInventory(socket, userID, data) {
        Logger.log("ACTION", `Xem túi đồ (UserID: ${userID})`);
        let targetUserID = userID;
        if (data && data.length >= 21) targetUserID = data.readUInt32BE(17);

        try {
            const [rows] = await pool.query(
                "SELECT item_id, amount, is_wearing FROM user_items WHERE user_id = ?", [targetUserID]
            );
            const itemCount = rows.length;
            const body = Buffer.alloc(8 + itemCount * 8);
            let offset = 0;
            body.writeUInt32BE(targetUserID, offset); offset += 4;
            body.writeUInt32BE(itemCount, offset); offset += 4;
            for (const row of rows) {
                body.writeUInt32BE(row.item_id, offset); offset += 4;
                body.writeUInt32BE(row.amount, offset); offset += 4;
            }
            const head = PacketBuilder.makeHead(507, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
        } catch (err) {
            Logger.log("ERROR", `Lỗi DB túi đồ: ${err.message}`);
            const body = Buffer.alloc(4, 0);
            const head = PacketBuilder.makeHead(507, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
        }
    }

    /**
     * CMD 5011 - Xem tủ quần áo
     */
    static async handleViewClothes(socket, userID, data) {
        Logger.log("ACTION", `Xem tủ quần áo (UserID: ${userID})`);
        let targetUserID = userID;
        if (data && data.length >= 21) targetUserID = data.readUInt32BE(17);

        try {
            const [rows] = await pool.query(
                "SELECT item_id FROM user_items WHERE user_id = ?", [targetUserID]
            );
            const body = Buffer.alloc(4 + rows.length * 4);
            let offset = 0;
            body.writeUInt32BE(rows.length, offset); offset += 4;
            for (const row of rows) {
                body.writeUInt32BE(row.item_id, offset); offset += 4;
            }
            const head = PacketBuilder.makeHead(5011, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
        } catch (err) {
            Logger.log("ERROR", `Lỗi DB tủ quần áo: ${err.message}`);
            const body = Buffer.alloc(4, 0);
            const head = PacketBuilder.makeHead(5011, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
        }
    }

    /** CMD 503 - Kho đồ */
    static handleViewStorage(socket, userID) {
        const body = Buffer.alloc(4, 0);
        const head = PacketBuilder.makeHead(503, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /** CMD 504 - Sử dụng item */
    static handleUseItem(socket, userID, data) {
        let itemID = 0;
        if (data && data.length >= 21) itemID = data.readUInt32BE(17);
        const body = Buffer.alloc(8);
        body.writeUInt32BE(itemID, 0);
        body.writeUInt32BE(0, 4);
        const head = PacketBuilder.makeHead(504, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /** CMD 505 - Pet food */
    static handlePetFood(socket, userID) {
        const body = Buffer.alloc(4, 0);
        const head = PacketBuilder.makeHead(505, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /** CMD 508 - Vứt item */
    static async handleDropItem(socket, userID, data) {
        let itemID = 0;
        if (data && data.length >= 21) itemID = data.readUInt32BE(17);
        try {
            await pool.query("DELETE FROM user_items WHERE user_id = ? AND item_id = ? LIMIT 1", [userID, itemID]);
        } catch (err) {
            Logger.log("ERROR", `Lỗi DB vứt item: ${err.message}`);
        }
        const body = Buffer.alloc(4);
        body.writeUInt32BE(itemID, 0);
        const head = PacketBuilder.makeHead(508, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /** CMD 511 - Lấy số lượng item */
    static handleGetItemCount(socket, userID, data) {
        let itemID = 0;
        if (data && data.length >= 21) itemID = data.readUInt32BE(17);
        const body = Buffer.alloc(8);
        body.writeUInt32BE(itemID, 0);
        body.writeUInt32BE(1, 4);
        const head = PacketBuilder.makeHead(511, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /** CMD 512 - Thêm MoleBeans miễn phí (private server) */
    static async handleGiveMeMoney(socket, userID) {
        Logger.log("ACTION", `Thêm tiền miễn phí (UserID: ${userID})`);
        const vipInfo = await getUserVipInfo(userID);
        const addAmount = 10000;
        const newCoins = vipInfo.coins + addAmount;

        try {
            await pool.query("UPDATE users SET coins = ? WHERE user_id = ?", [newCoins, userID]);
            const user = UserModel.getUser(userID);
            if (user) { user.coins = newCoins; UserModel.setUser(userID, user); }
        } catch (err) {
            Logger.log("ERROR", `Lỗi DB thêm tiền: ${err.message}`);
        }

        const body = Buffer.alloc(4);
        body.writeUInt32BE(newCoins, 0);
        const head = PacketBuilder.makeHead(512, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Thêm ${addAmount} beans, tổng: ${newCoins}`);
    }

    /** CMD 5014 - Toggle mặc/cởi 1 món quần áo */
    static async handleToggleClothes(socket, userID, data) {
        Logger.log("ACTION", `Toggle quần áo (UserID: ${userID})`);
        let itemID = 0;
        if (data && data.length >= 21) itemID = data.readUInt32BE(17);

        try {
            const [rows] = await pool.query(
                "SELECT is_wearing FROM user_items WHERE user_id = ? AND item_id = ?", [userID, itemID]
            );
            if (rows.length > 0) {
                const newState = rows[0].is_wearing ? 0 : 1;
                await pool.query("UPDATE user_items SET is_wearing = ? WHERE user_id = ? AND item_id = ?", [newState, userID, itemID]);
            }
        } catch (err) {
            Logger.log("ERROR", `Lỗi DB toggle clothes: ${err.message}`);
        }

        const body = Buffer.alloc(4);
        body.writeUInt32BE(itemID, 0);
        const head = PacketBuilder.makeHead(5014, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /** CMD 1243 - Đổi vật phẩm (Exchange Items) */
    static async handleExchangeItem(socket, userID, data) {
        Logger.log("ACTION", `Đổi vật phẩm CMD 1243 (UserID: ${userID})`);
        let type = 0, count = 1, flag = 0;
        if (data && data.length >= 29) {
            type = data.readUInt32BE(17);
            count = data.readUInt32BE(21);
            flag = data.readUInt32BE(25);
        }

        try {
            await pool.query(
                `INSERT INTO user_items (user_id, item_id, amount, is_wearing)
                 VALUES (?, ?, ?, 0)
                 ON DUPLICATE KEY UPDATE amount = amount + ?`,
                [userID, type, count, count]
            );
        } catch (err) {
            Logger.log("ERROR", `Lỗi DB đổi vật phẩm: ${err.message}`);
        }

        const body = Buffer.alloc(16);
        body.writeUInt32BE(type, 0); // infoObj.type
        body.writeUInt32BE(1, 4);    // infoObj.Count
        body.writeUInt32BE(type, 8); // itemID
        body.writeUInt32BE(count, 12); // count

        const head = PacketBuilder.makeHead(1243, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Đổi OK item ${type} x${count}`);
    }

    /** CMD 2031 - buyCommodity */
    static async handleBuyCommodity(socket, userID, data) {
        Logger.log("ACTION", `Buy Commodity (CMD 2031) UserID: ${userID}`);
        if (data.length < 17 + 10) return;
        
        const itemID = data.readUInt32BE(17 + 4); 
        const count = data.readUInt16BE(17 + 8); 
        
        const vipInfo = await getUserVipInfo(userID);
        const jdItem = findJDItem(itemID);
        const dianItem = findDiandianItem(itemID);
        
        let currencyType = "coins";
        let price = 0;

        if (jdItem) {
            currencyType = "jdCoins";
            price = calcPrice(jdItem, null, vipInfo.isVip) * count;
        } else if (dianItem) {
            currencyType = "dianCoins";
            price = calcPrice(null, dianItem, vipInfo.isVip) * count;
        }
        
        if (price > 0 && vipInfo[currencyType] < price) {
             const head = PacketBuilder.makeHead(2031, userID, 1, 0);
             socket.write(head);
             return;
        }
        
        const newBalance = vipInfo[currencyType] - price;
        try {
            if (currencyType === "jdCoins") {
                await pool.query("UPDATE users SET jd_coins = ? WHERE user_id = ?", [newBalance, userID]);
            } else if (currencyType === "dianCoins") {
                await pool.query("UPDATE users SET dian_coins = ? WHERE user_id = ?", [newBalance, userID]);
            } else {
                await pool.query("UPDATE users SET coins = ? WHERE user_id = ?", [newBalance, userID]);
            }
            
            const user = UserModel.getUser(userID);
            if (user) { 
                if (currencyType === "jdCoins") user.jd_coins = newBalance;
                else if (currencyType === "dianCoins") user.dian_coins = newBalance;
                else user.coins = newBalance;
                UserModel.setUser(userID, user); 
            }
            
            const itemsToAdd = jdItem ? String(jdItem.item_ids).split("|").map(Number) : [itemID];
            for (const addID of itemsToAdd) {
                await pool.query(
                    `INSERT INTO user_items (user_id, item_id, amount, is_wearing)
                     VALUES (?, ?, ?, 0)
                     ON DUPLICATE KEY UPDATE amount = amount + ?`,
                    [userID, addID, count, count]
                );
            }
        } catch(err) {
            Logger.log("ERROR", `Lỗi DB khi mua commodity: ${err.message}`);
        }

        const body = Buffer.alloc(8);
        body.writeUInt32BE(price * 100, 0); // Pay_num
        body.writeUInt32BE(newBalance * 100, 4); // Balance_num
        
        const head = PacketBuilder.makeHead(2031, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Mua OK commodity ${itemID} x${count}, ${currencyType} còn ${newBalance}`);
    }

    /** CMD 2032 - selectDou (Lấy số dư Mibi / Beans) */
    static async handleGetMoney(socket, userID) {
        Logger.log("ACTION", `Xem số dư Mibi/Beans (CMD 2032) UserID: ${userID}`);
        const vipInfo = await getUserVipInfo(userID);
        
        const body = Buffer.alloc(4);
        body.writeUInt32BE(vipInfo.coins * 100, 0); 
        
        const head = PacketBuilder.makeHead(2032, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /** CMD 2033 - buyDou */
    static async handleBuyDou(socket, userID, data) {
        Logger.log("ACTION", `Buy Dou (CMD 2033) UserID: ${userID}`);
        let itemID = 0; let count = 1;
        if (data.length >= 17 + 10) {
            itemID = data.readUInt32BE(17 + 4);
            count = data.readUInt16BE(17 + 8);
        }

        const vipInfo = await getUserVipInfo(userID);
        const jdItem = findJDItem(itemID);
        const dianItem = findDiandianItem(itemID);
        
        let currencyType = "coins";
        let price = 0;

        if (jdItem) {
            currencyType = "jdCoins";
            price = calcPrice(jdItem, null, vipInfo.isVip) * count;
        } else if (dianItem) {
            currencyType = "dianCoins";
            price = calcPrice(null, dianItem, vipInfo.isVip) * count;
        }
        
        if (price > 0 && vipInfo[currencyType] < price) {
             const head = PacketBuilder.makeHead(2033, userID, 1, 0);
             socket.write(head);
             return;
        }

        const newBalance = vipInfo[currencyType] - price;
        try {
            if (currencyType === "jdCoins") {
                await pool.query("UPDATE users SET jd_coins = ? WHERE user_id = ?", [newBalance, userID]);
            } else if (currencyType === "dianCoins") {
                await pool.query("UPDATE users SET dian_coins = ? WHERE user_id = ?", [newBalance, userID]);
            } else {
                await pool.query("UPDATE users SET coins = ? WHERE user_id = ?", [newBalance, userID]);
            }
            
            const user = UserModel.getUser(userID);
            if (user) { 
                if (currencyType === "jdCoins") user.jd_coins = newBalance;
                else if (currencyType === "dianCoins") user.dian_coins = newBalance;
                else user.coins = newBalance;
                UserModel.setUser(userID, user); 
            }
            
            const itemsToAdd = jdItem ? String(jdItem.item_ids).split("|").map(Number) : [itemID];
            for (const addID of itemsToAdd) {
                await pool.query(
                    `INSERT INTO user_items (user_id, item_id, amount, is_wearing)
                     VALUES (?, ?, ?, 0)
                     ON DUPLICATE KEY UPDATE amount = amount + ?`,
                    [userID, addID, count, count]
                );
            }
        } catch(err) {
            Logger.log("ERROR", `Lỗi DB khi mua Dou: ${err.message}`);
        }

        const body = Buffer.alloc(16);
        body.writeUInt32BE(price * 100, 0);
        body.writeUInt32BE(newBalance * 100, 4);
        body.writeUInt32BE(0, 8); // Dou_num
        // Trả về số dư jd_coins cho Balance_Dou_num, vì buyDou thường liên quan Đậu Vàng/Đậu Điểm
        const jdCoinsBal = (currencyType === "jdCoins") ? newBalance : vipInfo.jdCoins;
        body.writeUInt32BE(jdCoinsBal * 100, 12); 
        
        const head = PacketBuilder.makeHead(2033, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Mua OK Dou ${itemID} x${count}, ${currencyType} còn ${newBalance}`);
    }

    /** CMD 2040 - addScore */
    static async handleAddScore(socket, userID) {
        Logger.log("ACTION", `Add Score (CMD 2040) UserID: ${userID}`);
        
        const body = Buffer.alloc(12);
        body.writeUInt32BE(1, 0); // loginCount
        body.writeUInt32BE(100, 4); // score
        body.writeUInt32BE(200, 8); // nextScore
        
        const head = PacketBuilder.makeHead(2040, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /** Reload shop cache (gọi khi update DB) */
    static async reloadCache() {
        await loadShopCache();
        return { jd: JD_GOODS_CACHE.length, diandian: DIANDIAN_CACHE.length };
    }
}

module.exports = ShopController;
