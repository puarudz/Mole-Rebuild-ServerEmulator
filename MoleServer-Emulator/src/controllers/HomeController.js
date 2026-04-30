const pool = require("../config/database");
const PacketBuilder = require("../core/PacketBuilder");
const Logger = require("../core/Logger");

// ─── Đồ mặc định trong kho ──────────────────────────────────────────────────
const DEFAULT_DEPOT = [
    { ID: 1220001, Count: 1 }, { ID: 1220002, Count: 1 },
    { ID: 1220003, Count: 3 }, { ID: 1220004, Count: 3 },
    { ID: 1220005, Count: 3 }, { ID: 1220006, Count: 3 },
    { ID: 1220007, Count: 2 }, { ID: 1220009, Count: 2 },
    { ID: 1220010, Count: 2 }, { ID: 1220011, Count: 1 },
    { ID: 1220013, Count: 2 }, { ID: 1220014, Count: 2 },
    { ID: 1220020, Count: 2 }, { ID: 1220021, Count: 1 },
    { ID: 1220022, Count: 2 }, { ID: 1220025, Count: 2 },
    { ID: 1220041, Count: 1 }, { ID: 1220045, Count: 2 },
];

// ─── Cache in-memory để giảm DB query ───────────────────────────────────────
const stateCache = {}; // { userID: { houseID, terrainID, roomBGItem, usedItems[], roomItems[], depotItems[], plants[], plantCounter } }

const DEFAULT_ROOM_BG = {
    ID: 160030,
    PosX: 450,
    PosY: 200,
    Direction: 1,
    Visible: 1,
    Layer: 6,
    Type: 3,
    Rotation: 0,
};

function isTerrainBackgroundID(itemID) {
    // Outdoor ground/background items live in the 122xxxx range.
    // House shells use a different ID range (e.g. 160030), so do not
    // classify them as the first terrain item or they will be removed.
    return itemID >= 1220000 && itemID < 1230000;
}

function isHouseShellID(itemID) {
    return itemID > 0 && !isTerrainBackgroundID(itemID);
}

function isRoomBackgroundItem(item) {
    return !!item && item.Layer === 6 && item.Type === 3;
}

function isHomeDepotItemID(itemID) {
    return (itemID >= 1220000 && itemID < 1230000) || (itemID >= 160000 && itemID < 170000);
}

function normalizeDepotItems(items) {
    const merged = new Map();
    for (const item of items || []) {
        const id = Number(item?.ID || 0);
        const count = Number(item?.Count || 0);
        if (id <= 0 || count <= 0) {
            continue;
        }
        merged.set(id, (merged.get(id) || 0) + count);
    }
    return [...merged.entries()]
        .sort((a, b) => a[0] - b[0])
        .map(([ID, Count]) => ({ ID, Count }));
}

// ─── Helpers: Build packet ───────────────────────────────────────────────────
// Item format CMD 1301: ID(4)+PosX(2)+PosY(2)+Dir(1)+Vis(1)+Layer(1)+Type(1)+Other(4) = 16 bytes
function writeHomeItem(buf, offset, item) {
    buf.writeUInt32BE(item.ID >>> 0, offset); offset += 4;
    buf.writeInt16BE(item.PosX || 0, offset); offset += 2;
    buf.writeInt16BE(item.PosY || 0, offset); offset += 2;
    buf.writeUInt8(item.Direction || 0, offset++);
    buf.writeUInt8(item.Visible !== undefined ? item.Visible : 1, offset++);
    buf.writeUInt8(item.Layer !== undefined ? item.Layer : 4, offset++);
    buf.writeUInt8(item.Type || 0, offset++);
    buf.writeUInt32BE(item.Other >>> 0, offset); offset += 4;
    return offset;
}

// Plant format (SeedParse): PlantID+ID+PosX+PosY+Growth+SickFlag+FruitNum+
// Fruit_status+Mature_time+Diff_mature_time+Cur_grow_rate+EarthState+Pollination+Can_thief = 56 bytes
function writePlant(buf, offset, p) {
    buf.writeUInt32BE(p.PlantID >>> 0, offset); offset += 4;
    buf.writeUInt32BE(p.ID >>> 0, offset); offset += 4;
    buf.writeInt16BE(p.PosX || 0, offset); offset += 2;
    buf.writeInt16BE(p.PosY || 0, offset); offset += 2;
    buf.writeUInt32BE(p.Growth || 1, offset); offset += 4;
    buf.writeUInt32BE(p.SickFlag || 0, offset); offset += 4;
    buf.writeUInt32BE(p.FruitNum || 0, offset); offset += 4;
    buf.writeUInt32BE(p.Fruit_status || 0, offset); offset += 4;
    buf.writeUInt32BE(p.Mature_time || 7200, offset); offset += 4;
    buf.writeUInt32BE(p.Diff_mature_time || 7200, offset); offset += 4;
    buf.writeUInt32BE(p.Cur_grow_rate || 100, offset); offset += 4;
    buf.writeUInt32BE(p.EarthState || 0, offset); offset += 4;
    buf.writeUInt32BE(p.Pollination || 0, offset); offset += 4;
    buf.writeUInt32BE(p.Can_thief || 0, offset); offset += 4;
    return offset;
}

