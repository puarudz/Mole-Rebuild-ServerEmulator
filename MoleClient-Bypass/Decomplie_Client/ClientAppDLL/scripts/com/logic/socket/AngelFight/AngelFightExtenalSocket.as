package com.logic.socket.AngelFight
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   
   public class AngelFightExtenalSocket
   {
      
      public static const GetUserInfoCmd:int = 8200;
      
      public static const GetBagCmd:int = 8201;
      
      public static const GetSkillCmd:int = 8202;
      
      public static const GetCardsCmd:int = 8203;
      
      public static const UseItemCmd:int = 8204;
      
      public static const UseCardCmd:int = 8205;
      
      public static const WearAngelAndEquipCmd:int = 8207;
      
      public static const GetFriendsInfoCmd:int = 8208;
      
      public static const GetSkillLevelCmd:int = 8211;
      
      public static const UpLevelCmd:int = 8206;
      
      public static const GetGameOverCardsCmd:int = 8212;
      
      public static const SelectGameOverCardCmd:int = 8213;
      
      public static const GetMapInfoCmd:int = 8210;
      
      public static const WishItemCmd:int = 8214;
      
      public static const ArchiveFriendWishCmd:int = 8215;
      
      public static const GetWishStateCmd:int = 8216;
      
      public static const HandleFriendEventCmd:int = 8217;
      
      public static const GetFriendEventsCmd:int = 8218;
      
      public static const GetMessagesCmd:int = 8219;
      
      public static const GetWishAwardCmd:int = 8220;
      
      public static const GetTaskStateCmd:int = 8221;
      
      public static const FinishTaskCmd:int = 8222;
      
      public static const RefreshTaskCmd:int = 8223;
      
      public static const getChallengeCountCmd:int = 8224;
      
      public static const GetDiscipleMarketCmd:int = 8225;
      
      public static const GetDiscipleMasterInfoCmd:int = 8226;
      
      public static const CheckCanAddDiscipleCmd:int = 8227;
      
      public static const GetTrainingInfoCmd:int = 8228;
      
      public static const TrainingCmd:int = 8229;
      
      public static const DeleteDiscipleCmd:int = 8230;
      
      public static const SendCashToMasterCmd:int = 8231;
      
      public static const GetCashFromDiscipleCmd:int = 8232;
      
      public static const BetrayMasterCmd:int = 8233;
      
      public static const OutMasterDoorCmd:int = 8234;
      
      public static const GetMasterAndDiscipleMsgCmd:int = 8235;
      
      public static const FightEndAddDiscipleCmd:int = 8236;
      
      public static const GetPvpRecordCmd:int = 8237;
      
      public static const GetPvpAwardCmd:int = 8238;
      
      public static const GetDonatePointCmd:int = 8241;
      
      public static const DonateCardCmd:int = 8239;
      
      public static const ChangeCardCmd:int = 8240;
      
      public function AngelFightExtenalSocket()
      {
         super();
      }
      
      public static function GetUserInfo(userId:Number) : void
      {
         MsgHead.Command = GetUserInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetUserInfo() : void
      {
         var state:Object = null;
         var angel:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.userId = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.maxExp = output.readUnsignedInt();
         obj.level = output.readUnsignedInt();
         obj.wisdom = output.readUnsignedInt();
         obj.flexibility = output.readUnsignedInt();
         obj.power = output.readUnsignedInt();
         obj.strong = output.readUnsignedInt();
         obj.HP = output.readUnsignedInt();
         obj.MP = output.readUnsignedInt();
         obj.energy = output.readUnsignedInt();
         obj.maxEnergy = output.readUnsignedInt();
         obj.vigour = output.readUnsignedInt();
         obj.maxVigour = output.readUnsignedInt();
         obj.collectValue = output.readUnsignedInt();
         obj.addPhysiqueValue = output.readUnsignedInt();
         obj.clothId = output.readUnsignedInt();
         obj.pvpCount = output.readUnsignedInt();
         var stateCount:int = int(output.readUnsignedInt());
         var states:Array = new Array();
         for(var i:int = 0; i < stateCount; i++)
         {
            state = new Object();
            state.type = output.readUnsignedInt();
            state.count = output.readUnsignedInt();
            states.push(state);
         }
         obj.states = states;
         var angelCount:int = int(output.readUnsignedInt());
         var angels:Array = new Array();
         for(var j:int = 0; j < angelCount; j++)
         {
            angel = new Object();
            angel.id = output.readUnsignedInt();
            angel.level = output.readUnsignedInt();
            angels.push(angel);
         }
         obj.angels = angels;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetUserInfoCmd,obj));
      }
      
      public static function GetBag() : void
      {
         MsgHead.Command = GetBagCmd;
         GF.writeHead();
      }
      
      public static function res_GetBag() : void
      {
         var card:Object = null;
         var item:Object = null;
         var equipitem:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var cardCount:int = int(output.readUnsignedInt());
         var cardArr:Array = new Array();
         for(var i:int = 0; i < cardCount; i++)
         {
            card = new Object();
            card.id = output.readUnsignedInt();
            card.count = output.readUnsignedInt();
            cardArr.push(card);
         }
         obj.cardArr = cardArr;
         var itemCount:int = int(output.readUnsignedInt());
         var itemArr:Array = new Array();
         for(var j:int = 0; j < itemCount; j++)
         {
            item = new Object();
            item.id = output.readUnsignedInt();
            item.count = output.readUnsignedInt();
            itemArr.push(item);
         }
         obj.itemArr = itemArr;
         var equipCount:int = int(output.readUnsignedInt());
         var equipArr:Array = new Array();
         for(var k:int = 0; k < equipCount; k++)
         {
            equipitem = new Object();
            equipitem.id = output.readUnsignedInt();
            equipitem.count = output.readUnsignedInt();
            equipArr.push(equipitem);
         }
         obj.equipArr = equipArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetBagCmd,obj));
      }
      
      public static function GetSkill(userId:Number) : void
      {
         MsgHead.Command = GetSkillCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetSkill() : void
      {
         var skill:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var skillCount:int = int(output.readUnsignedInt());
         var dic:Dictionary = new Dictionary();
         for(var i:int = 0; i < skillCount; i++)
         {
            skill = new Object();
            skill.id = output.readUnsignedInt();
            skill.level = output.readUnsignedInt();
            dic[skill.id] = skill;
         }
         obj.dic = dic;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetSkillCmd,obj));
      }
      
      public static function GetCards(userId:Number) : void
      {
         MsgHead.Command = GetCardsCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetCards() : void
      {
         var card:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var cardCount:int = int(output.readUnsignedInt());
         var cardDic:Dictionary = new Dictionary();
         for(var i:int = 0; i < cardCount; i++)
         {
            card = new Object();
            card.id = output.readUnsignedInt();
            card.collectCount = output.readUnsignedInt();
            cardDic[card.id] = card;
         }
         obj.count = cardCount;
         obj.cardDic = cardDic;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetCardsCmd,obj));
      }
      
      public static function UseItem(itemId:int) : void
      {
         MsgHead.Command = UseItemCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UseItem() : void
      {
         var item:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         obj.itemId = output.readUnsignedInt();
         obj.dayAdded = output.readUnsignedInt();
         var count:int = int(output.readUnsignedInt());
         var items:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            item = new Object();
            item.id = output.readUnsignedInt();
            item.count = output.readUnsignedInt();
            items.push(item);
         }
         obj.items = items;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UseItemCmd,obj));
      }
      
      public static function UseCard(cardId:Number) : void
      {
         MsgHead.Command = UseCardCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(cardId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UseCard() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         obj.usedCount = output.readUnsignedInt();
         obj.cardId = output.readUnsignedInt();
         obj.archieveCard = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UseCardCmd,obj));
      }
      
      public static function WearAngelAndEquip(id:int, state:int = 1) : void
      {
         MsgHead.Command = WearAngelAndEquipCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(id);
         tempByteArray.writeUnsignedInt(state);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_WearAngelAndEquip() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.id = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + WearAngelAndEquipCmd,obj));
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
         var friend:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         var arr:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            friend = new Object();
            friend.id = output.readUnsignedInt();
            friend.exp = output.readUnsignedInt();
            friend.level = output.readUnsignedInt();
            arr.push(friend);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetFriendsInfoCmd,obj));
      }
      
      public static function GetSkillLevel(skillId:int) : void
      {
         MsgHead.Command = GetSkillLevelCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(skillId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetSkillLevel() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.id = output.readUnsignedInt();
         obj.level = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetSkillLevelCmd,obj));
      }
      
      public static function UpLevel(skillId:int, level:int) : void
      {
         MsgHead.Command = UpLevelCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(skillId);
         tempByteArray.writeUnsignedInt(level);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UpLevel() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         obj.id = output.readUnsignedInt();
         obj.level = output.readUnsignedInt();
         obj.archieveCard = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UpLevelCmd,obj));
      }
      
      public static function GetGameOverCards() : void
      {
         MsgHead.Command = GetGameOverCardsCmd;
         GF.writeHead();
      }
      
      public static function res_GetGameOverCards() : void
      {
         var card:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.exp = output.readUnsignedInt();
         obj.type = output.readUnsignedInt();
         obj.isWin = output.readUnsignedInt();
         var count:int = int(output.readUnsignedInt());
         var cards:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            card = new Object();
            card.id = output.readUnsignedInt();
            card.count = output.readUnsignedInt();
            cards.push(card);
         }
         obj.cards = cards;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetGameOverCardsCmd,obj));
      }
      
      public static function SelectGameOverCard(arr:Array) : void
      {
         var count:int = 0;
         var cardId:int = 0;
         MsgHead.Command = SelectGameOverCardCmd;
         var tempByteArray:ByteArray = new ByteArray();
         if(arr == null)
         {
            tempByteArray.writeUnsignedInt(0);
         }
         else
         {
            count = int(arr.length);
            tempByteArray.writeUnsignedInt(count);
            for each(cardId in arr)
            {
               tempByteArray.writeUnsignedInt(cardId);
            }
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_SelectGameOverCard() : void
      {
         var awardId:int = 0;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.isLevlUp = output.readUnsignedInt() == 1;
         obj.id = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         var awardCount:int = int(output.readUnsignedInt());
         var awards:Array = new Array();
         for(var i:int = 0; i < awardCount; i++)
         {
            awardId = int(output.readUnsignedInt());
            awards.push(awardId);
         }
         obj.awards = awards;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SelectGameOverCardCmd,obj));
      }
      
      public static function GetMapInfo(mapId:int) : void
      {
         MsgHead.Command = GetMapInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(mapId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetMapInfo() : void
      {
         var point:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         var arr:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            point = new Object();
            point.id = output.readUnsignedInt();
            point.finish = output.readUnsignedInt();
            arr.push(point);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetMapInfoCmd,obj));
      }
      
      public static function WishItem(itemId:int) : void
      {
         MsgHead.Command = WishItemCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_WishItem() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + WishItemCmd,obj));
      }
      
      public static function ArchiveFriendWish(friendId:int) : void
      {
         MsgHead.Command = ArchiveFriendWishCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(friendId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ArchiveFriendWish() : void
      {
         var count:int = 0;
         var i:int = 0;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         if(obj.state == 1)
         {
            obj.id = output.readUnsignedInt();
            obj.count = output.readUnsignedInt();
            obj.isLevelUp = output.readUnsignedInt();
            count = int(output.readUnsignedInt());
            obj.arr = new Array();
            for(i = 0; i < count; i++)
            {
               obj.arr.push(output.readUnsignedInt());
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + ArchiveFriendWishCmd,obj));
      }
      
      public static function GetWishState() : void
      {
         MsgHead.Command = GetWishStateCmd;
         GF.writeHead();
      }
      
      public static function res_GetWishState() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.id = output.readUnsignedInt();
         obj.needCount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetWishStateCmd,obj));
      }
      
      public static function HandleFriendEvent(friendId:int, eventId:int) : void
      {
         MsgHead.Command = HandleFriendEventCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(friendId);
         tempByteArray.writeUnsignedInt(eventId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_HandleFriendEvent() : void
      {
         var count:int = 0;
         var i:int = 0;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         if(obj.state == 1)
         {
            obj.id = output.readUnsignedInt();
            obj.count = output.readUnsignedInt();
            obj.isLevelUp = output.readUnsignedInt();
            count = int(output.readUnsignedInt());
            obj.arr = new Array();
            for(i = 0; i < count; i++)
            {
               obj.arr.push(output.readUnsignedInt());
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + HandleFriendEventCmd,obj));
      }
      
      public static function GetFriendEvents(array:Array) : void
      {
         MsgHead.Command = GetFriendEventsCmd;
         if(array == null || array.length == 0)
         {
            return;
         }
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(array.length);
         for(var i:int = 0; i < array.length; i++)
         {
            tempByteArray.writeUnsignedInt(array[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetFriendEvents() : void
      {
         var friend:Object = null;
         var eventCount:int = 0;
         var j:int = 0;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var friendCount:int = int(output.readUnsignedInt());
         var arr:Array = new Array();
         for(var i:int = 0; i < friendCount; i++)
         {
            friend = new Object();
            friend.id = output.readUnsignedInt();
            friend.state = output.readUnsignedInt();
            friend.events = new Array();
            eventCount = int(output.readUnsignedInt());
            for(j = 0; j < eventCount; j++)
            {
               friend.events.push(output.readUnsignedInt());
            }
            friend.events = friend.events.reverse();
            arr.push(friend);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetFriendEventsCmd,obj));
      }
      
      public static function GetMessages() : void
      {
         MsgHead.Command = GetMessagesCmd;
         GF.writeHead();
      }
      
      public static function res_GetMessages() : void
      {
         var msg:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         var arr:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            msg = new Object();
            msg.msgType = output.readUnsignedInt();
            msg.id = output.readUnsignedInt();
            msg.type = output.readUnsignedInt();
            msg.isWin = output.readUnsignedInt();
            msg.exp = output.readUnsignedInt();
            msg.time = output.readUnsignedInt();
            arr.push(msg);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetMessagesCmd,obj));
      }
      
      public static function GetWishAward() : void
      {
         MsgHead.Command = GetWishAwardCmd;
         GF.writeHead();
      }
      
      public static function res_GetWishAward() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.id = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetWishAwardCmd,obj));
      }
      
      public static function GetTaskState() : void
      {
         MsgHead.Command = GetTaskStateCmd;
         GF.writeHead();
      }
      
      public static function res_GetTaskState() : void
      {
         var task:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.refreshCount = output.readUnsignedInt();
         var count:int = int(output.readUnsignedInt());
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            task = new Object();
            task.id = output.readUnsignedInt();
            task.state = output.readUnsignedInt();
            task.finishCount = output.readUnsignedInt();
            arr.push(task);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetTaskStateCmd,obj));
      }
      
      public static function FinishTask(taskId:int, type:int) : void
      {
         MsgHead.Command = FinishTaskCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(taskId);
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_FinishTask() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.isLevelUp = output.readUnsignedInt();
         var count:int = int(output.readUnsignedInt());
         obj.arr = new Array();
         for(var i:int = 0; i < count; i++)
         {
            obj.arr.push(output.readUnsignedInt());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + FinishTaskCmd,obj));
      }
      
      public static function RefreshTask(taskId:int) : void
      {
         MsgHead.Command = RefreshTaskCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(taskId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_RefreshTask() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.id = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + RefreshTaskCmd,obj));
      }
      
      public static function getChallengeCount() : void
      {
         MsgHead.Command = getChallengeCountCmd;
         GF.writeHead();
      }
      
      public static function res_GetChallengeCount() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.normal = output.readUnsignedInt();
         obj.vip = output.readUnsignedInt();
         obj.limit = output.readUnsignedInt();
         obj.activity = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + getChallengeCountCmd,obj));
      }
      
      public static function GetDiscipleMarket(array:Array) : void
      {
         MsgHead.Command = GetDiscipleMarketCmd;
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
      
      public static function res_GetDiscipleMarket() : void
      {
         var friend:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            friend = new Object();
            friend.id = output.readUnsignedInt();
            friend.level = output.readUnsignedInt();
            friend.masterId = output.readUnsignedInt();
            friend.masterLevel = output.readUnsignedInt();
            arr.push(friend);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetDiscipleMarketCmd,obj));
      }
      
      public static function GetDiscipleMasterInfo(userId:int) : void
      {
         MsgHead.Command = GetDiscipleMasterInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetDiscipleMasterInfo() : void
      {
         var disciple:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.userId = output.readUnsignedInt();
         obj.merit = output.readUnsignedInt();
         obj.outCount = output.readUnsignedInt();
         obj.level = output.readUnsignedInt();
         obj.masterId = output.readUnsignedInt();
         obj.masterOutCount = output.readUnsignedInt();
         obj.masterLevel = output.readUnsignedInt();
         obj.masterMerit = output.readUnsignedInt();
         obj.masterDiscipleCount = output.readUnsignedInt();
         obj.canSendCash = output.readUnsignedInt();
         var count:int = int(output.readUnsignedInt());
         var disciples:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            disciple = new Object();
            disciple.id = output.readUnsignedInt();
            disciple.level = output.readUnsignedInt();
            disciple.hasDiscipleCash = output.readUnsignedInt();
            disciples.push(disciple);
         }
         obj.disciples = disciples;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetDiscipleMasterInfoCmd,obj));
      }
      
      public static function CheckCanAddDisciple(userId:int) : void
      {
         MsgHead.Command = CheckCanAddDiscipleCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_CheckCanAddDisciple() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CheckCanAddDiscipleCmd,obj));
      }
      
      public static function GetTrainingInfo(userId:int) : void
      {
         MsgHead.Command = GetTrainingInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetTrainingInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         var dic:Dictionary = new Dictionary();
         for(var i:int = 0; i < count; i++)
         {
            dic[output.readUnsignedInt()] = 1;
         }
         obj.dic = dic;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetTrainingInfoCmd,obj));
      }
      
      public static function Training(userId:int, trainId:int) : void
      {
         MsgHead.Command = TrainingCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         tempByteArray.writeUnsignedInt(trainId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_Training() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.exp = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + TrainingCmd,obj));
      }
      
      public static function DeleteDisciple(userId:int) : void
      {
         MsgHead.Command = DeleteDiscipleCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_DeleteDisciple() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Userid = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + DeleteDiscipleCmd,obj));
      }
      
      public static function SendCashToMaster() : void
      {
         MsgHead.Command = SendCashToMasterCmd;
         GF.writeHead();
      }
      
      public static function res_SendCashToMaster() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SendCashToMasterCmd,obj));
      }
      
      public static function GetCashFromDisciple(userId:int) : void
      {
         MsgHead.Command = GetCashFromDiscipleCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetCashFromDisciple() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetCashFromDiscipleCmd));
      }
      
      public static function BetrayMaster() : void
      {
         MsgHead.Command = BetrayMasterCmd;
         GF.writeHead();
      }
      
      public static function res_BetrayMaster() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + BetrayMasterCmd));
      }
      
      public static function OutMasterDoor(type:int, userId:int) : void
      {
         MsgHead.Command = OutMasterDoorCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_OutMasterDoor() : void
      {
         var item:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         obj.masterId = output.readUnsignedInt();
         obj.discipleId = output.readUnsignedInt();
         obj.outCount = output.readUnsignedInt();
         var count:int = int(output.readUnsignedInt());
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            item = new Object();
            item.id = output.readUnsignedInt();
            item.count = output.readUnsignedInt();
            arr.push(item);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + OutMasterDoorCmd,obj));
      }
      
      public static function GetMasterAndDiscipleMsg() : void
      {
         MsgHead.Command = GetMasterAndDiscipleMsgCmd;
         GF.writeHead();
      }
      
      public static function res_GetMasterAndDiscipleMsg() : void
      {
         var item:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            item = new Object();
            item.time = output.readUnsignedInt();
            item.masterId = output.readUnsignedInt();
            item.discipleId = output.readUnsignedInt();
            item.msgId = output.readUnsignedInt();
            item.exp = output.readUnsignedInt();
            item.merit = output.readUnsignedInt();
            arr.push(item);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetMasterAndDiscipleMsgCmd,obj));
      }
      
      public static function FightEndAddDisciple() : void
      {
         MsgHead.Command = FightEndAddDiscipleCmd;
         GF.writeHead();
      }
      
      public static function res_FightEndAddDisciple() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.masterId = output.readUnsignedInt();
         obj.discipleId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + FightEndAddDiscipleCmd,obj));
      }
      
      public static function GetPvpRecord() : void
      {
         MsgHead.Command = GetPvpRecordCmd;
         GF.writeHead();
      }
      
      public static function res_GetPvpRecord() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.dayCount = output.readUnsignedInt();
         obj.winCount = output.readUnsignedInt();
         var count:int = int(output.readUnsignedInt());
         var dic:Dictionary = new Dictionary();
         for(var i:int = 0; i < count; i++)
         {
            dic[output.readUnsignedInt()] = true;
         }
         obj.dic = dic;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetPvpRecordCmd,obj));
      }
      
      public static function GetPvpAward(winCount:int) : void
      {
         MsgHead.Command = GetPvpAwardCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(winCount);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetPvpAward() : void
      {
         var item:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         var count:int = int(output.readUnsignedInt());
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            item = new Object();
            item.id = output.readUnsignedInt();
            item.count = output.readUnsignedInt();
            arr.push(item);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetPvpAwardCmd,obj));
      }
      
      public static function GetDonatePoint() : void
      {
         MsgHead.Command = GetDonatePointCmd;
         GF.writeHead();
      }
      
      public static function res_GetDonatePoint() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.point = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetDonatePointCmd,obj));
      }
      
      public static function DonateCard(cardID:int, count:int) : void
      {
         MsgHead.Command = DonateCardCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(cardID);
         tempByteArray.writeUnsignedInt(count);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_DonateCard() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + DonateCardCmd,obj));
      }
      
      public static function ChangeCard(cardID:int, count:int) : void
      {
         MsgHead.Command = ChangeCardCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(cardID);
         tempByteArray.writeUnsignedInt(count);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ChangeCard() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + ChangeCardCmd,obj));
      }
   }
}

