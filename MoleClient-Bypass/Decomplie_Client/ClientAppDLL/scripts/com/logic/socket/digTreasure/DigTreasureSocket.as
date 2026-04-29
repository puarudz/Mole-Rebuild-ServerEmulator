package com.logic.socket.digTreasure
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class DigTreasureSocket
   {
      
      public static const GetDigMapInfoCmd:int = 8021;
      
      public static const DigAreaCmd:int = 8023;
      
      public static const GetDigAwardCmd:int = 8024;
      
      public static const SyncHpCmd:int = 8027;
      
      public static const GetBagCmd:int = 8022;
      
      public static const UseItemCmd:int = 8025;
      
      public static const GIFTITEM:int = 8028;
      
      public function DigTreasureSocket()
      {
         super();
      }
      
      public static function GetDigMapInfo(digMapId:int, screenId:int) : void
      {
         MsgHead.Command = GetDigMapInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(digMapId);
         tempByteArray.writeUnsignedInt(screenId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetDigMapInfo() : void
      {
         var staticItem:Object = null;
         var randomItem:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.hp = output.readUnsignedInt();
         obj.level = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         var areas:Array = new Array();
         var staticCount:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < staticCount; i++)
         {
            staticItem = new Object();
            staticItem.index = output.readUnsignedInt();
            staticItem.digCount = output.readUnsignedInt();
            areas.push(staticItem);
         }
         var randomCount:int = int(output.readUnsignedInt());
         for(var j:int = 0; j < randomCount; j++)
         {
            randomItem = new Object();
            randomItem.index = output.readUnsignedInt();
            randomItem.digCount = output.readUnsignedInt();
            randomItem.posId = output.readUnsignedInt();
            areas.push(randomItem);
         }
         obj.areas = areas;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetDigMapInfoCmd,obj));
      }
      
      public static function DigArea(areaIndex:int) : void
      {
         MsgHead.Command = DigAreaCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(areaIndex);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_DigArea() : void
      {
         var award:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.index = output.readUnsignedInt();
         obj.digCount = output.readUnsignedInt();
         obj.hp = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.nextAddHpTime = output.readUnsignedInt();
         obj.isLevelUp = Boolean(output.readUnsignedInt());
         var awards:Array = new Array();
         var awardCount:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < awardCount; i++)
         {
            award = new Object();
            award.id = output.readUnsignedInt();
            award.count = output.readUnsignedInt();
            awards.push(award);
         }
         obj.awards = awards;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + DigAreaCmd,obj));
      }
      
      public static function GetDigAward(itemId:int, count:int) : void
      {
         MsgHead.Command = GetDigAwardCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemId);
         tempByteArray.writeUnsignedInt(count);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetDigAward() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.id = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetDigAwardCmd,obj));
      }
      
      public static function SyncHp() : void
      {
         MsgHead.Command = SyncHpCmd;
         GF.writeHead();
      }
      
      public static function res_SyncHp() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.hp = output.readUnsignedInt();
         obj.nextAddHpTime = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SyncHpCmd,obj));
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
         var items:Array = new Array();
         var count:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            item = new Object();
            item.id = output.readUnsignedInt();
            item.count = output.readUnsignedInt();
            items.push(item);
         }
         obj.items = items;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetBagCmd,obj));
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
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.hp = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + UseItemCmd,obj));
      }
      
      public static function res_giftItem() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.id = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GIFTITEM,obj));
      }
   }
}

