package com.logic.socket.farm
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.msgHead.MsgHead;
   import com.core.field.animalInfo.AnimalInfo;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class farmSocket
   {
      
      public static const ANIMAL_UP_DATA:String = "Animal_UpData";
      
      public function farmSocket()
      {
         super();
      }
      
      public static function farm_follow(anmNO:uint, type:int = 1) : void
      {
         MsgHead.Command = 1374;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(anmNO);
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_farm_follow() : void
      {
         var oneanm:AnimalInfo = null;
         var obj:Object = {};
         obj.arr = new Array();
         obj.UserID = GV.onlineSocket.readUnsignedInt();
         obj.NO = GV.onlineSocket.readUnsignedInt();
         obj.Flag = GV.onlineSocket.readUnsignedInt();
         obj.Count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.Count; i++)
         {
            oneanm = AnimalParse();
            if(oneanm.NO == obj.NO)
            {
               if(obj.UserID == GV.MyInfo_userID)
               {
                  if(Boolean(obj.Flag))
                  {
                     GV.MAN_PEOPLE.addAnimalOrUpDate(oneanm);
                  }
                  else
                  {
                     GV.MAN_PEOPLE.delAnimal();
                  }
               }
               oneanm.BackOfFollow = obj.Flag;
               GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1374,oneanm));
            }
            obj.arr.push(oneanm);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_1374_all",obj));
      }
      
      public static function res_farm_hunger() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1376));
      }
      
      public static function farm_info(uid:uint) : void
      {
         MsgHead.Command = 1361;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(uid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_farm_info() : void
      {
         var itemobj:Object = null;
         var feedobj:Object = null;
         var eggobj:Object = null;
         var farmInfoObj:Object = new Object();
         var ItemInfoArr:Array = new Array();
         var AnmInfoArr:Array = new Array();
         var FeedInfoArr:Array = new Array();
         var EggInfoArr:Array = new Array();
         farmInfoObj.UserID = GV.onlineSocket.readUnsignedInt();
         farmInfoObj.Name = GV.onlineSocket.readUTFBytes(16);
         farmInfoObj.Online = GV.onlineSocket.readUnsignedInt();
         farmInfoObj.PoolLock = GV.onlineSocket.readUnsignedInt();
         farmInfoObj.PoolState = GV.onlineSocket.readUnsignedInt();
         farmInfoObj.InsectsType = GV.onlineSocket.readUnsignedInt();
         farmInfoObj.AnimalCount = GV.onlineSocket.readUnsignedInt();
         farmInfoObj.ItemCount = GV.onlineSocket.readUnsignedInt();
         farmInfoObj.FeedCount = GV.onlineSocket.readUnsignedInt();
         farmInfoObj.Egg_Count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < farmInfoObj.AnimalCount; i++)
         {
            AnmInfoArr.push(readAnimal());
         }
         for(var j:uint = 0; j < farmInfoObj.ItemCount; j++)
         {
            itemobj = new Object();
            itemobj.ID = GV.onlineSocket.readUnsignedInt();
            itemobj.r1 = GV.onlineSocket.readUnsignedInt();
            itemobj.r2 = GV.onlineSocket.readUnsignedInt();
            itemobj.r3 = GV.onlineSocket.readUnsignedInt();
            ItemInfoArr.push(itemobj);
         }
         for(var k:uint = 0; k < farmInfoObj.FeedCount; k++)
         {
            feedobj = new Object();
            feedobj.ID = GV.onlineSocket.readUnsignedInt();
            feedobj.Count = GV.onlineSocket.readUnsignedInt();
            FeedInfoArr.push(feedobj);
         }
         for(var e:uint = 0; e < farmInfoObj.Egg_Count; e++)
         {
            eggobj = new Object();
            eggobj.itemid = GV.onlineSocket.readUnsignedInt();
            eggobj.pos = GV.onlineSocket.readUnsignedInt();
            eggobj.doNum = GV.onlineSocket.readUnsignedInt();
            eggobj.notDoNum = GV.onlineSocket.readUnsignedInt();
            EggInfoArr.push(eggobj);
         }
         farmInfoObj.ItemInfoArr = ItemInfoArr;
         farmInfoObj.AnmInfoArr = AnmInfoArr;
         farmInfoObj.FeedInfoArr = FeedInfoArr;
         farmInfoObj.EggInfoArr = EggInfoArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1361,farmInfoObj));
      }
      
      public static function farm_depot() : void
      {
         MsgHead.Command = 1362;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_farm_depot() : void
      {
         var depotobj:Object = null;
         var obj:Object = new Object();
         obj.arr = new Array();
         obj.count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.count; i++)
         {
            depotobj = new Object();
            depotobj.ID = GV.onlineSocket.readUnsignedInt();
            depotobj.Count = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(depotobj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1362,obj));
      }
      
      public static function farm_feedroom() : void
      {
         MsgHead.Command = 1369;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_farm_feedroom() : void
      {
         var feedobj:Object = null;
         var obj:Object = new Object();
         obj.arr = new Array();
         obj.userid = GV.onlineSocket.readUnsignedInt();
         obj.count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.count; i++)
         {
            feedobj = new Object();
            feedobj.id = GV.onlineSocket.readUnsignedInt();
            feedobj.count = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(feedobj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1369,obj));
      }
      
      public static function catch_animal(anmNO:uint, anmType:uint = 1) : void
      {
         MsgHead.Command = 1363;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(anmType);
         tempByteArray.writeUnsignedInt(anmNO);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_catch_animal() : void
      {
         var obj:Object = new Object();
         obj.ItemID = GV.onlineSocket.readUnsignedInt();
         obj.ItemNO = GV.onlineSocket.readUnsignedInt();
         obj.starLvl = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1363,obj));
      }
      
      public static function letgo_animal(anmNO:uint, anmType:uint = 2) : void
      {
         MsgHead.Command = 1377;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(anmNO);
         tempByteArray.writeUnsignedInt(anmType);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_letgo_animal() : void
      {
         var obj:Object = new Object();
         obj.ItemNO = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1377,obj));
      }
      
      public static function add_feed(feedid:uint, feedcount:uint) : void
      {
         MsgHead.Command = 1364;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(feedid);
         tempByteArray.writeUnsignedInt(feedcount);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_add_feed() : void
      {
         var feedobj:Object = null;
         var obj:Object = new Object();
         obj.arr = new Array();
         obj.count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.count; i++)
         {
            feedobj = new Object();
            feedobj.id = GV.onlineSocket.readUnsignedInt();
            feedobj.count = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(feedobj);
            if(feedobj.id == 190232)
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("prop_190232"));
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1364,obj));
      }
      
      public static function feed_animal(anmID:uint) : void
      {
         MsgHead.Command = 1365;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(anmID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_feed_animal() : void
      {
         var o:Object = readAnimal();
         o.rawId = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1365,{
            "data":o,
            "anmNO":o.NO,
            "anmID":o.ID,
            "anmType":o.Type
         }));
      }
      
      public static function outMap_feed(anmID:uint) : void
      {
         MsgHead.Command = 1375;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(anmID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_outMap_feed() : void
      {
         var o:Object = readAnimal();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1375,o));
      }
      
      public static function animal_info_fish(type:uint) : void
      {
         MsgHead.Command = 1366;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_animal_info_fish() : void
      {
         var obj:Object = new Object();
         obj.AnmInfoArr = new Array();
         obj.Type = GV.onlineSocket.readUnsignedInt();
         obj.count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.count; i++)
         {
            obj.AnmInfoArr.push(readAnimal());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1366,obj));
      }
      
      public static function animal_info_addwater() : void
      {
         MsgHead.Command = 1367;
         GF.writeHead();
      }
      
      public static function res_animal_info_addwater() : void
      {
         var obj:Object = new Object();
         obj.AnmInfoArr = new Array();
         obj.count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.count; i++)
         {
            obj.AnmInfoArr.push(readAnimal());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1367,obj));
      }
      
      public static function lockPool(Flag:uint) : void
      {
         MsgHead.Command = 1371;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Flag);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_lockPool() : void
      {
         var obj:Object = new Object();
         obj.Flag = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1371,obj));
      }
      
      public static function farmGuest(id:uint) : void
      {
         MsgHead.Command = 1368;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(id);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_farmGuest() : void
      {
         var visitor:Object = null;
         var obj:Object = new Object();
         var visitorArr:Array = new Array();
         var len:int = GV.onlineSocket.readShort();
         for(var i:uint = 0; i < len; i++)
         {
            visitor = new Object();
            visitor.UserID = GV.onlineSocket.readUnsignedInt();
            visitor.Flag = GV.onlineSocket.readUnsignedInt();
            visitor.Nick = GV.onlineSocket.readUTFBytes(16);
            visitor.Color = GV.onlineSocket.readUnsignedInt();
            visitor.Vip = GV.onlineSocket.readUnsignedByte();
            visitor.Time = GV.onlineSocket.readUnsignedInt();
            visitorArr.push(visitor);
         }
         obj.arr = visitorArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1368,obj));
      }
      
      public static function AnimalParse() : AnimalInfo
      {
         var output:IDataInput = GV.onlineSocket;
         var anm:Object = new Object();
         anm.NO = GV.onlineSocket.readUnsignedInt();
         anm.ID = GV.onlineSocket.readUnsignedInt();
         anm.Flag = GV.onlineSocket.readUnsignedInt();
         anm.Value = GV.onlineSocket.readUnsignedInt();
         anm.Eat_time = GV.onlineSocket.readUnsignedInt();
         anm.Drink_time = GV.onlineSocket.readUnsignedInt();
         anm.Output_count = GV.onlineSocket.readUnsignedInt();
         anm.Output_time = GV.onlineSocket.readUnsignedInt();
         anm.Update_time = GV.onlineSocket.readUnsignedInt();
         anm.Mature_time = GV.onlineSocket.readUnsignedInt();
         anm.Type = GV.onlineSocket.readUnsignedInt();
         if(anm.ID == 1270008)
         {
            anm.Type = 4;
         }
         anm.FriendTime = GV.onlineSocket.readUnsignedInt();
         anm.FriendNum = GV.onlineSocket.readUnsignedInt();
         anm.Outgo = GV.onlineSocket.readUnsignedInt();
         anm.hasAction = GV.onlineSocket.readUnsignedInt();
         anm.PollinationNum = GV.onlineSocket.readUnsignedInt();
         anm.max_output = GV.onlineSocket.readUnsignedInt();
         anm.Diff_mature_time = GV.onlineSocket.readUnsignedInt();
         anm.Cur_grow_rate = GV.onlineSocket.readUnsignedInt();
         anm.starLvl = GV.onlineSocket.readUnsignedInt();
         var tobj:Object = GoodsInfo.getInfoById(anm.ID);
         anm.typeObject = tobj.typeObject;
         anm.id = anm.ID;
         anm.name = tobj.name;
         anm.price = tobj.price;
         anm.Class = tobj.Class;
         anm.LevelArray = tobj.LevelArray;
         anm.quantifier = tobj.quantifier;
         anm.Fruit = tobj.Fruit;
         anm.growth = tobj.growth;
         anm.water = tobj.water;
         anm.Growth = anm.Value;
         anm.Food = tobj.Food;
         anm.speed = tobj.speed;
         anm.floatSpeed = tobj.floatSpeed;
         anm.floatMoveTime = tobj.floatMoveTime;
         anm.baseMoveTime = tobj.baseMoveTime;
         anm.acedia = tobj.acedia;
         anm.canFollow = tobj.canFollow;
         return new AnimalInfo(anm);
      }
      
      public static function readAnimal() : Object
      {
         var itemCountObj:Object = AnimalParse();
         if(Boolean(itemCountObj.Type))
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(ANIMAL_UP_DATA,itemCountObj));
         }
         return itemCountObj;
      }
      
      public static function getsheep(uid:int) : void
      {
         MsgHead.Command = 1372;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(uid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getsheep() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1372));
      }
      
      public static function gethomebg() : void
      {
         MsgHead.Command = 1373;
         GF.writeHead();
      }
      
      public static function res_gethomebg() : void
      {
         var obj:Object = new Object();
         obj.itemid = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1373,obj));
      }
      
      public static function changeBG(usedArr:Array, nousedArr:Array) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(1370);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(usedArr.length);
         GV.onlineSocket.writeUnsignedInt(nousedArr.length);
         for(var j:int = 0; j < nousedArr.length; j++)
         {
            GV.onlineSocket.writeUnsignedInt(nousedArr[j].ID);
            GV.onlineSocket.writeUnsignedInt(nousedArr[j].Count);
         }
         for(var i:uint = 0; i < usedArr.length; i++)
         {
            GV.onlineSocket.writeUnsignedInt(usedArr[i].ID);
            GV.onlineSocket.writeUnsignedInt(0);
            GV.onlineSocket.writeUnsignedInt(0);
            GV.onlineSocket.writeUnsignedInt(0);
         }
         GV.onlineSocket.flush();
      }
      
      public static function res_changeBG() : void
      {
         var obj:Object = new Object();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1370,obj));
      }
      
      public static function buynet() : void
      {
         MsgHead.Command = 1900;
         GF.writeHead();
      }
      
      public static function res_buynet() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1900));
      }
      
      public static function netstatus() : void
      {
         MsgHead.Command = 1901;
         GF.writeHead();
      }
      
      public static function res_netstatus() : void
      {
         var obj:Object = new Object();
         obj.status = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1901,obj));
      }
      
      public static function netfishing() : void
      {
         MsgHead.Command = 1902;
         GF.writeHead();
      }
      
      public static function res_netfishing() : void
      {
         var tmp:Object = null;
         var obj:Object = new Object();
         obj.fishType = GV.onlineSocket.readUnsignedInt();
         obj.netstatus = GV.onlineSocket.readUnsignedInt();
         obj.fisharr = new Array();
         obj.fishNum = 0;
         for(var i:uint = 0; i < obj.fishType; i++)
         {
            tmp = new Object();
            tmp.itemID = GV.onlineSocket.readUnsignedInt();
            tmp.Count = GV.onlineSocket.readUnsignedInt();
            obj.fishNum += tmp.Count;
            obj.fisharr.push(tmp);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1902,obj));
      }
      
      public static function getcandy(uid:uint, candynum:uint) : void
      {
         MsgHead.Command = 1856;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(uid);
         tempByteArray.writeUnsignedInt(candynum);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getcandy() : void
      {
         var obj:Object = new Object();
         obj.count = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1856,obj));
      }
      
      public static function checkEgg(Cposition:uint, Cid:uint) : void
      {
         MsgHead.Command = 1920;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Cposition);
         tempByteArray.writeUnsignedInt(Cid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_checkEgg() : void
      {
         var obj:Object = new Object();
         obj.num = GV.onlineSocket.readUnsignedInt();
         obj.rest = GV.onlineSocket.readUnsignedInt();
         obj.pos = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1920,obj));
      }
      
      public static function touchEgg(Cid:uint, Cposition:uint) : void
      {
         MsgHead.Command = 1919;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Cid);
         tempByteArray.writeUnsignedInt(Cposition);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_touchEgg() : void
      {
         var obj:Object = new Object();
         obj.pos = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1919,obj));
      }
      
      public static function setEgg(Cpos:uint, Cid:uint) : void
      {
         MsgHead.Command = 1918;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Cpos);
         tempByteArray.writeUnsignedInt(Cid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setEgg() : void
      {
         var obj:Object = new Object();
         obj.result = GV.onlineSocket.readUnsignedInt();
         obj.pos = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1918,obj));
      }
      
      public static function breakEgg(Cpos:uint) : void
      {
         MsgHead.Command = 1928;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Cpos);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_breakEgg() : void
      {
         var obj:Object = new Object();
         obj.pos = GV.onlineSocket.readUnsignedInt();
         obj.itemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1928,obj));
      }
      
      public static function getEgg() : void
      {
         MsgHead.Command = 1922;
         GF.writeHead();
      }
      
      public static function res_getEgg() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1922));
      }
      
      public static function getWoolPos() : void
      {
         MsgHead.Command = 60013;
         GF.writeHead();
      }
      
      public static function res_getWoolPos() : void
      {
         var obj1:Object = new Object();
         var obj:Array = new Array(3);
         for(var objRound:int = 0; objRound < obj.length; objRound++)
         {
            obj[objRound] = GV.onlineSocket.readUnsignedInt();
         }
         obj1.obj = obj;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1931,obj1));
      }
      
      public static function getWool() : void
      {
         MsgHead.Command = 1921;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(0);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getWool() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1921));
      }
      
      public static function getfishBy8() : void
      {
         MsgHead.Command = 1957;
         GF.writeHead();
      }
      
      public static function res_getfishBy8() : void
      {
         var obj:Object = new Object();
         obj.fishId = GV.onlineSocket.readUnsignedInt();
         obj.angelSeedId = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1957,obj));
      }
      
      public static function res_getFarmSkillup() : void
      {
         var obj:Object = new Object();
         obj.plantSkill = GV.onlineSocket.readUnsignedInt();
         obj.animalSkill = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1984,obj));
      }
      
      public static function doudouCar_animal(no:uint) : void
      {
         MsgHead.Command = 2011;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(no);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_doudouCar_animal() : void
      {
         var obj:Object = new Object();
         obj.ItemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 2011,obj));
      }
      
      public static function getStarAnimal(userID:int) : void
      {
         MsgHead.Command = 1467;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getStarAnimal() : void
      {
         var obj1:Object = null;
         var j:int = 0;
         var obj2:Object = null;
         var obj:Object = new Object();
         obj.count = GV.onlineSocket.readUnsignedInt();
         obj.arr = new Array();
         for(var i:int = 0; i < obj.count; i++)
         {
            obj1 = new Object();
            obj1.skillArr = new Array();
            obj1.ID = GV.onlineSocket.readUnsignedInt();
            obj1.sID = GV.onlineSocket.readUnsignedInt();
            obj1.starLevel = GV.onlineSocket.readUnsignedInt();
            obj1.animalId = GV.onlineSocket.readUnsignedInt();
            obj1.skillCount = GV.onlineSocket.readUnsignedInt();
            for(j = 0; j < obj1.skillCount; j++)
            {
               obj2 = new Object();
               obj2.skillId = GV.onlineSocket.readUnsignedInt();
               obj2.usingCount = GV.onlineSocket.readUnsignedInt();
               obj1.skillArr.push(obj2);
            }
            obj.arr.push(obj1);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1467,obj));
      }
      
      public static function aniamlAddSpeed(animalNO:int, goodsItemId:int) : void
      {
         MsgHead.Command = 1468;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(animalNO);
         tempByteArray.writeUnsignedInt(goodsItemId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_aniamlAddSpeed() : void
      {
         var obj:Object = new Object();
         obj.goodsItemId = GV.onlineSocket.readUnsignedInt();
         obj.animalInfo = readAnimal();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1468,obj));
      }
   }
}

