const Logger = require("../core/Logger");
const PacketBuilder = require("../core/PacketBuilder");
const UserModel = require("../models/UserModel");
const MapModel = require("../models/MapModel");

class MapController {
    static handleEnterMap(socket, userID, data) {
        Logger.log("ACTION", `進入地圖 (UserID: ${userID})`);
        const user = UserModel.getUser(userID);
        if (!user) return;

        const newMapID = data.length >= 21 ? data.readUInt32BE(17) : 0;
        const newMapType = data.length >= 25 ? data.readUInt32BE(21) : 0;

        Logger.log("ACTION", `使用者 ${userID} 進入地圖 (MapID: ${newMapID})`);

        // Rời map cũ
        const oldMapUsers = MapModel.removeUserFromMap(user, UserModel);
        if (oldMapUsers) {
            this.broadcastLeaveMap(oldMapUsers, user);
        }

        // Vào map mới
        user.map = newMapID;
        user.x = 480;
        user.y = 280;
        MapModel.addUserToMap(user, newMapID, UserModel);
        UserModel.setUser(userID, user);

        const mapUsers = MapModel.getUsersByMap(newMapID, UserModel);
        this.broadcastEnterMap(mapUsers, user);
    }

    static broadcastEnterMap(mapUsers, userEntering) {
        // MUST use the special format for 401 (Direction before Pet_action)
        const body = PacketBuilder.makeEnterMapOrRoomUserInfo(userEntering);
        for (const user of mapUsers) {
            if (user.socket) {
                // Header must use RECEIVER's userID for 401 (EnterMap) to pass MsgHead validation
                const head = PacketBuilder.makeHead(401, user.userID, 0, body.length);
                user.socket.write(head);
                user.socket.write(body);
            }
        }
    }

    static broadcastLeaveMap(mapUsers, userLeaving) {
        const body = Buffer.alloc(8);
        body.writeUInt32BE(1, 0); // Count = 1
        body.writeUInt32BE(userLeaving.userID, 4);
        
        for (const user of mapUsers) {
            if (user.socket) {
                // Header must use RECEIVER's userID
                const head = PacketBuilder.makeHead(402, user.userID, 0, body.length);
                user.socket.write(head);
                user.socket.write(body);
            }
        }
    }
    static handleLeaveMap(socket, userID) {
        Logger.log("ACTION", `Rời Map (UserID: ${userID})`);
        const user = UserModel.getUser(userID);
        if (user) {
            const oldMapUsers = MapModel.removeUserFromMap(user, UserModel);
            if (oldMapUsers) {
                this.broadcastLeaveMap(oldMapUsers, user);
            }
            user.map = 0;
            UserModel.setUser(userID, user);
        }
    }

    static handleAllSceneUser(socket, userID, data) {
        Logger.log("ACTION", `Lấy danh sách người chơi trong Map (UserID: ${userID})`);
        if (data.length < 20) return;
        
        const mapID = data.readUInt32BE(17);
        const mapUsers = MapModel.getUsersByMap(mapID, UserModel);
        
        const parts = [];
        const header = Buffer.alloc(4);
        header.writeUInt32BE(mapUsers.length, 0);
        parts.push(header);
        
        for (const u of mapUsers) {
            parts.push(PacketBuilder.makeEnterMapUserInfo(u));
        }
        
        const body = Buffer.concat(parts);
        const packetHead = PacketBuilder.makeHead(405, userID, 0, body.length);
        socket.write(packetHead);
        socket.write(body);
    }

