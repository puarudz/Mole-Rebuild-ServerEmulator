const Logger = require("../core/Logger");
const PacketBuilder = require("../core/PacketBuilder");
const UserModel = require("../models/UserModel");
const MapModel = require("../models/MapModel");

class ActionController {
    static handleWalk(socket, userID, data) {
        Logger.log("ACTION", `走路 (UserID: ${userID})`);
        
        if (data.length < 28) {
            Logger.log("ERROR", `封包長度不足，無法讀取坐標`);
            return;
        }
        
        const endX = data.readUInt32BE(16 + 1);
        const endY = data.readUInt32BE(16 + 5);
        const moveID = data.readUInt32BE(16 + 9);
        
        if (endX < 0 || endY < 0 || endX > 5000 || endY > 5000) {
            Logger.log("ERROR", `無效坐標 (X:${endX}, Y:${endY})`);
            return;
        }

        const user = UserModel.getUser(userID);
        if (user) {
            user.x = endX;
            user.y = endY;
            UserModel.setUser(userID, user);

            const mapUsers = MapModel.getUsersByMap(user.map, UserModel);
            const body = Buffer.alloc(20);
            body.writeUInt32BE(userID, 0); // Prepend ACTOR's userID!
            body.writeUInt32BE(endX, 4);
            body.writeUInt32BE(endY, 8);
            body.writeUInt32BE(0, 12);     // UseItem
            body.writeUInt32BE(moveID, 16);// Grid
            
            for (const mapUser of mapUsers) {
                if (mapUser.socket) {
                    // MUST use RECEIVER's userID in the header to pass MsgHead validation!
                    const head = PacketBuilder.makeHead(303, mapUser.userID, 0, body.length);
                    mapUser.socket.write(head);
                    mapUser.socket.write(body);
                }
            }
        }
    }

    static handleUserAction(socket, userID, data) {
        Logger.log("ACTION", `Hành động (UserID: ${userID})`);
        if (data.length < 21) {
            Logger.log("ERROR", `封包長度不足，無法讀取動作數據`);
            return;
        }

        const action = data.readUInt32BE(16 + 1);
        const direction = data.readUInt8(16 + 5);

        const user = UserModel.getUser(userID);
        if (user) {
            const mapUsers = MapModel.getUsersByMap(user.map, UserModel);
            const body = Buffer.alloc(9);
            body.writeUInt32BE(userID, 0); // Prepend ACTOR's userID!
            body.writeUInt32BE(action, 4);
            body.writeUInt8(direction, 8);

            for (const mapUser of mapUsers) {
                if (mapUser.socket) {
                    // MUST use RECEIVER's userID in the header!
                    const head = PacketBuilder.makeHead(305, mapUser.userID, 0, body.length);
                    mapUser.socket.write(head);
                    mapUser.socket.write(body);
                }
            }
        }
    }

    static handleChatMessage(socket, userID, data) {
        Logger.log("ACTION", `Chat (UserID: ${userID})`);
        if (data.length < 25) {
            Logger.log("ERROR", `封包長度不足，無法讀取聊天數據`);
            return;
        }
        const toWho = data.readUInt32BE(16 + 1);
        const msgLen = data.readUInt32BE(16 + 5);
        if (data.length < 25 + msgLen - 2) {
            Logger.log("ERROR", `封包長度不足，無法讀取完整聊天內容`);
            return;
        }
        const message = data.toString("utf8", 25, 25 + msgLen - 2);
        const maxMessageLength = 200;
        if (message.length > maxMessageLength) {
            Logger.log("ERROR", `聊天訊息過長: ${message.length} > ${maxMessageLength}`);
            return;
        }

        const user = UserModel.getUser(userID);
        if (!user) return;

        if (toWho === 0) {
            // Broadcast Chat
            const mapUsers = MapModel.getUsersByMap(user.map, UserModel);
            const msgBuf = Buffer.from(message, "utf8");
            const body = Buffer.alloc(28 + msgBuf.length);
            body.writeUInt32BE(user.userID, 0);
            body.write(user.nick.padEnd(16, "\0"), 4, 16, "utf8");
            body.writeUInt32BE(0, 20);
            body.writeUInt32BE(msgBuf.length, 24);
            msgBuf.copy(body, 28);

            for (const u of mapUsers) {
                if (u.socket) {
                    const head = PacketBuilder.makeHead(302, u.userID, 0, body.length);
                    u.socket.write(head);
                    u.socket.write(body);
                }
            }
            Logger.log("CHAT", `[${user.userID}] ${user.nick}: ${message}`);
        } else {
            // Private Chat
            const targetUser = UserModel.getUser(toWho);
            if (targetUser && targetUser.socket) {
                const msgBuf = Buffer.from(message, "utf8");
                const body = Buffer.alloc(28 + msgBuf.length);
                body.writeUInt32BE(user.userID, 0);
                body.write(user.nick.padEnd(16, "\0"), 4, 16, "utf8");
                body.writeUInt32BE(0, 20);
                body.writeUInt32BE(msgBuf.length, 24);
                msgBuf.copy(body, 28);
                const head = PacketBuilder.makeHead(302, targetUser.userID, 0, body.length);
                targetUser.socket.write(head);
                targetUser.socket.write(body);
            }
        }
    }

