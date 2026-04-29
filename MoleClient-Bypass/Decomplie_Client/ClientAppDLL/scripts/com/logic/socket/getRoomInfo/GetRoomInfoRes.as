package com.logic.socket.getRoomInfo
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class GetRoomInfoRes extends EventDispatcher
   {
      
      public static var GET_ROOM_INFO:String = "get_room_info";
      
      public function GetRoomInfoRes()
      {
         super();
      }
      
      public function getRoomInfo() : void
      {
         var itemCountObj:Object = null;
         var isUpset:Boolean = false;
         var getRoomInfoObj:Object = new Object();
         var getRoomInfoArr:Array = new Array();
         getRoomInfoObj.UserID = GV.onlineSocket.readUnsignedInt();
         getRoomInfoObj.Name = GV.onlineSocket.readUTFBytes(16);
         getRoomInfoObj.Online = GV.onlineSocket.readUnsignedInt();
         var houseBGObj:Object = new Object();
         houseBGObj.ID = GV.onlineSocket.readUnsignedInt();
         houseBGObj.PosX = GV.onlineSocket.readShort();
         houseBGObj.PosY = GV.onlineSocket.readShort();
         houseBGObj.Direction = GV.onlineSocket.readUnsignedByte();
         houseBGObj.Visible = GV.onlineSocket.readUnsignedByte();
         houseBGObj.Layer = GV.onlineSocket.readUnsignedByte();
         houseBGObj.Type = GV.onlineSocket.readUnsignedByte();
         houseBGObj.Rotation = GV.onlineSocket.readUnsignedByte() * 2;
         houseBGObj.Reserved = GV.onlineSocket.readUTFBytes(3);
         getRoomInfoArr.push(houseBGObj);
         getRoomInfoObj.ItemCount = GV.onlineSocket.readUnsignedInt();
         for(var j:int = 0; j < getRoomInfoObj.ItemCount; j++)
         {
            itemCountObj = new Object();
            itemCountObj.ID = GV.onlineSocket.readUnsignedInt();
            itemCountObj.PosX = GV.onlineSocket.readShort();
            itemCountObj.PosY = GV.onlineSocket.readShort();
            itemCountObj.Direction = GV.onlineSocket.readUnsignedByte();
            itemCountObj.Visible = GV.onlineSocket.readUnsignedByte();
            itemCountObj.Layer = GV.onlineSocket.readUnsignedByte();
            if(itemCountObj.ID == 160602)
            {
               itemCountObj.Layer = 2;
            }
            itemCountObj.Type = GV.onlineSocket.readUnsignedByte();
            itemCountObj.Rotation = GV.onlineSocket.readUnsignedByte() * 2;
            if(itemCountObj.Rotation != 0)
            {
               isUpset = true;
            }
            itemCountObj.Reserved = GV.onlineSocket.readUTFBytes(3);
            getRoomInfoArr.push(itemCountObj);
         }
         if(getRoomInfoArr.length > 1)
         {
            if(getRoomInfoArr[0].ID == getRoomInfoArr[1].ID)
            {
               getRoomInfoArr.shift();
            }
         }
         getRoomInfoObj.isUpset = isUpset;
         getRoomInfoObj.itemArr = getRoomInfoArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_ROOM_INFO,getRoomInfoObj));
      }
   }
}

