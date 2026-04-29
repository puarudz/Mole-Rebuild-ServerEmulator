package com.logic.socket.AladdinPWD
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class AladdinPWDRes extends EventDispatcher
   {
      
      public static var AladdinPWD_SUCC:String = "AladdinPWD_SUCC";
      
      public static var AladdinPWD_SUCC_NEW:String = "AladdinPWD_SUCC_NEW";
      
      public static var USE_AladdinPWD_SUCC_NEW:String = "USE_AladdinPWD_SUCC_NEW";
      
      public function AladdinPWDRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var tmp:Object = null;
         var obj:Object = new Object();
         obj.count = GV.onlineSocket.readUnsignedInt();
         obj.arr = new Array();
         for(var i:uint = 0; i < obj.count; i++)
         {
            tmp = new Object();
            tmp.ItemID = GV.onlineSocket.readUnsignedInt();
            tmp.ItemCount = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(tmp);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(AladdinPWD_SUCC,obj));
      }
      
      public function parseBANew() : void
      {
         var itemObj:Object = null;
         var obj:Object = new Object();
         obj.type = GV.onlineSocket.readByte();
         obj.MaxNum = GV.onlineSocket.readShort();
         obj.UsedNum = GV.onlineSocket.readShort();
         obj.AllNum = GV.onlineSocket.readShort();
         obj.arr = new Array();
         for(var i:uint = 0; i < obj.AllNum; i++)
         {
            itemObj = new Object();
            itemObj.id = GV.onlineSocket.readUnsignedInt();
            itemObj.count = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(itemObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(AladdinPWD_SUCC_NEW,obj));
      }
      
      public function usePWD() : void
      {
         var itemObj:Object = null;
         var obj:Object = new Object();
         obj.userid = GV.onlineSocket.readUnsignedInt();
         obj.flag = GV.onlineSocket.readByte();
         obj.itemnum = GV.onlineSocket.readShort();
         obj.arr = new Array();
         for(var i:uint = 0; i < obj.itemnum; i++)
         {
            itemObj = new Object();
            itemObj.id = GV.onlineSocket.readUnsignedInt();
            itemObj.count = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(itemObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(USE_AladdinPWD_SUCC_NEW,obj));
      }
   }
}