// ─── Helpers: DB ─────────────────────────────────────────────────────────────
async function ensureHomeState(userID) {
    if (stateCache[userID]) return stateCache[userID];

    try {
        // Lấy cấu hình nhà chính
        const [homeRows] = await pool.query(
            "SELECT * FROM home_state WHERE user_id = ?", [userID]
        );

        let houseID = 160030, terrainID = 1220001;
        let houseX = 114, houseY = 262, houseDir = 1;
        if (homeRows.length > 0) {
            houseID   = homeRows[0].house_id;
            terrainID = homeRows[0].terrain_id;
            houseX    = homeRows[0].house_x;
            houseY    = homeRows[0].house_y;
            houseDir  = homeRows[0].house_dir;
        } else {
            await pool.query(
                "INSERT INTO home_state (user_id, house_id, terrain_id, house_x, house_y, house_dir) VALUES (?, ?, ?, ?, ?, ?)",
                [userID, houseID, terrainID, houseX, houseY, houseDir]
            );
        }

        // Lấy đồ đang đặt (used items trong sân)
        const [usedRows] = await pool.query(
            "SELECT * FROM home_used_items WHERE user_id = ? ORDER BY slot_index", [userID]
        );
        const usedItems = usedRows.map(r => ({
            ID: r.item_id, PosX: r.pos_x, PosY: r.pos_y,
            Direction: r.direction, Visible: r.visible,
            Layer: r.layer, Type: r.type, Other: r.other,
        }));

        // Lấy đồ đặt trong nhà (room items)
        const [roomRows] = await pool.query(
            "SELECT * FROM home_room_items WHERE user_id = ? ORDER BY slot_index", [userID]
        );
        const rawRoomItems = roomRows.map(r => ({
            ID: r.item_id, PosX: r.pos_x, PosY: r.pos_y,
            Direction: r.direction, Visible: r.visible,
            Layer: r.layer, Type: r.type, Rotation: r.rotation,
        }));
        let roomBGItem = null;
        const roomItems = [];
        for (const item of rawRoomItems) {
            if (!roomBGItem && isRoomBackgroundItem(item)) {
                roomBGItem = item;
                continue;
            }
            roomItems.push(item);
        }
        roomBGItem = roomBGItem || { ...DEFAULT_ROOM_BG, ID: houseID || DEFAULT_ROOM_BG.ID };

        // Lấy kho đồ
        const [depotRows] = await pool.query(
            "SELECT item_id, count FROM home_depot WHERE user_id = ?", [userID]
        );
        let depotItems;
        if (depotRows.length === 0) {
            // Lần đầu: tạo kho mặc định
            depotItems = JSON.parse(JSON.stringify(DEFAULT_DEPOT));
            const values = depotItems.map(d => [userID, d.ID, d.Count]);
            await pool.query(
                "INSERT INTO home_depot (user_id, item_id, count) VALUES ?", [values]
            );
        } else {
            depotItems = normalizeDepotItems(depotRows.map(r => ({ ID: r.item_id, Count: r.count })));
        }

        // Lấy cây đang trồng
        const [plantRows] = await pool.query(
            "SELECT * FROM home_plants WHERE user_id = ? ORDER BY plant_id", [userID]
        );
        const plants = plantRows.map(r => ({
            PlantID: r.plant_id, ID: r.seed_id,
            PosX: r.pos_x, PosY: r.pos_y,
            Growth: r.growth, SickFlag: r.sick_flag,
            FruitNum: r.fruit_num, Fruit_status: r.fruit_status,
            Mature_time: r.mature_time, Diff_mature_time: r.diff_mature_time,
            Cur_grow_rate: r.cur_grow_rate, EarthState: r.earth_state,
            Pollination: r.pollination, Can_thief: r.can_thief,
        }));

        const maxPlantID = plants.reduce((m, p) => Math.max(m, p.PlantID), 0);

        stateCache[userID] = { houseID, terrainID, houseX, houseY, houseDir, roomBGItem, usedItems, roomItems, depotItems, plants, plantCounter: maxPlantID + 1 };
        return stateCache[userID];
    } catch (e) {
        Logger.log("ERROR", `[HomeController] ensureHomeState: ${e.message}`);
        // Fallback in-memory nếu DB lỗi
        stateCache[userID] = {
            houseID: 160030, terrainID: 1220001, houseX: 114, houseY: 262, houseDir: 1,
            roomBGItem: { ...DEFAULT_ROOM_BG },
            usedItems: [], roomItems: [], depotItems: JSON.parse(JSON.stringify(DEFAULT_DEPOT)),
            plants: [], plantCounter: 1,
        };
        return stateCache[userID];
    }
}

