package com.view.transfiguration
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.throwItem.ThrowEffectItemRes;
   
   public class TransfigurationView
   {
      
      private static var owner:TransfigurationView;
      
      public static var itemID:int;
      
      public static var bool:int;
      
      public static var buckerNum:int;
      
      public function TransfigurationView()
      {
         super();
         owner = this;
      }
      
      public static function getInstance() : TransfigurationView
      {
         return Boolean(owner) ? owner : new TransfigurationView();
      }
      
      public function startChange(_itemID:int) : void
      {
         itemID = _itemID;
         var throwItemObj:Object = new Object();
         throwItemObj.UserID = LocalUserInfo.getUserID();
         throwItemObj.ChangeID = LocalUserInfo.getUserID();
         throwItemObj.ItemID = itemID;
         throwItemObj.OtherID = LocalUserInfo.getUserID();
         throwItemObj.FlashTag = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee(ThrowEffectItemRes.EFFECT_ITEM,throwItemObj));
      }
      
      public function ovenChange(_itemID:int) : void
      {
         itemID = _itemID;
         var throwItemObj:Object = new Object();
         throwItemObj.UserID = LocalUserInfo.getUserID();
         throwItemObj.ItemID = itemID;
         GV.onlineSocket.dispatchEvent(new EventTaomee(ThrowEffectItemRes.EFFECT_TIME,throwItemObj));
         itemID = 0;
      }
   }
}

