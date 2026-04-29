package com.logic.socket.listShopItem
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class ListShopItemRes extends EventDispatcher
   {
      
      public static var LIST_SHOP_ITEM:String = "list_shop_item";
      
      public function ListShopItemRes()
      {
         super();
      }
      
      public function listShopItemRes() : void
      {
         var Url:String = null;
         try
         {
            Url = GV.onlineSocket.readUTFBytes(256);
            GV.onlineSocket.dispatchEvent(new EventTaomee(LIST_SHOP_ITEM,{"url":Url}));
         }
         catch(e:*)
         {
         }
      }
   }
}