    static handleGetServerTime(socket, userID) {
        Logger.log("ACTION", `取得伺服器時間 (UserID: ${userID})`);
        const body = Buffer.alloc(8);
        const unixTime = Math.floor(Date.now() / 1000);
        body.writeUInt32BE(unixTime, 0);
        body.writeUInt32BE(0, 4);
        
        const head = PacketBuilder.makeHead(10301, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    static async handleModUserNickName(socket, userID, data) {
        Logger.log("ACTION", `Đổi tên (UserID: ${userID})`);
        if (data.length < 17) {
            Logger.log("ERROR", `封包長度不足，無法讀取新名字`);
            return;
        }
        
        // The nickname string might not fill 16 bytes completely or be null-terminated.
        // In ModUserInfoReq.as, it sends MsgHead.PkgLen = 33, so the body is 16 bytes.
        let nickBuf = Buffer.alloc(16);
        if (data.length >= 33) {
            data.copy(nickBuf, 0, 17, 33);
        } else {
            data.copy(nickBuf, 0, 17);
        }
        
        let nick = nickBuf.toString("utf8").replace(/\0/g, '');
        if (!nick || nick.trim() === "") nick = "Mole";

        const isTaken = await UserModel.isNicknameTaken(nick, userID);
        if (isTaken) {
            Logger.log("WARNING", `Đổi tên thất bại: Tên ${nick} đã được sử dụng.`);
            // Error code 10023 (Tên đã tồn tại) hoặc tương tự. (10024, 10015...)
            const head = PacketBuilder.makeHead(208, userID, 10024, 0); // result = 10024
            socket.write(head);
            return;
        }

        const user = UserModel.getUser(userID);
        if (user) {
            user.nick = nick;
            UserModel.setUser(userID, user);
            
            // Lưu vào MySQL (Fire and forget hoặc await nếu muốn)
            UserModel.updateNickname(userID, nick).catch(err => Logger.log("ERROR", "Lỗi lưu nickname: " + err));
            
            // Broadcast the change to everyone in the map
            const mapUsers = MapModel.getUsersByMap(user.map, UserModel);
            const body = Buffer.alloc(49);
            let offset = 0;
            body.writeUInt32BE(user.userID, offset); offset += 4;
            body.write(user.nick.padEnd(16, "\0"), offset, 16, "utf8"); offset += 16;
            body.writeUInt32BE(user.color || 0xFFFFFF, offset); offset += 4;
            body.writeUInt32BE(0, offset); offset += 4; // restaurantSign
            body.writeUInt32BE(0, offset); offset += 4; // restaurantLevel
            body.writeUInt32BE(user.isVIP ? 1 : 0, offset); offset += 4; // Vip
            body.writeUInt32BE(user.map || 0, offset); offset += 4; // MapID
            body.writeUInt32BE(user.mapType || 0, offset); offset += 4; // MapType
            body.writeUInt8(user.status || 0, offset); offset += 1; // Status
            body.writeUInt32BE(user.action || 0, offset); offset += 4; // Action
            
            for (const mapUser of mapUsers) {
                if (mapUser.socket) {
                    const head = PacketBuilder.makeHead(208, mapUser.userID, 0, body.length);
                    mapUser.socket.write(head);
                    mapUser.socket.write(body);
                }
            }
        }
    }

    static async handleWearClothes(socket, userID, data) {
        const reqCmdID = data.readUInt32BE(5);
        Logger.log("ACTION", `Thay đồ (CMD ${reqCmdID}, UserID: ${userID})`);
        
        const bodyLength = data.length - 17;
        let newItems = [];
        
        if (reqCmdID === 5017) {
            // CMD 5017 = "Lưu tủ đồ" (Save Closet)
            // Body chỉ chứa count (4 bytes) hoặc rỗng - KHÔNG chứa danh sách ItemID
            // Đọc danh sách đồ đang mặc từ DB (is_wearing = 1)
            Logger.log("DEBUG", `CMD 5017 body: ${bodyLength} bytes, hex: ${data.subarray(17).toString('hex')}`);
            
            try {
                const pool = require("../config/database");
                const [rows] = await pool.query(
                    "SELECT item_id FROM user_items WHERE user_id = ? AND is_wearing = 1",
                    [userID]
                );
                newItems = rows.map(r => r.item_id);
                Logger.log("INFO", `CMD 5017: User ${userID} đang mặc ${newItems.length} items từ DB: ${newItems.join(", ")}`);
            } catch (err) {
                Logger.log("ERROR", `Lỗi đọc DB cho CMD 5017: ${err.message}`);
                // Phản hồi lỗi
                const resBody = Buffer.alloc(0);
                const resHead = PacketBuilder.makeHead(5017, userID, 1, resBody.length);
                socket.write(resHead);
                socket.write(resBody);
                return;
            }
        } else {
            // CMD 306 = "Mặc đồ" (cũ) hoặc 503 = useUDProperty (Thay đồ/Lưu tủ đồ)
            if (data.length < 21) {
                Logger.log("ERROR", `Gói tin CMD ${reqCmdID} quá ngắn`);
                return;
            }
            const count = data.readUInt32BE(17);
            let offset = 21;
            for (let i = 0; i < count; i++) {
                if (offset + 4 <= data.length) {
                    newItems.push(data.readUInt32BE(offset));
                    offset += 4;
                }
            }
            Logger.log("INFO", `CMD ${reqCmdID}: User ${userID} mặc ${count} trang phục: ${newItems.join(", ")}`);
            
            // Cập nhật DB
            const pool = require("../config/database");
            pool.query("UPDATE user_items SET is_wearing = 0 WHERE user_id = ?", [userID]).then(() => {
                if (newItems.length > 0) {
                    const placeholders = newItems.map(() => "?").join(",");
                    const query = `UPDATE user_items SET is_wearing = 1 WHERE user_id = ? AND item_id IN (${placeholders})`;
                    pool.query(query, [userID, ...newItems]).catch(e => Logger.log("ERROR", "Lỗi DB cập nhật đồ: " + e));
                }
            }).catch(e => Logger.log("ERROR", "Lỗi DB reset đồ: " + e));
        }
        
        // Cập nhật user model (bộ nhớ)
        const user = UserModel.getUser(userID);
        const oldItems = user ? user.items || [] : [];
        
        // Tính toán Diff
        const addedItems = newItems.filter(id => !oldItems.includes(id));
        const removedItems = oldItems.filter(id => !newItems.includes(id));
        const diffItems = [];
        addedItems.forEach(id => diffItems.push({ id, flag: 1 }));
        removedItems.forEach(id => diffItems.push({ id, flag: 0 }));
        
        // Phản hồi cho sender với CmdID gốc
        let resBody = Buffer.alloc(0);
        if (reqCmdID === 503 || reqCmdID === 306) {
            // Thay đổi quần áo -> CMD 503 (UseUserItemRigRes)
            // Cấu trúc: UserID (4) + Count (4) + [ItemID (4) + Flag (1)] * Count
            resBody = Buffer.alloc(8 + diffItems.length * 5);
            let offset = 0;
            resBody.writeUInt32BE(userID, offset); offset += 4;
            resBody.writeUInt32BE(diffItems.length, offset); offset += 4;
            for (let i = 0; i < diffItems.length; i++) {
                resBody.writeUInt32BE(diffItems[i].id, offset); offset += 4;
                resBody.writeUInt8(diffItems[i].flag, offset); offset += 1;
            }
        }
        
        if (user) {
            user.items = newItems;
            UserModel.setUser(userID, user);
            
            // Broadcast CMD 503 cho tất cả users trong map
            // StageActionLogic.as lắng nghe USE_USER_ITEM_RIG (503) để chạy clothsChange
            if (diffItems.length > 0) {
                const mapUsers = MapModel.getUsersByMap(user.map, UserModel);
                for (const mapUser of mapUsers) {
                    if (mapUser.socket && mapUser.userID !== userID) { // Chỉ broadcast cho người khác
                        const head = PacketBuilder.makeHead(503, mapUser.userID, 0, resBody.length);
                        mapUser.socket.write(head);
                        mapUser.socket.write(resBody);
                    }
                }
                Logger.log("RESPONSE", `Broadcast CMD 503 cho ${mapUsers.length - 1} users (Diff: +${addedItems.join(",")}, -${removedItems.join(",")})`);
            }
        }
        
        const resHead = PacketBuilder.makeHead(reqCmdID, userID, 0, resBody.length);
        socket.write(resHead);
        socket.write(resBody);
    }
}

module.exports = ActionController;

