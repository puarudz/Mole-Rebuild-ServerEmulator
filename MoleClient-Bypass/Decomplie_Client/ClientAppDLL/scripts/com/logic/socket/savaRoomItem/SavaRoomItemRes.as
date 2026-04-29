package com.logic.socket.savaRoomItem
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class SavaRoomItemRes extends EventDispatcher
   {
      
      public static var SAVA_ROOM_ITEM:String = "sava_room_item";
      
      public function SavaRoomItemRes()
      {
         super();
      }
      
      public function savaRoomItem() : void
      {
         var savaRoomItemObj:Object = new Object();
         savaRoomItemObj.msg = " 保存小屋道具成功";
         GV.onlineSocket.dispatchEvent(new EventTaomee(SAVA_ROOM_ITEM,savaRoomItemObj));
      }
      
      public function savaRoomBGSucc() : void
      {
         var obj:Object = null;
         var savaRoomItemObj:Object = new Object();
         var itemArray:Array = new Array();
         var itemCount:uint = GV.onlineSocket.readUnsignedInt();
         for(var i:int = 0; i < itemCount; i++)
         {
            obj = new Object();
            obj.id = GV.onlineSocket.readUnsignedInt();
            obj.count = GV.onlineSocket.readUnsignedInt();
            itemArray.push(obj);
         }
         savaRoomItemObj.arr = itemArray;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 415,savaRoomItemObj));
      }
   }
}

