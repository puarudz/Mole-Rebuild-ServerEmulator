package com.logic.socket.OperationJob
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class SetMutualRes extends Sprite
   {
      
      public static var SET_MUTUAL_BACK:String = "set_back_mutual";
      
      public function SetMutualRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(SET_MUTUAL_BACK));
      }
   }
}

