const fs = require("fs");
const net = require("net");
const crypto = require("crypto");
const Logger = require("./src/core/Logger");
const CryptoUtils = require("./src/core/CryptoUtils");
const PacketBuilder = require("./src/core/PacketBuilder");
const AuthController = require("./src/controllers/AuthController");
const MapController = require("./src/controllers/MapController");
const ActionController = require("./src/controllers/ActionController");
const ShopController = require("./src/controllers/ShopController");
const UserModel = require("./src/models/UserModel");

class MoleServer {
    constructor() {
        this.SERVER_IP = "0.0.0.0";
        this.SERVER_PORT = 7777;
        this.POLICY_XML = `
        <?xml version="1.0"?>
        <cross-domain-policy>
            <allow-access-from domain="*" to-ports="7777" />
        </cross-domain-policy>\0`;

        this.startServer();
    }

    startServer() {
        this.server = net.createServer((socket) => this.handleConnection(socket));
        this.server.listen(this.SERVER_PORT, this.SERVER_IP, () => {
            Logger.log("INFO", `Mole TCP Server khởi động tại ${this.SERVER_IP}:${this.SERVER_PORT}`);
        });
    }

    handleConnection(socket) {
        Logger.log("INFO", `Kết nối mới: ${socket.remoteAddress}:${socket.remotePort}`);

        let buffer = Buffer.alloc(0);

        socket.on("data", async (data) => {
            // Xử lý Policy File Request
            const dataStr = data.toString();
            if (dataStr.includes("<policy-file-request/>")) {
                Logger.log("INFO", `Gửi Cross-Domain Policy tới ${socket.remoteAddress}`);
                socket.write(this.POLICY_XML);
                return;
            }

            buffer = Buffer.concat([buffer, data]);

            while (buffer.length >= 17) {
                const length = buffer.readUInt32BE(0);
                if (buffer.length < length) {
                    break;
                }

                const packet = buffer.subarray(0, length);
                buffer = buffer.subarray(length);

                // Disable decryption since current client uses unencrypted packets
                await this.processPacket(socket, packet);
            }
        });

        socket.on("end", () => this.handleDisconnect(socket));
        socket.on("error", (err) => {
            Logger.log("ERROR", `Lỗi Socket: ${err.message}`);
        });
    }

