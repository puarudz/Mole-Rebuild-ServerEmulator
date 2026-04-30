const Logger = require("../core/Logger");
const PacketBuilder = require("../core/PacketBuilder");
const UserModel = require("../models/UserModel");

const PET_STAGE_GROWTH_HOURS = [24, 24 * 30, 24 * 90];
const PET_STAGE_LEVELS = [1, 2, 3, 4];

class PetController {
    static clampPetStat(value) {
        return Math.max(0, Math.min(100, value));
    }

    static updateSuperPetState(pet) {
        pet.isSuper = !!pet.isSuper;
        return pet;
    }

    static recomputePetLevel(pet) {
        const totalHours = Math.floor((pet.value || 0) / 3600);
        let level = 1;
        if (totalHours >= PET_STAGE_GROWTH_HOURS[0]) level = 2;
        if (totalHours >= PET_STAGE_GROWTH_HOURS[1]) level = 3;
        if (totalHours >= PET_STAGE_GROWTH_HOURS[2]) level = 4;
        pet.level = level;
        pet.exp = totalHours;
        return pet;
    }

    static addPetGrowth(pet, deltaSeconds) {
        pet.value = Math.max(0, (pet.value || 0) + deltaSeconds);
        if (pet.birthday <= 0) {
            pet.birthday = Math.floor(Date.now() / 1000);
        }
        return this.recomputePetLevel(this.updateSuperPetState(pet));
    }

    static hasPet(pet) {
        return !!pet;
    }

    static isPetMature(pet) {
        return !!pet && (pet.level > 1 || (pet.value || 0) >= PET_STAGE_GROWTH_HOURS[0] * 3600);
    }

    static async isVipUser(userID) {
        const user = UserModel.getUser(userID) || await UserModel.fetchUserFromDB(userID);
        if (!user) return false;
        const vipFlags = user.vipFlags ?? user.vip_flags ?? 0;
        return (vipFlags & 1) === 1;
    }

    static applyPetCare(pet, itemID, delta = 12) {
        const group = itemID % 4;
        if (itemID === 0 || group === 0) pet.hungry = this.clampPetStat(pet.hungry + delta);
        if (itemID === 0 || group === 1) pet.thirsty = this.clampPetStat(pet.thirsty + delta);
        if (itemID === 0 || group === 2) pet.dirty = this.clampPetStat(pet.dirty + delta);
        if (itemID === 0 || group === 3) pet.spirit = this.clampPetStat(pet.spirit + delta);
        pet.flag = 0;
        pet.sickType = 0;
        return this.addPetGrowth(pet, 2 * 3600);
    }

    static syncUserPetState(userID, pet) {
        const user = UserModel.getUser(userID);
        if (!user) return;
        user.petID = pet.follow || pet.onMap ? pet.spriteID : 0;
        user.petNick = pet.nick;
        user.petColor = pet.color;
        user.petLevel = pet.level;
        user.petAction = pet.follow || pet.onMap ? 1 : 0;
        UserModel.setUser(userID, user);
    }

    static makePetInfoBody(ownerUserID, pets) {
        const parts = [];
        const writeUInt32 = (val) => { const b = Buffer.alloc(4); b.writeUInt32BE(val >>> 0, 0); parts.push(b); };
        const writeUInt8 = (val) => { const b = Buffer.alloc(1); b.writeUInt8(val & 0xFF, 0); parts.push(b); };
        const writeString16 = (text) => {
            const b = Buffer.alloc(16, 0);
            Buffer.from(text || "", "utf8").copy(b, 0, 0, 16);
            parts.push(b);
        };

        writeUInt32(ownerUserID);
        writeUInt32(pets.length);
        for (const pet of pets) {
            this.updateSuperPetState(pet);
            writeUInt32(pet.spriteID);
            writeUInt32(pet.flag);
            writeUInt32(pet.birthday);
            writeUInt32(pet.value);
            writeString16(pet.nick);
            writeUInt32(pet.color);
            writeUInt32(pet.sickTime);
            writeUInt8(pet.posX);
            writeUInt8(pet.posY);
            writeUInt8(pet.hungry);
            writeUInt8(pet.thirsty);
            writeUInt8(pet.dirty);
            writeUInt8(pet.spirit);
            writeUInt8(pet.level);
            writeUInt32(pet.skill);
            writeUInt32(pet.sickType);
            writeUInt32(pet.skillFire);
            writeUInt32(pet.skillWater);
            writeUInt32(pet.skillWood);
            writeUInt32(pet.skillType);
            writeUInt32(pet.skillValue);
            writeUInt8(pet.item1);
            writeUInt8(pet.item2);
            writeUInt8(pet.item3);
            writeUInt32(pet.cloth);
            writeUInt32(pet.honor);
        }
        return Buffer.concat(parts);
    }

