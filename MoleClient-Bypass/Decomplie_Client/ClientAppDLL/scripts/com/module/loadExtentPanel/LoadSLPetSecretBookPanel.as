package com.module.loadExtentPanel
{
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class LoadSLPetSecretBookPanel extends EventDispatcher
   {
      
      private static var SEND_MSG:String = "send_msg";
      
      private var url:String;
      
      private var loadName:String;
      
      private var levelMC:Sprite;
      
      private var tempMC:MCLoader;
      
      private var childMC:Loader;
      
      public var panle2:MovieClip;
      
      private var sandType:uint = 0;
      
      public function LoadSLPetSecretBookPanel(path:String, name:String, container:Sprite, type:uint = 1002)
      {
         super();
         StatisticsClass.getInstance().init(67666742,"http://g.miaozhen.com/x.gif?^k=1865^p=C-x0%5E");
         this.url = path;
         this.levelMC = container;
         this.loadName = name;
         this.sandType = type;
         this.loadUI();
      }
      
      private function loadUI() : void
      {
         if(!this.levelMC.getChildByName("panle2"))
         {
            if(this.sandType != 0)
            {
               BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
            }
            this.panle2 = new MovieClip();
            this.panle2.name = "panle2";
            BC.addEvent(this,this.panle2,Event.REMOVED_FROM_STAGE,this.removeEventHandler);
            this.levelMC.addChild(this.panle2);
            this.tempMC = new MCLoader(this.url,this.panle2,Loading.TITLE_AND_PERCENT,this.loadName);
            BC.addEvent(this,this.tempMC,MCLoadEvent.ON_SUCCESS,this.loadPassHandler);
            this.tempMC.doLoad();
         }
      }
      
      private function loadPassHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         this.closeEvent();
         this.otherBtnEvent();
         BC.removeEvent(this,this.tempMC,MCLoadEvent.ON_SUCCESS,this.loadPassHandler);
         this.tempMC.clear();
      }
      
      protected function closeEvent() : void
      {
         BC.addEvent(this,this.childMC.content.root["close_btn"],MouseEvent.CLICK,this.closeHandler);
      }
      
      protected function closeHandler(event:*) : void
      {
         BC.removeEvent(this);
         GC.clearAll(this.panle2);
         var o:Object = this.panle2.parent;
         this.panle2 = null;
         this.levelMC = null;
         this.tempMC = null;
         this.childMC = null;
      }
      
      protected function removeEventHandler(evt:*) : void
      {
         this.closeHandler(null);
      }
      
      protected function otherBtnEvent() : void
      {
      }
   }
}

