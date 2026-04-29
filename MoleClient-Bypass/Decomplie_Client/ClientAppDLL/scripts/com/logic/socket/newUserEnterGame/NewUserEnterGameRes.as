package com.logic.socket.newUserEnterGame
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class NewUserEnterGameRes extends EventDispatcher
   {
      
      public static var NEWUSER_ENTERGAME:String = "newuser_entergame";
      
      public function NewUserEnterGameRes()
      {
         super();
      }
      
      public function newUserEnterGame() : void
      {
         var newUserEneteGameObj:Object = new Object();
         newUserEneteGameObj.UserID = GV.GameSocket.readUnsignedInt();
         GV.GameSocket.dispatchEvent(new EventTaomee(NEWUSER_ENTERGAME,newUserEneteGameObj));
      }
   }
}

