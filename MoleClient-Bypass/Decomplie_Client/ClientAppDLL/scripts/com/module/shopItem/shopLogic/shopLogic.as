package com.module.shopItem.shopLogic
{
   import com.core.newloader.XMLLoader;
   import com.event.EventTaomee;
   import com.event.XMLLoadEvent;
   import com.logic.socket.listShopItem.ListShopItemReq;
   import com.logic.socket.listShopItem.ListShopItemRes;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   
   public class shopLogic extends EventDispatcher
   {
      
      public static var CLOTH_OVER:String = "cloth_over";
      
      public var listShop:ListShopItemReq;
      
      public function shopLogic()
      {
         super();
         this.listShop = new ListShopItemReq();
         try
         {
            GV.onlineSocket.addEventListener(ListShopItemRes.LIST_SHOP_ITEM,this.getShopURL);
         }
         catch(E:*)
         {
         }
      }
      
      public function sendClothURL(type:int = 1) : void
      {
         this.listShop.listShopItem(type);
      }
      
      public function getShopURL(evt:*) : void
      {
         var URL:String = evt.EventObj.url;
         var tempClass:XMLLoader = new XMLLoader(URL);
         tempClass.addEventListener(XMLLoadEvent.ON_SUCCESS,this.XMLOverHandler);
         tempClass.addEventListener(XMLLoadEvent.ERROR,this.XMLFailHandler);
         tempClass.doLoad();
      }
      
      public function XMLOverHandler(evt:XMLLoadEvent) : void
      {
         var tempXML:XML = evt.getXML();
         dispatchEvent(new EventTaomee(CLOTH_OVER,{"xml":tempXML}));
         var tempClass:XMLLoader = evt.target as XMLLoader;
         tempClass.removeEventListener(XMLLoadEvent.ON_SUCCESS,this.XMLOverHandler);
         tempClass.removeEventListener(XMLLoadEvent.ERROR,this.XMLFailHandler);
      }
      
      public function XMLFailHandler(evt:XMLLoadEvent) : void
      {
      }
   }
}

