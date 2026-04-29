package com.view.mapView.activity.Task83
{
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class ComposeAngelCtl
   {
      
      private static var instance:ComposeAngelCtl;
      
      private var panel_url:String = "resource/angelsAndDemons/swf/ComposeAngelGame.swf";
      
      private var gift_MC:MovieClip;
      
      private var childMC:*;
      
      public function ComposeAngelCtl()
      {
         super();
      }
      
      public static function getInstance() : ComposeAngelCtl
      {
         if(instance == null)
         {
            instance = new ComposeAngelCtl();
         }
         return instance;
      }
      
      public function laoderComposePanel() : void
      {
         this.onLoadPanel(this.panel_url);
      }
      
      private function onLoadPanel(url:String, _type:int = 0) : void
      {
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         if(_type == 0)
         {
            MainManager.getAppLevel().addChild(this.gift_MC);
         }
         else if(_type == 1)
         {
            MainManager.getGameLevel().addChild(this.gift_MC);
         }
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,"請耐心等待......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         e.currentTarget.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
      }
      
      public function clearHandler(e:* = null) : void
      {
         BC.removeEvent(this);
         GC.clearAll(this.gift_MC);
         this.childMC = null;
         this.gift_MC = null;
      }
   }
}

