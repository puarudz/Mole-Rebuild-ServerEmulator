package com.logic.socket.petClass.expandItem
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class SetPetClassJobRes extends Sprite
   {
      
      public static var GET_BACK:String = "set_back_classjob";
      
      public function SetPetClassJobRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("set_back_classjob"));
      }
   }
}

