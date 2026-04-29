package com.module.coin
{
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.module.activityModule.superPetLogin;
   import com.module.superGift.superGiftCtrl;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SutraBookModule
   {
      
      private static var instance:SutraBookModule;
      
      private var SutraBookMC:MovieClip;
      
      private var CoinBuyModles:CoinBuyModle;
      
      private var itemArr:Array = [100828,100774,100793,100792,100794,100795,100796,100655];
      
      private var ChestArr:Array = [190690,190681,190710,190709,190712,190713,190715,190708];
      
      private var longArr:Array = [1350002,1350001,1350005,1350003,1350007,1350008,1350010,1350004];
      
      public function SutraBookModule()
      {
         super();
      }
      
      public static function getInstance() : SutraBookModule
      {
         if(instance == null)
         {
            instance = new SutraBookModule();
         }
         return instance;
      }
      
      public function initView(url:String, str:String, mcName:String) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName(mcName))
         {
            this.SutraBookMC = new MovieClip();
            this.SutraBookMC.name = mcName;
            MainManager.getGameLevel().addChild(this.SutraBookMC);
            tempMC = new MCLoader(url,this.SutraBookMC,1,str);
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.petBookLoadOver);
            GV.onlineSocket.addEventListener("removeMapEvent",this.removeMapEvent);
            tempMC.doLoad();
         }
      }
      
      private function petBookLoadOver(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.petBookLoadOver);
         mcloader.clear();
         this.addEvent();
      }
      
      public function addEvent() : void
      {
         GV.onlineSocket.addEventListener("VIPBUY_EVENT",this.buyClothHandler);
         GV.onlineSocket.addEventListener("removeSutraMCEvent",this.removeBookHandler);
         GV.onlineSocket.addEventListener("GAMEBUT_EVENT",this.gameBuyEvent);
      }
      
      public function removeEvent() : void
      {
         GV.onlineSocket.removeEventListener("VIPBUY_EVENT",this.buyClothHandler);
         GV.onlineSocket.removeEventListener("removeSutraMCEvent",this.removeBookHandler);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeMapEvent);
         GV.onlineSocket.removeEventListener("GAMEBUT_EVENT",this.gameBuyEvent);
      }
      
      public function removeBookHandler(evt:Event = null) : void
      {
         this.removeEvent();
         GC.stopAllMC(this.SutraBookMC);
         GC.clearChildren(this.SutraBookMC);
         this.SutraBookMC.parent.removeChild(this.SutraBookMC);
         this.SutraBookMC = null;
      }
      
      private function gameBuyEvent(evt:Event) : void
      {
         superPetLogin.gameBuy();
      }
      
      public function buyClothHandler(evt:EventTaomee) : void
      {
         var commodityID:int = int(evt.EventObj.id);
         var indexNum:Number = this.itemArr.indexOf(commodityID);
         if(indexNum >= 0)
         {
            superGiftCtrl.getInstance().buyGiftFun(commodityID,this.ChestArr[indexNum],this.longArr[indexNum]);
         }
         else
         {
            if(this.CoinBuyModles == null)
            {
               this.CoinBuyModles = new CoinBuyModle();
            }
            this.CoinBuyModles.BuyModle(commodityID,1);
         }
      }
      
      public function removeMapEvent(evt:EventTaomee) : void
      {
         this.removeBookHandler();
      }
   }
}