async function saveHomeStateToDB(userID, state) {
    try {
        await pool.query(
            "UPDATE home_state SET house_id = ?, terrain_id = ?, house_x = ?, house_y = ?, house_dir = ? WHERE user_id = ?",
            [state.houseID, state.terrainID, state.houseX, state.houseY, state.houseDir, userID]
        );
    } catch (e) {
        Logger.log("ERROR", `[HomeController] saveHomeStateToDB: ${e.message}`);
    }
}

async function saveUsedItemsToDB(userID, usedItems) {
    try {
        await pool.query("DELETE FROM home_used_items WHERE user_id = ?", [userID]);
        if (usedItems.length > 0) {
            const values = usedItems.map((item, i) => [
                userID, i, item.ID, item.PosX, item.PosY,
                item.Direction, item.Visible, item.Layer, item.Type, item.Other || 0,
            ]);
            await pool.query(
                `INSERT INTO home_used_items
                 (user_id, slot_index, item_id, pos_x, pos_y, direction, visible, layer, type, other)
                 VALUES ?`,
                [values]
            );
        }
    } catch (e) {
        Logger.log("ERROR", `[HomeController] saveUsedItemsToDB: ${e.message}`);
    }
}

async function saveRoomItemsToDB(userID, roomItems, roomBGItem = null) {
    try {
        await pool.query("DELETE FROM home_room_items WHERE user_id = ?", [userID]);
        const rows = [];
        if (roomBGItem) {
            rows.push([
                userID, 0, roomBGItem.ID, roomBGItem.PosX, roomBGItem.PosY,
                roomBGItem.Direction, roomBGItem.Visible, roomBGItem.Layer, roomBGItem.Type, roomBGItem.Rotation || 0,
            ]);
        }
        if (roomItems.length > 0) {
            rows.push(...roomItems.map((item, i) => [
                userID, i + (roomBGItem ? 1 : 0), item.ID, item.PosX, item.PosY,
                item.Direction, item.Visible, item.Layer, item.Type, item.Rotation || 0,
            ]));
        }
        if (rows.length > 0) {
            await pool.query(
                `INSERT INTO home_room_items
                 (user_id, slot_index, item_id, pos_x, pos_y, direction, visible, layer, type, rotation)
                 VALUES ?`,
                [rows]
            );
        }
    } catch (e) {
        Logger.log("ERROR", `[HomeController] saveRoomItemsToDB: ${e.message}`);
    }
}

async function saveDepotToDB(userID, depotItems) {
    try {
        await pool.query("DELETE FROM home_depot WHERE user_id = ?", [userID]);
        const active = normalizeDepotItems(depotItems);
        if (active.length > 0) {
            const values = active.map(d => [userID, d.ID, d.Count]);
            await pool.query(
                "INSERT INTO home_depot (user_id, item_id, count) VALUES ?", [values]
            );
        }
    } catch (e) {
        Logger.log("ERROR", `[HomeController] saveDepotToDB: ${e.message}`);
    }
}

async function savePlantToDB(userID, plant) {
    try {
        await pool.query(
            `INSERT INTO home_plants
             (user_id, plant_id, seed_id, pos_x, pos_y, growth, sick_flag, fruit_num, fruit_status,
              mature_time, diff_mature_time, cur_grow_rate, earth_state, pollination, can_thief)
             VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
             ON DUPLICATE KEY UPDATE
               growth=VALUES(growth), sick_flag=VALUES(sick_flag),
               fruit_num=VALUES(fruit_num), fruit_status=VALUES(fruit_status),
               earth_state=VALUES(earth_state), pollination=VALUES(pollination),
               can_thief=VALUES(can_thief)`,
            [userID, plant.PlantID, plant.ID, plant.PosX, plant.PosY,
             plant.Growth, plant.SickFlag, plant.FruitNum, plant.Fruit_status,
             plant.Mature_time, plant.Diff_mature_time, plant.Cur_grow_rate,
             plant.EarthState, plant.Pollination, plant.Can_thief]
        );
    } catch (e) {
        Logger.log("ERROR", `[HomeController] savePlantToDB: ${e.message}`);
    }
}

