const Logger = require("../core/Logger");
const PacketBuilder = require("../core/PacketBuilder");
const UserModel = require("../models/UserModel");
const MapModel = require("../models/MapModel");

class MapController {
    static handleEnterMap(socket, userID, data) {
        // Debug: dump raw packet
        Logger.log("DEBUG", `[CMD 401 RAW] len=${data.length}, hex=${data.toString('hex').substring(0, 60)}`);
        const user = UserModel.getUser(userID);
        if (!user) {
            Logger.log("ERROR", `User ${userID} không tồn tại, không thể vào map`);
            return;
        }

        const newMapID = data.length >= 21 ? data.readUInt32BE(17) : 0;
        const newMapType = data.length >= 25 ? data.readUInt32BE(21) : 0;
        const oldMapID = data.length >= 29 ? data.readUInt32BE(25) : 0;
        const oldMapType = data.length >= 33 ? data.readUInt32BE(29) : 0;

        const isHome = newMapID > 2000000000;
        Logger.log("ACTION", `使用者 ${userID} 進入地圖 (MapID: ${newMapID}, MapType: ${newMapType}, OldMapID: ${oldMapID}, OldMapType: ${oldMapType}, isHome: ${isHome})`);

        // Rời map cũ (nếu user.map > 0 mới có map cũ để rời)
        const oldMapUsers = MapModel.removeUserFromMap(user, UserModel);
        if (oldMapUsers && oldMapUsers.length > 0) {
            this.broadcastLeaveMap(oldMapUsers, user);
        }

        // Cập nhật socket hiện tại (đảm bảo socket luôn đúng)
        user.socket = socket;

        // Vào map mới
        user.map = newMapID;
        user.x = 480;
        user.y = 280;
        MapModel.addUserToMap(user, newMapID, UserModel);
        UserModel.setUser(userID, user);

        // 1. Gửi CMD 401 cho CHÍNH NGƯỜI VÀO MAP (để client có ENTER_MAP_ROOM event)
        const selfBody = PacketBuilder.makeEnterMapOrRoomUserInfo(user);
        Logger.log("DEBUG", `[CMD 401 RESP] BodySize=${selfBody.length}, PkgLen=${17 + selfBody.length}`);
        const selfHead = PacketBuilder.makeHead(401, userID, 0, selfBody.length);
        socket.write(selfHead);
        socket.write(selfBody);
        Logger.log("RESPONSE", `Gửi CMD 401 cho chính người vào map (UserID: ${userID}, MapID: ${newMapID})`);

        // 2. Broadcast CMD 401 cho NHỮNG NGƯỜI KHÁC trong map (không gửi lại cho người vào)
        const mapUsers = MapModel.getUsersByMap(newMapID, UserModel);
        let broadcastCount = 0;
        for (const u of mapUsers) {
            if (u.userID !== userID && u.socket) {
                const head = PacketBuilder.makeHead(401, u.userID, 0, selfBody.length);
                u.socket.write(head);
                u.socket.write(selfBody);
                broadcastCount++;
            }
        }
        if (broadcastCount > 0) {
            Logger.log("RESPONSE", `Broadcast CMD 401 đến ${broadcastCount} người khác trong map`);
        }
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
        if (!user) {
            Logger.log("ERROR", `User ${userID} không tồn tại khi rời map`);
            return;
        }
        user.socket = socket;

        const oldMapUsers = MapModel.removeUserFromMap(user, UserModel);

        // LUÔN gửi CMD 402 cho CHÍNH NGƯỜI RỜI MAP (để client có LEAVE_ROOM_MYSELF event)
        // Nếu không gửi, client sẽ treo vĩnh viễn chờ response
        const leaveBody = Buffer.alloc(8);
        leaveBody.writeUInt32BE(1, 0);
        leaveBody.writeUInt32BE(userID, 4);
        const selfHead = PacketBuilder.makeHead(402, userID, 0, leaveBody.length);
        socket.write(selfHead);
        socket.write(leaveBody);
        Logger.log("RESPONSE", `Gửi CMD 402 cho chính người rời map (UserID: ${userID})`);

        // Broadcast CMD 402 cho NHỮNG NGƯỜI KHÁC trong map cũ (nếu có)
        if (oldMapUsers && oldMapUsers.length > 0) {
            let leaveBroadcastCount = 0;
            for (const u of oldMapUsers) {
                if (u.socket) {
                    const head = PacketBuilder.makeHead(402, u.userID, 0, leaveBody.length);
                    u.socket.write(head);
                    u.socket.write(leaveBody);
                    leaveBroadcastCount++;
                }
            }
            if (leaveBroadcastCount > 0) {
                Logger.log("RESPONSE", `Broadcast CMD 402 đến ${leaveBroadcastCount} người khác trong map`);
            }
        }

        user.map = 0;
        UserModel.setUser(userID, user);
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

    /**
     * CMD 1301 - GetHomeInfo (Về Nhà / Xem nhà)
     * 
     * Client gửi: PkgLen=21, Header(17) + targetUserID(4)
     * Server trả về format theo GetHomeInfoRes.GetInfo():
     *   UserID(4) + Name(16) + Online(4) + HouseBackground(4) + ItemCount(4) + PlantCount(4)
     *   + Items[] (mỗi item 16 bytes: ID:4,PosX:2,PosY:2,Dir:1,Vis:1,Layer:1,Type:1,Other:4)
     *   + Plants[] (SeedParse format)
     * 
     * LƯU Ý: CMD 1301 khác với CMD 409 - HouseBackground chỉ là 4 byte ID,
     * KHÔNG phải là full HouseBGObj 16 byte như CMD 409.
     * 
     * QUAN TRỌNG: Client yêu cầu ItemCount >= 1, item đầu tiên (homeItemArr[0])
     * phải là house background (Layer=6) vì HomeLogic.homeBGID đọc homeItemArr[0].ID
     * và HouseBGcompleteHandler đọc homeItemArr[0].PosX/PosY/Direction.
     */
    static handleGetHomeInfo(socket, userID, data) {
        Logger.log("DEBUG", `[CMD 1301 RAW] len=${data.length}, hex=${data.toString('hex').substring(0, 60)}`);
        Logger.log("ACTION", `Xem nhà người dùng (CMD 1301, UserID: ${userID})`);
        const targetUserID = data && data.length >= 21 ? data.readUInt32BE(17) : userID;
        Logger.log("DEBUG", `[CMD 1301] targetUserID=${targetUserID}, userID=${userID}`);

        // Luôn cập nhật socket cho user hiện tại
        const user = UserModel.getUser(userID);
        if (user) user.socket = socket;
        const targetUser = UserModel.getUser(targetUserID) || user;
        const nick = targetUser ? (targetUser.nick || "Home") : "Home";

        const HOUSE_ID = 160030;      // ID ngôi nhà (resource/goods/BGinHome/) — dùng cho HouseBackground field
        const TERRAIN_BG_ID = 1220001; // ID nền đất mặc định (resource/home/item/swf/1220001.swf)
        // homeItemArr[0].ID = TERRAIN_BG_ID → HomeLogic.homeBGID = 1220001
        // HomeView.loadHomeground() load: resource/home/item/swf/1220001.swf (có mc, username, bg, item_mc, housebg_mc)
        const ITEM_COUNT = 1;
        const PLANT_COUNT = 0;
        // Header: UserID(4) + Name(16) + Online(4) + HouseBackground(4) + ItemCount(4) + PlantCount(4) = 36 bytes
        // Item format (16 bytes): ID(4) + PosX(2) + PosY(2) + Dir(1) + Visible(1) + Layer(1) + Type(1) + Other(4)
        const body = Buffer.alloc(36 + ITEM_COUNT * 16);
        let offset = 0;
        body.writeUInt32BE(targetUserID, offset); offset += 4;       // UserID
        const nickBuf = Buffer.alloc(16, 0);
        nickBuf.write(nick, 0, "utf8");
        nickBuf.copy(body, offset); offset += 16;                    // Name (16 bytes)
        body.writeUInt32BE(1, offset); offset += 4;                  // Online (1=online)
        body.writeUInt32BE(HOUSE_ID, offset); offset += 4;          // HouseBackground: 160030 (HomeView.loadHouseground dùng field này)
        body.writeUInt32BE(ITEM_COUNT, offset); offset += 4;         // ItemCount = 1
        body.writeUInt32BE(PLANT_COUNT, offset); offset += 4;        // PlantCount = 0

        // Item[0]: ID = TERRAIN_BG_ID → HomeLogic.homeBGID = 1220001
        // Layer = 0 → HomeEditView.loadGoodsInHome() BỎ QUA item này (chỉ load Layer==4 hoặc Layer==6)
        // → Không crash #1010 (không gọi mc1.gotoAndStop)
        // HomeView.loadHomeground() vẫn dùng homeBGID=1220001 để load resource/home/item/swf/1220001.swf
        body.writeUInt32BE(TERRAIN_BG_ID, offset); offset += 4;      // ID = 1220001 (homeBGID đọc field này)
        body.writeInt16BE(450, offset); offset += 2;                 // PosX (client dùng readShort - signed)
        body.writeInt16BE(200, offset); offset += 2;                 // PosY (client dùng readShort - signed)
        body.writeUInt8(1, offset); offset += 1;                     // Direction
        body.writeUInt8(1, offset); offset += 1;                     // Visible
        body.writeUInt8(0, offset); offset += 1;                     // Layer = 0 → HomeEditView bỏ qua, không load SWF
        body.writeUInt8(0, offset); offset += 1;                     // Type
        body.writeUInt32BE(0, offset); offset += 4;                  // Other

        const head = PacketBuilder.makeHead(1301, userID, 0, offset);
        socket.write(head);
        socket.write(body.slice(0, offset));
        Logger.log("RESPONSE", `Gửi thông tin nhà CMD 1301 (UserID: ${userID}, Target: ${targetUserID}, BodySize: ${offset}, homeBGID: ${TERRAIN_BG_ID}, HouseID: ${HOUSE_ID})`);
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
            Logger.log("ERROR", `Không tìm thấy UserID: ${targetUserID} cho lệnh 204. Nếu đây là NPC, bỏ qua.`);
            // Không gửi fakeUser, để client tự xử lý NPC
            const head = PacketBuilder.makeHead(204, userID, 10008, 0); // 10008 = User not found
            socket.write(head);
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
        // Format: Count (4 bytes - readUnsignedInt)
        const body = Buffer.alloc(4);
        body.writeUInt32BE(0, 0); // len = 0

        const head = PacketBuilder.makeHead(1319, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Gửi danh sách quà trống`);
    }

    /*** Xử lý SaveHomeInfo (CMD 1302) - Lưu thông tin nhà ***/
    static handleSaveHomeInfo(socket, userID, data) {
        Logger.log("ACTION", `Lưu thông tin nhà (CMD 1302, UserID: ${userID})`);
        // Response: chỉ cần result=0 (thành công), không cần body
        const head = PacketBuilder.makeHead(1302, userID, 0, 0);
        socket.write(head);
        Logger.log("RESPONSE", `Xác nhận lưu thông tin nhà thành công`);
    }

    /*** Xử lý SaveHomeUsed (CMD 1312) - Lưu vật phẩm đã dùng trong nhà ***/
    static handleSaveHomeUsed(socket, userID, data) {
        Logger.log("ACTION", `Lưu vật phẩm đã dùng trong nhà (CMD 1312, UserID: ${userID})`);
        // Response: chỉ cần result=0 (thành công), không cần body
        const head = PacketBuilder.makeHead(1312, userID, 0, 0);
        socket.write(head);
        Logger.log("RESPONSE", `Xác nhận lưu vật phẩm nhà thành công`);
    }

    /*** Xử lý GetGoodsInBox (CMD 1318) - Lấy quà trong hộp ***/
    static handleGetGoodsInBox(socket, userID, data) {
        Logger.log("ACTION", `Lấy quà trong hộp (CMD 1318, UserID: ${userID})`);
        // Response: chỉ cần result=0 (thành công), không cần body
        const head = PacketBuilder.makeHead(1318, userID, 0, 0);
        socket.write(head);
        Logger.log("RESPONSE", `Xác nhận lấy quà thành công`);
    }

    /*** Xử lý GetRoomList (CMD 412) - Danh sách phòng VIP ***/
    static handleGetRoomList(socket, userID, data) {
        Logger.log("ACTION", `Lấy danh sách phòng VIP (CMD 412, UserID: ${userID})`);
        // Format: Count(4) + mỗi phòng: UserID(4), Name(16), Vip(4), UserNum(4)
        const body = Buffer.alloc(4);
        body.writeUInt32BE(0, 0); // Count = 0 (không có phòng VIP)

        const head = PacketBuilder.makeHead(412, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Gửi danh sách phòng VIP trống`);
    }

    /*** Xử lý UserExist (CMD 1313) - Kiểm tra user tồn tại ***/
    static handleUserExist(socket, userID, data) {
        let targetUserID = userID;
        if (data && data.length >= 21) {
            targetUserID = data.readUInt32BE(17);
        }
        Logger.log("ACTION", `Kiểm tra user tồn tại (CMD 1313, UserID: ${userID}, Target: ${targetUserID})`);
        const targetUser = UserModel.getUser(targetUserID);
        const exists = targetUser ? 1 : 0;
        const body = Buffer.alloc(4);
        body.writeUInt32BE(exists, 0);
        const head = PacketBuilder.makeHead(1313, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `UserExist: ${exists ? "Tồn tại" : "Không tồn tại"}`);
    }

    /*** Xử lý UserFlag (CMD 1314) - Lấy cờ user ***/
    static handleUserFlag(socket, userID, data) {
        let targetUserID = userID;
        if (data && data.length >= 21) {
            targetUserID = data.readUInt32BE(17);
        }
        Logger.log("ACTION", `Lấy cờ user (CMD 1314, UserID: ${userID}, Target: ${targetUserID})`);
        const targetUser = UserModel.getUser(targetUserID);
        const flag = targetUser ? (targetUser.lockHome || 0) : 0;
        const body = Buffer.alloc(4);
        body.writeUInt32BE(flag, 0);
        const head = PacketBuilder.makeHead(1314, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `UserFlag: ${flag}`);
    }
}
module.exports = MapController;
