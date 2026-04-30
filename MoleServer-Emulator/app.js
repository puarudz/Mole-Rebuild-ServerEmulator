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
const HomeController = require("./src/controllers/HomeController");
const FriendController = require("./src/controllers/FriendController");
const JJLCardController = require("./src/controllers/JJLCardController");
const PetController = require("./src/controllers/PetController");
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
                case 211: // Nhận Lamu
                    await PetController.handleAdoptPet(socket, userID);
                    break;
                case 212: // Lấy thông tin Lamu
                    await PetController.handlePetInfo(socket, userID, data);
                    break;
                case 214: // Số lượng Lamu
                    await PetController.handlePetNum(socket, userID);
                    break;
                case 215: // Mang Lamu theo
                    await PetController.handlePetFollow(socket, userID, data);
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
                case 218: // Đổi tên Lamu
                    await PetController.handlePetNick(socket, userID, data);
                    break;
                case 219: // Chơi / huấn luyện Lamu
                    await PetController.handlePetPlay(socket, userID, data);
                    break;
                case 220: // Lưu vị trí Lamu
                    await PetController.handlePetPos(socket, userID, data);
                    break;
                case 232: // Kiểm tra Super Lamu
                    await PetController.handleSuperLamuCheck(socket, userID);
                    break;
                case 233: // Đếm Lamu trên map
                    await PetController.handlePetCountInMap(socket, userID);
                    break;
                case 235: // Đưa Lamu ra map/nhà
                    await PetController.handlePetFollowOut(socket, userID, data);
                    break;
                case 237: // Chăm sóc Lamu bằng đạo cụ
                    await PetController.handlePetTool(socket, userID, data);
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
                    await HomeController.handleGetRoomInfo(socket, userID, data);
                    break;
                // CMD 410 và 415 được xử lý bởi HomeController (xem bên dưới)
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
                    await ShopController.handlePetFood(socket, userID);
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
                case 1400: // SetJJLCard
                    await JJLCardController.handleSetJJLCard(socket, userID, data);
                    break;
                case 1401: // GetJJLCard
                    await JJLCardController.handleGetJJLCard(socket, userID, data);
                    break;
                case 1402: // ExchangeJJLCard
                    await JJLCardController.handleExchangeJJLCard(socket, userID, data);
                    break;
                case 1403: // SearchJJLCard
                    await JJLCardController.handleSearchJJLCard(socket, userID, data);
                    break;
                case 1404: // ExchangeJJLCloth
                    await JJLCardController.handleExchangeJJLCloth(socket, userID, data);
                    break;
                case 1243: // Exchange Item (Super Lamu Gift etc)
                    await ShopController.handleExchangeItem(socket, userID, data);
                    break;
                case 1301: // GetHomeInfo
                    await HomeController.handleGetHomeInfo(socket, userID, data);
                    break;
                case 1302: // SaveHomeInfo (lưu bố cục sân/nhà)
                    await HomeController.handleSaveHomeInfo(socket, userID, data);
                    break;
                case 1303: // GetHomeDepotInfo (kho đồ trang trí)
                    await HomeController.handleGetHomeDepotInfo(socket, userID, data);
                    break;
                case 1312: // SaveHomeUsed
                    await HomeController.handleSaveHomeUsed(socket, userID, data);
                    break;
                case 415: // SaveRoomBG (thay đổi nền sân/nhà)
                    await HomeController.handleSaveRoomBG(socket, userID, data);
                    break;
                case 410: // SaveRoomItem
                    await HomeController.handleSaveRoomItem(socket, userID, data);
                    break;
                case 1304: // PlantingSeed (trồng cây)
                    await HomeController.handlePlantingSeed(socket, userID, data);
                    break;
                case 1305: // DeleteSeed (nhổ cây)
                    await HomeController.handleDeleteSeed(socket, userID, data);
                    break;
                case 1306: // IrrigateWater (tưới nước)
                    await HomeController.handleIrrigateWater(socket, userID, data);
                    break;
                case 1308: // UseInsecticide (xịt thuốc)
                    await HomeController.handleUseInsecticide(socket, userID, data);
                    break;
                case 1309: // GainFruitage (thu hoạch)
                    await HomeController.handleGainFruitage(socket, userID, data);
                    break;
                case 1310: // GetSeedInfo (xem thông tin cây)
                    await HomeController.handleGetSeedInfo(socket, userID, data);
                    break;
                case 1311: // HomeGuestList
                    MapController.handleHomeGuestList(socket, userID, data);
                    break;
                case 1318: // GetGoodsInBox
                    MapController.handleGetGoodsInBox(socket, userID, data);
                    break;
                case 1319: // GetGoodsInBoxList
                    MapController.handleGetGoodsInBoxList(socket, userID, data);
                    break;
                case 1313: // UserExist
                    MapController.handleUserExist(socket, userID, data);
                    break;
                case 1314: // UserFlag
                    MapController.handleUserFlag(socket, userID, data);
                    break;
                case 412: // GetRoomList (VIP)
                    MapController.handleGetRoomList(socket, userID, data);
                    break;
                case 10301: // Server Time
                    ActionController.handleGetServerTime(socket, userID, data);
                    break;
                case 5011: // Xem tủ quần áo (Clothes)
                    await ShopController.handleViewClothes(socket, userID, data);
                    break;
                case 1114: // PET_SHOP_PLAY
                    await PetController.handlePetShopPlay(socket, userID);
                    break;
                case 1126: // Thăng cấp / tiến hóa Lamu
                    await PetController.handlePetLevelUp(socket, userID, data);
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
                case 602: // Phản hồi lời mời kết bạn
                    await FriendController.handleResponseFriend(socket, userID, data);
                    break;
                case 603: // Gửi lời mời kết bạn
                    await FriendController.handleAddFriend(socket, userID, data);
                    break;
                case 605: // Xóa bạn
                    await FriendController.handleDeleteFriend(socket, userID, data);
                    break;
                case 606: // Lấy danh sách bạn
                    await FriendController.handleGetFriendList(socket, userID, data);
                    break;
                case 607: // Thêm vào danh sách đen
                    await FriendController.handleAddBlacklist(socket, userID, data);
                    break;
                case 608: // Xóa khỏi danh sách đen
                    await FriendController.handleDelBlacklist(socket, userID, data);
                    break;
                case 609: // Lấy danh sách đen (xử lý bởi FriendController thay vì Dummy)
                    await FriendController.handleGetBlacklist(socket, userID, data);
                    break;
                case 315:
                case 11010: case 3106: case 10101: case 10102: case 8817: case 10302: 
                case 426: case 8920: case 8606: case 8755: case 8974: case 8990: 
                case 12018: case 11009: case 1328: case 10011: case 11085: case 12004: 
                case 1496: case 216: case 217: case 228: case 239:
                case 244: case 245: case 246:
                case 6024: case 6026: case 6034: case 805: case 9124: case 2008:
                case 240: case 8302: case 1227: case 10303:
                case 11014: case 1456:
                case 8938: case 1991: case 1915: case 1911:
                case 3101: case 3102: case 3105: case 3107: case 919: case 1269:
                case 1912: case 1914: case 3103: case 3104:
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
