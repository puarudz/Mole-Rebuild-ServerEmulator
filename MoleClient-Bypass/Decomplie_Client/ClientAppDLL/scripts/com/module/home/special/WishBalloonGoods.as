package com.module.home.special
{
   import com.core.MainManager;
   import com.module.home.HomeEditView;
   import com.module.loadExtentPanel.LoadGame;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class WishBalloonGoods
   {
      
      private static var instance:WishBalloonGoods;
      
      private static var canotNew:Boolean = true;
      
      private var goodsMC:MovieClip;
      
      public function WishBalloonGoods()
      {
         super();
         if(canotNew)
         {
            throw new Error("WishBalloonGoods不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : WishBalloonGoods
      {
         if(!instance)
         {
            canotNew = false;
            instance = new WishBalloonGoods();
            canotNew = true;
         }
         return instance;
      }
      
      public function init(mc:MovieClip) : void
      {
         this.goodsMC = mc;
         GV.onlineSocket.addEventListener("chris_oven_ok",this.onchris_oven_ok);
         this.goodsMC.btn.addEventListener(MouseEvent.CLICK,this.changeStatus);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function changeStatus(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         if(!HomeEditView.Editable)
         {
            loadGame = new LoadGame("module/external/ChristScrip.swf","正在心願傳遞氣球打開面板.....",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      private function onchris_oven_ok(evt:Event) : void
      {
         this.goodsMC.mc2.getChildAt(0).gotoAndPlay(33);
      }
      
      private function removeEventHandler(E:Event) : void
      {
         GV.onlineSocket.removeEventListener("chris_oven_ok",this.onchris_oven_ok);
         this.goodsMC.btn.removeEventListener(MouseEvent.CLICK,this.changeStatus);
         BC.removeEvent(this);
      }
   }
}

