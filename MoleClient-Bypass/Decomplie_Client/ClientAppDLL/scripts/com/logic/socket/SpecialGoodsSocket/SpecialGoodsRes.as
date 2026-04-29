package com.logic.socket.SpecialGoodsSocket
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class SpecialGoodsRes extends EventDispatcher
   {
      
      public static var GET_SPECIAL_GOODS_SUCC:String = "GET_SPECIAL_GOODS_SUCC";
      
      public function SpecialGoodsRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var msgobj:Object = null;
         var obj:Object = new Object();
         obj.count = GV.onlineSocket.readUnsignedInt();
         var GoodArr:Array = new Array();
         for(var i:uint = 0; i < obj.count; i++)
         {
            msgobj = new Object();
            msgobj.type = GV.onlineSocket.readUnsignedInt();
            msgobj.v1 = GV.onlineSocket.readUnsignedInt();
            msgobj.v2 = GV.onlineSocket.readUnsignedInt();
            msgobj.v3 = GV.onlineSocket.readUnsignedInt();
            msgobj.v4 = GV.onlineSocket.readUnsignedInt();
            msgobj.v5 = GV.onlineSocket.readUnsignedInt();
            GoodArr.push(msgobj);
         }
         obj.Arr = GoodArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_SPECIAL_GOODS_SUCC,obj));
      }
   }
}

