package com.logic.socket.SpecialGoodsSocket.lilypond
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class LilyPondRes extends EventDispatcher
   {
      
      public static var GET_LILYPOND_SUCC:String = "GET_LILYPOND_SUCC";
      
      public function LilyPondRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.water = GV.onlineSocket.readUnsignedInt();
         obj.num = GV.onlineSocket.readUnsignedInt();
         if(obj.num > 2)
         {
            obj.num = 2;
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_LILYPOND_SUCC,obj));
      }
   }
}

