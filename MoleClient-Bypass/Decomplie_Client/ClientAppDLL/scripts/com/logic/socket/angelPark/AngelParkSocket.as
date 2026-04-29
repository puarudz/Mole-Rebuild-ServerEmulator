package com.logic.socket.angelPark
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.angelPark.valueObj.AngelParkVO;
   import com.logic.socket.angelPark.valueObj.AngelParkWarehouseVO;
   import com.logic.socket.angelPark.valueObj.GrowingAngelVO;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class AngelParkSocket
   {
      
      public static const GetParkInfoCmd:int = 7001;
      
      public static const GetParkWarehouseCmd:int = 7002;
      
      public static const GetRankCmd:int = 7061;
      
      public static const GetGuestListCmd:int = 7060;
      
      public static const UseSeedCmd:int = 7020;
      
      public static const UseItemCmd:int = 7021;
      
      public static const LevelUpCmd:int = 7050;
      
      public static const LetGoBeforeMadeChangeCmd:int = 7031;
      
      public static const AddAuraCmd:int = 7010;
      
      public static const FollowCmd:int = 7042;
      
      public static const MadeChangeCmd:int = 7030;
      
      public static const animalSwitchSocketCmd:int = 7032;
      
      public static const getAngelsInHospitalCmd:int = 7006;
      
      public static const angelOutHospitalCmd:int = 7011;
      
      public static const useKingTearCmd:int = 7023;
      
      public static const UseBackgroundCmd:int = 7022;
      
      public static const ShowAngelCmd:int = 7079;
      
      public static const HideAngelCmd:int = 7080;
      
      public static const GetCollectionAngelCmd:int = 7081;
      
      public static const GetHonerCmd:int = 7084;
      
      public static const GetHonerAwardCmd:int = 7085;
      
      public static const UnlockHonerCmd:int = 7086;
      
      public function AngelParkSocket()
      {
         super();
      }
      
      public static function GetParkInfo(userId:Number, high:int) : void
      {
         MsgHead.Command = GetParkInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         tempByteArray.writeUnsignedInt(high);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetParkInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var angelParkVO:AngelParkVO = new AngelParkVO();
         angelParkVO.userId = output.readUnsignedInt();
         angelParkVO.isVip = Boolean(output.readUnsignedInt());
         angelParkVO.high = output.readUnsignedInt();
         angelParkVO.aura = output.readUnsignedInt();
         angelParkVO.exp = output.readUnsignedInt();
         angelParkVO.level = output.readUnsignedInt();
         angelParkVO.canSeedAgelCount = output.readUnsignedInt();
         angelParkVO.showAngelId = output.readUnsignedInt();
         angelParkVO.dressUpList = new Array();
         var dressUpCount:int = int(output.readUnsignedInt());
         for(var j:int = 0; j < dressUpCount; j++)
         {
            angelParkVO.dressUpList.push(output.readUnsignedInt());
         }
         angelParkVO.angelList = new Array();
         var angelCount:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < angelCount; i++)
         {
            angelParkVO.angelList.push(GetAngelInfo(output));
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetParkInfoCmd,angelParkVO));
      }
      
      private static function GetAngelInfo(output:IDataInput) : GrowingAngelVO
      {
         var ga:GrowingAngelVO = new GrowingAngelVO();
         ga.index = output.readUnsignedInt();
         ga.id = output.readUnsignedInt();
         ga.posId = output.readUnsignedInt();
         ga.growth = output.readUnsignedInt();
         ga.state = output.readUnsignedInt();
         ga.variateId = output.readUnsignedInt();
         ga.variateRate = output.readUnsignedInt();
         ga.needTimeGrowUp = output.readUnsignedInt();
         return ga;
      }
      
      public static function GetWarehouseInfo() : void
      {
         MsgHead.Command = GetParkWarehouseCmd;
         GF.writeHead();
      }
      
      public static function res_GetWarehouseInfo() : void
      {
         var Obj:Object = null;
         var type:int = 0;
         var output:IDataInput = GV.onlineSocket;
         var wareHouseVO:AngelParkWarehouseVO = new AngelParkWarehouseVO();
         wareHouseVO.bgList = new Array();
         wareHouseVO.itemList = new Array();
         wareHouseVO.seedList = new Array();
         var count:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            Obj = new Object();
            Obj.id = output.readUnsignedInt();
            Obj.count = output.readUnsignedInt();
            type = int(GoodsInfo.getInfoById(Obj.id).Type);
            if(type == 1)
            {
               wareHouseVO.bgList.push(Obj);
            }
            else if(type == 0)
            {
               wareHouseVO.seedList.push(Obj);
            }
            else if(type == 2)
            {
               wareHouseVO.itemList.push(Obj);
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetParkWarehouseCmd,wareHouseVO));
      }
      
      public static function GetRankInfo(firendArr:Array) : void
      {
         MsgHead.Command = GetRankCmd;
         if(firendArr == null)
         {
            return;
         }
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(firendArr.length + 1);
         for(var i:int = 0; i < firendArr.length; i++)
         {
            if(firendArr[i].friend != 0)
            {
               tempByteArray.writeUnsignedInt(firendArr[i].friend);
            }
         }
         tempByteArray.writeUnsignedInt(LocalUserInfo.getUserID());
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetRankInfo() : void
      {
         var userObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.rankArr = new Array();
         obj.Count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.Count; i++)
         {
            userObj = new Object();
            userObj.id = output.readUnsignedInt();
            userObj.parkLvl = int(output.readUnsignedInt());
            userObj.angelCount = int(output.readUnsignedInt());
            if(userObj.id == LocalUserInfo.getUserID())
            {
               obj.selfInfo = userObj;
            }
            else
            {
               obj.rankArr.push(userObj);
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetRankCmd,obj));
      }
      
      public static function GetGuestList(userId:Number, high:int) : void
      {
         MsgHead.Command = GetGuestListCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         tempByteArray.writeUnsignedInt(high);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetGuestList() : void
      {
         var userObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.visitorList = new Array();
         obj.Count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.Count; i++)
         {
            userObj = new Object();
            userObj.id = output.readUnsignedInt();
            userObj.time = output.readUnsignedInt();
            userObj.parkLvl = int(output.readUnsignedInt());
            userObj.angelCount = int(output.readUnsignedInt());
            obj.visitorList.push(userObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetGuestListCmd,obj));
      }
      
      public static function UseSeed(posId:int, seedId:int) : void
      {
         MsgHead.Command = UseSeedCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(posId);
         tempByteArray.writeUnsignedInt(seedId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UseSeed() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var ga:GrowingAngelVO = GetAngelInfo(output);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UseSeedCmd,ga));
      }
      
      public static function UseItem(posId:int, itemId:int) : void
      {
         MsgHead.Command = UseItemCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemId);
         tempByteArray.writeUnsignedInt(posId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UseItem() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var itemId:int = int(output.readUnsignedInt());
         var angelInfo:GrowingAngelVO = GetAngelInfo(output);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UseItemCmd,{
            "itemId":itemId,
            "angel":angelInfo
         }));
      }
      
      public static function res_LevelUp() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var level:int = int(output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + LevelUpCmd,level));
      }
      
      public static function LetGoBeforeMadeChange(index:int) : void
      {
         MsgHead.Command = LetGoBeforeMadeChangeCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(index);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_LetGoBeforeMadeChange() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var index:int = int(output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + LetGoBeforeMadeChangeCmd,index));
      }
      
      public static function AddAura(id:int, count:int) : void
      {
         MsgHead.Command = AddAuraCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(id);
         tempByteArray.writeUnsignedInt(count);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_AddAura() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var maxAura:int = int(output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + AddAuraCmd,maxAura));
      }
      
      public static function Follow(id:int, type:int) : void
      {
         MsgHead.Command = FollowCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(id);
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
         var obj:Object = new Object();
         obj.id = id;
         obj.type = type;
         GV.onlineSocket.dispatchEvent(new EventTaomee("go_back_angle",obj));
      }
      
      public static function res_Follow() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var id:int = int(output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + FollowCmd,id));
      }
      
      public static function MadeChange(index:int) : void
      {
         MsgHead.Command = MadeChangeCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(index);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_MadeChange() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.index = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + MadeChangeCmd,obj));
      }
      
      public static function GetCollection(userId:Number) : void
      {
         MsgHead.Command = 7040;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetCollection() : void
      {
         var Obj1:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.haveAngelCount = output.readUnsignedInt();
         obj.angelList = new Array();
         obj.count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.count; i++)
         {
            Obj1 = new Object();
            Obj1.angelId = output.readUnsignedInt();
            Obj1.angelCount = output.readUnsignedInt();
            obj.angelList.push(Obj1);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_7040",obj));
      }
      
      public static function LetGoAfterMadeChange(angelId:int, num:int) : void
      {
         MsgHead.Command = 7041;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(angelId);
         tempByteArray.writeUnsignedInt(num);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_LetGoAfterMadeChange() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.angelId = output.readUnsignedInt();
         obj.angelNum = output.readUnsignedInt();
         obj.awardCount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_7041",obj));
      }
      
      public static function GetAsa(animalID:int) : void
      {
         MsgHead.Command = animalSwitchSocketCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(animalID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetAsa() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var Is_sucess:int = int(output.readUnsignedInt());
         var Angel_id:int = int(output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + animalSwitchSocketCmd,{
            "Is":Is_sucess,
            "Id":Angel_id
         }));
      }
      
      public static function GetAngelsInHospital() : void
      {
         MsgHead.Command = getAngelsInHospitalCmd;
         GF.writeHead();
      }
      
      public static function res_GetAngelsInHospital() : void
      {
         var angel:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var angelCount:int = int(output.readUnsignedInt());
         var angelArray:Array = new Array();
         for(var i:int = 0; i < angelCount; i++)
         {
            angel = new Object();
            angel.id = output.readUnsignedInt();
            angel.name = GoodsInfo.getItemNameByID(angel.id);
            angel.index = output.readUnsignedInt();
            angel.time = output.readUnsignedInt();
            angelArray.push(angel);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + getAngelsInHospitalCmd,angelArray));
      }
      
      public static function AngelOutHospital(arr:Array) : void
      {
         var tempByteArray:ByteArray = null;
         var length:int = 0;
         var i:int = 0;
         if(Boolean(arr) && arr.length > 0)
         {
            MsgHead.Command = angelOutHospitalCmd;
            tempByteArray = new ByteArray();
            length = int(arr.length);
            tempByteArray.writeUnsignedInt(length);
            for(i = 0; i < length; i++)
            {
               tempByteArray.writeUnsignedInt(arr[i]);
            }
            GF.writeHead(tempByteArray);
         }
      }
      
      public static function res_AngelOutHospital() : void
      {
         var output:IDataInput = GV.onlineSocket;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + angelOutHospitalCmd));
      }
      
      public static function UseKingTear(index:int) : void
      {
         MsgHead.Command = useKingTearCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(index);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UseKingTear() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var index:int = int(output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + useKingTearCmd,index));
      }
      
      public static function UseBackground(bgId:int, layerId:int = 300) : void
      {
         MsgHead.Command = UseBackgroundCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(layerId);
         tempByteArray.writeUnsignedInt(bgId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UseBackground() : void
      {
         var output:IDataInput = GV.onlineSocket;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UseBackgroundCmd));
      }
      
      public static function ShowAngel(angelId:int) : void
      {
         MsgHead.Command = ShowAngelCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(angelId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ShowAngel() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var angelId:int = int(output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + ShowAngelCmd,angelId));
      }
      
      public static function HideAngel() : void
      {
         MsgHead.Command = HideAngelCmd;
         GF.writeHead();
      }
      
      public static function res_HideAngel() : void
      {
         var output:IDataInput = GV.onlineSocket;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + HideAngelCmd));
      }
      
      public static function GetCollectionAngel(userId:int) : void
      {
         MsgHead.Command = GetCollectionAngelCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetCollectionAngel() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var userId:int = int(output.readUnsignedInt());
         var angelCount:int = int(output.readUnsignedInt());
         var angelList:Array = new Array();
         for(var i:int = 0; i < angelCount; i++)
         {
            angelList.push(output.readUnsignedInt());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetCollectionAngelCmd,angelList));
      }
      
      public static function GetHoner(userId:int) : void
      {
         MsgHead.Command = GetHonerCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetHoner() : void
      {
         var parkObj:Object = null;
         var fightObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var hasHonerAward:Boolean = false;
         var parkCount:int = int(output.readUnsignedInt());
         var honerList:Array = new Array();
         for(var i:int = 0; i < parkCount; i++)
         {
            parkObj = new Object();
            parkObj.id = output.readUnsignedInt();
            parkObj.flag = output.readUnsignedInt();
            parkObj.type = 1;
            if(parkObj.flag == 0)
            {
               hasHonerAward = true;
            }
            honerList.push(parkObj);
         }
         var fightCount:int = int(output.readUnsignedInt());
         for(var j:int = 0; j < fightCount; j++)
         {
            fightObj = new Object();
            fightObj.id = output.readUnsignedInt();
            fightObj.flag = output.readUnsignedInt();
            fightObj.type = 2;
            if(fightObj.flag == 0)
            {
               hasHonerAward = true;
            }
            honerList.push(fightObj);
         }
         var obj:Object = new Object();
         obj.honerList = honerList;
         obj.hasHonerAward = hasHonerAward;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetHonerCmd,obj));
      }
      
      public static function GetHonerAward(honerId:int, type:int) : void
      {
         MsgHead.Command = GetHonerAwardCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(honerId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetHonerAward() : void
      {
         var obj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var itemCount:int = int(output.readUnsignedInt());
         var items:Array = new Array();
         for(var i:int = 0; i < itemCount; i++)
         {
            obj = new Object();
            obj.id = output.readUnsignedInt();
            obj.count = output.readUnsignedInt();
            items.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetHonerAwardCmd,items));
      }
      
      public static function res_UnlockHoner() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.type = output.readUnsignedInt();
         obj.id = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UnlockHonerCmd,obj));
      }
   }
}

