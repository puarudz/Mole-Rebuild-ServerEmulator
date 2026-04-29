package com.module.loadExtentPanel
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SpringPanel
   {
      
      private static var instance:SpringPanel;
      
      private var container:Sprite;
      
      private var panel:MovieClip;
      
      public function SpringPanel()
      {
         super();
      }
      
      public static function getInstance() : SpringPanel
      {
         if(instance == null)
         {
            instance = new SpringPanel();
         }
         return instance;
      }
      
      public function dapPanel(mc:Sprite, panelStr:String) : void
      {
         var tempMC:Class = null;
         this.container = mc;
         if(!MainManager.getAppLevel().getChildByName("panel"))
         {
            tempMC = GV.Lib_Map.getClass(panelStr) as Class;
            this.panel = new tempMC() as MovieClip;
            this.panel.name = "panel";
            this.panel.x = (MainManager.getStageWidth() - this.panel.width) / 2;
            this.panel.y = (MainManager.getStageHeight() - this.panel.height) / 2;
            this.panel.close_btn.addEventListener(MouseEvent.CLICK,this.panelHandler);
            this.container.addChild(this.panel);
         }
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
      }
      
      private function panelHandler(event:MouseEvent = null) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         this.panel.close_btn.removeEventListener(MouseEvent.CLICK,this.panelHandler);
         this.container.removeChild(this.panel);
         GC.stopAllMC(this.panel);
         GC.clearAllChildren(this.panel);
         this.panel = null;
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         if(Boolean(this.panel))
         {
            this.panelHandler();
         }
      }
   }
}