    static makePetLevelUpBody(level) {
        const body = Buffer.alloc(4);
        body.writeUInt32BE(level >>> 0, 0);
        return body;
    }

    static makePetFollowBody(pet) {
        const parts = [];
        const writeUInt32 = (val) => { const b = Buffer.alloc(4); b.writeUInt32BE(val >>> 0, 0); parts.push(b); };
        const writeUInt8 = (val) => { const b = Buffer.alloc(1); b.writeUInt8(val & 0xFF, 0); parts.push(b); };
        const nick = Buffer.alloc(16, 0);
        Buffer.from(pet.nick || "", "utf8").copy(nick, 0, 0, 16);

        writeUInt32(pet.userID);
        writeUInt32(pet.spriteID);
        parts.push(nick);
        writeUInt32(pet.color);
        writeUInt32(pet.follow ? 1 : 0);
        writeUInt8(pet.hungry);
        writeUInt8(pet.thirsty);
        writeUInt8(pet.dirty);
        writeUInt8(pet.spirit);
        writeUInt8(pet.level);
        writeUInt32(pet.skill);
        writeUInt32(pet.skillFire);
        writeUInt32(pet.skillWater);
        writeUInt32(pet.skillWood);
        writeUInt32(pet.skillType);
        writeUInt32(pet.skillValue);
        writeUInt8(pet.item1);
        writeUInt8(pet.item2);
        writeUInt8(pet.item3);
        writeUInt32(pet.cloth);
        writeUInt32(pet.honor);
        return Buffer.concat(parts);
    }

    static async ensurePet(userID) {
        const pet = await UserModel.loadUserPet(userID);
        if (!pet) {
            this.syncUserPetState(userID, {
                spriteID: 0,
                nick: "",
                color: 0,
                level: 0,
                follow: false,
                onMap: false
            });
            return null;
        }
        this.recomputePetLevel(pet);
        this.updateSuperPetState(pet);
        this.syncUserPetState(userID, pet);
        return pet;
    }

    static async persistPet(userID) {
        await UserModel.saveUserPetToDB(userID);
    }

    static async handleAdoptPet(socket, userID) {
        Logger.log("ACTION", `Nhận Lamu (UserID: ${userID})`);
        let pet = await this.ensurePet(userID);
        if (!pet) {
            pet = UserModel.createUserPet(userID);
            this.recomputePetLevel(pet);
        }
        pet.birthday = Math.floor(Date.now() / 1000);
        pet.value = 0;
        pet.level = 1;
        pet.isSuper = false;
        pet.follow = false;
        pet.onMap = false;
        pet.exp = 0;
        this.syncUserPetState(userID, pet);
        await this.persistPet(userID);
        const body = Buffer.alloc(4);
        body.writeUInt32BE(pet.spriteID, 0);
        socket.write(PacketBuilder.makeHead(211, userID, 0, body.length));
        socket.write(body);
    }

    static async handlePetInfo(socket, userID, data) {
        Logger.log("ACTION", `Lấy thông tin Lamu (UserID: ${userID})`);
        const requestedPetID = data && data.length >= 25 ? data.readUInt32BE(21) : 0;
        const pet = await this.ensurePet(userID);
        const pets = pet && (!requestedPetID || requestedPetID === pet.spriteID) ? [pet] : [];
        const body = this.makePetInfoBody(userID, pets);
        socket.write(PacketBuilder.makeHead(212, userID, 0, body.length));
        socket.write(body);
    }

