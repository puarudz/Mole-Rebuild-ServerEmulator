package com.module.coin
{
   import com.event.EventTaomee;
   import com.module.clothBuyModule.clothBuyModule;
   
   public class ScatteredBookModule extends SutraBookModule
   {
      
      private static var instance:ScatteredBookModule;
      
      public function ScatteredBookModule()
      {
         super();
      }
      
      public static function getInstance() : ScatteredBookModule
      {
         if(instance == null)
         {
            instance = new ScatteredBookModule();
         }
         return instance;
      }
      
      override public function addEvent() : void
      {
         GV.onlineSocket.addEventListener("scatteredEvent",this.buyClothHandler);
         GV.onlineSocket.addEventListener("removeScattered",removeBookHandler);
      }
      
      override public function removeEvent() : void
      {
         GV.onlineSocket.removeEventListener("scatteredEvent",this.buyClothHandler);
         GV.onlineSocket.removeEventListener("removeScattered",removeBookHandler);
         GV.onlineSocket.removeEventListener("removeMapEvent",removeMapEvent);
      }
      
      override public function buyClothHandler(evt:EventTaomee) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = evt.EventObj.itemid;
         itemObj.price = 700;
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj);
      }
   }
}

