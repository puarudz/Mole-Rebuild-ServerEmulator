const Logger = require("../core/Logger");
const PacketBuilder = require("../core/PacketBuilder");

// Build task list for CMD 216 (handleSMCTaskList)
// Protocol: 4 bytes taskCount (uint32 BE) + taskCount bytes (uint8 state per task, indexed by task ID)
// Client code checks if(task.id < 2000) when iterating task list, so we need at least 2000 entries
const MAX_TASK_ID = 2000;
function buildSMCTaskList() {
    const taskCount = MAX_TASK_ID + 1; // indices 0..2000
    const buf = Buffer.alloc(4 + taskCount);
    buf.writeUInt32BE(taskCount, 0);
    // All tasks default to state 0 (NO_OPEN)
    buf.fill(0, 4);
    // Task 382 (新手引導): state 2 = FINISH → prevents null ref in petmapView.chartTask382()
    buf[4 + 382] = 2;
    // Task 636 (checked by switchMapLogic)
    buf[4 + 636] = 2;
    // Task 221 (checked by JobLogic)
    buf[4 + 221] = 2;
    return buf;
}
const SMCTaskListBuffer = buildSMCTaskList();

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
            3106: Buffer.alloc(4, 0),      // handleQueryNpcTasks: count=0
            240: Buffer.alloc(8, 0),       // queryHaveSuperLamu: UserID(4) + count(4)=0
            8302: Buffer.alloc(4, 0),      // unknown (4 bytes)
            1227: Buffer.alloc(4, 0),      // unknown (4 bytes)
            2032: Buffer.alloc(4, 0),      // handleSelectDou (4 bytes count)
            2040: Buffer.alloc(4, 0),      // handleAddScore (4 bytes count)
            1911: Buffer.alloc(16, 0),     // queryPlantAndFarm: plantLV+farmLV+plantLVNum+farmLVNum = 4x4
            216: SMCTaskListBuffer,        // handleSMCTaskList: 2001 task states, all NO_OPEN except known tasks set to FINISH
            217: Buffer.alloc(8, 0),       // handleTaskStateChange (taskID + newState)
            228: Buffer.alloc(8, 0),       // handlePetTaskList (8 bytes)
            232: Buffer.from([1]),       // handleSuperLamuCheck (1 byte)
            233: Buffer.alloc(4, 0),       // handlePetCountInMap (4 bytes)
            244: Buffer.alloc(13, 0),      // handleTaskBuffer: taskID(4) + stepID(1) + panelID(4) + stateBit(4) = 13 bytes
            245: Buffer.alloc(4, 0),       // handleTaskBufferSet (ack)
            246: Buffer.alloc(4, 0),       // handleTaskBufferRemove (ack)
            1313: Buffer.from([0, 0, 0, 1]),       // handleUserExist (1 = true)
            1314: Buffer.alloc(4, 0),      // handleUserFlag (0 = door open)
            1456: Buffer.alloc(4, 0),      // handleGetFriendsHot (count=0)
            10303: Buffer.alloc(8, 0),     // VIP_SPARE_TIME: DaysLeft(4) + flag(4)
        };
        
        let body = dummyResponses[cmdID];
        
        // Dynamic payload handlers based on tcp-server.js logic
        if (cmdID === 10303) {
            // VIP_SPARE_TIME: Trả về số ngày VIP còn lại
            const UserModel = require("../models/UserModel");
            const user = UserModel.getUser(userID);
            const vipEndTime = user?.vipEndTime || user?.vip_end_time || 2145916800;
            const now = Math.floor(Date.now() / 1000);
            const daysLeft = Math.max(0, Math.floor((vipEndTime - now) / 86400));
            body = Buffer.alloc(8);
            body.writeUInt32BE(daysLeft, 0);   // DaysLeft
            body.writeUInt32BE(1, 4);           // flag = 1 (VIP đang hoạt động)
        } else if ([10101, 10102, 8606, 8755, 11009, 10011].includes(cmdID) && data && data.length >= 21) {
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
        } else if (cmdID === 3101 || cmdID === 3105) {
            // acceptNpcJob (3101) / askNpcJob (3105): Trả về job data
            let jobID = 0;
            if (data && data.length >= 21) jobID = data.readUInt32BE(17);
            body = Buffer.alloc(32);
            body.writeUInt32BE(jobID, 0);       // jobID
            body.writeUInt32BE(4, 4);           // npcID (default 4)
            body.writeUInt32BE(0xFFFFFF38, 8);  // attitudeValue (-200)
            body.writeUInt32BE(0, 12);          // isVip
            body.writeUInt32BE(1, 16);          // jobType
            body.writeUInt32BE(1, 20);          // maxJobNum
            body.writeUInt32BE(1, 24);          // jobStatus (1 = đang làm)
            body.writeUInt32BE(1, 28);          // jobNum
            Logger.log("RESPONSE", `NPC Job data cho jobID: ${jobID}`);
        } else if (cmdID === 3102) {
            // overNpcJob: Trả về job data + item count (0 items)
            let jobID = 0;
            if (data && data.length >= 21) jobID = data.readUInt32BE(17);
            body = Buffer.alloc(36); // 32 + 4
            body.writeUInt32BE(jobID, 0);
            body.writeUInt32BE(4, 4);
            body.writeUInt32BE(0xFFFFFF38, 8);
            body.writeUInt32BE(0, 12);
            body.writeUInt32BE(1, 16);
            body.writeUInt32BE(1, 20);
            body.writeUInt32BE(2, 24);          // jobStatus = 2 (đã hoàn thành)
            body.writeUInt32BE(1, 28);
            body.writeUInt32BE(0, 32);          // itemCount = 0
            Logger.log("RESPONSE", `NPC Over Job cho jobID: ${jobID}`);
        } else if (cmdID === 3107) {
            // giveupNpcJob: Trả về jobID
            let jobID = 0;
            if (data && data.length >= 21) jobID = data.readUInt32BE(17);
            body = Buffer.alloc(4);
            body.writeUInt32BE(jobID, 0);
            Logger.log("RESPONSE", `NPC Giveup Job: ${jobID}`);
        } else if (cmdID === 919) {
            // architectInfo: ser(4) + exp(4)
            body = Buffer.alloc(8);
            body.writeUInt32BE(0, 0);  // ser = 0
            body.writeUInt32BE(0, 4);  // exp = 0
        } else if (cmdID === 1269) {
            // smcProfessional: count(4) = 0
            body = Buffer.alloc(4);
            body.writeUInt32BE(0, 0);
        } else if (cmdID === 1912) {
            // getNpcStandings: Trả về npcID(4) + standgings(2) + times(4)
            let npcID = 0;
            if (data && data.length >= 21) npcID = data.readUInt32BE(17);
            body = Buffer.alloc(10);
            body.writeUInt32BE(npcID, 0);   // npcID
            body.writeInt16BE(50, 4);       // standgings (short, 50 = neutral positive)
            body.writeUInt32BE(Math.floor(Date.now() / 1000), 6); // times
            Logger.log("RESPONSE", `NPC Standings cho NPC ${npcID}`);
        } else if (cmdID === 1914) {
            // changeNpcStandings: Trả về npcID(4) + standgings(2) + times(4)
            let npcID = 0, standVal = 50;
            if (data && data.length >= 25) {
                npcID = data.readUInt32BE(17);
                standVal = data.readInt32BE(21);
            }
            body = Buffer.alloc(10);
            body.writeUInt32BE(npcID, 0);
            body.writeInt16BE(standVal, 4);
            body.writeUInt32BE(Math.floor(Date.now() / 1000), 6);
            Logger.log("RESPONSE", `NPC Change Standings: ${npcID} -> ${standVal}`);
        } else if (cmdID === 3103) {
            // setJobData: dispatch event, no body data
            body = Buffer.alloc(0);
            Logger.log("RESPONSE", `NPC Set Job Data OK`);
        } else if (cmdID === 3104) {
            // getJobData: Trả về jobID(4) + flag(4)
            let jobID = 0;
            if (data && data.length >= 21) jobID = data.readUInt32BE(17);
            body = Buffer.alloc(8);
            body.writeUInt32BE(jobID, 0);  // jobID
            body.writeUInt32BE(0, 4);      // flag = 0
            Logger.log("RESPONSE", `NPC Get Job Data: ${jobID}`);
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
