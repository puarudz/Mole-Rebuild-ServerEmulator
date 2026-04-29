const Logger = require("../core/Logger");
const CryptoUtils = require("../core/CryptoUtils");
const PacketBuilder = require("../core/PacketBuilder");
const UserModel = require("../models/UserModel");

class AuthController {
    static async handleLogin(socket, data) {
        Logger.log("ACTION", `Yêu cầu đăng nhập - ${socket.remoteAddress}`);

        const userID = data.readUInt32BE(9);

        // Payload starts at 17, password is usually a 32-byte hex string starting there or shortly after
        const passwordBuffer = data.subarray(17);
        let password = passwordBuffer.toString("utf-8").replace(/\0/g, "").trim();
        password = password.match(/[a-f0-9]{32}/i)?.[0]?.toLowerCase() || "";

        Logger.log("INFO", `Đang xác thực UserID: ${userID}`);

        // Auto-create user if not exist, or verify
        // (Assuming you have logic to check password, but for now we just create/fetch)
        const user = await UserModel.createUser(userID, password);

        const success = user !== null;
        const actualUserID = success ? user.user_id : userID;
        const statusCode = success ? 0 : 5003;
        const packetLength = success ? 51 : 35;
        const response = Buffer.alloc(packetLength);

        response.writeUInt32BE(packetLength, 0); // Tổng độ dài
        response.writeUInt8(1, 4); // Phiên bản
        response.writeUInt32BE(103, 5); // CmdID 103 (Login Res)
        response.writeUInt32BE(actualUserID, 9); // Tài khoản
        response.writeUInt32BE(statusCode, 13);

        if (success) {
            response.writeUInt32BE(0, 17); // flag
            const crypto = require("crypto");
            crypto.randomBytes(16).copy(response, 21); // Session Key
            socket.userID = actualUserID;
            UserModel.saveSession(socket.remoteAddress, { userID: actualUserID });
            UserModel.setUser(actualUserID, user); // Load user to memory
        } else {
            Buffer.from("Login Failed   ", "utf-8").copy(response, 17, 0, 14);
            response.writeUInt8(0, 31);
        }

        socket.write(response);
        Logger.log("RESPONSE", `Gửi gói tin đăng nhập ${success ? "thành công" : "thất bại"}`);
    }

    static handleServerList(socket, isGoodServerList = false) {
        Logger.log("ACTION", `Gửi danh sách server ${isGoodServerList ? "đề xuất" : "tất cả"}`);
        const servers = [
            { id: 1, userCount: 0, ip: "127.0.0.1", port: 7777, friends: 0 },
            // { id: 2, userCount: 1, ip: "127.0.0.1", port: 7777, friends: 0 },
            // { id: 3, userCount: 20, ip: "127.0.0.1", port: 7777, friends: 0 },
        ];
        const serverEntrySize = 30;
        const headerSize = 17;
        const serverCount = servers.length;
        const baseBodySize = 4 + serverCount * serverEntrySize; // Số server + thông tin server
        const extraMetadataSize = isGoodServerList ? 12 : 0; // Chỉ danh sách đề xuất cần thêm 12 Byte Metadata
        const packetLength = headerSize + baseBodySize + extraMetadataSize;

        Logger.log("INFO", `Độ dài gói tin: ${packetLength}, Số server: ${serverCount}`);
        const response = Buffer.alloc(packetLength);
        let offset = 0;
        response.writeUInt32BE(packetLength, offset); offset += 4;
        response.writeUInt8(1, offset); offset += 1;  // Phiên bản
        response.writeUInt32BE(isGoodServerList ? 105 : 106, offset); offset += 4;
        response.writeUInt32BE(socket.userID || 0, offset); offset += 4; // userID
        response.writeUInt32BE(0, offset); offset += 4; // errorID
        response.writeUInt32BE(serverCount, offset); offset += 4; // Số server

        servers.forEach(server => {
            response.writeUInt32BE(server.id, offset); offset += 4;
            response.writeUInt32BE(server.userCount || 0, offset); offset += 4;
            const ipBuffer = Buffer.alloc(16, 0);
            Buffer.from(server.ip, "utf8").copy(ipBuffer, 0);
            ipBuffer.copy(response, offset);
            offset += 16;
            response.writeUInt16BE(server.port || 0, offset); offset += 2;
            response.writeUInt32BE(server.friends || 0, offset); offset += 4;
        });

        if (isGoodServerList) {
            response.writeUInt32BE(20, offset); offset += 4; // MaxServerID
            response.writeUInt32BE(1, offset); offset += 4;  // isVIP 
            response.writeUInt32BE(0, offset); offset += 4;  // Số bạn bè 
        }

        if (offset !== packetLength) {
            Logger.log("ERROR", `Độ dài gói tin không khớp, phải là ${packetLength}, nhưng thực tế là ${offset}`);
            return;
        }
        socket.write(response);
        Logger.log("RESPONSE", `Gửi gói tin danh sách server ${isGoodServerList ? "đề xuất" : ""}`);
    }

    static async handleLoginOnlineServer(socket, userID, data) {
        Logger.log("ACTION", `Xử lý đăng nhập Online Server (UserID: ${userID})`);

        let serverID = 1;
        try {
            if (data.length >= 19) {
                serverID = data.readUInt16BE(16 + 1);
            }
        } catch (e) {
            Logger.log("ERROR", `Không thể parse body CMD 201: ${e.message}`);
        }

        Logger.log("INFO", `Đăng nhập Online Server: ServerID: ${serverID}, UserID: ${userID}`);

        const user = await UserModel.fetchUserFromDB(userID);
        if (!user) {
            Logger.log("ERROR", `Không tìm thấy user ${userID} trong DB khi đăng nhập Online Server`);
            return;
        }

        // Cập nhật socket
        user.socket = socket;
        user.map = 3;
        UserModel.setUser(userID, user);
        socket.userID = userID;

        const MapModel = require("../models/MapModel");
        MapModel.addUserToMap(user, 3, UserModel);

        const body = PacketBuilder.makeInitPlayerEx(user);
        const head = PacketBuilder.makeHead(201, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        
        Logger.log("RESPONSE", `Gửi Init Player (CMD 201) thành công cho UserID: ${userID}`);

        // FIX LỖI: NGƯỜI VÀO TRƯỚC KHÔNG THẤY NGƯỜI ĐĂNG NHẬP SAU!
        // Khi một người vừa đăng nhập, họ tự thêm vào Map 3 nhưng CHƯA bao giờ báo cho người khác trong Map 3.
        // Cần phải gửi gói 401 cho TẤT CẢ NGƯỜI KHÁC trong Map 3 để họ biết người này vừa vào!
        const mapUsers = MapModel.getUsersByMap(3, UserModel);
        const enterMapBody = PacketBuilder.makeEnterMapOrRoomUserInfo(user);
        for (const otherUser of mapUsers) {
            // Không gửi lại cho chính mình (vì 201 đã lo phần login rồi)
            if (otherUser.userID !== userID && otherUser.socket) {
                const enterMapHead = PacketBuilder.makeHead(401, otherUser.userID, 0, enterMapBody.length);
                otherUser.socket.write(enterMapHead);
                otherUser.socket.write(enterMapBody);
            }
        }
    }
}

module.exports = AuthController;
