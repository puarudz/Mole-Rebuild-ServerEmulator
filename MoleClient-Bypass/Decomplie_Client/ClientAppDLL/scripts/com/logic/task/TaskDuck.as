package com.logic.task
{
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.logic.active.MaylstActiveCtl;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.type.ModuleType;
   import com.mole.app.ui.LoadingPanel;
   import com.mole.app.utils.PlayMovie;
   
   public class TaskDuck
   {
      
      private var _map:MapBase;
      
      private var _duckMovie:PlayMovie;
      
      public function TaskDuck(map:MapBase)
      {
         super();
         this._map = map;
         SystemEventManager.addEventListener("duck_openDiary",this.openDiary);
         SystemEventManager.addEventListener("duck_duckMovie",this.duckMovie);
         SystemEventManager.addEventListener("duck_openPanel",this.openPanel);
         SystemEventManager.addEventListener("duck_openGame",this.openGame);
      }
      
      private function openDiary(e:SystemEvent) : void
      {
         var resID:int = int(DownLoadManager.add("resource/task/duckDiary.swf",ResType.DISPLAY_OBJECT));
         LoadingPanel.addRes(resID);
         DownLoadManager.addEvent(resID,this.loadDiaryOver);
      }
      
      private function loadDiaryOver(e:DownLoadEvent) : void
      {
         MainManager.getAppLevel().addChild(e.data);
      }
      
      private function duckMovie(e:SystemEvent) : void
      {
         this._duckMovie = PlayMovie.play("resource/task/duckMovie.swf",null,null,this.playDuckOver);
      }
      
      private function playDuckOver() : void
      {
         this._duckMovie.destroy();
         this._map.mapSay(27);
      }
      
      private function openPanel(e:SystemEvent) : void
      {
         ModuleManager.openPanel(ModuleType.DUCK_ACTIVE_PANEL);
      }
      
      private function openGame(e:SystemEvent) : void
      {
         MaylstActiveCtl.instance.onLoadGame("module/game/rocket.swf",true,true);
      }
      
      public function destroy() : void
      {
         SystemEventManager.removeEventListener("duck_openDiary",this.openDiary);
         SystemEventManager.removeEventListener("duck_duckMovie",this.duckMovie);
         SystemEventManager.removeEventListener("duck_openPanel",this.openPanel);
         SystemEventManager.removeEventListener("duck_openGame",this.openGame);
         BC.removeEvent(this);
         this._map = null;
      }
   }
}

