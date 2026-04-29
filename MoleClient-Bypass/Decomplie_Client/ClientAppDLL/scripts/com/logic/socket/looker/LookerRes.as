package com.logic.socket.looker
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class LookerRes extends EventDispatcher
   {
      
      public static var LOOKER_CHESS:String = "looker_chess";
      
      public function LookerRes()
      {
         super();
      }
      
      public function looker() : void
      {
         var lookerObj:Object = new Object();
         lookerObj.Count = GV.GameSocket.readUnsignedInt();
         GV.GameSocket.dispatchEvent(new EventTaomee(LOOKER_CHESS,lookerObj));
      }
   }
}

