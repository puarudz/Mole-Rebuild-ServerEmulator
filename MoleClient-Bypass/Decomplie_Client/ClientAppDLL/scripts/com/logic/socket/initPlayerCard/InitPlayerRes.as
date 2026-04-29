package com.logic.socket.initPlayerCard
{
   import com.event.EventTaomee;
   import flash.events.Event;
   import flash.utils.IDataInput;
   
   public class InitPlayerRes
   {
      
      public static var INITPLAYER:String = "initplayer";
      
      public function InitPlayerRes()
      {
         super();
      }
      
      public static function initPlayer() : void
      {
         GV.onlineSocket.dispatchEvent(new Event(INITPLAYER));
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.ret = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 3000,obj));
      }
   }
}

