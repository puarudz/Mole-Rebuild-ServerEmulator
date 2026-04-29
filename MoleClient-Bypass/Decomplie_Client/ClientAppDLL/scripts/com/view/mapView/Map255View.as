package com.view.mapView
{
   import com.logic.task.SummerActivityCtr;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import flash.events.Event;
   
   public class Map255View extends MapBase
   {
      
      private static var _prevMapID:uint = 254;
      
      public function Map255View()
      {
         super();
      }
      
      public static function setPrevMapID(mapId:uint) : void
      {
         _prevMapID = mapId;
      }
      
      override protected function initView() : void
      {
         SummerActivityCtr.inst.initPlumber();
         SystemEventManager.addEventListener("getOff",this.onGetOff);
         SystemEventManager.addEventListener("Ride",this.onRide);
      }
      
      override public function init() : void
      {
         super.init();
      }
      
      private function onRide(e:SystemEvent) : void
      {
         ModuleManager.openPanel("ParadiseWhereToPanel");
      }
      
      private function onGetOff(e:Event) : void
      {
         MapManager.enterMap(_prevMapID);
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("getOff",this.onGetOff);
         SystemEventManager.removeEventListener("Ride",this.onRide);
         super.destroy();
      }
   }
}

