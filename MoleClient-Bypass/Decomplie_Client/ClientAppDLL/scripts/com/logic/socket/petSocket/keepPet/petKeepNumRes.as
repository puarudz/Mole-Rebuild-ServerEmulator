package com.logic.socket.petSocket.keepPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class petKeepNumRes extends EventDispatcher
   {
      
      public static var GOODS_NUM_SUCC:String = "GOODS_NUM_SUCC";
      
      public function petKeepNumRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.Type = GV.onlineSocket.readUnsignedInt();
         obj.Num = GV.onlineSocket.readUnsignedInt();
         trace(obj.Type,obj.Num);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GOODS_NUM_SUCC,obj));
      }
   }
}

