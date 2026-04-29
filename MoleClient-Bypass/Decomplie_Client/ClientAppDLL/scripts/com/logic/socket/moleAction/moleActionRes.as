package com.logic.socket.moleAction
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class moleActionRes extends EventDispatcher
   {
      
      public static var MOLE_SLIDE:String = "MOLE_SLIDE";
      
      public function moleActionRes()
      {
         super();
      }
      
      public function moleAction() : void
      {
         var ActionObj:Object = new Object();
         ActionObj.UserID = GV.onlineSocket.readUnsignedInt();
         ActionObj.Action = GV.onlineSocket.readUnsignedShort();
         ActionObj.posX = GV.onlineSocket.readUnsignedShort();
         ActionObj.posY = GV.onlineSocket.readUnsignedShort();
         GV.onlineSocket.dispatchEvent(new EventTaomee(MOLE_SLIDE,ActionObj));
      }
   }
}

