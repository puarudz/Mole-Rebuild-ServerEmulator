package com.view.mapView
{
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.TaskManager;
   
   public class fireMapOutView extends MapBase
   {
      
      public function fireMapOutView()
      {
         super();
         GV.onlineSocket.addEventListener("PacManWin",this.pacManWin);
      }
      
      private function pacManWin(e:*) : void
      {
         TaskManager.getTask(565).setStepAndPanel(3,3);
         MapManager.enterMap(61);
      }
      
      override public function destroy() : void
      {
         GV.onlineSocket.removeEventListener("PacManWin",this.pacManWin);
         super.destroy();
      }
   }
}

