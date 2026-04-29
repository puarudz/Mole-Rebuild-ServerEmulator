package com.logic.socket.JJLCard
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class ExchangeJJLClothRes extends Sprite
   {
      
      public static var BACK_JJL_CHANG:String = "changjjlcloth_back";
      
      public function ExchangeJJLClothRes()
      {
         super();
      }
      
      public function backFun() : void
      {
         var objs:Object = new Object();
         objs.ID = GV.onlineSocket.readUnsignedInt();
         objs.Count = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_JJL_CHANG,{"obj":objs}));
      }
   }
}

