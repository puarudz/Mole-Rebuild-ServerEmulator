package com.logic.socket.petSocket.adoptPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class petChangeColorRes extends EventDispatcher
   {
      
      public static var CHANGE_PET_COLOR_SUCC:String = "CHANGE_PET_COLOR_SUCC";
      
      public function petChangeColorRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.Action = GV.onlineSocket.readUnsignedInt();
         obj.Type = GV.onlineSocket.readUnsignedInt();
         obj.Flag = GV.onlineSocket.readUnsignedInt();
         obj.SpriteID = GV.onlineSocket.readUnsignedInt();
         obj.ColorType = GV.onlineSocket.readUnsignedInt();
         obj.Hungry = 0;
         obj.Thirsty = 0;
         obj.Dirty = 0;
         obj.Spirit = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee(CHANGE_PET_COLOR_SUCC,obj));
      }
   }
}

