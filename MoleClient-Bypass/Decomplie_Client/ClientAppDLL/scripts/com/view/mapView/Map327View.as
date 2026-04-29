package com.view.mapView
{
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import flash.events.Event;
   
   public class Map327View extends MapBase
   {
      
      public function Map327View()
      {
         super();
         TaskManager.getTask(542).addEventListener(Task.TASK_OVER,this.judgeTaskState,false,0,true);
      }
      
      override protected function initView() : void
      {
      }
      
      private function judgeTaskState(e:Event) : void
      {
         MapManager.enterMap(110);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

