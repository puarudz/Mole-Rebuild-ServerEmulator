const Logger = require("../core/Logger");
const PacketBuilder = require("../core/PacketBuilder");
const pool = require("../config/database");
const UserModel = require("../models/UserModel");

class FriendController {
    /**
     * CMD 603 - Gửi lời mời kết bạn
     * Client gửi: UserID (4 bytes) của người muốn kết bạn
     */
    static async handleAddFriend(socket, userID, data) {
        if (data.length < 21) {
            Logger.log("ERROR", "AddFriend: Packet quá ngắn");
            return;
        }
        const targetUserID = data.readUInt32BE(17);
        Logger.log("FRIEND", `User ${userID} muốn kết bạn với ${targetUserID}`);

        try {
            // Kiểm tra target có tồn tại không
            const targetUser = await UserModel.fetchUserFromDB(targetUserID);
            if (!targetUser) {
                // Target không tồn tại → gửi lỗi
                const head = PacketBuilder.makeHead(603, userID, 5003, 0);
                socket.write(head);
                return;
            }

            // Kiểm tra đã là bạn chưa
            const [existing] = await pool.query(
                "SELECT * FROM user_friends WHERE user_id = ? AND friend_id = ?",
                [userID, targetUserID]
            );
            if (existing.length > 0) {
                // Đã là bạn → báo lỗi
                const head = PacketBuilder.makeHead(603, userID, 5004, 0);
                socket.write(head);
                Logger.log("FRIEND", `User ${userID} và ${targetUserID} đã là bạn`);
                return;
            }

            // Thêm vào DB
            await pool.query(
                "INSERT INTO user_friends (user_id, friend_id) VALUES (?, ?)",
                [userID, targetUserID]
            );
            await pool.query(
                "INSERT INTO user_friends (user_id, friend_id) VALUES (?, ?)",
                [targetUserID, userID]
            );

            // Gửi response thành công (body rỗng)
            const head = PacketBuilder.makeHead(603, userID, 0, 0);
            socket.write(head);
            Logger.log("FRIEND", `Kết bạn thành công: ${userID} <-> ${targetUserID}`);

            // Thông báo cho target nếu đang online
            const targetSocket = UserModel.getUser(targetUserID)?.socket;
            if (targetSocket) {
                const targetHead = PacketBuilder.makeHead(604, targetUserID, 0, 0);
                targetSocket.write(targetHead);
                Logger.log("FRIEND", `Đã thông báo cho ${targetUserID} về bạn mới`);
            }
        } catch (error) {
            Logger.log("ERROR", `Lỗi khi thêm bạn: ${error.message}`);
            const head = PacketBuilder.makeHead(603, userID, 5003, 0);
            socket.write(head);
        }
    }

    /**
     * CMD 605 - Xóa bạn
     * Client gửi: UserID (4 bytes) của người cần xóa
     */
    static async handleDeleteFriend(socket, userID, data) {
        if (data.length < 21) {
            Logger.log("ERROR", "DeleteFriend: Packet quá ngắn");
            return;
        }
        const targetUserID = data.readUInt32BE(17);
        Logger.log("FRIEND", `User ${userID} xóa bạn ${targetUserID}`);

        try {
            await pool.query(
                "DELETE FROM user_friends WHERE user_id = ? AND friend_id = ?",
                [userID, targetUserID]
            );
            await pool.query(
                "DELETE FROM user_friends WHERE user_id = ? AND friend_id = ?",
                [targetUserID, userID]
            );

            // Gửi response thành công
            const head = PacketBuilder.makeHead(605, userID, 0, 0);
            socket.write(head);
            Logger.log("FRIEND", `Xóa bạn thành công: ${userID} -/-> ${targetUserID}`);
        } catch (error) {
            Logger.log("ERROR", `Lỗi khi xóa bạn: ${error.message}`);
            const head = PacketBuilder.makeHead(605, userID, 5003, 0);
            socket.write(head);
        }
    }

