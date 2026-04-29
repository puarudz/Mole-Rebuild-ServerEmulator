package com.logic.socket.petSocket.adoptPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class petPlayRes extends EventDispatcher
   {
      
      public static var GET_PETPLAY_SUCC:String = "GET_PETPLAY_SUCC";
      
      public static var GET_PETSHOP_SUCC:String = "GET_PETSHOP_SUCC";
      
      public function petPlayRes()
      {
         super();
      }
      
      public static function petshopplay() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_PETSHOP_SUCC));
      }
      
      public static function petback() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 239));
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.UserID = GV.onlineSocket.readUnsignedInt();
         obj.SpriteID = GV.onlineSocket.readUnsignedInt();
         obj.Action = GV.onlineSocket.readUnsignedInt();
         obj.Hungry = GV.onlineSocket.readUnsignedByte();
         obj.Thirsty = GV.onlineSocket.readUnsignedByte();
         obj.Dirty = GV.onlineSocket.readUnsignedByte();
         obj.Spirit = GV.onlineSocket.readUnsignedByte();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_PETPLAY_SUCC,obj));
      }
   }
}

