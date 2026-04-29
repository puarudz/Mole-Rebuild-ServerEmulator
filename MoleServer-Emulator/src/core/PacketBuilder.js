class PacketBuilder {
    static makeHead(cmdID, userID, result = 0, bodyLength = 0) {
        const head = Buffer.alloc(17);
        head.writeUInt32BE(17 + bodyLength, 0); // Độ dài
        head.writeUInt8(0x01, 4);               // Phiên bản
        head.writeUInt32BE(cmdID, 5);           // Lệnh (CmdID)
        head.writeUInt32BE(userID, 9);          // UserID
        head.writeUInt32BE(result, 13);         // Kết quả
        return head;
    }

    static makeInitPlayerEx(user) {
        const parts = [];
        const writeUInt32 = (val) => { const b = Buffer.alloc(4); b.writeUInt32BE(val >>> 0, 0); parts.push(b); };
        const writeUInt8 = (val) => { const b = Buffer.alloc(1); b.writeUInt8(val & 0xFF, 0); parts.push(b); };
        const writeBytes = (buf) => { parts.push(buf); };

        writeUInt32(parseInt(user.user_id || user.userID));       // 1. UserID
        const nickBuf = Buffer.alloc(16, 0);
        nickBuf.write(user.nick || "Mole", 0, "utf8");
        writeBytes(nickBuf);                      // 2. Nick             readUTFBytes(16)
        writeUInt32(0);                           // 3. ParentID         readUnsignedInt
        writeUInt32(0);                           // 4. childCount       readUnsignedInt
        writeUInt32(0);                           // 5. newChildCount    readUnsignedInt
        writeUInt32(user.color || 0x7A0000);      // 6. Color            readUnsignedInt
        writeUInt32(user.vipFlags ?? 33);          // 7. Vip bitmask: bit0=VIP, bit5=onceVIP  readUnsignedInt
        writeUInt32(user.role_type || 0);         // 8. roleType         readUnsignedInt
        writeUInt32(Math.floor(Date.now() / 1000)); // 9. Birthday       readUnsignedInt
        writeUInt32(user.exp || 0);               // 10. Exp             readUnsignedInt
        writeUInt32(user.strong || 0);            // 11. Strong          readUnsignedInt
        writeUInt32(user.iq || 0);                // 12. IQ              readUnsignedInt
        writeUInt32(user.charm || 0);             // 13. Charm           readUnsignedInt
        writeUInt32(user.game_king || 0);         // 14. Game_king       readUnsignedInt
        writeUInt32(user.coins || 10000);         // 15. YXQ (摩爾豆)    readUnsignedInt
        writeUInt32(0);                           // 16. Engineer        readUnsignedInt
        writeUInt32(0);                           // 17. DanceLevel      readUnsignedInt
        writeUInt32(0);                           // 18. planter         readUnsignedInt
        writeUInt32(0);                           // 19. farmer          readUnsignedInt
        writeUInt32(0);                           // 20. Dining_flag     readUnsignedInt
        writeUInt32(0);                           // 21. Dining_level    readUnsignedInt
        writeUInt32(user.map || 3);               // 22. MapID           readUnsignedInt
        writeUInt32(0);                           // 23. MapType         readUnsignedInt
        writeUInt8(user.status || 0);             // 24. Status          readUnsignedByte
        writeUInt32(user.action || 0);            // 25. Action          readUnsignedInt
        writeUInt8(user.direction || 0);          // 26. Direction       readUnsignedByte
        writeUInt32(user.x || 333);               // 27. PosX            readUnsignedInt
        writeUInt32(user.y || 333);               // 28. PosY            readUnsignedInt
        writeUInt32(509);                         // 29. LoginTimes      readUnsignedInt
        writeUInt32(50601600);                    // 30. birthday (book) readUnsignedInt
        writeUInt32(0);                           // 31. PetSkill5_Flag  readUnsignedInt
        writeUInt32(0);                           // 32. Magic_task      readUnsignedInt
        writeUInt32(user.vipLevel ?? 8);           // 33. Vip_level (0-8, max=8)  readUnsignedInt
        writeUInt32(user.vipMonth ?? 12);          // 34. Vip_month       readUnsignedInt
        writeUInt32(user.vipValue ?? 9999);        // 35. VipValue        readUnsignedInt
        writeUInt32(user.vipEndTime ?? 2145916800);// 36. VipEndTime (2037-12-31) readUnsignedInt
        writeUInt32(user.autoPayVip ?? 1);         // 37. autoPayVip      readUnsignedInt
        
        writeUInt32(0);                           // 38. Dragon ID       readUnsignedInt
        const dragonNick = Buffer.alloc(16, 0);
        writeBytes(dragonNick);                   // 39. Dragon nickname readUTFBytes(16)
        writeUInt32(0);                           // 40. growth          readUnsignedInt
        
        writeUInt32(0);                           // 41. RemainingTime   readUnsignedInt
        const activityBuf = Buffer.alloc(32, 0);
        writeBytes(activityBuf);                  // 42. Activity        readBytes(32)
        // Items logic
        const items = user.items || [];
        writeUInt8(items.length);                 // 43. ItemCount
        for (const itemID of items) {
            writeUInt32(itemID);                  // ItemID
        }
        
        return Buffer.concat(parts);
    }

    static makeEnterMapOrRoomUserInfo(user) {
        const parts = [];
        const writeUInt32 = (val) => { const b = Buffer.alloc(4); b.writeUInt32BE(val >>> 0, 0); parts.push(b); };
        const writeUInt8 = (val) => { const b = Buffer.alloc(1); b.writeUInt8(val & 0xFF, 0); parts.push(b); };
        const writeBytes = (buf) => { parts.push(buf); };

        writeUInt32(parseInt(user.user_id || user.userID) || 0);  // UserID
        const nickBuf = Buffer.alloc(16, 0);
        nickBuf.write(user.nick || "Mole", 0, "utf8");
        writeBytes(nickBuf);                      // Nick (16 bytes)
        writeUInt32(0);                           // ParentID
        writeUInt32(0);                           // childCount
        writeUInt32(0);                           // newChildCount
        writeUInt32(user.color || 0x7A0000);      // Color
        writeUInt32(user.vipFlags ?? 33);          // Vip bitmask
        writeUInt32(user.map || 0);               // MapID
        writeUInt32(0);                           // MapType
        writeUInt8(user.status || 0);             // Status
        writeUInt32(user.action || 0);            // Action
        writeUInt8(user.direction || 0);          // Direction (MUST BE BEFORE PET_ACTION FOR CMD 401!)
        writeUInt32(user.petAction || 0);         // Pet_action
        writeUInt32(user.x || 480);               // PosX
        writeUInt32(user.y || 280);               // PosY
        writeUInt32(user.grid || 0);              // Grid
        writeUInt32(user.action2 || 0);           // Action2
        writeUInt32(user.petID || 1);              // PetID (1 = Lamu mặc định)
        const petNick = Buffer.alloc(16, 0);
        petNick.write(user.petNick || "Đậu Đậu", 0, "utf8");
        writeBytes(petNick);                      // PetName
        writeUInt32(user.petColor || 0xFFCC00);   // PetColor (vàng)
        writeUInt8(user.petLevel || 8);            // Petlevel
        writeUInt32(0);                           // Reserved1
        writeUInt32(0);                           // PetSick
        writeUInt32(0);                           // skill_Fire
        writeUInt32(0);                           // skill_Water
        writeUInt32(0);                           // skill_Wood
        writeUInt32(0);                           // Skill_Type
        writeUInt32(0);                           // Skill_Value
        writeUInt8(0);                            // item1
        writeUInt8(0);                            // item2
        writeUInt8(0);                            // item3
        writeUInt32(0);                           // Pet_cloth
        writeUInt32(0);                           // Pet_honor
        writeUInt32(0);                           // Can_Fly
        
        const activityBuf = Buffer.alloc(32, 0);
        writeBytes(activityBuf);                  // Activity (32 bytes)
        
        writeUInt32(0);                           // Dragon obj.id
        const dragonNick = Buffer.alloc(16, 0);
        writeBytes(dragonNick);                   // Dragon obj.nickname (16 bytes)
        writeUInt32(0);                           // Dragon obj.growth
        writeUInt32(0);                           // digTreasureLvl
        writeUInt32(0);                           // hasCar
        writeUInt32(0);                           // hasAnimal
        writeUInt32(0);                           // roleType
        
        // Items logic
        const items = user.items || [];
        writeUInt8(items.length);                 // ItemCount
        for (const itemID of items) {
            writeUInt32(itemID);                  // ItemID
        }
        writeUInt32(user.super_guide || 0);       // superGuide
        
        return Buffer.concat(parts);
    }

    // This is for 405 (AllSceneUser) and 204 (GetSceneUserInfo)
    static makeEnterMapUserInfo(user) {
        const parts = [];
        const writeUInt32 = (val) => { const b = Buffer.alloc(4); b.writeUInt32BE(val >>> 0, 0); parts.push(b); };
        const writeUInt8 = (val) => { const b = Buffer.alloc(1); b.writeUInt8(val & 0xFF, 0); parts.push(b); };
        const writeBytes = (buf) => { parts.push(buf); };

        writeUInt32(parseInt(user.user_id || user.userID) || 0);  // UserID
        const nickBuf = Buffer.alloc(16, 0);
        nickBuf.write(user.nick || "Mole", 0, "utf8");
        writeBytes(nickBuf);                      // Nick (16 bytes)
        writeUInt32(0);                           // ParentID
        writeUInt32(0);                           // childCount
        writeUInt32(0);                           // newChildCount
        writeUInt32(user.color || 0x7A0000);      // Color
        writeUInt32(user.vipFlags ?? 33);          // Vip bitmask
        writeUInt32(user.map || 0);               // MapID
        writeUInt32(0);                           // MapType
        writeUInt8(user.status || 0);             // Status
        writeUInt32(user.action || 0);            // Action
        writeUInt32(user.petAction || 0);         // Pet_action (MUST BE BEFORE DIRECTION FOR 405!)
        writeUInt8(user.direction || 0);          // Direction
        writeUInt32(user.x || 480);               // PosX
        writeUInt32(user.y || 280);               // PosY
        writeUInt32(user.grid || 0);              // Grid
        writeUInt32(user.action2 || 0);           // Action2
        writeUInt32(user.petID || 1);              // PetID (1 = Lamu mặc định)
        const petNick2 = Buffer.alloc(16, 0);
        petNick2.write(user.petNick || "Đậu Đậu", 0, "utf8");
        writeBytes(petNick2);                     // PetName
        writeUInt32(user.petColor || 0xFFCC00);   // PetColor (vàng)
        writeUInt8(user.petLevel || 8);            // Petlevel
        writeUInt32(0);                           // Reserved1
        writeUInt32(0);                           // PetSick
        writeUInt32(0);                           // skill_Fire
        writeUInt32(0);                           // skill_Water
        writeUInt32(0);                           // skill_Wood
        writeUInt32(0);                           // Skill_Type
        writeUInt32(0);                           // Skill_Value
        writeUInt8(0);                            // item1
        writeUInt8(0);                            // item2
        writeUInt8(0);                            // item3
        writeUInt32(0);                           // Pet_cloth
        writeUInt32(0);                           // Pet_honor
        writeUInt32(0);                           // Can_Fly
        
        const activityBuf = Buffer.alloc(32, 0);
        writeBytes(activityBuf);                  // Activity (32 bytes)
        
        writeUInt32(0);                           // Dragon obj.id
        const dragonNick = Buffer.alloc(16, 0);
        writeBytes(dragonNick);                   // Dragon obj.nickname (16 bytes)
        writeUInt32(0);                           // Dragon obj.growth
        writeUInt32(0);                           // digTreasureLvl
        writeUInt32(0);                           // hasCar
        writeUInt32(0);                           // hasAnimal
        writeUInt32(0);                           // roleType
        
        // Items logic
        const items = user.items || [];
        writeUInt8(items.length);                 // ItemCount
        for (const itemID of items) {
            writeUInt32(itemID);                  // ItemID
        }
        writeUInt32(user.super_guide || 0);       // superGuide
        
        return Buffer.concat(parts);
    }

    // This is exclusively for CMD 204 (GetSceneUserInfo) - Profile View
    static makeSceneUserInfo(user) {
        const parts = [];
        const writeUInt32 = (val) => { const b = Buffer.alloc(4); b.writeUInt32BE(val >>> 0, 0); parts.push(b); };
        const writeUInt8 = (val) => { const b = Buffer.alloc(1); b.writeUInt8(val & 0xFF, 0); parts.push(b); };
        const writeBytes = (buf) => { parts.push(buf); };

        writeUInt32(parseInt(user.user_id || user.userID) || 0);  // UserID
        const nickBuf = Buffer.alloc(16, 0);
        nickBuf.write(user.nick || "Mole", 0, "utf8");
        writeBytes(nickBuf);                      // Nick (16 bytes)
        writeUInt32(0);                           // ParentID
        writeUInt32(0);                           // childCount
        writeUInt32(0);                           // newChildCount
        writeUInt32(user.color || 0x7A0000);      // Color
        writeUInt32(user.vipFlags ?? 33);          // Vip
        
        // Birthday (account creation time). We'll set a default of 2008-05-01 (1209600000 / 1000 = 1209600)
        // If the user object has created_at or roleTime, we could use it. Here we use 1209600 for display purposes.
        writeUInt32(user.create_time || 1209600); // Birthday
        
        writeUInt32(user.exp || 0);               // Exp
        writeUInt32(user.strong || 0);            // Strong
        writeUInt32(user.iq || 0);                // IQ
        writeUInt32(user.charm || 0);             // Charm
        writeUInt32(user.game_king || 0);         // Game_king
        writeUInt32(user.coins || 10000);         // YXQ
        writeUInt32(0);                           // Engineer
        writeUInt32(0);                           // DanceLevel
        writeUInt32(0);                           // planter
        writeUInt32(0);                           // farmer
        writeUInt32(0);                           // Dining_flag
        writeUInt32(0);                           // Dining_level
        writeUInt32(user.vipLevel ?? 8);          // SLstar
        writeUInt32(user.vipMonth ?? 12);         // MonthNum
        writeUInt32(user.vipValue ?? 9999);       // VipValue
        writeUInt32(user.vipEndTime ?? 2145916800); // VipEndTime
        writeUInt32(user.autoPayVip ?? 1);        // autoPayVip
        
        writeUInt32(user.map || 0);               // MapID
        writeUInt32(0);                           // MapType
        writeUInt8(user.status || 0);             // Status
        writeUInt32(user.action || 0);            // Action
        writeUInt8(user.direction || 0);          // Direction
        writeUInt32(user.x || 480);               // PosX
        writeUInt32(user.y || 280);               // PosY
        writeUInt32(user.grid || 0);              // Grid
        
        const activityBuf = Buffer.alloc(32, 0);
        writeBytes(activityBuf);                  // Activity (32 bytes)
        
        writeUInt32(0);                           // Dragon obj.id
        const dragonNick = Buffer.alloc(16, 0);
        writeBytes(dragonNick);                   // Dragon obj.nickname (16 bytes)
        writeUInt32(0);                           // Dragon obj.growth
        
        writeUInt32(0);                           // digTreasureLvl
        writeUInt32(0);                           // hasCar
        writeUInt32(0);                           // hasAnimal
        writeUInt32(user.role_type || 0);         // roleType
        
        // Items logic
        const items = user.items || [];
        writeUInt8(items.length);                 // ItemCount
        for (const itemID of items) {
            writeUInt32(itemID);                  // ItemID
        }
        writeUInt32(user.super_guide || 0);       // superGuide
        
        return Buffer.concat(parts);
    }
}

module.exports = PacketBuilder;
