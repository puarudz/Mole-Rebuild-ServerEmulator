package com.logic.socket.shopItem
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class BuyItemRes extends EventDispatcher
   {
      
      public static var BUY_ITEM_SUCCESS:String = "buy_item_success";
      
      public function BuyItemRes()
      {
         super();
      }
      
      public function buyItemSuccess() : void
      {
         var shell:int = int(GV.onlineSocket.readUnsignedInt());
         LocalUserInfo.setYXQ(shell);
         GV.onlineSocket.dispatchEvent(new EventTaomee(BUY_ITEM_SUCCESS,{"shell":shell}));
      }
   }
}