async function deletePlantFromDB(userID, plantID) {
    try {
        await pool.query("DELETE FROM home_plants WHERE user_id = ? AND plant_id = ?", [userID, plantID]);
    } catch (e) {
        Logger.log("ERROR", `[HomeController] deletePlantFromDB: ${e.message}`);
    }
}

// ─── Controller ───────────────────────────────────────────────────────────────
class HomeController {
    static isHomeDepotItemID(itemID) {
        return isHomeDepotItemID(itemID);
    }

    static async addDepotItem(userID, itemID, count = 1) {
        if (!isHomeDepotItemID(itemID) || count <= 0) {
            return false;
        }

        const state = await ensureHomeState(userID);
        const depotItem = state.depotItems.find(d => d.ID === itemID);
        if (depotItem) depotItem.Count += count;
        else state.depotItems.push({ ID: itemID, Count: count });

        state.depotItems = normalizeDepotItems(state.depotItems);
        await saveDepotToDB(userID, state.depotItems);
        return true;
    }

    // CMD 409 - GetRoomInfo (Xem trong nhà)
    static async handleGetRoomInfo(socket, userID, data) {
        Logger.log("ACTION", `[CMD 409] GetRoomInfo UserID=${userID}`);
        
        let targetUserID = userID;
        if (data && data.length >= 21) {
            targetUserID = data.readUInt32BE(17);
        }
        
        const UModel = require("../models/UserModel");
        const user = UModel.getUser(userID);
        if (user) user.socket = socket;
        const targetUser = UModel.getUser(targetUserID) || user;
        const nick = targetUser ? (targetUser.nick || "Home") : "Home";
        
        const state = await ensureHomeState(targetUserID);
        const roomBGItem = state.roomBGItem || { ...DEFAULT_ROOM_BG, ID: state.houseID || DEFAULT_ROOM_BG.ID };
        
        // Buffer: UserID(4)+Name(16)+Online(4) + HouseBGObj(16) + ItemCount(4) + roomItems * 16
        const bodySize = 44 + state.roomItems.length * 16;
        const body = Buffer.alloc(bodySize);
        let offset = 0;
        
        body.writeUInt32BE(targetUserID, offset); offset += 4;
        const nickBuf = Buffer.alloc(16, 0);
        nickBuf.write(nick, 0, "utf8");
        nickBuf.copy(body, offset); offset += 16;
        body.writeUInt32BE(1, offset); offset += 4; // Online
        
        // HouseBGObj (16 bytes)
        body.writeUInt32BE(roomBGItem.ID, offset); offset += 4;
        body.writeInt16BE(roomBGItem.PosX || 450, offset); offset += 2;
        body.writeInt16BE(roomBGItem.PosY || 200, offset); offset += 2;
        body.writeUInt8(roomBGItem.Direction || 1, offset++);
        body.writeUInt8(roomBGItem.Visible !== undefined ? roomBGItem.Visible : 1, offset++);
        body.writeUInt8(roomBGItem.Layer !== undefined ? roomBGItem.Layer : 6, offset++);
        body.writeUInt8(roomBGItem.Type !== undefined ? roomBGItem.Type : 3, offset++);
        body.writeUInt8(roomBGItem.Rotation || 0, offset++);
        body.write("\x00\x00\x00", offset, 3, "binary"); offset += 3; // Reserved
        
        // Items
        body.writeUInt32BE(state.roomItems.length, offset); offset += 4;
        
        for (const item of state.roomItems) {
            body.writeUInt32BE(item.ID, offset); offset += 4;
            body.writeInt16BE(item.PosX || 0, offset); offset += 2;
            body.writeInt16BE(item.PosY || 0, offset); offset += 2;
            body.writeUInt8(item.Direction || 0, offset++);
            body.writeUInt8(item.Visible !== undefined ? item.Visible : 1, offset++);
            body.writeUInt8(item.Layer !== undefined ? item.Layer : 4, offset++);
            body.writeUInt8(item.Type || 0, offset++);
            body.writeUInt8(item.Rotation || 0, offset++);
            body.write("\x00\x00\x00", offset, 3, "binary"); offset += 3; // Reserved
        }
        
        const head = PacketBuilder.makeHead(409, userID, 0, offset);
        socket.write(head);
        socket.write(body.slice(0, offset));
        Logger.log("RESPONSE", `[CMD 409] target=${targetUserID}, roomItems=${state.roomItems.length}`);
    }