    /**
     * CMD 606 - Lấy danh sách bạn bè
     * Client gửi: Body rỗng (chỉ header)
     * Server trả về: Count(4) + [UserID(4) + Nick(16) + Color(4) + Vip(4) + MapID(4) + Status(1) + Action(4)]...
     */
    static async handleGetFriendList(socket, userID, data) {
        Logger.log("FRIEND", `User ${userID} yêu cầu danh sách bạn`);

        try {
            const [friends] = await pool.query(
                `SELECT uf.friend_id, u.nick, u.color, u.vip_flags, 3 as map_id, 0 as status, 0 as action
                 FROM user_friends uf
                 JOIN users u ON u.user_id = uf.friend_id
                 WHERE uf.user_id = ? AND uf.status = 1`,
                [userID]
            );

            // Format: Count(4) + mỗi bạn: UserID(4) + Nick(16) + Color(4) + Vip(4) + MapID(4) + Status(1) + Action(4)
            const entrySize = 4 + 16 + 4 + 4 + 4 + 1 + 4; // = 37
            const body = Buffer.alloc(4 + friends.length * entrySize);
            let offset = 0;
            body.writeUInt32BE(friends.length, offset);
            offset += 4;

            for (const friend of friends) {
                body.writeUInt32BE(friend.friend_id, offset);
                offset += 4;
                const nickBuf = Buffer.alloc(16, 0);
                nickBuf.write((friend.nick || "Mole").substring(0, 16), 0, "utf8");
                nickBuf.copy(body, offset);
                offset += 16;
                body.writeUInt32BE(friend.color || 0x7A0000, offset);
                offset += 4;
                body.writeUInt32BE(friend.vip_flags || 33, offset);
                offset += 4;
                body.writeUInt32BE(friend.map_id || 3, offset);
                offset += 4;
                body.writeUInt8(friend.status || 0, offset);
                offset += 1;
                body.writeUInt32BE(friend.action || 0, offset);
                offset += 4;
            }

            const head = PacketBuilder.makeHead(606, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
            Logger.log("FRIEND", `Gửi danh sách ${friends.length} bạn cho ${userID}`);
        } catch (error) {
            Logger.log("ERROR", `Lỗi khi lấy danh sách bạn: ${error.message}`);
            const head = PacketBuilder.makeHead(606, userID, 5003, 0);
            socket.write(head);
        }
    }

    /**
     * CMD 607 - Thêm vào danh sách đen (Blacklist)
     * Client gửi: UserID (4 bytes)
     */
    static async handleAddBlacklist(socket, userID, data) {
        if (data.length < 21) {
            Logger.log("ERROR", "AddBlacklist: Packet quá ngắn");
            return;
        }
        const targetUserID = data.readUInt32BE(17);
        Logger.log("FRIEND", `User ${userID} thêm ${targetUserID} vào blacklist`);

        try {
            // Cập nhật hoặc thêm mới
            await pool.query(
                `INSERT INTO user_friends (user_id, friend_id, status) VALUES (?, ?, 2)
                 ON DUPLICATE KEY UPDATE status = 2`,
                [userID, targetUserID]
            );

            const head = PacketBuilder.makeHead(607, userID, 0, 0);
            socket.write(head);
            Logger.log("FRIEND", `Đã thêm ${targetUserID} vào blacklist của ${userID}`);
        } catch (error) {
            Logger.log("ERROR", `Lỗi khi thêm blacklist: ${error.message}`);
            const head = PacketBuilder.makeHead(607, userID, 5003, 0);
            socket.write(head);
        }
    }

    /**
     * CMD 608 - Xóa khỏi danh sách đen
     * Client gửi: UserID (4 bytes)
     */
    static async handleDelBlacklist(socket, userID, data) {
        if (data.length < 21) {
            Logger.log("ERROR", "DelBlacklist: Packet quá ngắn");
            return;
        }
        const targetUserID = data.readUInt32BE(17);
        Logger.log("FRIEND", `User ${userID} xóa ${targetUserID} khỏi blacklist`);

        try {
            await pool.query(
                "DELETE FROM user_friends WHERE user_id = ? AND friend_id = ? AND status = 2",
                [userID, targetUserID]
            );

            const head = PacketBuilder.makeHead(608, userID, 0, 0);
            socket.write(head);
            Logger.log("FRIEND", `Đã xóa ${targetUserID} khỏi blacklist của ${userID}`);
        } catch (error) {
            Logger.log("ERROR", `Lỗi khi xóa blacklist: ${error.message}`);
            const head = PacketBuilder.makeHead(608, userID, 5003, 0);
            socket.write(head);
        }
    }

    /**
     * CMD 609 - Lấy danh sách đen
     * Client gửi: Body rỗng
     * Server trả về: Count(4) + [UserID(4)]...
     */
    static async handleGetBlacklist(socket, userID, data) {
        Logger.log("FRIEND", `User ${userID} yêu cầu danh sách đen`);

        try {
            const [blacklist] = await pool.query(
                "SELECT friend_id FROM user_friends WHERE user_id = ? AND status = 2",
                [userID]
            );

            const body = Buffer.alloc(4 + blacklist.length * 4);
            body.writeUInt32BE(blacklist.length, 0);
            let offset = 4;
            for (const entry of blacklist) {
                body.writeUInt32BE(entry.friend_id, offset);
                offset += 4;
            }

            const head = PacketBuilder.makeHead(609, userID, 0, body.length);
            socket.write(head);
            socket.write(body);
            Logger.log("FRIEND", `Gửi danh sách đen ${blacklist.length} người cho ${userID}`);
        } catch (error) {
            Logger.log("ERROR", `Lỗi khi lấy blacklist: ${error.message}`);
            const head = PacketBuilder.makeHead(609, userID, 5003, 0);
            socket.write(head);
        }
    }

    /**
     * CMD 602 - Phản hồi lời mời kết bạn (accept/reject)
     * Client gửi: UserID(4) + MapID(4) + MapType(4) + Accept(1)
     */
    static async handleResponseFriend(socket, userID, data) {
        if (data.length < 30) {
            Logger.log("ERROR", "ResponseFriend: Packet quá ngắn");
            return;
        }
        const targetUserID = data.readUInt32BE(17);
        const mapID = data.readUInt32BE(21);
        const mapType = data.readUInt32BE(25);
        const accept = data.readUInt8(29);
        Logger.log("FRIEND", `User ${userID} ${accept ? "chấp nhận" : "từ chối"} kết bạn với ${targetUserID}`);

        try {
            if (accept) {
                // Thêm 2 chiều
                await pool.query(
                    `INSERT INTO user_friends (user_id, friend_id, status) VALUES (?, ?, 1)
                     ON DUPLICATE KEY UPDATE status = 1`,
                    [userID, targetUserID]
                );
                await pool.query(
                    `INSERT INTO user_friends (user_id, friend_id, status) VALUES (?, ?, 1)
                     ON DUPLICATE KEY UPDATE status = 1`,
                    [targetUserID, userID]
                );
            }

            const head = PacketBuilder.makeHead(602, userID, 0, 0);
            socket.write(head);

            // Thông báo cho target nếu online
            const targetSocket = UserModel.getUser(targetUserID)?.socket;
            if (targetSocket && accept) {
                const targetHead = PacketBuilder.makeHead(604, targetUserID, 0, 0);
                targetSocket.write(targetHead);
            }
        } catch (error) {
            Logger.log("ERROR", `Lỗi khi phản hồi kết bạn: ${error.message}`);
            const head = PacketBuilder.makeHead(602, userID, 5003, 0);
            socket.write(head);
        }
    }
}

module.exports = FriendController;
