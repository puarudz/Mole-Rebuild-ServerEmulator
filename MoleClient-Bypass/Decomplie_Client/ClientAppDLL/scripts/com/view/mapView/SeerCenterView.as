package com.view.mapView
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.module.activityModule.SoundControlModule;
   import com.module.npc.dialog.TalkEvent;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SeerCenterView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      private var taskObj:Object;
      
      public function SeerCenterView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         SoundControlModule.getInstance().initSound();
         this.cheakTaskEvent();
         BC.addEvent(this,this.botton_mc.hit2MC1,"onHit",this.secondEvent);
         BC.addEvent(this,this.botton_mc.hit2MC2,"onHit",this.firstEvent);
         if(MainManager.getGlobalObject().data.seerMapDate == 1)
         {
            this.depth_mc.test_mc.visible = false;
            this.depth_mc.test_mc.gotoAndStop(1);
         }
         BC.addEvent(this,TalkEvent,"seer_sayOven",function(E:*):*
         {
            depth_mc.test_mc.visible = false;
            depth_mc.test_mc.gotoAndStop(1);
            MainManager.getGlobalObject().data.seerMapDate = 1;
         });
      }
      
      private function firstEvent(evt:*) : void
      {
         GV.MAN_PEOPLE.visible = false;
         BC.addEvent(this,GV.onlineSocket,"GO_TO_MAP_145",this.goToMap145);
         this.target_mc.mc_145.gotoAndStop(2);
      }
      
      private function goToMap145(evt:Event) : void
      {
         GF.switchMap(145,true);
      }
      
      private function secondEvent(evt:*) : void
      {
         GV.MAN_PEOPLE.visible = false;
         BC.addEvent(this,GV.onlineSocket,"GO_TO_MAP_123",this.goToMap123);
         this.target_mc.mc_123.gotoAndStop(2);
      }
      
      private function goToMap123(evt:Event) : void
      {
         GF.switchMap(123,true);
      }
      
      private function cheakTaskEvent() : void
      {
         var task106State:uint = TaskManager.getTaskState(106);
         if(task106State == 1)
         {
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.onTaskStatusCheck);
            JobExpandLogic.getJobExpand().getOneJob(106);
         }
      }
      
      private function onTaskStatusCheck(evt:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.onTaskStatusCheck);
         this.taskObj = evt.EventObj.obj;
         if(this.taskObj.flag == 0)
         {
            this.taskObj.flag = 1;
            this.target_mc.step_mc.visible = true;
            JobExpandLogic.getJobExpand().setOneJob(106,this.taskObj);
         }
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

