package com.mole.app.task.action
{
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import flash.events.Event;
   
   public class TaskGoMapAction extends TaskActionBase
   {
      
      private var _mapID:uint;
      
      private var _mapType:int;
      
      public function TaskGoMapAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._mapID = uint(actionXml.@MapID);
         this._mapType = int(actionXml.@MapType);
      }
      
      override public function execute() : void
      {
         GV.onlineSocket.addEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.onChangeMapComplete);
         MapManager.enterMap(this._mapID,this._mapType);
      }
      
      private function onChangeMapComplete(e:Event) : void
      {
         nextAction();
      }
      
      override public function destroy() : void
      {
         GV.onlineSocket.removeEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.onChangeMapComplete);
         super.destroy();
      }
   }
}

