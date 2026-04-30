const Logger = require("../core/Logger");
const PacketBuilder = require("../core/PacketBuilder");
const pool = require("../config/database");

const JJL_CARD_MIN = 1290001;
const JJL_CARD_MAX = 1290094;

const BASIC_CARD_SETS = {
    1: [1290001, 1290002, 1290003, 1290004],
    2: [1290005, 1290006, 1290007, 1290008],
    3: [1290009, 1290010, 1290011, 1290012],
    4: [1290013, 1290014, 1290015, 1290016],
    5: [1290017, 1290018, 1290019, 1290020],
};

const CLOTH_REWARDS = {
    1: 1290056,
    2: 1290057,
    3: 1290058,
    4: 1290059,
    5: 1290060,
};

class JJLCardController {
    static async ensureTables() {
        if (this._tablesReady) {
            return;
        }

        await pool.query(`
            CREATE TABLE IF NOT EXISTS user_jjl_trade_settings (
                user_id BIGINT NOT NULL,
                card_id INT NOT NULL,
                trade_flag INT NOT NULL DEFAULT 0,
                want_card_id INT NOT NULL DEFAULT 0,
                updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (user_id, card_id)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        `);

        this._tablesReady = true;
    }

    static isJJLCard(itemID) {
        return itemID >= JJL_CARD_MIN && itemID <= JJL_CARD_MAX;
    }

    static async getOwnedCards(userID) {
        const [rows] = await pool.query(
            `SELECT item_id, amount
             FROM user_items
             WHERE user_id = ? AND item_id BETWEEN ? AND ? AND amount > 0
             ORDER BY item_id ASC`,
            [userID, JJL_CARD_MIN, JJL_CARD_MAX]
        );
        return rows;
    }

    static async getItemCount(conn, userID, itemID) {
        const [rows] = await conn.query(
            "SELECT amount FROM user_items WHERE user_id = ? AND item_id = ? LIMIT 1",
            [userID, itemID]
        );
        return rows.length > 0 ? Number(rows[0].amount || 0) : 0;
    }

    static async addItem(conn, userID, itemID, amount) {
        const [rows] = await conn.query(
            "SELECT amount, is_wearing FROM user_items WHERE user_id = ? AND item_id = ? LIMIT 1",
            [userID, itemID]
        );

        if (rows.length > 0) {
            await conn.query(
                "UPDATE user_items SET amount = amount + ? WHERE user_id = ? AND item_id = ?",
                [amount, userID, itemID]
            );
        } else {
            await conn.query(
                "INSERT INTO user_items (user_id, item_id, amount, is_wearing) VALUES (?, ?, ?, 0)",
                [userID, itemID, amount]
            );
        }
    }

    static async consumeItem(conn, userID, itemID, amount) {
        const current = await this.getItemCount(conn, userID, itemID);
        if (current < amount) {
            return false;
        }

        if (current === amount) {
            await conn.query(
                "DELETE FROM user_items WHERE user_id = ? AND item_id = ? LIMIT 1",
                [userID, itemID]
            );
        } else {
            await conn.query(
                "UPDATE user_items SET amount = amount - ? WHERE user_id = ? AND item_id = ?",
                [amount, userID, itemID]
            );
        }

        return true;
    }

    static async clearTradeIfCardMissing(conn, userID, cardID) {
        const count = await this.getItemCount(conn, userID, cardID);
        if (count > 0) {
            return;
        }

        await conn.query(
            "DELETE FROM user_jjl_trade_settings WHERE user_id = ? AND card_id = ?",
            [userID, cardID]
        );
    }

    static writeFixedUtf8(buffer, offset, text, length) {
        const value = Buffer.from(String(text || ""), "utf8");
        value.copy(buffer, offset, 0, Math.min(value.length, length));
    }