    // CMD 1301 - GetHomeInfo
    static async handleGetHomeInfo(socket, userID, data) {
        Logger.log("ACTION", `[CMD 1301] GetHomeInfo UserID=${userID}`);
        let targetUserID = userID;
        if (data && data.length >= 21) targetUserID = data.readUInt32BE(17);

        const UModel = require("../models/UserModel");
        const user = UModel.getUser(userID);
        if (user) user.socket = socket;
        const targetUser = UModel.getUser(targetUserID) || user;
        const nick = targetUser ? (targetUser.nick || "Home") : "Home";

        const state = await ensureHomeState(targetUserID);
        const allItems = [
            // The first item is the outdoor terrain/home background descriptor.
            // Keep Layer=0 so the client does not treat it like a normal placed item.
            { ID: state.terrainID, PosX: state.houseX, PosY: state.houseY, Direction: state.houseDir, Visible: 1, Layer: 0, Type: 0, Other: 0 },
            ...state.usedItems,
        ];

        const bodySize = 36 + allItems.length * 16 + state.plants.length * 56;
        const body = Buffer.alloc(bodySize);
        let offset = 0;

        body.writeUInt32BE(targetUserID, offset); offset += 4;
        const nickBuf = Buffer.alloc(16, 0);
        nickBuf.write(nick, 0, "utf8");
        nickBuf.copy(body, offset); offset += 16;
        body.writeUInt32BE(1, offset); offset += 4;
        body.writeUInt32BE(state.houseID, offset); offset += 4;
        body.writeUInt32BE(allItems.length, offset); offset += 4;
        body.writeUInt32BE(state.plants.length, offset); offset += 4;

        for (const item of allItems) offset = writeHomeItem(body, offset, item);
        for (const plant of state.plants) offset = writePlant(body, offset, plant);

        const head = PacketBuilder.makeHead(1301, userID, 0, offset);
        socket.write(head);
        socket.write(body.slice(0, offset));
        Logger.log("RESPONSE", `[CMD 1301] items=${allItems.length}, plants=${state.plants.length}`);
    }

    // CMD 1302 - SaveHomeInfo (lưu bố cục sân/nhà)
    // Client gửi: usedCount(4) + nousedCount(4) + nousd[ID(4)+Count(4)]×n + used[16bytes]×m
    static async handleSaveHomeInfo(socket, userID, data) {
        Logger.log("ACTION", `[CMD 1302] SaveHomeInfo UserID=${userID}`);
        const state = await ensureHomeState(userID);

        try {
            let off = 17;
            if (off + 8 <= data.length) {
                const usedCount   = data.readUInt32BE(off); off += 4;
                const nousedCount = data.readUInt32BE(off); off += 4;

                // `noused` là snapshot đầy đủ của kho đồ hiện tại, không phải delta.
                // Nếu cứ cộng dồn vào cache cũ thì số lượng sẽ phình ra sau mỗi lần lưu.
                const nextDepotItems = [];
                for (let i = 0; i < nousedCount && off + 8 <= data.length; i++) {
                    const id = data.readUInt32BE(off); off += 4;
                    const cnt = data.readUInt32BE(off); off += 4;
                    nextDepotItems.push({ ID: id, Count: cnt });
                }

                // Đồ đang đặt
                const newUsed = [];
                for (let i = 0; i < usedCount && off + 16 <= data.length; i++) {
                    newUsed.push({
                        ID: data.readUInt32BE(off),
                        PosX: data.readInt16BE(off + 4),
                        PosY: data.readInt16BE(off + 6),
                        Direction: data.readUInt8(off + 8),
                        Visible: data.readUInt8(off + 9),
                        Layer: data.readUInt8(off + 10),
                        Type: data.readUInt8(off + 11),
                        Other: data.readUInt32BE(off + 12),
                    });
                    off += 16;
                }

                // Lọc nền sân (terrain BG) - nó luôn nằm ở phần tử đầu tiên
                if (newUsed.length > 0 && isTerrainBackgroundID(newUsed[0].ID)) {
                    const bgItem = newUsed.shift();
                    let changed = false;
                    if (bgItem.ID !== state.terrainID) {
                        state.terrainID = bgItem.ID; changed = true;
                    }
                    if (bgItem.PosX !== state.houseX || bgItem.PosY !== state.houseY || bgItem.Direction !== state.houseDir) {
                        state.houseX = bgItem.PosX;
                        state.houseY = bgItem.PosY;
                        state.houseDir = bgItem.Direction;
                        changed = true;
                    }
                    if (changed) {
                        saveHomeStateToDB(userID, state);
                        Logger.log("DEBUG", `[CMD 1302] Cập nhật nền sân/nhà (ID=${state.terrainID}, X=${state.houseX}, Y=${state.houseY})`);
                    }
                }

                state.depotItems = normalizeDepotItems(nextDepotItems);
                state.usedItems = newUsed;

                // Lưu DB async (không chặn response)
                saveUsedItemsToDB(userID, newUsed);
                saveDepotToDB(userID, state.depotItems);
                Logger.log("DEBUG", `[CMD 1302] Lưu ${newUsed.length} items đặt, ${state.depotItems.length} loại đồ trong kho`);
            }
        } catch (e) {
            Logger.log("ERROR", `[CMD 1302] ${e.message}`);
        }

        socket.write(PacketBuilder.makeHead(1302, userID, 0, 0));
    }

