const Logger = require("../core/Logger");
const PacketBuilder = require("../core/PacketBuilder");

class DummyController {
    static handleGeneric(socket, userID, cmdID, data) {
        Logger.log("ACTION", `Dummy handle for CmdID: ${cmdID}`);
        
        // Define hardcoded responses for dummy endpoints that used to be in tcp-server.js
        const dummyResponses = {
            609: Buffer.alloc(8, 0),       // handleBlacklist
            10101: Buffer.alloc(4, 0),     // handleIsFinishedSth
            10102: Buffer.alloc(4, 0),     // handleFinishedSth
            2008: Buffer.alloc(32, 0),     // handleCommitteePresidentVote
            10301: Buffer.alloc(4, 0),     // handleGetServerTime
            8817: Buffer.alloc(12, 0),     // handleGetMiniGameStep
            10302: Buffer.from("[C\x8BE435370a2b2f3c57c07f3564f792f1650", "utf8"), // handleRegistrationRedirectSession
            426: Buffer.from("12345678901234567890123456789012", "utf8"), // handleGetLoginSession (32 bytes)
            8920: Buffer.alloc(4, 0),      // handlePaymentPasswordRequirement
            8606: Buffer.alloc(4, 0),      // handleQueryRewardStatus
            8755: Buffer.alloc(4, 0),      // handleComeBackStatus
            8974: Buffer.alloc(4, 0),      // handleGetKnightTransferState8974
            8990: Buffer.alloc(8, 0),      // handleElementKnightInfo
            12018: Buffer.from("\x05\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01", "binary"), // handleMagicSpiritBagInfo
            11009: Buffer.alloc(8, 0),     // handleGetLimitInfo
            1328: Buffer.from("\x05\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01", "binary"), // handleGetMyProfession
            11010: Buffer.alloc(1, 0),     // handleInitPlayerEx
            3106: Buffer.from("\x00\x00\x00\x07\x00\x00\x00\x09\x00\x00\x00\x04\xFF\xFF\xFF\x38\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x07\xFF\xFF\xFF\x38\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x07\xFF\xFF\xFF\x38\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x18\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x19\x00\x00\x00\x08\xFF\xFF\xFF\x38\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x1A\x00\x00\x00\x08\xFF\xFF\xFF\x38\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x28\x00\x00\x00\x09\xFF\xFF\xFF\x38\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00", "binary"), // handleQueryNpcTasks
            240: Buffer.alloc(8, 0),       // queryHaveSuperLamu: UserID(4) + count(4)=0
            8302: Buffer.alloc(4, 0),      // unknown (4 bytes)
            1227: Buffer.alloc(4, 0),      // unknown (4 bytes)
            2032: Buffer.alloc(4, 0),      // handleSelectDou (4 bytes count)
            2040: Buffer.alloc(4, 0),      // handleAddScore (4 bytes count)
            1911: Buffer.alloc(16, 0),     // queryPlantAndFarm: plantLV+farmLV+plantLVNum+farmLVNum = 4x4
            216: Buffer.alloc(4, 0),       // handleSMCTaskList (4 bytes)
            228: Buffer.alloc(8, 0),       // handlePetTaskList (8 bytes)
            232: Buffer.from([1]),       // handleSuperLamuCheck (1 byte)
            233: Buffer.alloc(4, 0),       // handlePetCountInMap (4 bytes)
            1313: Buffer.from([0, 0, 0, 1]),       // handleUserExist (1 = true)
            1314: Buffer.alloc(4, 0),      // handleUserFlag (0 = door open)
            1456: Buffer.alloc(4, 0),      // handleGetFriendsHot (count=0)
        };
        
        let body = dummyResponses[cmdID];
        
        // Dynamic payload handlers based on tcp-server.js logic
        if ([10101, 10102, 8606, 8755, 11009, 10011].includes(cmdID) && data && data.length >= 21) {
            const type = data.readUInt32BE(17);
            if (cmdID === 10101 || cmdID === 8606) {
                body = Buffer.alloc(8);
                body.writeUInt32BE(type, 0);
                body.writeUInt32BE(0, 4); // 0 = Chưa Finished
            } else if (cmdID === 10102) {
                body = Buffer.alloc(8);
                body.writeUInt32BE(type, 0);
                body.writeUInt32BE(1, 4); // 1 = count > 0 (Nhận thành công)
            } else if (cmdID === 8755) {
                if (type === 2025) {
                    Logger.log("INFO", `Bỏ qua COME_BK_STATUS (Type: 2025)`);
                    return; // Return nothing
                }
                body = Buffer.alloc(12);
                body.writeUInt32BE(type, 0);
                body.writeUInt32BE(0, 4);
                body.writeUInt32BE(0, 8);
            } else if (cmdID === 11009) {
                const listSize = type; // listSize is at offset 17
                body = Buffer.alloc(4 + listSize * 4);
                body.writeUInt32BE(listSize, 0);
                for (let i = 0; i < listSize; i++) {
                    body.writeUInt32BE(5, 4 + i * 4);
                }
            } else if (cmdID === 10011) {
                body = Buffer.alloc(12);
                body.writeUInt32BE(type, 0);
                body.writeUInt32BE(8, 4);
                body.writeUInt32BE(2356, 8);
            }
        } else if (cmdID === 426) {
            body = Buffer.alloc(16);
            body.fill(0);
        } else if (cmdID === 9124) {
            body = Buffer.alloc(4, 0);
            body.writeUInt32BE(2, 0); // KNIGHT_TRANSFER_STATE value: 2
        } else if (cmdID === 2032 || cmdID === 2040) {
            body = Buffer.alloc(4, 0);
            body.writeUInt32BE(99999, 0); // 99999 Dou / Score
        } else if (cmdID === 805) {
            body = Buffer.alloc(4, 0); // Unread postcard count = 0
        } else if (cmdID === 8938) {
            // GET_LOVE_STAR: flag(4) + id(4). flag=1 means already received today
            body = Buffer.alloc(8);
            body.writeUInt32BE(1, 0); // flag = 1 (đã nhận)
            body.writeUInt32BE(0, 4); // id = 0
        } else if (cmdID === 1991) {
            // seedefendTime: ID(4) + Time(4) + PwaterCou(4) + IkillCou(4) + AwaterCou(4) + Acatch(4) = 24 bytes
            let defendID = 0;
            if (data && data.length >= 25) {
                defendID = data.readUInt32BE(21); // Đọc defend ID từ offset 21 (sau userID ở 17)
            }
            body = Buffer.alloc(24);
            body.writeUInt32BE(defendID, 0);  // ID (1320001 or 1320002)
            body.writeUInt32BE(0, 4);         // Time = 0 (không có năng lượng)
            body.writeUInt32BE(0, 8);         // PwaterCou = 0
            body.writeUInt32BE(0, 12);        // IkillCou = 0
            body.writeUInt32BE(0, 16);        // AwaterCou = 0
            body.writeUInt32BE(0, 20);        // Acatch = 0
        } else if (cmdID === 1915) {
            // examinePack: count(4) + [id(4) + count(4)]...
            // Đếm số item cần check từ data
            let itemCheckCount = 0;
            if (data && data.length >= 21) {
                itemCheckCount = data.readUInt32BE(17);
            }
            body = Buffer.alloc(4 + itemCheckCount * 8);
            body.writeUInt32BE(itemCheckCount, 0);
            for (let i = 0; i < itemCheckCount; i++) {
                let checkItemID = 0;
                if (data && data.length >= 25 + i * 4) {
                    checkItemID = data.readUInt32BE(21 + i * 4);
                }
                body.writeUInt32BE(checkItemID, 4 + i * 8); // itemID
                body.writeUInt32BE(0, 8 + i * 8);           // count = 0
            }
        } else if (cmdID === 11014) {
            body = Buffer.alloc(4);
            body.writeUInt32BE(0, 0); // Trả 0
        } else if (cmdID === 12004) {
            body = Buffer.alloc(4);
            body.writeUInt32BE(0, 0); // Trả 0
        } else if (!body) {
            Logger.log("WARNING", `Chưa cấu hình Body cho Dummy CmdID ${cmdID}, trả về rỗng để tránh kẹt stream.`);
            body = Buffer.alloc(0);
        }
        
        const head = PacketBuilder.makeHead(cmdID, userID, 0, body.length);
        socket.write(head);
        socket.write(body);
        Logger.log("RESPONSE", `Gửi Dummy Data cho CmdID: ${cmdID}`);
    }
}

module.exports = DummyController;
