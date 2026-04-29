package com.logic.socket.postCard
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class getOnlyNumRes extends EventDispatcher
   {
      
      public static var ONLY_NUM:String = "getOnly_postNum";
      
      public function getOnlyNumRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var target_obj:Object = new Object();
         target_obj.Num = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(ONLY_NUM,target_obj));
      }
   }
}