    // CMD 1303 - GetHomeDepotInfo (kho đồ)
    static async handleGetHomeDepotInfo(socket, userID, data) {
        Logger.log("ACTION", `[CMD 1303] GetHomeDepotInfo UserID=${userID}`);
        const state = await ensureHomeState(userID);
        const items = state.depotItems.filter(d => d.Count > 0);

        const body = Buffer.alloc(4 + items.length * 8);
        let offset = 0;
        body.writeUInt32BE(items.length, offset); offset += 4;
        for (const item of items) {
            body.writeUInt32BE(item.ID, offset); offset += 4;
            body.writeUInt32BE(item.Count, offset); offset += 4;
        }
        const head = PacketBuilder.makeHead(1303, userID, 0, offset);
        socket.write(head);
        socket.write(body.slice(0, offset));
        Logger.log("RESPONSE", `[CMD 1303] ${items.length} loại đồ trong kho`);
    }

    // CMD 1312 - SaveHomeUsed
    static async handleSaveHomeUsed(socket, userID, data) {
        Logger.log("ACTION", `[CMD 1312] SaveHomeUsed UserID=${userID}`);
        const state = await ensureHomeState(userID);
        try {
            if (data.length > 21) {
                let off = 17;
                const count = data.readUInt32BE(off); off += 4;
                const items = [];
                for (let i = 0; i < count && off + 16 <= data.length; i++) {
                    items.push({
                        ID: data.readUInt32BE(off),
                        PosX: data.readInt16BE(off + 4),
                        PosY: data.readInt16BE(off + 6),
                        Direction: data.readUInt8(off + 8),
                        Visible: data.readUInt8(off + 9),
                        Layer: data.readUInt8(off + 10),
                        Type: data.readUInt8(off + 11),
                        Other: data.readUInt32BE(off + 12),
                    });
                    off += 16;
                }

                // Lọc nền sân (terrain BG)
                if (items.length > 0 && isTerrainBackgroundID(items[0].ID)) {
                    const bgItem = items.shift();
                    let changed = false;
                    if (bgItem.ID !== state.terrainID) {
                        state.terrainID = bgItem.ID; changed = true;
                    }
                    if (bgItem.PosX !== state.houseX || bgItem.PosY !== state.houseY || bgItem.Direction !== state.houseDir) {
                        state.houseX = bgItem.PosX;
                        state.houseY = bgItem.PosY;
                        state.houseDir = bgItem.Direction;
                        changed = true;
                    }
                    if (changed) {
                        saveHomeStateToDB(userID, state);
                        Logger.log("DEBUG", `[CMD 1312] Cập nhật nền sân/nhà`);
                    }
                }

                state.usedItems = items;
                saveUsedItemsToDB(userID, items);
            }
        } catch (e) {
            Logger.log("ERROR", `[CMD 1312] ${e.message}`);
        }
        socket.write(PacketBuilder.makeHead(1312, userID, 0, 0));
    }

    // CMD 415 - SaveRoomBG (thay đổi nền sân hoặc ngôi nhà)
    static async handleSaveRoomBG(socket, userID, data) {
        Logger.log("ACTION", `[CMD 415] SaveRoomBG UserID=${userID}`);
        const state = await ensureHomeState(userID);
        try {
            if (data.length >= 21) {
                const newID = data.readUInt32BE(17);
                state.roomBGItem = {
                    ID: newID,
                    PosX: data.length >= 25 ? data.readInt16BE(21) : (state.roomBGItem?.PosX || DEFAULT_ROOM_BG.PosX),
                    PosY: data.length >= 27 ? data.readInt16BE(23) : (state.roomBGItem?.PosY || DEFAULT_ROOM_BG.PosY),
                    Direction: data.length >= 28 ? data.readUInt8(25) : (state.roomBGItem?.Direction || DEFAULT_ROOM_BG.Direction),
                    Visible: data.length >= 29 ? data.readUInt8(26) : (state.roomBGItem?.Visible ?? DEFAULT_ROOM_BG.Visible),
                    Layer: data.length >= 30 ? data.readUInt8(27) : 6,
                    Type: data.length >= 31 ? data.readUInt8(28) : 3,
                    Rotation: data.length >= 35 ? data.readUInt32BE(29) & 0xFF : (state.roomBGItem?.Rotation || 0),
                };
                saveRoomItemsToDB(userID, state.roomItems, state.roomBGItem);
                Logger.log("DEBUG", `[CMD 415] Lưu nền trong nhà -> ${newID}`);
            }
        } catch (e) {
            Logger.log("ERROR", `[CMD 415] ${e.message}`);
        }
        const body = Buffer.alloc(4);
        body.writeUInt32BE(0, 0); // itemCount = 0
        socket.write(PacketBuilder.makeHead(415, userID, 0, body.length));
        socket.write(body);
    }