    static async handlePetNum(socket, userID) {
        Logger.log("ACTION", `Lấy số lượng Lamu (UserID: ${userID})`);
        const pet = await this.ensurePet(userID);
        const body = Buffer.from([pet ? 1 : 0]);
        socket.write(PacketBuilder.makeHead(214, userID, 0, body.length));
        socket.write(body);
    }

    static async handlePetFollow(socket, userID, data) {
        Logger.log("ACTION", `Đổi trạng thái theo của Lamu (UserID: ${userID})`);
        const pet = await this.ensurePet(userID);
        if (!pet) {
            socket.write(PacketBuilder.makeHead(215, userID, 1, 0));
            return;
        }
        if (data && data.length >= 25) {
            const nextFollow = data.readUInt32BE(21) === 1;
            pet.follow = nextFollow && this.isPetMature(pet);
            pet.onMap = pet.follow;
        }
        this.syncUserPetState(userID, pet);
        await this.persistPet(userID);
        const body = this.makePetFollowBody(pet);
        socket.write(PacketBuilder.makeHead(215, userID, 0, body.length));
        socket.write(body);
    }

    static async handlePetNick(socket, userID, data) {
        Logger.log("ACTION", `Đổi tên Lamu (UserID: ${userID})`);
        const pet = await this.ensurePet(userID);
        if (!pet) {
            socket.write(PacketBuilder.makeHead(218, userID, 1, 0));
            return;
        }
        if (data && data.length > 21) {
            pet.nick = data.toString("utf8", 21).replace(/\0/g, "").trim() || pet.nick;
        }
        this.syncUserPetState(userID, pet);
        await this.persistPet(userID);
        socket.write(PacketBuilder.makeHead(218, userID, 0, 0));
    }

    static async handlePetPlay(socket, userID, data) {
        Logger.log("ACTION", `Chơi / huấn luyện Lamu (UserID: ${userID})`);
        const pet = await this.ensurePet(userID);
        if (!pet) {
            socket.write(PacketBuilder.makeHead(219, userID, 1, 0));
            return;
        }
        const action = data && data.length >= 25 ? data.readUInt32BE(21) : 0;
        pet.spirit = this.clampPetStat(pet.spirit + 10);
        pet.hungry = this.clampPetStat(pet.hungry - 2);
        pet.thirsty = this.clampPetStat(pet.thirsty - 1);
        this.addPetGrowth(pet, 3 * 3600);
        this.syncUserPetState(userID, pet);
        await this.persistPet(userID);

        const body = Buffer.alloc(24, 0);
        body.writeUInt32BE(userID, 0);
        body.writeUInt32BE(pet.spriteID, 4);
        body.writeUInt32BE(action, 8);
        body.writeUInt8(pet.hungry, 12);
        body.writeUInt8(pet.thirsty, 13);
        body.writeUInt8(pet.dirty, 14);
        body.writeUInt8(pet.spirit, 15);
        socket.write(PacketBuilder.makeHead(219, userID, 0, body.length));
        socket.write(body);
    }

    static async handlePetPos(socket, userID, data) {
        Logger.log("ACTION", `Lưu vị trí Lamu (UserID: ${userID})`);
        const pet = await this.ensurePet(userID);
        if (!pet) {
            socket.write(PacketBuilder.makeHead(220, userID, 1, 0));
            return;
        }
        if (data && data.length >= 26) {
            pet.posX = data.readUInt8(21);
            pet.posY = data.readUInt8(22);
        }
        await this.persistPet(userID);
        socket.write(PacketBuilder.makeHead(220, userID, 0, 0));
    }

    static async handleSuperLamuCheck(socket, userID) {
        Logger.log("ACTION", `Kiểm tra Super Lamu (UserID: ${userID})`);
        const pet = await this.ensurePet(userID);
        const body = Buffer.from([pet && pet.isSuper ? 1 : 0]);
        socket.write(PacketBuilder.makeHead(232, userID, 0, body.length));
        socket.write(body);
    }

