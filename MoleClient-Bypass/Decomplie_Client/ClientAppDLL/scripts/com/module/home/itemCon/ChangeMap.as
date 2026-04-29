package com.module.home.itemCon
{
   import com.module.home.HomeEditView;
   import com.mole.app.map.MapManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ChangeMap
   {
      
      private var targetMC:MovieClip;
      
      private var _mapId:int;
      
      public function ChangeMap(_targetMC:MovieClip, mid:int)
      {
         super();
         this.targetMC = _targetMC;
         this._mapId = mid;
         BC.addEvent(this,this.targetMC.btn,MouseEvent.CLICK,this.goMap);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function goMap(e:MouseEvent) : void
      {
         if(!HomeEditView.Editable)
         {
            MapManager.enterMap(this._mapId);
         }
      }
      
      private function removeEventHandler(E:Event) : void
      {
         BC.removeEvent(this);
      }
   }
}