    // CMD 410 - SaveRoomItem
    // Client gửi: maptype(4) + usedCount(4) + items[ID(4)+PosX(2)+PosY(2)+Dir(1)+Vis(1)+Layer(1)+Type(1)+Rot(1)+Res(3)]
    static async handleSaveRoomItem(socket, userID, data) {
        Logger.log("ACTION", `[CMD 410] SaveRoomItem UserID=${userID}`);
        const state = await ensureHomeState(userID);
        try {
            let off = 17;
            if (off + 8 <= data.length) {
                const maptype = data.readUInt32BE(off); off += 4;
                const usedCount = data.readUInt32BE(off); off += 4;
                
                const newRoomItems = [];
                for (let i = 0; i < usedCount && off + 16 <= data.length; i++) {
                    newRoomItems.push({
                        ID: data.readUInt32BE(off),
                        PosX: data.readInt16BE(off + 4),
                        PosY: data.readInt16BE(off + 6),
                        Direction: data.readUInt8(off + 8),
                        Visible: data.readUInt8(off + 9),
                        Layer: data.readUInt8(off + 10),
                        Type: data.readUInt8(off + 11),
                        Rotation: data.readUInt8(off + 12)
                    });
                    off += 16;
                }

                // Trả đồ cũ về kho
                for (const item of state.roomItems) {
                    const dep = state.depotItems.find(d => d.ID === item.ID);
                    if (dep) dep.Count++;
                    else state.depotItems.push({ ID: item.ID, Count: 1 });
                }
                
                // Lấy đồ mới ra từ kho
                for (const item of newRoomItems) {
                    const dep = state.depotItems.find(d => d.ID === item.ID);
                    if (dep && dep.Count > 0) dep.Count--;
                }
                
                state.roomItems = newRoomItems;
                saveRoomItemsToDB(userID, newRoomItems, state.roomBGItem);
                saveDepotToDB(userID, state.depotItems);
                Logger.log("DEBUG", `[CMD 410] Đã lưu ${newRoomItems.length} items trong nhà.`);
            }
        } catch (e) {
            Logger.log("ERROR", `[CMD 410] ${e.message}`);
        }
        socket.write(PacketBuilder.makeHead(410, userID, 0, 0));
    }

    // CMD 1304 - PlantingSeed (trồng cây)
    static async handlePlantingSeed(socket, userID, data) {
        Logger.log("ACTION", `[CMD 1304] PlantingSeed UserID=${userID}`);
        const state = await ensureHomeState(userID);

        let seedID = 1000001, posX = 0, posY = 0;
        try {
            if (data.length >= 27) {
                seedID = data.readUInt32BE(17);
                posX   = data.readInt16BE(21);
                posY   = data.readInt16BE(23);
            }
        } catch (e) {}

        const plant = {
            PlantID: state.plantCounter++,
            ID: seedID, PosX: posX, PosY: posY,
            Growth: 1, SickFlag: 0, FruitNum: 0, Fruit_status: 0,
            Mature_time: 7200, Diff_mature_time: 7200, Cur_grow_rate: 100,
            EarthState: 0, Pollination: 0, Can_thief: 0,
        };
        state.plants.push(plant);
        await savePlantToDB(userID, plant);

        const body = Buffer.alloc(56);
        const offset = writePlant(body, 0, plant);
        socket.write(PacketBuilder.makeHead(1304, userID, 0, offset));
        socket.write(body.slice(0, offset));
        Logger.log("RESPONSE", `[CMD 1304] Trồng ID=${seedID} tại (${posX},${posY}), PlantID=${plant.PlantID}`);
    }

    // CMD 1305 - DeleteSeed (nhổ cây)
    static async handleDeleteSeed(socket, userID, data) {
        Logger.log("ACTION", `[CMD 1305] DeleteSeed UserID=${userID}`);
        const state = await ensureHomeState(userID);

        let plantID = 0;
        try { if (data.length >= 21) plantID = data.readUInt32BE(17); } catch (e) {}

        state.plants = state.plants.filter(p => p.PlantID !== plantID);
        await deletePlantFromDB(userID, plantID);

        const body = Buffer.alloc(8);
        body.writeUInt32BE(plantID, 0);
        body.writeUInt32BE(0, 4);
        socket.write(PacketBuilder.makeHead(1305, userID, 0, 8));
        socket.write(body);
    }

