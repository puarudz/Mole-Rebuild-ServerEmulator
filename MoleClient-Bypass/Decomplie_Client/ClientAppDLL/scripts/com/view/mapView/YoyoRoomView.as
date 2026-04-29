package com.view.mapView
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.NPCJobLogic.NPCJobLogic;
   import com.logic.socket.NPCJob.GetNPCJobDataSocket;
   import com.logic.socket.NPCJob.SetNPCJobDataSocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class YoyoRoomView extends MapBase
   {
      
      public static var task403Obj:Object;
      
      public var topMC:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public function YoyoRoomView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,this.target_mc.puzz_btn,MouseEvent.CLICK,this.clickPuzzHandler);
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.NOWTIMES,this.getTimeBack);
         JobExpandLogic.getJobExpand().getServerTime();
         this.checkTask403Fun();
      }
      
      private function checkTask403Fun() : void
      {
         var task403State:uint = TaskManager.getTaskState(403);
         if(task403State == 1)
         {
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.checkJobInfo);
            JobExpandLogic.getJobExpand().getOneJob(403);
         }
      }
      
      private function checkJobInfo(evt:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.checkJobInfo);
         task403Obj = evt.EventObj.obj;
      }
      
      private function getTimeBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.NOWTIMES,this.getTimeBack);
         var date:Date = new Date(evt.EventObj.obj);
         if(date.getHours() >= 8 && date.getHours() <= 21)
         {
            BC.addEvent(this,GV.onlineSocket,NPCJobLogic.GET_JOB,this.getJobInfo);
            NPCJobLogic.getNpcJobLogic().getJobData(2);
         }
      }
      
      private function clickPuzzHandler(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/PuzzleTest.swf","正在打開面板.....",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function getJobInfo(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,NPCJobLogic.GET_JOB,this.getJobInfo);
         var obj:Object = NPCJobLogic.npcJobList[2];
         if(obj.jobStatus == 1)
         {
            BC.addEvent(this,GV.onlineSocket,GetNPCJobDataSocket.GET_JOB_DATA,this.getJobDataBack);
            GetNPCJobDataSocket.getJobData(2);
         }
      }
      
      private function getJobDataBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetNPCJobDataSocket.GET_JOB_DATA,this.getJobDataBack);
         var obj:Object = evt.EventObj;
         if(obj.flag == 0)
         {
            this.target_mc.lamu_btn.visible = true;
            this.target_mc.lamu.visible = true;
            BC.addEvent(this,GV.onlineSocket,"give_lamu_cake",this.giveLamuCake);
         }
      }
      
      private function giveLamuCake(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"give_lamu_cake",this.giveLamuCake);
         var obj:Object = {"flag":1};
         SetNPCJobDataSocket.setJobData(2,obj);
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.topMC = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

