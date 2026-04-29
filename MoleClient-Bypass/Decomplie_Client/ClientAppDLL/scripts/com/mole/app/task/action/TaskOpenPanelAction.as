package com.mole.app.task.action
{
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.events.Event;
   
   public class TaskOpenPanelAction extends TaskActionBase
   {
      
      private var _clearMap:Boolean;
      
      private var _isStopSound:Boolean;
      
      public function TaskOpenPanelAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._clearMap = uint(actionXml.@ClearMap) == 1;
         this._isStopSound = uint(actionXml.@IsStopSound) == 1;
      }
      
      override public function execute() : void
      {
         this.openPanel();
         if(this._isStopSound)
         {
            SoundManager.stopAll();
         }
      }
      
      private function openPanel() : void
      {
         if(this._clearMap)
         {
            MapManager.clearMap();
         }
         var appControl:AppModuleControl = ModuleManager.openPanel(this.panelName,_data);
         appControl.addEventListener(ModuleEvent.DESTROY,this.onDestroyPanel);
      }
      
      private function onDestroyPanel(e:Event) : void
      {
         var appCtl:AppModuleControl = e.currentTarget as AppModuleControl;
         appCtl.removeEventListener(ModuleEvent.DESTROY,this.onDestroyPanel);
         if(this._clearMap)
         {
            MapManager.refreshMap();
         }
         if(this._isStopSound)
         {
            SoundManager.openAll();
         }
         nextAction();
      }
      
      private function get panelName() : String
      {
         return _param;
      }
      
      override public function destroy() : void
      {
         if(this._isStopSound)
         {
            SoundManager.openAll();
         }
         super.destroy();
      }
   }
}

