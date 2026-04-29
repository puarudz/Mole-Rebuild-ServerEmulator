package com.module.home.itemCon
{
   import com.core.MainManager;
   import com.module.home.HomeEditView;
   import com.module.loadExtentPanel.LoadGame;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MatherPanel
   {
      
      private static var instance:MatherPanel = null;
      
      private var targetMC:MovieClip;
      
      public function MatherPanel()
      {
         super();
      }
      
      public static function getInstance() : MatherPanel
      {
         return instance = instance || new MatherPanel();
      }
      
      public function init(_targetMC:MovieClip) : void
      {
         this.targetMC = _targetMC;
         BC.addEvent(this,this.targetMC.btn,MouseEvent.CLICK,this.openPanel);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      public function openPanel(e:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         if(!HomeEditView.Editable)
         {
            loadGame = new LoadGame("module/external/greetingCards.swf","正在加載......",MainManager.getAppLevel());
            loadGame = null;
         }
      }
      
      private function removeEventHandler(E:Event) : void
      {
         BC.removeEvent(this);
      }
   }
}