    static async handleGetJJLCard(socket, userID, data) {
        try {
            await this.ensureTables();

            const targetUserID = data.length >= 21 ? data.readUInt32BE(17) : userID;
            const [cardRows, tradeRows] = await Promise.all([
                this.getOwnedCards(targetUserID),
                pool.query(
                    "SELECT card_id, trade_flag, want_card_id FROM user_jjl_trade_settings WHERE user_id = ?",
                    [targetUserID]
                ),
            ]);

            const settings = new Map();
            for (const row of tradeRows[0]) {
                settings.set(Number(row.card_id), {
                    tradeFlag: Number(row.trade_flag || 0),
                    wantCardID: Number(row.want_card_id || 0),
                });
            }

            const body = Buffer.alloc(4 + cardRows.length * 16);
            let offset = 0;
            body.writeUInt32BE(cardRows.length, offset);
            offset += 4;

            for (const row of cardRows) {
                const cardID = Number(row.item_id);
                const setting = settings.get(cardID) || { tradeFlag: 0, wantCardID: 0 };
                body.writeUInt32BE(cardID, offset); offset += 4;
                body.writeUInt32BE(Number(row.amount || 0), offset); offset += 4;
                body.writeUInt32BE(setting.tradeFlag, offset); offset += 4;
                body.writeUInt32BE(setting.wantCardID, offset); offset += 4;
            }

            const head = PacketBuilder.makeHead(1401, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
            Logger.log("JJL", `GetJJLCard: user=${userID}, target=${targetUserID}, count=${cardRows.length}`);
        } catch (error) {
            Logger.log("ERROR", `GetJJLCard lỗi: ${error.message}`);
            socket.write(PacketBuilder.makeHead(1401, userID, 5003, 0));
        }
    }

    static async handleSetJJLCard(socket, userID, data) {
        try {
            await this.ensureTables();
            if (data.length < 29) {
                socket.write(PacketBuilder.makeHead(1400, userID, 5003, 0));
                return;
            }

            const flag = data.readUInt32BE(17);
            const myCardID = data.readUInt32BE(21);
            const wantCardID = data.readUInt32BE(25);

            if (!this.isJJLCard(myCardID) || (wantCardID !== 0 && !this.isJJLCard(wantCardID))) {
                socket.write(PacketBuilder.makeHead(1400, userID, 5003, 0));
                return;
            }

            const ownedCount = await this.getItemCount(pool, userID, myCardID);
            if (ownedCount <= 0) {
                socket.write(PacketBuilder.makeHead(1400, userID, 5004, 0));
                return;
            }

            await pool.query(
                `INSERT INTO user_jjl_trade_settings (user_id, card_id, trade_flag, want_card_id)
                 VALUES (?, ?, ?, ?)
                 ON DUPLICATE KEY UPDATE trade_flag = VALUES(trade_flag), want_card_id = VALUES(want_card_id)`,
                [userID, myCardID, flag >>> 0, flag ? wantCardID : 0]
            );

            socket.write(PacketBuilder.makeHead(1400, userID, 0, 0));
            Logger.log("JJL", `SetJJLCard: user=${userID}, flag=${flag}, my=${myCardID}, want=${wantCardID}`);
        } catch (error) {
            Logger.log("ERROR", `SetJJLCard lỗi: ${error.message}`);
            socket.write(PacketBuilder.makeHead(1400, userID, 5003, 0));
        }
    }

    static async handleExchangeJJLCard(socket, userID, data) {
        let conn;
        try {
            await this.ensureTables();
            if (data.length < 29) {
                socket.write(PacketBuilder.makeHead(1402, userID, 5003, 0));
                return;
            }

            const friendID = data.readUInt32BE(17);
            const myCardID = data.readUInt32BE(21);
            const getCardID = data.readUInt32BE(25);

            if (friendID === userID || !this.isJJLCard(myCardID) || !this.isJJLCard(getCardID) || myCardID === getCardID) {
                socket.write(PacketBuilder.makeHead(1402, userID, 5003, 0));
                return;
            }

            conn = await pool.getConnection();
            await conn.beginTransaction();

            const myCount = await this.getItemCount(conn, userID, myCardID);
            const friendCount = await this.getItemCount(conn, friendID, getCardID);
            if (myCount <= 0 || friendCount <= 0) {
                await conn.rollback();
                socket.write(PacketBuilder.makeHead(1402, userID, 5004, 0));
                return;
            }

            const [tradeRows] = await conn.query(
                `SELECT trade_flag, want_card_id
                 FROM user_jjl_trade_settings
                 WHERE user_id = ? AND card_id = ? LIMIT 1`,
                [friendID, getCardID]
            );

            const friendTrade = tradeRows[0];
            if (!friendTrade || Number(friendTrade.trade_flag || 0) === 0 || Number(friendTrade.want_card_id || 0) !== myCardID) {
                await conn.rollback();
                socket.write(PacketBuilder.makeHead(1402, userID, 5005, 0));
                return;
            }

            await this.consumeItem(conn, userID, myCardID, 1);
            await this.consumeItem(conn, friendID, getCardID, 1);
            await this.addItem(conn, userID, getCardID, 1);
            await this.addItem(conn, friendID, myCardID, 1);

            await this.clearTradeIfCardMissing(conn, userID, myCardID);
            await this.clearTradeIfCardMissing(conn, friendID, getCardID);

            await conn.commit();
            socket.write(PacketBuilder.makeHead(1402, userID, 0, 0));
            Logger.log("JJL", `ExchangeJJLCard: ${userID} traded ${myCardID} with ${friendID} for ${getCardID}`);
        } catch (error) {
            if (conn) {
                await conn.rollback();
            }
            Logger.log("ERROR", `ExchangeJJLCard lỗi: ${error.message}`);
            socket.write(PacketBuilder.makeHead(1402, userID, 5003, 0));
        } finally {
            if (conn) {
                conn.release();
            }
        }
    }

    static async handleSearchJJLCard(socket, userID, data) {
        try {
            await this.ensureTables();
            if (data.length < 25) {
                socket.write(PacketBuilder.makeHead(1403, userID, 5003, 0));
                return;
            }

            const myCardID = data.readUInt32BE(17);
            const wantCardID = data.readUInt32BE(21);

            const [rows] = await pool.query(
                `SELECT DISTINCT u.user_id, u.nick, u.color, u.vip_flags, UNIX_TIMESTAMP(uts.updated_at) AS updated_time
                 FROM user_jjl_trade_settings uts
                 JOIN users u ON u.user_id = uts.user_id
                 JOIN user_items ui ON ui.user_id = uts.user_id AND ui.item_id = uts.card_id AND ui.amount > 0
                 WHERE uts.user_id != ?
                   AND uts.card_id = ?
                   AND uts.want_card_id = ?
                   AND uts.trade_flag > 0
                 ORDER BY uts.updated_at DESC
                 LIMIT 100`,
                [userID, wantCardID, myCardID]
            );

            const entrySize = 4 + 16 + 4 + 1 + 4;
            const body = Buffer.alloc(4 + rows.length * entrySize);
            let offset = 0;
            body.writeUInt32BE(rows.length, offset);
            offset += 4;

            for (const row of rows) {
                body.writeUInt32BE(Number(row.user_id), offset); offset += 4;
                this.writeFixedUtf8(body, offset, row.nick || "Mole", 16); offset += 16;
                body.writeUInt32BE(Number(row.color || 0x7A0000), offset); offset += 4;
                body.writeUInt8(Number(row.vip_flags || 0) > 0 ? 1 : 0, offset); offset += 1;
                body.writeUInt32BE(Number(row.updated_time || 0), offset); offset += 4;
            }

            const head = PacketBuilder.makeHead(1403, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
            Logger.log("JJL", `SearchJJLCard: user=${userID}, my=${myCardID}, want=${wantCardID}, found=${rows.length}`);
        } catch (error) {
            Logger.log("ERROR", `SearchJJLCard lỗi: ${error.message}`);
            socket.write(PacketBuilder.makeHead(1403, userID, 5003, 0));
        }
    }

    static async handleExchangeJJLCloth(socket, userID) {
        let conn;
        try {
            await this.ensureTables();
            conn = await pool.getConnection();
            await conn.beginTransaction();

            let rewardID = 0;
            for (const [groupType, cardIDs] of Object.entries(BASIC_CARD_SETS)) {
                let complete = true;
                for (const cardID of cardIDs) {
                    const count = await this.getItemCount(conn, userID, cardID);
                    if (count <= 0) {
                        complete = false;
                        break;
                    }
                }

                if (!complete) {
                    continue;
                }

                rewardID = CLOTH_REWARDS[groupType];
                for (const cardID of cardIDs) {
                    await this.consumeItem(conn, userID, cardID, 1);
                    await this.clearTradeIfCardMissing(conn, userID, cardID);
                }
                await this.addItem(conn, userID, rewardID, 1);
                break;
            }

            if (!rewardID) {
                await conn.rollback();
                socket.write(PacketBuilder.makeHead(1404, userID, 5004, 0));
                return;
            }

            const rewardCount = await this.getItemCount(conn, userID, rewardID);
            await conn.commit();

            const body = Buffer.alloc(8);
            body.writeUInt32BE(rewardID, 0);
            body.writeUInt32BE(rewardCount, 4);

            const head = PacketBuilder.makeHead(1404, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
            Logger.log("JJL", `ExchangeJJLCloth: user=${userID}, reward=${rewardID}, count=${rewardCount}`);
        } catch (error) {
            if (conn) {
                await conn.rollback();
            }
            Logger.log("ERROR", `ExchangeJJLCloth lỗi: ${error.message}`);
            socket.write(PacketBuilder.makeHead(1404, userID, 5003, 0));
        } finally {
            if (conn) {
                conn.release();
            }
        }
    }
}

module.exports = JJLCardController;