    static handleGetMapInfo(socket, userID, data) {
        Logger.log("ACTION", `取得地圖資訊 (UserID: ${userID})`);
        let mapID = 3, type = 0;
        try {
            if (data && data.length >= 21) mapID = data.readUInt32BE(17);
            if (data && data.length >= 25) type = data.readUInt32BE(21);
        } catch (e) {
            Logger.log("ERROR", `Không thể parse map info: ${e.message}`);
        }
        const body = Buffer.alloc(80);
        body.writeUInt32BE(mapID, 0); // MapID
        body.writeUInt32BE(type, 4); // MapType
        const mapName = ""; // Tên bản đồ (Trống tạm thời)
        body.write(mapName.padEnd(64, "\x00"), 8, "binary"); // Tên bản đồ
        body.writeUInt32BE(1, 72); // Type
        body.writeUInt32BE(0, 76); // ItemCount
        const head = PacketBuilder.makeHead(406, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    static handleMapLoaded(socket, userID) {
        Logger.log("ACTION", `地圖加載完成 (UserID: ${userID})`);
        const body = Buffer.alloc(4);
        body.writeUInt32BE(0, 0); // mapCount = 0
        const head = PacketBuilder.makeHead(408, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    static handleGetHomeInfo(socket, userID, data) {
        Logger.log("ACTION", `Xem nhà người dùng (UserID: ${userID})`);
        const targetUserID = data && data.length >= 21 ? data.readUInt32BE(17) : userID;

        // Dùng buffer 100 byte (dư 64 byte) để nếu Client yêu cầu thêm các trường mới (level, exp...) thì không bị EOFError.
        const body = Buffer.alloc(100);
        let offset = 0;
        body.writeUInt32BE(targetUserID, offset); offset += 4; // UserID
        const nickBuf = Buffer.alloc(16, 0);
        nickBuf.write("Home", 0, "utf8");
        nickBuf.copy(body, offset); offset += 16; // Name
        body.writeUInt32BE(1, offset); offset += 4; // Online
        body.writeUInt32BE(160030, offset); offset += 4; // HouseBackground (resource/goods/BGinHome/160030.swf)
        body.writeUInt32BE(1, offset); offset += 4; // ItemCount = 1 (Bắt buộc phải >= 1 vì client gọi itemArr[0])
        body.writeUInt32BE(0, offset); offset += 4; // PlantCount = 0
        
        // Item 0 (16 bytes) - Default Home BG
        body.writeUInt32BE(1220001, offset); offset += 4; // ID (1220001 exists in resource/home/item/swf/)
        body.writeInt16BE(450, offset); offset += 2;      // PosX
        body.writeInt16BE(200, offset); offset += 2;      // PosY
        body.writeUInt8(0, offset); offset += 1;          // Direction
        body.writeUInt8(1, offset); offset += 1;          // Visible
        body.writeUInt8(0, offset); offset += 1;          // Layer
        body.writeUInt8(0, offset); offset += 1;          // Type
        body.writeUInt32BE(0, offset); offset += 4;       // Other
        
        const head = PacketBuilder.makeHead(1301, userID, 0, offset);
        socket.write(head);
        socket.write(body.slice(0, offset));
        Logger.log("RESPONSE", `Gửi thông tin nhà (UserID: ${userID}, Target: ${targetUserID})`);
    }

    /**
     * CMD 409 - GetRoomInfo (Vào nhà của người chơi / xem nhà)
     * Client gửi khi người chơi bấm "Về nhà" hoặc xem nhà người khác
     */
    static handleGetRoomInfo(socket, userID, data) {
        Logger.log("ACTION", `Lấy thông tin phòng/nhà (CMD 409, UserID: ${userID})`);
        
        let targetUserID = userID;
        if (data && data.length >= 21) {
            targetUserID = data.readUInt32BE(17);
        }
        
        const user = UserModel.getUser(userID);
        const targetUser = UserModel.getUser(targetUserID) || user;
        const nick = targetUser ? (targetUser.nick || "Home") : "Home";
        
        // Format theo getRoomInfo.GetRoomInfoRes
        const body = Buffer.alloc(44);
        let offset = 0;
        body.writeUInt32BE(targetUserID, offset); offset += 4;       // UserID chủ nhà
        const nickBuf = Buffer.alloc(16, 0);
        nickBuf.write(nick, 0, "utf8");
        nickBuf.copy(body, offset); offset += 16;                    // Tên chủ nhà
        body.writeUInt32BE(1, offset); offset += 4;                  // Online (1=online)
        
        // HouseBGObj (16 bytes)
        body.writeUInt32BE(160030, offset); offset += 4;              // ID (HouseBG = 160030)
        body.writeInt16BE(0, offset); offset += 2;                   // PosX
        body.writeInt16BE(0, offset); offset += 2;                   // PosY
        body.writeUInt8(0, offset); offset += 1;                     // Direction
        body.writeUInt8(1, offset); offset += 1;                     // Visible
        body.writeUInt8(0, offset); offset += 1;                     // Layer
        body.writeUInt8(0, offset); offset += 1;                     // Type
        body.writeUInt8(0, offset); offset += 1;                     // Rotation
        body.write("   ", offset, 3, "utf8"); offset += 3;           // Reserved (3 bytes)
        
        body.writeUInt32BE(0, offset); offset += 4;                  // ItemCount (0 = không có đồ trong nhà)

        const head = PacketBuilder.makeHead(409, userID, 0, offset);
        socket.write(head);
        socket.write(body.slice(0, offset));
        Logger.log("RESPONSE", `Gửi thông tin phòng (CMD 409, UserID: ${userID}, Target: ${targetUserID})`);
    }

    /**
     * CMD 403 - EnterGame (Vào game/phòng chơi)
     */
    static handleEnterGame(socket, userID, data) {
        Logger.log("ACTION", `Vào game (CMD 403, UserID: ${userID})`);
        
        // Parse game info from data
        let gameID = 0, gameType = 0;
        if (data && data.length >= 21) {
            gameID = data.readUInt32BE(17);
        }
        if (data && data.length >= 25) {
            gameType = data.readUInt32BE(21);
        }
        
        // Response: gameID(4) + result(4)
        const body = Buffer.alloc(8);
        body.writeUInt32BE(gameID, 0);
        body.writeUInt32BE(0, 4); // Result = 0 (thành công)
        
        const head = PacketBuilder.makeHead(403, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Gửi phản hồi EnterGame (CMD 403, GameID: ${gameID})`);
    }

    /**
     * CMD 410 - SaveRoomItem (Lưu vị trí vật phẩm trong nhà)
     */
    static handleSaveRoomItem(socket, userID, data) {
        Logger.log("ACTION", `Lưu vật phẩm nhà (CMD 410, UserID: ${userID})`);
        // Private server: luôn trả về thành công
        const body = Buffer.alloc(4);
        body.writeUInt32BE(0, 0); // Result = 0 (thành công)
        const head = PacketBuilder.makeHead(410, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /**
     * CMD 415 - SaveRoomBG (Lưu hình nền nhà)
     */
    static handleSaveRoomBG(socket, userID, data) {
        Logger.log("ACTION", `Lưu hình nền nhà (CMD 415, UserID: ${userID})`);
        const body = Buffer.alloc(4);
        body.writeUInt32BE(0, 0); // Result = 0 (thành công)
        const head = PacketBuilder.makeHead(415, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /**
     * CMD 210 - LockHome (Mở/khóa cửa nhà)
     */
    static handleLockHome(socket, userID, data) {
        Logger.log("ACTION", `Mở/khóa cửa nhà (CMD 210, UserID: ${userID})`);
        let lockState = 0;
        if (data && data.length >= 21) {
            lockState = data.readUInt32BE(17);
        }
        const body = Buffer.alloc(4);
        body.writeUInt32BE(lockState, 0);
        const head = PacketBuilder.makeHead(210, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    /**
     * CMD 207 - GetUserBasicInfo
     */
    static handleGetUserBasicInfo(socket, userID, data) {
        Logger.log("ACTION", `Lấy thông tin cơ bản (CMD 207, UserID: ${userID})`);
        let targetUserID = userID;
        if (data && data.length >= 21) {
            targetUserID = data.readUInt32BE(17);
        }
        
        const targetUser = UserModel.getUser(targetUserID);
        const nick = targetUser ? (targetUser.nick || "Mole") : "Mole";
        const color = targetUser ? (targetUser.color || 0x7A0000) : 0x7A0000;
        
        const body = Buffer.alloc(49);
        let offset = 0;
        body.writeUInt32BE(targetUserID, offset); offset += 4;
        const nickBuf = Buffer.alloc(16, 0);
        nickBuf.write(nick, 0, "utf8");
        nickBuf.copy(body, offset); offset += 16;
        body.writeUInt32BE(color, offset); offset += 4;
        body.writeUInt32BE(0, offset); offset += 4; // restaurantSign
        body.writeUInt32BE(0, offset); offset += 4; // restaurantLevel
        body.writeUInt32BE(targetUser && targetUser.vip ? 1 : 0, offset); offset += 4; // Vip
        body.writeUInt32BE(targetUser ? (targetUser.map || 0) : 0, offset); offset += 4; // MapID
        body.writeUInt32BE(0, offset); offset += 4; // MapType
        body.writeUInt8(0, offset); offset += 1; // Status
        body.writeUInt32BE(0, offset); offset += 4; // Action
        
        const head = PacketBuilder.makeHead(207, userID, 0, offset);
        socket.write(head);
        socket.write(body.slice(0, offset));
    }

    /**
     * CMD 209 - ModUserColor (Đổi màu da)
     */
    static handleModUserColor(socket, userID, data) {
        Logger.log("ACTION", `Đổi màu da (CMD 209, UserID: ${userID})`);
        let newColor = 0x7A0000;
        if (data && data.length >= 21) {
            newColor = data.readUInt32BE(17);
        }
        
        const user = UserModel.getUser(userID);
        if (user) {
            user.color = newColor;
            UserModel.setUser(userID, user);
        }
        
        const body = Buffer.alloc(4);
        body.writeUInt32BE(newColor, 0);
        const head = PacketBuilder.makeHead(209, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
    }

    static handleGetSceneUserInfo(socket, userID, data) {
        if (data.length < 21) {
            Logger.log("ERROR", `封包長度不足，無法讀取 GetSceneUserInfo 目標 UserID`);
            return;
        }
        const targetUserID = data.readUInt32BE(17);
        Logger.log("ACTION", `Lấy thông tin chi tiết (CMD 204) cho UserID: ${targetUserID} từ UserID: ${userID}`);
        
        const targetUser = UserModel.getUser(targetUserID);
        if (targetUser) {
            const body = PacketBuilder.makeSceneUserInfo(targetUser);
            // Header for 204 MUST use the receiver's userID (userID)
            const head = PacketBuilder.makeHead(204, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
        } else {
            Logger.log("ERROR", `Không tìm thấy UserID: ${targetUserID} cho lệnh 204`);
            // Create a fake user object for the NPC to satisfy the client parser.
            const fakeUser = {
                userID: targetUserID,
                roleTime: 1209600,
                nick: "NPC",
                color: 0xFFFFFF,
                isVIP: false,
                isGuide: false,
                vipLevel: 0,
                vipMonth: 0,
                map: 0,
                mapType: 0,
                x: 0,
                y: 0,
                action: 0,
                direction: 0,
                items: [],
                status: 0
            };
            const body = PacketBuilder.makeSceneUserInfo(fakeUser);
            const head = PacketBuilder.makeHead(204, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
        }
    }

    /*** Xử lý GetHomeDepotInfo (CMD 1303) ***/
    static handleGetHomeDepotInfo(socket, userID, data) {
        Logger.log("ACTION", `Xem kho nhà (UserID: ${userID})`);
        // Format: Count (4 bytes)
        const body = Buffer.alloc(4);
        body.writeUInt32BE(0, 0); // Count = 0

        const head = PacketBuilder.makeHead(1303, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Gửi kho nhà trống`);
    }

    /*** Xử lý HomeGuestList (CMD 1311) ***/
    static handleHomeGuestList(socket, userID, data) {
        Logger.log("ACTION", `Xem khách đến nhà (UserID: ${userID})`);
        // Format: Count (2 bytes - readShort)
        const body = Buffer.alloc(2);
        body.writeUInt16BE(0, 0); // Count = 0

        const head = PacketBuilder.makeHead(1311, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Gửi danh sách khách đến nhà trống`);
    }

    /*** Xử lý Lấy danh sách quà hộp (CMD 1319) ***/
    static handleGetGoodsInBoxList(socket, userID, data) {
        Logger.log("ACTION", `Lấy danh sách người nhận quà nhà (UserID: ${userID})`);
        // Format: Count (4 bytes)
        const body = Buffer.alloc(4);
        body.writeUInt32BE(0, 0); // len = 0

        const head = PacketBuilder.makeHead(1319, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Gửi danh sách quà trống`);
    }
}
module.exports = MapController;
