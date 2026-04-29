package com.logic.socket.pig
{
   import com.common.data.HashMap;
   import com.common.msgHead.MsgHead;
   import com.common.util.StringUtil;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PigSocket
   {
      
      private static var _type:int;
      
      public static const GetPigHouseInfoCmd:int = 8250;
      
      public static const GetPigInfoCmd:int = 8251;
      
      public static const GetBagCmd:int = 8253;
      
      public static const SellItemCmd:int = 8262;
      
      public static const AddPigCmd:int = 8255;
      
      public static const AddFoodCmd:int = 8256;
      
      public static const BatheCmd:int = 8257;
      
      public static const TeaseCmd:int = 8258;
      
      public static const TrainCmd:int = 8259;
      
      public static const ChangeNameCmd:int = 8260;
      
      public static const SetTeamCmd:int = 8261;
      
      public static const UpLevelCmd:int = 8264;
      
      public static const GetFriendsInfoCmd:int = 8265;
      
      public static const GetLuckCmd:int = 8271;
      
      public static const UseItemCmd:int = 8274;
      
      public static const GetNoticeCmd:int = 8269;
      
      public static const MachiningPigCmd:int = 8270;
      
      public static const IllustratedHandbookCmd:int = 8272;
      
      public static const SelectTaskMsgCmd:int = 8266;
      
      public static const AcceptTaskCmd:int = 8267;
      
      public static const OverTaskCmd:int = 8268;
      
      public static const GetFriendPigCmd:int = 8252;
      
      public static const BreedPigCmd:int = 8263;
      
      public static const BuildUpLevelCmd:int = 8273;
      
      public static const GetPigTicketCmd:int = 8275;
      
      public static const UseCardCmd:int = 8277;
      
      public static const GetCardBuffInfoCmd:int = 8278;
      
      public static const ExchangePigByGoodsCmd:int = 8279;
      
      public static const SetBGCmd:int = 8280;
      
      public static const FollowMoleCmd:int = 8281;
      
      public static const GetTempHouseInfoCmd:int = 8284;
      
      public static const SendToTempHouseCmd:int = 8285;
      
      public static const GetShowStageInfoCmd:int = 8282;
      
      public static const ShowPigCmd:uint = 8283;
      
      public static const BeautyMatchGetAwardCmd:int = 8286;
      
      public static const SelectBeautyDayAndAllCountCmd:int = 8287;
      
      public static const SpecialGiftBroadcastCmd:int = 8288;
      
      public static const GetSpecialGiftCmd:int = 8289;
      
      public static const GetBeautyMatchResultCmd:int = 8290;
      
      public static const FatPigMatchCmd:int = 8293;
      
      public static const GetFatMatchAwardsStateCmd:int = 8294;
      
      public static const GetAchieveStateCmd:int = 8291;
      
      public static const GetAchieveAwardsCmd:int = 8292;
      
      public static const GetHasHonorCmd:int = 8296;
      
      public static const TmpHouseExchangeCmd:uint = 8107;
      
      public static const SelectMachinistSquareInfoCmd:uint = 8506;
      
      public static const CutePigExplorMapCmd:uint = 8507;
      
      public static const SelectCutePigExplorInfoCmd:uint = 8508;
      
      public static const TAKE_BACK_PIG_CMD:uint = 8529;
      
      public static const PigLetMeltOreCmd:uint = 8509;
      
      public static const ProduceMachinePartCmd:uint = 8510;
      
      public static const PigLetFinishWorlCmd:uint = 8511;
      
      public static const ProduceSpecialMachineCmd:uint = 8519;
      
      public static const GET_NEW_STEP_CMD:int = 8514;
      
      public static const GET_NEW_STEP:String = "read_8514";
      
      public static const SET_NEW_STEP_CMD:int = 8515;
      
      public static const SET_NEW_STEP:String = "read_8515";
      
      public static const MachineRandomGoodsCmd:uint = 8524;
      
      public static const UserMachineGoodsCmd:uint = 8513;
      
      public function PigSocket()
      {
         super();
      }
      
      public static function GetPigHouseInfo(userId:Number, type:int = 1) : void
      {
         _type = type;
         MsgHead.Command = GetPigHouseInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetPigHouseInfo() : void
      {
         var pig:HashMap = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:HashMap = new HashMap();
         obj.add("state",output.readUnsignedInt());
         obj.add("level",output.readUnsignedInt());
         obj.add("exp",output.readUnsignedInt());
         obj.add("nextExp",output.readUnsignedInt());
         obj.add("beautyHouseLvl",output.readUnsignedInt());
         obj.add("machineHouseLvl",output.readUnsignedInt());
         obj.add("workHouseLvl",output.readUnsignedInt());
         obj.add("honor",output.readUnsignedInt());
         obj.add("feedCnt",output.readUnsignedInt());
         obj.add("workHouseCnt",output.readUnsignedInt());
         obj.add("batheTime",output.readUnsignedInt());
         obj.add("team",output.readUnsignedInt());
         obj.add("bgId",output.readUnsignedInt());
         obj.add("teamMsg",output.readUTFBytes(56));
         var pigCount:int = int(output.readUnsignedInt());
         var pigs:HashMap = new HashMap();
         for(var i:int = 0; i < pigCount; i++)
         {
            pig = new HashMap();
            pig.add("id",output.readUnsignedInt());
            pig.add("itemId",output.readUnsignedInt());
            pig.add("breed",output.readUnsignedInt());
            pig.add("sex",output.readUnsignedInt());
            pig.add("hunger",output.readUnsignedInt());
            pig.add("state",output.readUnsignedInt());
            pig.add("teaseCont",output.readUnsignedInt());
            pig.add("transformId",output.readUnsignedInt());
            pig.add("dress_1",output.readUnsignedInt());
            pig.add("dress_2",output.readUnsignedInt());
            pigs.add(pig.getValue("id"),pig);
         }
         obj.add("pigs",pigs);
         if(_type == 1)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetPigHouseInfoCmd,obj));
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetPigHouseInfoCmd + "_2",obj));
         }
      }
      
      public static function GetPigInfo(userId:Number, pigId:int) : void
      {
         MsgHead.Command = GetPigInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         tempByteArray.writeUnsignedInt(pigId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetPigInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var pig:HashMap = new HashMap();
         pig.add("id",output.readUnsignedInt());
         pig.add("itemId",output.readUnsignedInt());
         pig.add("matherName",output.readUTFBytes(16));
         pig.add("fatherName",output.readUTFBytes(16));
         pig.add("name",output.readUTFBytes(16));
         pig.add("state",output.readUnsignedInt());
         pig.add("age",output.readUnsignedInt());
         pig.add("liftTime",output.readUnsignedInt());
         pig.add("hunger",output.readUnsignedInt());
         pig.add("breed",output.readUnsignedInt());
         pig.add("generation",output.readUnsignedInt());
         pig.add("sex",output.readUnsignedInt());
         pig.add("isSpecial",output.readUnsignedInt());
         pig.add("growthSpeed",output.readUnsignedInt());
         pig.add("weight",output.readUnsignedInt());
         pig.add("glamour",output.readUnsignedInt());
         pig.add("strength",output.readUnsignedInt());
         pig.add("transformId",output.readUnsignedInt());
         pig.add("transformTime",output.readUnsignedInt());
         pig.add("mateCount",output.readUnsignedInt());
         pig.add("teaseCont",output.readUnsignedInt());
         pig.add("trainPoint",output.readUnsignedInt());
         pig.add("babyTime",output.readUnsignedInt());
         pig.add("dress_1",output.readUnsignedInt());
         pig.add("dress_2",output.readUnsignedInt());
         pig.add("able_inject",output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetPigInfoCmd,pig));
      }
      
      public static function GetBag() : void
      {
         MsgHead.Command = GetBagCmd;
         GF.writeHead();
      }
      
      public static function res_GetBag() : void
      {
         var item:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var itemCount:int = int(output.readUnsignedInt());
         var items:Array = new Array();
         for(var i:int = 0; i < itemCount; i++)
         {
            item = new Object();
            item.id = output.readUnsignedInt();
            item.count = output.readUnsignedInt();
            items.push(item);
         }
         obj.items = items;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetBagCmd,obj));
      }
      
      public static function SellItem(isPig:*, id:int = 0, count:int = 1, pigArr:Array = null) : void
      {
         var i:int = 0;
         MsgHead.Command = SellItemCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(int(isPig));
         if(Boolean(isPig))
         {
            tempByteArray.writeUnsignedInt(pigArr.length);
            for(i = 0; i < pigArr.length; i++)
            {
               tempByteArray.writeUnsignedInt(pigArr[i]);
            }
         }
         else
         {
            tempByteArray.writeUnsignedInt(id);
            tempByteArray.writeUnsignedInt(count);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_SellItem() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.gold = output.readUnsignedInt();
         obj.result = output.readUnsignedInt();
         obj.canSellNum = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SellItemCmd,obj));
      }
      
      public static function AddPig(itemId:int) : void
      {
         MsgHead.Command = AddPigCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_AddPig() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var pig:HashMap = new HashMap();
         pig.add("isOk",output.readUnsignedInt());
         pig.add("id",output.readUnsignedInt());
         pig.add("itemId",output.readUnsignedInt());
         pig.add("breed",output.readUnsignedInt());
         pig.add("sex",output.readUnsignedInt());
         pig.add("hunger",output.readUnsignedInt());
         pig.add("state",output.readUnsignedInt());
         pig.add("transformId",output.readUnsignedInt());
         pig.add("dress_1",output.readUnsignedInt());
         pig.add("dress_2",output.readUnsignedInt());
         pig.add("teaseCont",0);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + AddPigCmd,pig));
      }
      
      public static function AddFood(userId:int, foodId:int) : void
      {
         MsgHead.Command = AddFoodCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         tempByteArray.writeUnsignedInt(foodId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_AddFood() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         obj.consume = output.readUnsignedInt();
         obj.feedCnt = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.weight = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + AddFoodCmd,obj));
      }
      
      public static function Bathe(userId:int) : void
      {
         MsgHead.Command = BatheCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_Bathe() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.isOk = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.time = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + BatheCmd,obj));
         GF.sendSocket(CommandID.GOLDEN_BEAN_REWARD,0,2);
      }
      
      public static function Tease(pigId:int) : void
      {
         MsgHead.Command = TeaseCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(pigId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_Tease() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.pigId = output.readUnsignedInt();
         obj.isOk = output.readUnsignedInt();
         obj.weight = output.readUnsignedInt();
         obj.glamour = output.readUnsignedInt();
         obj.strength = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + TeaseCmd,obj));
      }
      
      public static function Train(pigId:int, type:int) : void
      {
         MsgHead.Command = TrainCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(pigId);
         tempByteArray.writeUnsignedInt(type - 1);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_Train() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.pigId = output.readUnsignedInt();
         obj.isOk = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.weight = output.readUnsignedInt();
         obj.glamour = output.readUnsignedInt();
         obj.strength = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + TrainCmd,obj));
      }
      
      public static function ChangeName(pigId:int, name:String) : void
      {
         MsgHead.Command = ChangeNameCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(pigId);
         tempByteArray.writeBytes(StringUtil.FillString(name,16));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ChangeName() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.isOk = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + ChangeNameCmd,obj));
      }
      
      public static function SetTeam(teamId:int, msg:String) : void
      {
         MsgHead.Command = SetTeamCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(teamId);
         tempByteArray.writeBytes(StringUtil.FillString(msg,56));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_SetTeam() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.isOk = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SetTeamCmd,obj));
      }
      
      public static function res_UpLevel() : void
      {
         var item:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.level = output.readUnsignedInt();
         var arr:Array = new Array();
         var count:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            item = new Object();
            item.id = output.readUnsignedInt();
            item.count = output.readUnsignedInt();
            arr.push(item);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UpLevelCmd,obj));
      }
      
      public static function GetFriendsInfo(array:Array) : void
      {
         MsgHead.Command = GetFriendsInfoCmd;
         if(array == null)
         {
            return;
         }
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(array.length);
         for(var i:int = 0; i < array.length; i++)
         {
            if(array[i].friend != 0)
            {
               tempByteArray.writeUnsignedInt(array[i].friend);
            }
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetFriendsInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:HashMap = new HashMap();
         var friendCount:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < friendCount; i++)
         {
            obj.add(output.readUnsignedInt(),output.readUnsignedInt());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetFriendsInfoCmd,obj));
      }
      
      public static function GetLuckInfo(type:int = 0) : void
      {
         MsgHead.Command = GetLuckCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetLuck() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         obj.id = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         obj.nextTime = output.readInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetLuckCmd,obj));
      }
      
      public static function UseItem(itemId:int, pigId:int) : void
      {
         MsgHead.Command = UseItemCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemId);
         tempByteArray.writeUnsignedInt(pigId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UseItem() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         obj.itemId = output.readUnsignedInt();
         obj.pigId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UseItemCmd,obj));
      }
      
      public static function GetNotice(userId:int) : void
      {
         MsgHead.Command = GetNoticeCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetNotice() : void
      {
         var item:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var arr:Array = new Array();
         var count:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            item = new Object();
            item.time = output.readUnsignedInt();
            item.type = output.readUnsignedInt();
            item.operator = output.readUnsignedInt();
            item.awardId = output.readInt();
            item.count = output.readUnsignedInt();
            item.pigName = output.readUTFBytes(16);
            arr.push(item);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetNoticeCmd,obj));
      }
      
      public static function MachiningPig(procID:int, pigID:int) : void
      {
         MsgHead.Command = MachiningPigCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(procID);
         tempByteArray.writeUnsignedInt(pigID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_MachiningPig() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         obj.award = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + MachiningPigCmd,obj));
      }
      
      public static function IllustratedHandbook(userID:uint) : void
      {
         MsgHead.Command = IllustratedHandbookCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         GF.writeHead(tempByteArray);
         GF.writeHead();
      }
      
      public static function res_IllustratedHandbook() : void
      {
         var breed:int = 0;
         var output:IDataInput = GV.onlineSocket;
         var count:int = int(output.readUnsignedInt());
         var arr:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            breed = int(output.readUnsignedInt());
            arr.push(breed);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + IllustratedHandbookCmd,arr));
      }
      
      public static function SelectTaskMsg() : void
      {
         MsgHead.Command = SelectTaskMsgCmd;
         GF.writeHead();
      }
      
      public static function res_SelectTaskMsg() : void
      {
         var obj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var count:int = int(output.readUnsignedInt());
         var arr:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            obj = new Object();
            obj.TaskID = output.readUnsignedInt();
            obj.TaskCnt = output.readUnsignedInt();
            obj.TaskState = output.readUnsignedInt();
            arr.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SelectTaskMsgCmd,arr));
      }
      
      public static function AcceptTask(taskID:int) : void
      {
         MsgHead.Command = AcceptTaskCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(taskID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_AcceptTask() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var taskID:int = int(output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + AcceptTaskCmd,taskID));
      }
      
      public static function OverTask(taskID:int) : void
      {
         MsgHead.Command = OverTaskCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(taskID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_OverTask() : void
      {
         var itemObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.isOK = output.readUnsignedInt();
         obj.gold = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.itemKind = output.readUnsignedInt();
         obj.itemArr = new Array();
         for(var i:int = 0; i < obj.itemKind; i++)
         {
            itemObj = new Object();
            itemObj.itemID = output.readUnsignedInt();
            itemObj.itemCnt = output.readUnsignedInt();
            obj.itemArr.push(itemObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + OverTaskCmd,obj));
      }
      
      public static function GetFriendPig(friendID:uint) : void
      {
         MsgHead.Command = GetFriendPigCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(friendID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetFriendPig() : void
      {
         var obj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var count:int = int(output.readUnsignedInt());
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            obj = new Object();
            obj.PigID = output.readUnsignedInt();
            obj.ItemID = output.readUnsignedInt();
            obj.BreedID = output.readUnsignedInt();
            obj.Star = output.readUnsignedInt();
            obj.PigName = output.readUTFBytes(16);
            arr.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetFriendPigCmd,arr));
      }
      
      public static function BreedPig(pigID:int, tarUserID:uint, tarPigID:int) : void
      {
         MsgHead.Command = BreedPigCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(pigID);
         tempByteArray.writeUnsignedInt(tarUserID);
         tempByteArray.writeUnsignedInt(tarPigID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_BreedPig() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.isOK = output.readUnsignedInt();
         obj.Cost = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + BreedPigCmd,obj));
      }
      
      public static function BuildUpLevel(type:int) : void
      {
         MsgHead.Command = BuildUpLevelCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_BuildUpLevel() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.isOK = output.readUnsignedInt();
         obj.Cost = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + BuildUpLevelCmd,obj));
      }
      
      public static function GetPigTicket() : void
      {
         MsgHead.Command = GetPigTicketCmd;
         GF.writeHead();
      }
      
      public static function res_GetPigTicket() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetPigTicketCmd,obj));
      }
      
      public static function UseCard(cardId:uint, targetUserId:int) : void
      {
         MsgHead.Command = UseCardCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(cardId);
         tempByteArray.writeUnsignedInt(targetUserId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UseCard() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UseCardCmd,obj));
      }
      
      public static function GetCardBuffInfo(targetUserId:int) : void
      {
         MsgHead.Command = GetCardBuffInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(targetUserId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetCardBuffInfo() : void
      {
         var item:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         var arr:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            item = new Object();
            item.cardId = output.readUnsignedInt();
            item.time = output.readUnsignedInt();
            item.userId = output.readUnsignedInt();
            arr.push(item);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetCardBuffInfoCmd,obj));
      }
      
      public static function ExchangePigByGoods() : void
      {
         MsgHead.Command = ExchangePigByGoodsCmd;
         GF.writeHead();
      }
      
      public static function res_ExchangePigByGoods() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + ExchangePigByGoodsCmd,{}));
      }
      
      public static function SetBG(bgId:int) : void
      {
         MsgHead.Command = SetBGCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(bgId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_SetBG() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var result:int = int(output.readUnsignedInt());
         obj.result = result;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SetBGCmd,obj));
      }
      
      public static function FollowMole(pigId:int, isFollow:Boolean = true) : void
      {
         MsgHead.Command = FollowMoleCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(pigId);
         tempByteArray.writeUnsignedInt(int(isFollow));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_FollowMole() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.pigId = output.readUnsignedInt();
         obj.itemId = output.readUnsignedInt();
         obj.state = output.readUnsignedInt();
         obj.transformId = output.readUnsignedInt();
         obj.transformTime = output.readUnsignedInt();
         obj.dress_1 = output.readUnsignedInt();
         obj.dress_2 = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + FollowMoleCmd,obj));
      }
      
      public static function GetTempHouseInfo(userID:uint) : void
      {
         MsgHead.Command = GetTempHouseInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetTempHouseInfo() : void
      {
         var pig:HashMap = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         var pigs:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            pig = new HashMap();
            pig.add("id",output.readUnsignedInt());
            pig.add("itemId",output.readUnsignedInt());
            pigs.push(pig);
         }
         obj.pigs = pigs;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetTempHouseInfoCmd,obj));
      }
      
      public static function SendToTempHouse(type:int, pigIds:Array) : void
      {
         var length:int = int(pigIds.length);
         if(length <= 0)
         {
            return;
         }
         MsgHead.Command = SendToTempHouseCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(length);
         for(var i:int = 0; i < length; i++)
         {
            tempByteArray.writeUnsignedInt(pigIds[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_SendToTempHouse() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.isOk = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SendToTempHouseCmd,obj));
      }
      
      public static function GetShowStageInfo(userID:uint) : void
      {
         MsgHead.Command = GetShowStageInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetShowStageInfo() : void
      {
         var itemObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.lvl = output.readUnsignedInt();
         obj.showCount = output.readUnsignedInt();
         obj.itemCount = output.readUnsignedInt();
         obj.arr = [];
         for(var i:int = 0; i < obj.itemCount; i++)
         {
            itemObj = new Object();
            itemObj.itemID = output.readUnsignedInt();
            itemObj.lastTime = output.readUnsignedInt();
            obj.arr.push(itemObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetShowStageInfoCmd,obj));
      }
      
      public static function ShowPig(tarID:uint, myPigsArr:Array, tarPigsArr:Array, itemArr:Array) : void
      {
         MsgHead.Command = ShowPigCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(tarID);
         for(var i:int = 0; i < 3; i++)
         {
            tempByteArray.writeUnsignedInt(myPigsArr[i]);
         }
         for(i = 0; i < 3; i++)
         {
            tempByteArray.writeUnsignedInt(tarPigsArr[i]);
         }
         for(i = 0; i < 8; i++)
         {
            tempByteArray.writeUnsignedInt(itemArr[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ShowPig() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         obj.myScore = output.readUnsignedInt();
         obj.tarScore = output.readUnsignedInt();
         obj.addExp = output.readUnsignedInt();
         obj.gold = output.readUnsignedInt();
         obj.attributes = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + ShowPigCmd,obj));
         GF.sendSocket(CommandID.GOLDEN_BEAN_REWARD,0,5);
      }
      
      public static function BeautyMatchGetAward() : void
      {
         MsgHead.Command = BeautyMatchGetAwardCmd;
         GF.writeHead();
      }
      
      public static function res_BeautyMatchGetAward() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemID = output.readUnsignedInt();
         obj.itemCount = output.readUnsignedInt();
         obj.itemID2 = output.readUnsignedInt();
         obj.itemCount2 = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + BeautyMatchGetAwardCmd,obj));
      }
      
      public static function SelectBeautyDayAndAllCount() : void
      {
         MsgHead.Command = SelectBeautyDayAndAllCountCmd;
         GF.writeHead();
      }
      
      public static function res_SelectBeautyDayAndAllCount() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Last_cnt = output.readUnsignedInt();
         obj.Today_cnt = output.readUnsignedInt();
         obj.All_cnt = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SelectBeautyDayAndAllCountCmd,obj));
      }
      
      public static function res_SpecialGiftBroadcast() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Gift_type = output.readUnsignedInt();
         obj.All_Cnt = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SpecialGiftBroadcastCmd,obj));
      }
      
      public static function GetSpecialGift() : void
      {
         MsgHead.Command = GetSpecialGiftCmd;
         GF.writeHead();
      }
      
      public static function res_GetSpecialGift() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemID = output.readUnsignedInt();
         obj.itemCount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetSpecialGiftCmd,obj));
      }
      
      public static function GetBeautyMatchResult(type:int, npc:int, myPigs:Array, itemArr:Array) : void
      {
         MsgHead.Command = GetBeautyMatchResultCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(npc);
         for(var i:int = 0; i < myPigs.length; i++)
         {
            tempByteArray.writeUnsignedInt(myPigs[i]);
         }
         for(i = 0; i < itemArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(itemArr[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetBeautyMatchResult() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.is_win = output.readUnsignedInt();
         obj.My_score = output.readUnsignedInt();
         obj.Npc_score = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetBeautyMatchResultCmd,obj));
      }
      
      public static function FatPigMatch(pigID:int) : void
      {
         MsgHead.Command = FatPigMatchCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(pigID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_FatPigMatch() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.isWin = output.readUnsignedInt();
         obj.npc_pig_id = output.readUnsignedInt();
         obj.my_weight = output.readUnsignedInt();
         obj.tar_weight = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + FatPigMatchCmd,obj));
      }
      
      public static function GetFatMatchAwardsState() : void
      {
         MsgHead.Command = GetFatMatchAwardsStateCmd;
         GF.writeHead();
      }
      
      public static function res_GetFatMatchAwardsState() : void
      {
         var num:int = 0;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         obj.resultArr = new Array();
         var tmp:int = int(obj.result);
         for(var i:int = 0; i < 4; i++)
         {
            num = tmp % 2;
            tmp /= 2;
            obj.resultArr.push(num);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetFatMatchAwardsStateCmd,obj));
      }
      
      public static function GetAchieveState() : void
      {
         MsgHead.Command = GetAchieveStateCmd;
         GF.writeHead();
      }
      
      public static function res_GetAchieveState() : void
      {
         var num:int = 0;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         obj.resultArr = new Array();
         var tmp:int = int(obj.state);
         for(var i:int = 0; i < 5; i++)
         {
            num = tmp % 4;
            tmp /= 4;
            obj.resultArr.push(num);
         }
         obj.result_cnt = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetAchieveStateCmd,obj));
      }
      
      public static function GetAchieveAwards(achieve_id:int) : void
      {
         MsgHead.Command = GetAchieveAwardsCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(achieve_id);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetAchieveAwards() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.res = output.readUnsignedInt();
         obj.itemID = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetAchieveAwardsCmd,obj));
      }
      
      public static function GetHasHonor(userID:uint) : void
      {
         MsgHead.Command = GetHasHonorCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetHasHonor() : void
      {
         var tmp:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.count = output.readUnsignedInt();
         obj.hasHonor = [];
         for(var i:int = 0; i < obj.count; i++)
         {
            tmp = new Object();
            tmp.honorID = output.readUnsignedInt();
            tmp.HonorCnt = output.readUnsignedInt();
            tmp.MaxCnt = output.readUnsignedInt();
            obj.hasHonor.push(tmp);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetHasHonorCmd,obj));
      }
      
      public static function TmpHouseExchange(pigHouseID:uint, tmpHouseID:uint) : void
      {
         MsgHead.Command = TmpHouseExchangeCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(pigHouseID);
         tempByteArray.writeUnsignedInt(tmpHouseID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_TmpHouseExchange() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + TmpHouseExchangeCmd,obj));
      }
      
      public static function SelectMachinistSquareInfo(userID:uint) : void
      {
         MsgHead.Command = SelectMachinistSquareInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_SelectMachinistSquareInfo() : void
      {
         var pig:HashMap = null;
         var machine:HashMap = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:HashMap = new HashMap();
         obj.add("state",output.readUnsignedInt());
         obj.add("machine_lvl",output.readUnsignedInt());
         obj.add("warhouse_lvl",output.readUnsignedInt());
         obj.add("exp",output.readUnsignedInt());
         obj.add("nextExp",output.readUnsignedInt());
         obj.add("pigHouseLevel",output.readUnsignedInt());
         obj.add("pigsCount",output.readUnsignedInt());
         var pigCount:int = int(output.readUnsignedInt());
         var machineCount:int = int(output.readUnsignedInt());
         var pigs:HashMap = new HashMap();
         for(var i:int = 0; i < pigCount; i++)
         {
            pig = new HashMap();
            pig.add("id",output.readUnsignedInt());
            pig.add("itemId",output.readUnsignedInt());
            pig.add("breed",output.readUnsignedInt());
            pig.add("sex",output.readUnsignedInt());
            pig.add("dress_1",output.readUnsignedInt());
            pig.add("dress_2",output.readUnsignedInt());
            pig.add("energy",output.readUnsignedInt());
            pig.add("max_energy",output.readUnsignedInt());
            pigs.add(pig.getValue("id"),pig);
         }
         obj.add("pigs",pigs);
         var machines:Array = new Array();
         for(var j:uint = 0; j < machineCount; j++)
         {
            machine = new HashMap();
            machine.add("tool_type",output.readUnsignedInt());
            machine.add("tool_index",output.readUnsignedInt());
            machine.add("tool_lvl",output.readUnsignedInt());
            machine.add("work_state",output.readUnsignedInt());
            machine.add("work_time",output.readUnsignedInt());
            machine.add("work_totaltime",output.readUnsignedInt());
            machine.add("buffID",output.readUnsignedInt());
            machines.push(machine);
         }
         obj.add("machines",machines);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SelectMachinistSquareInfoCmd,obj));
      }
      
      public static function CutePigExplorMap(pigID:uint, mapID:uint) : void
      {
         MsgHead.Command = CutePigExplorMapCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(pigID);
         tempByteArray.writeUnsignedInt(mapID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_CutePigExplorMap() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CutePigExplorMapCmd,obj));
      }
      
      public static function SelectCutePigExplorInfo() : void
      {
         MsgHead.Command = SelectCutePigExplorInfoCmd;
         GF.writeHead();
      }
      
      public static function res_SelectCutePigExplorInfo() : void
      {
         var tmp:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Count = output.readUnsignedInt();
         obj.explorInfo = [];
         for(var i:uint = 0; i < obj.Count; i++)
         {
            tmp = new Object();
            tmp.mapID = output.readUnsignedInt();
            tmp.pigID = output.readUnsignedInt();
            tmp.endTime = output.readUnsignedInt();
            obj.explorInfo.push(tmp);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SelectCutePigExplorInfoCmd,obj));
      }
      
      public static function takeBackPig(mapID:int) : void
      {
         MsgHead.Command = TAKE_BACK_PIG_CMD;
         var tempByteArr:ByteArray = new ByteArray();
         tempByteArr.writeUnsignedInt(mapID);
         GF.writeHead(tempByteArr);
      }
      
      public static function res_TakeBackPig() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + TAKE_BACK_PIG_CMD,{}));
      }
      
      public static function PigLetMeltOre(stoveID:uint, oreID:uint, type:int, pigs:Array) : void
      {
         MsgHead.Command = PigLetMeltOreCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(stoveID);
         tempByteArray.writeUnsignedInt(oreID);
         tempByteArray.writeUnsignedInt(type);
         var len:uint = pigs.length;
         tempByteArray.writeUnsignedInt(len);
         for(var i:uint = 0; i < len; i++)
         {
            tempByteArray.writeUnsignedInt(pigs[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_PigLetMeltOre() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         obj.machine = new HashMap();
         obj.machine.add("tool_type",output.readUnsignedInt());
         obj.machine.add("tool_index",output.readUnsignedInt());
         obj.machine.add("tool_lvl",output.readUnsignedInt());
         obj.machine.add("work_state",output.readUnsignedInt());
         obj.machine.add("work_time",output.readUnsignedInt());
         obj.machine.add("work_totaltime",output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + PigLetMeltOreCmd,obj));
      }
      
      public static function ProduceMachinePart(toolID:uint, partID:uint, count:uint, pigs:Array) : void
      {
         MsgHead.Command = ProduceMachinePartCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(toolID);
         tempByteArray.writeUnsignedInt(partID);
         tempByteArray.writeUnsignedInt(count);
         var len:uint = pigs.length;
         tempByteArray.writeUnsignedInt(len);
         for(var i:uint = 0; i < len; i++)
         {
            tempByteArray.writeUnsignedInt(pigs[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ProduceMachinePart() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         obj.machine = new HashMap();
         obj.machine.add("tool_type",output.readUnsignedInt());
         obj.machine.add("tool_index",output.readUnsignedInt());
         obj.machine.add("tool_lvl",output.readUnsignedInt());
         obj.machine.add("work_state",output.readUnsignedInt());
         obj.machine.add("work_time",output.readUnsignedInt());
         obj.machine.add("work_totaltime",output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + ProduceMachinePartCmd,obj));
      }
      
      public static function PigLetFinishWorl(toolType:uint, toolID:uint) : void
      {
         MsgHead.Command = PigLetFinishWorlCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(toolType);
         tempByteArray.writeUnsignedInt(toolID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_PigLetFinishWorl() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         obj.itemID = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + PigLetFinishWorlCmd,obj));
      }
      
      public static function ProduceSpecialMachine(type:uint, itemID:uint) : void
      {
         MsgHead.Command = ProduceSpecialMachineCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(itemID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ProduceSpecialMachine() : void
      {
         GV.onlineSocket.dispatchEvent(new Event("read_" + ProduceSpecialMachineCmd));
      }
      
      public static function getNewStep() : void
      {
         MsgHead.Command = GET_NEW_STEP_CMD;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead();
      }
      
      public static function res_GetNewStep() : void
      {
         var step:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_NEW_STEP,{"step":step}));
      }
      
      public static function setNewStep(step:int) : void
      {
         MsgHead.Command = SET_NEW_STEP_CMD;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(step);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_SetNewStep() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(SET_NEW_STEP,{}));
      }
      
      public static function MachineRandomGoods(userID:uint) : void
      {
         MsgHead.Command = MachineRandomGoodsCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_MachineRandomGoods() : void
      {
         var tmp:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.count = output.readUnsignedInt();
         obj.items = new Array();
         for(var i:uint = 0; i < obj.count; i++)
         {
            tmp = new Object();
            tmp.type = output.readUnsignedInt();
            tmp.index = output.readUnsignedInt();
            tmp.itemID = output.readUnsignedInt();
            tmp.count = output.readUnsignedInt();
            obj.items.push(tmp);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + MachineRandomGoodsCmd,obj));
      }
      
      public static function UserMachineGoods(uid:uint, toolID:uint, type:uint, index:uint) : void
      {
         MsgHead.Command = UserMachineGoodsCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(uid);
         tempByteArray.writeUnsignedInt(toolID);
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(index);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UserMachineGoods() : void
      {
         var itemID:uint = 0;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.count = output.readUnsignedInt();
         obj.items = [];
         for(var i:uint = 0; i < obj.count; i++)
         {
            itemID = output.readUnsignedInt();
            obj.items.push(itemID);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UserMachineGoodsCmd,obj));
      }
   }
}

