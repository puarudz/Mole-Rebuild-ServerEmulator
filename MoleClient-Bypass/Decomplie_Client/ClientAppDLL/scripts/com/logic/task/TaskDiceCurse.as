package com.logic.task
{
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.mole.app.map.MapManager;
   import com.mole.app.ui.LoadingPanel;
   import com.view.mapView.activity.Task83.StatisticsClass;
   
   public class TaskDiceCurse
   {
      
      private static var _instance:TaskDiceCurse;
      
      public function TaskDiceCurse()
      {
         super();
      }
      
      public static function get inst() : TaskDiceCurse
      {
         if(_instance == null)
         {
            _instance = new TaskDiceCurse();
         }
         return _instance;
      }
      
      public function openSystem() : void
      {
         StatisticsClass.getInstance().init(67748910);
         var resID:int = int(DownLoadManager.add("module/external/SirenSystem.swf",ResType.DISPLAY_OBJECT));
         LoadingPanel.addRes(resID);
         DownLoadManager.addEvent(resID,this.loadSysOver);
      }
      
      private function loadSysOver(e:DownLoadEvent) : void
      {
         GameframeLogic.stopMousicHandler();
         MapManager.clearMap();
         MainManager.getTopLevel().addChild(e.data);
      }
      
      public function openAdventure() : void
      {
         var resID:int = int(DownLoadManager.add("module/external/SirenAdventure.swf",ResType.DISPLAY_OBJECT));
         LoadingPanel.addRes(resID);
         DownLoadManager.addEvent(resID,this.loadAdvOver);
      }
      
      private function loadAdvOver(e:DownLoadEvent) : void
      {
         GameframeLogic.stopMousicHandler();
         MapManager.clearMap();
         MainManager.getTopLevel().addChild(e.data);
      }
   }
}

