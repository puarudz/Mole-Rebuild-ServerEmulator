package com.module.home.special
{
   import com.core.MainManager;
   import com.module.home.HomeEditView;
   import com.module.loadExtentPanel.LoadGame;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Bodhi1220096
   {
      
      private static var instance:Bodhi1220096;
      
      private static var canotNew:Boolean = true;
      
      private var goodsMC:MovieClip;
      
      public function Bodhi1220096()
      {
         super();
         if(canotNew)
         {
            throw new Error("Bodhi1220096不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : Bodhi1220096
      {
         if(!instance)
         {
            canotNew = false;
            instance = new Bodhi1220096();
            canotNew = true;
         }
         return instance;
      }
      
      public function init(mc:MovieClip) : void
      {
         this.goodsMC = mc;
         this.goodsMC.btn.addEventListener(MouseEvent.CLICK,this.changeStatus);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function changeStatus(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         if(!HomeEditView.Editable)
         {
            loadGame = new LoadGame("module/external/Bodhi1220096.swf","正在加載大伯的表彰",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      private function removeEventHandler(E:Event) : void
      {
         this.goodsMC.btn.removeEventListener(MouseEvent.CLICK,this.changeStatus);
         BC.removeEvent(this);
      }
   }
}