    // CMD 1306 - IrrigateWater (tưới nước)
    static async handleIrrigateWater(socket, userID, data) {
        Logger.log("ACTION", `[CMD 1306] IrrigateWater UserID=${userID}`);
        const state = await ensureHomeState(userID);

        let plantID = 0;
        try { if (data.length >= 21) plantID = data.readUInt32BE(17); } catch (e) {}

        const plant = state.plants.find(p => p.PlantID === plantID);
        if (plant) {
            plant.Growth = Math.min(plant.Growth + 1, 5);
            plant.EarthState = 1;
            await savePlantToDB(userID, plant);
        }

        const p = plant || { PlantID: plantID, ID: 1000001, PosX: 0, PosY: 0, Growth: 1, SickFlag: 0, FruitNum: 0, Fruit_status: 0, Mature_time: 7200, Diff_mature_time: 7200, Cur_grow_rate: 100, EarthState: 1, Pollination: 0, Can_thief: 0 };
        const body = Buffer.alloc(56);
        const offset = writePlant(body, 0, p);
        socket.write(PacketBuilder.makeHead(1306, userID, 0, offset));
        socket.write(body.slice(0, offset));
    }

    // CMD 1308 - UseInsecticide (xịt thuốc)
    static async handleUseInsecticide(socket, userID, data) {
        Logger.log("ACTION", `[CMD 1308] UseInsecticide UserID=${userID}`);
        const state = await ensureHomeState(userID);

        let plantID = 0;
        try { if (data.length >= 21) plantID = data.readUInt32BE(17); } catch (e) {}

        const plant = state.plants.find(p => p.PlantID === plantID);
        if (plant) { plant.SickFlag = 0; await savePlantToDB(userID, plant); }

        const p = plant || { PlantID: plantID, ID: 1000001, PosX: 0, PosY: 0, Growth: 1, SickFlag: 0, FruitNum: 0, Fruit_status: 0, Mature_time: 7200, Diff_mature_time: 7200, Cur_grow_rate: 100, EarthState: 0, Pollination: 0, Can_thief: 0 };
        const body = Buffer.alloc(56);
        const offset = writePlant(body, 0, p);
        socket.write(PacketBuilder.makeHead(1308, userID, 0, offset));
        socket.write(body.slice(0, offset));
    }

    // CMD 1309 - GainFruitage (thu hoạch)
    static async handleGainFruitage(socket, userID, data) {
        Logger.log("ACTION", `[CMD 1309] GainFruitage UserID=${userID}`);
        const state = await ensureHomeState(userID);

        let plantID = 0;
        try { if (data.length >= 21) plantID = data.readUInt32BE(17); } catch (e) {}

        const plant = state.plants.find(p => p.PlantID === plantID);
        const itemID  = plant ? plant.ID : 1000001;
        const fruitNum = plant ? Math.max(plant.FruitNum, 1) : 1;

        if (plant) {
            plant.FruitNum = 0;
            plant.Growth = 1;
            plant.Fruit_status = 0;
            await savePlantToDB(userID, plant);
        }

        const body = Buffer.alloc(12);
        body.writeUInt32BE(plantID, 0);
        body.writeUInt32BE(itemID, 4);
        body.writeUInt32BE(fruitNum, 8);
        socket.write(PacketBuilder.makeHead(1309, userID, 0, 12));
        socket.write(body);
        Logger.log("RESPONSE", `[CMD 1309] Thu hoạch PlantID=${plantID}, item=${itemID}×${fruitNum}`);
    }

    // CMD 1310 - GetSeedInfo (xem thông tin cây)
    static async handleGetSeedInfo(socket, userID, data) {
        Logger.log("ACTION", `[CMD 1310] GetSeedInfo UserID=${userID}`);
        const state = await ensureHomeState(userID);

        let plantID = 0;
        try { if (data.length >= 21) plantID = data.readUInt32BE(17); } catch (e) {}

        const plant = state.plants.find(p => p.PlantID === plantID);
        if (!plant) {
            socket.write(PacketBuilder.makeHead(1310, userID, 10001, 0));
            return;
        }

        const body = Buffer.alloc(56);
        const offset = writePlant(body, 0, plant);
        socket.write(PacketBuilder.makeHead(1310, userID, 0, offset));
        socket.write(body.slice(0, offset));
    }
}

module.exports = HomeController;
