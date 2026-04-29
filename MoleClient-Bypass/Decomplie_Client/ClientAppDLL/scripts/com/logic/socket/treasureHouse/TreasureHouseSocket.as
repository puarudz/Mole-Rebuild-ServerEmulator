package com.logic.socket.treasureHouse
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TreasureHouseSocket
   {
      
      public static const GetTreasureHouseInfoCmd:int = 8001;
      
      public static const GetTreasureWareHouseCmd:int = 8002;
      
      public static const SetBoothCmd:int = 8003;
      
      public static const ChangeBoothCmd:int = 8004;
      
      public static const ChangeBoothStateCmd:int = 8008;
      
      public static const GetRankCmd:int = 8005;
      
      public static const GetGuestListCmd:int = 8006;
      
      public function TreasureHouseSocket()
      {
         super();
      }
      
      public static function GetTreasureHouseInfo(userId:Number) : void
      {
         MsgHead.Command = GetTreasureHouseInfoCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetTreasureHouseInfo() : void
      {
         var boothInfo:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.userId = output.readUnsignedInt();
         obj.isVip = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.level = output.readUnsignedInt();
         obj.bgId = output.readUnsignedInt();
         var booths:Array = new Array();
         var count:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            boothInfo = new Object();
            boothInfo.posId = output.readUnsignedInt();
            boothInfo.itemId = output.readUnsignedInt();
            boothInfo.state = output.readUnsignedInt();
            booths.push(boothInfo);
         }
         obj.booths = booths;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetTreasureHouseInfoCmd,obj));
      }
      
      public static function GetTreasureWareHouse(userId:Number, isIllustrated:Boolean = false) : void
      {
         MsgHead.Command = GetTreasureWareHouseCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         tempByteArray.writeUnsignedInt(int(isIllustrated));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetTreasureWareHouse() : void
      {
         var totalCount:int = 0;
         var itemInfo:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.userId = output.readUnsignedInt();
         var items:Array = new Array();
         var count:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            itemInfo = new Object();
            itemInfo.itemId = output.readUnsignedInt();
            itemInfo.count = output.readUnsignedInt();
            totalCount += itemInfo.count;
            items.push(itemInfo);
         }
         obj.items = items;
         obj.totalCount = totalCount;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetTreasureWareHouseCmd,obj));
      }
      
      public static function SetBooth(posId:int, itemId:int, state:int = 1) : void
      {
         MsgHead.Command = SetBoothCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(posId);
         tempByteArray.writeUnsignedInt(itemId);
         tempByteArray.writeUnsignedInt(state);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_SetBooth() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.posId = output.readUnsignedInt();
         obj.itemId = output.readUnsignedInt();
         obj.state = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + SetBoothCmd,obj));
      }
      
      public static function ChangeBooth(fromPosId:int, toPosId:int) : void
      {
         MsgHead.Command = ChangeBoothCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(fromPosId);
         tempByteArray.writeUnsignedInt(toPosId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ChangeBooth() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.fromPosId = output.readUnsignedInt();
         obj.toPosId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + ChangeBoothCmd,obj));
      }
      
      public static function ChangeBoothState(posId:int, state:int) : void
      {
         MsgHead.Command = ChangeBoothStateCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(posId);
         tempByteArray.writeUnsignedInt(state);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ChangeBoothState() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.posId = output.readUnsignedInt();
         obj.state = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + ChangeBoothStateCmd,obj));
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
            userObj.level = int(output.readUnsignedInt());
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
      
      public static function GetGuestList(userId:Number) : void
      {
         MsgHead.Command = GetGuestListCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
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
            userObj.level = int(output.readUnsignedInt());
            obj.visitorList.push(userObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetGuestListCmd,obj));
      }
   }
}