    static async handlePetCountInMap(socket, userID) {
        Logger.log("ACTION", `Lấy số Lamu trên map (UserID: ${userID})`);
        const count = UserModel.getAllPets().filter((pet) => pet.onMap).length;
        const body = Buffer.alloc(4);
        body.writeUInt32BE(count, 0);
        socket.write(PacketBuilder.makeHead(233, userID, 0, body.length));
        socket.write(body);
    }

    static async handlePetFollowOut(socket, userID, data) {
        Logger.log("ACTION", `Đưa Lamu ra map/nhà (UserID: ${userID})`);
        const pet = await this.ensurePet(userID);
        if (!pet) {
            socket.write(PacketBuilder.makeHead(235, userID, 1, 0));
            return;
        }
        if (data && data.length >= 25) {
            pet.onMap = data.readUInt32BE(21) !== 0 && this.isPetMature(pet);
        } else {
            pet.onMap = this.isPetMature(pet);
        }
        pet.follow = pet.onMap;
        this.syncUserPetState(userID, pet);
        await this.persistPet(userID);
        const body = this.makePetFollowBody(pet);
        socket.write(PacketBuilder.makeHead(235, userID, 0, body.length));
        socket.write(body);
    }

    static async handlePetTool(socket, userID, data) {
        Logger.log("ACTION", `Chăm sóc Lamu bằng đạo cụ (UserID: ${userID})`);
        const pet = await this.ensurePet(userID);
        if (!pet) {
            socket.write(PacketBuilder.makeHead(237, userID, 1, 0));
            return;
        }
        const itemID = data && data.length >= 25 ? data.readUInt32BE(21) : 0;
        this.applyPetCare(pet, itemID);
        this.syncUserPetState(userID, pet);
        await this.persistPet(userID);
        const body = this.makePetInfoBody(userID, [pet]);
        socket.write(PacketBuilder.makeHead(237, userID, 0, body.length));
        socket.write(body);
    }

    static async handlePetShopPlay(socket, userID) {
        Logger.log("ACTION", `PET_SHOP_PLAY (UserID: ${userID})`);
        const pet = await this.ensurePet(userID);
        if (!pet) {
            socket.write(PacketBuilder.makeHead(1114, userID, 1, 0));
            return;
        }
        pet.spirit = this.clampPetStat(pet.spirit + 6);
        pet.hungry = this.clampPetStat(pet.hungry - 1);
        this.addPetGrowth(pet, 2 * 3600);
        this.syncUserPetState(userID, pet);
        await this.persistPet(userID);
        const body = Buffer.alloc(8);
        body.writeUInt32BE(pet.spriteID, 0);
        body.writeUInt32BE(pet.level, 4);
        socket.write(PacketBuilder.makeHead(1114, userID, 0, body.length));
        socket.write(body);
    }

    static async handlePetLevelUp(socket, userID, data) {
        Logger.log("ACTION", `Thăng cấp / tiến hóa Lamu (UserID: ${userID})`);
        const pet = await this.ensurePet(userID);
        if (!pet) {
            socket.write(PacketBuilder.makeHead(1126, userID, 1, 0));
            return;
        }

        const itemID = data && data.length >= 25 ? data.readUInt32BE(21) : 0;
        const beforeLevel = pet.level;
        const vipUser = await this.isVipUser(userID);

        if (itemID > 0) {
            this.addPetGrowth(pet, 24 * 3600);
        } else {
            this.recomputePetLevel(pet);
        }

        if (pet.level >= 4 && vipUser) {
            pet.isSuper = true;
        }

        this.syncUserPetState(userID, pet);
        await this.persistPet(userID);

        Logger.log("INFO", `Lamu level update UserID=${userID}, item=${itemID}, level ${beforeLevel} -> ${pet.level}, super=${pet.isSuper ? 1 : 0}`);
        const body = this.makePetLevelUpBody(pet.level);
        socket.write(PacketBuilder.makeHead(1126, userID, 0, body.length));
        socket.write(body);
    }
}

module.exports = PetController;