    async processPacket(socket, data) {
        if (data.length < 17) return;

        const version = data.readUInt8(4);
        const cmdID = data.readUInt32BE(5);
        const userID = data.readUInt32BE(9);
        const result = data.readUInt32BE(13);

        Logger.log("DEBUG", `[PACKET INFO] Độ dài: ${data.length}, CmdID: ${cmdID}, UserID: ${userID}`);

        try {
            switch (cmdID) {
                case 103: // Đăng nhập / Lấy danh sách server
                    await AuthController.handleLogin(socket, data);
                    break;
                case 105: // Danh sách server đề xuất
                    AuthController.handleServerList(socket, true);
                    break;
                case 106: // Danh sách tất cả server
                    AuthController.handleServerList(socket, false);
                    break;
                case 201: // Đăng nhập Online Server
                    await AuthController.handleLoginOnlineServer(socket, userID, data);
                    break;
                case 204: // Get Scene User Info (NPC interaction, etc)
                    MapController.handleGetSceneUserInfo(socket, userID, data);
                    break;
                case 207: // Get User Basic Info
                    MapController.handleGetUserBasicInfo(socket, userID, data);
                    break;
                case 208: // Modify User Nickname
                    await ActionController.handleModUserNickName(socket, userID, data);
                    break;
                case 209: // Modify User Color
                    MapController.handleModUserColor(socket, userID, data);
                    break;
                case 210: // Lock/Unlock Home
                    MapController.handleLockHome(socket, userID, data);
                    break;
                case 302: // Chat
                    ActionController.handleChatMessage(socket, userID, data);
                    break;
                case 303: // Di chuyển
                    ActionController.handleWalk(socket, userID, data);
                    break;
                case 305: // Hành động (múa, vẫy tay...)
                    ActionController.handleUserAction(socket, userID, data);
                    break;
                case 306: // Mặc đồ (Cũ)
                case 5017: // Lưu tủ đồ (Save Closet)
                    await ActionController.handleWearClothes(socket, userID, data);
                    break;
                case 401: // Vào Map
                    MapController.handleEnterMap(socket, userID, data);
                    break;
                case 402: // Rời Map
                    MapController.handleLeaveMap(socket, userID);
                    break;
                case 403: // Enter Game
                    MapController.handleEnterGame(socket, userID, data);
                    break;
                case 405: // Lấy danh sách user trong Map
                    MapController.handleAllSceneUser(socket, userID, data);
                    break;
                case 406: // Thông tin bản đồ
                    MapController.handleGetMapInfo(socket, userID, data);
                    break;
                case 408: // Map Load xong
                    MapController.handleMapLoaded(socket, userID);
                    break;
                case 409: // Get Room Info (Về nhà)
                    MapController.handleGetRoomInfo(socket, userID, data);
                    break;
                case 410: // Save Room Item
                    MapController.handleSaveRoomItem(socket, userID, data);
                    break;
                case 415: // Save Room BG
                    MapController.handleSaveRoomBG(socket, userID, data);
                    break;
                case 501: // Mua vật phẩm từ NPC Shop
                    await ShopController.handleBuyItem(socket, userID, data);
                    break;
                case 503: // useUDProperty (Thay đồ / Lưu tủ đồ)
                    await ActionController.handleWearClothes(socket, userID, data);
                    break;
                case 504: // Sử dụng item đặc biệt
                    ShopController.handleUseItem(socket, userID, data);
                    break;
                case 505: // Cho thú cưng ăn
                    ShopController.handlePetFood(socket, userID);
                    break;
                case 507: // Xem túi đồ
                    await ShopController.handleViewInventory(socket, userID, data);
                    break;
                case 508: // Vứt item
                    await ShopController.handleDropItem(socket, userID, data);
                    break;
                case 509: // Danh sách shop NPC
                    await ShopController.handleListShopItem(socket, userID, data);
                    break;
                case 511: // Lấy số lượng item
                    ShopController.handleGetItemCount(socket, userID, data);
                    break;
                case 512: // Give me money
                    await ShopController.handleGiveMeMoney(socket, userID);
                    break;
                case 1389: // Buy Cloth
                    await ShopController.handleBuyCloth(socket, userID, data);
                    break;
                case 1243: // Exchange Item (Super Lamu Gift etc)
                    await ShopController.handleExchangeItem(socket, userID, data);
                    break;
                case 1301:
                    MapController.handleGetHomeInfo(socket, userID, data);
                    break;
                case 1303:
                    MapController.handleGetHomeDepotInfo(socket, userID, data);
                    break;
                case 1311:
                    MapController.handleHomeGuestList(socket, userID, data);
                    break;
                case 10301: // Server Time
                    ActionController.handleGetServerTime(socket, userID, data);
                    break;
                case 1319:
                    MapController.handleGetGoodsInBoxList(socket, userID, data);
                    break;
                case 5011: // Xem tủ quần áo (Clothes)
                    await ShopController.handleViewClothes(socket, userID, data);
                    break;
                case 5014: // Toggle mặc/cởi 1 món trong tủ quần áo
                    await ShopController.handleToggleClothes(socket, userID, data);
                    break;
                case 2031:
                    await ShopController.handleBuyCommodity(socket, userID, data);
                    break;
                case 2032:
                    await ShopController.handleGetMoney(socket, userID);
                    break;
                case 2033:
                    await ShopController.handleBuyDou(socket, userID, data);
                    break;
                case 2040:
                    await ShopController.handleAddScore(socket, userID);
                    break;
                case 11010: case 3106: case 609: case 10101: case 10102: case 8817: case 10302: 
                case 426: case 8920: case 8606: case 8755: case 8974: case 8990: 
                case 12018: case 11009: case 1328: case 10011: case 11085: case 12004: 
                case 1496: case 216: case 228: case 232: case 233: case 239: 
                case 6024: case 6026: case 6034: case 805: case 9124: case 2008:
                case 240: case 8302: case 1227: case 10303:
                case 11014: case 1313: case 1314: case 1456:
                case 8938: case 1991: case 1915: case 1911:
                    const DummyController = require("./src/controllers/DummyController");
                    DummyController.handleGeneric(socket, userID, cmdID, data);
                    break;
                default:
                    Logger.log("ERROR", `CmdID chưa được xử lý trong MVC: ${cmdID}`);
                    break;
            }
        } catch (error) {
            Logger.log("ERROR", `Lỗi khi xử lý gói tin (CmdID: ${cmdID}): ${error.message}`);
        }
    }

    handleDisconnect(socket) {
        if (socket.userID) {
            Logger.log("INFO", `Ngắt kết nối: ${socket.userID}`);
            MapController.handleLeaveMap(socket, socket.userID);
            UserModel.removeUser(socket.userID);
        } else {
            Logger.log("INFO", `Ngắt kết nối vô danh`);
        }
    }
}

new MoleServer();
