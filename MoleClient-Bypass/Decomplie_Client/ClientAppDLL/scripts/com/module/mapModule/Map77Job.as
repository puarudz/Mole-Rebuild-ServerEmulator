package com.module.mapModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.mole.app.task.TaskManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class Map77Job extends Sprite
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      private var Job_Info:Object;
      
      private var timers:Timer;
      
      public function Map77Job(con:MovieClip, dep:MovieClip)
      {
         this.target_mc = con;
         this.depth_mc = dep;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeFun);
         super();
      }
      
      public function beginJob() : void
      {
         if(LocalUserInfo.getMapID() == 77)
         {
            this.setJobMap77();
         }
         else
         {
            this.setJobMapFun();
         }
      }
      
      private function setJobMap77() : void
      {
         var task77State:uint = TaskManager.getTaskState(77);
         if(task77State == 1)
         {
            this.depth_mc.depth_Job.visible = true;
            this.target_mc.Job_btn.visible = true;
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobInfo);
            JobExpandLogic.getJobExpand().getOneJob(77);
         }
         else
         {
            this.depth_mc.depth_Job.visible = false;
            this.target_mc.Job_btn.visible = false;
         }
      }
      
      private function getJobInfo(eve:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobInfo);
         this.Job_Info = eve.EventObj.obj;
         if(this.Job_Info.flag1 == 0)
         {
            BC.addEvent(this,this.target_mc.Job_btn,MouseEvent.CLICK,this.JobFun77);
         }
         else
         {
            BC.addEvent(this,this.target_mc.Job_btn,MouseEvent.CLICK,this.JobFun77ok);
         }
      }
      
      private function JobFun77(eve:MouseEvent) : void
      {
         BC.removeEvent(this,this.target_mc.Job_btn,MouseEvent.CLICK,this.JobFun77);
         this.depth_mc.depth_Job.gotoAndStop(2);
         this.timers = GC.setGTimeout(this.Set77Info,1500);
      }
      
      private function Set77Info() : void
      {
         GC.clearGTimeout(this.timers);
         this.timers = null;
         this.Job_Info.flag1 = 1;
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.get77Item);
         JobExpandLogic.getJobExpand().setOneJob(77,this.Job_Info);
      }
      
      private function get77Item(eve:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.get77Item);
         this.Job_Info = eve.EventObj.obj;
         Alert.showAlert(MainManager.getAppLevel(),"resource/allJob/icon/Job77_01.swf","      水之力量，帶給你魔法五彩布！",Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         if(this.Job_Info.arr.indexOf(0) == -1)
         {
            GV.JobViews.showJob(77);
         }
      }
      
      private function JobFun77ok(eve:MouseEvent) : void
      {
         BC.removeEvent(this,this.target_mc.Job_btn,MouseEvent.CLICK,this.JobFun77ok);
         Alert.showAlert(GV.MC_AppLever,"你已經拿到魔法布了哦！","",Alert.ICO_ALERT2,"E");
      }
      
      private function setJobMapFun() : void
      {
         var task77State:uint = TaskManager.getTaskState(77);
         if(task77State != 1)
         {
            this.target_mc.Job_mc.visible = false;
            return;
         }
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobInfoFun);
         JobExpandLogic.getJobExpand().getOneJob(77);
      }
      
      private function getJobInfoFun(eve:EventTaomee) : void
      {
         var temp_:MovieClip = null;
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobInfoFun);
         this.Job_Info = eve.EventObj.obj;
         for(var i:uint = 0; i < this.target_mc.Job_mc.numChildren; i++)
         {
            temp_ = this.target_mc.Job_mc.getChildAt(i);
            temp_.buttonMode = true;
            temp_.gotoAndStop(1);
            if(this.Job_Info.flag2 == 0 && LocalUserInfo.getMapID() == 41)
            {
               BC.addEvent(this,temp_,MouseEvent.CLICK,this.randomGetItem);
            }
            else if(this.Job_Info.flag3 == 0 && LocalUserInfo.getMapID() == 24)
            {
               BC.addEvent(this,temp_,MouseEvent.CLICK,this.randomGetItem);
            }
            else
            {
               BC.addEvent(this,temp_,MouseEvent.CLICK,this.JobFunOK);
            }
         }
      }
      
      private function randomGetItem(eve:MouseEvent) : void
      {
         var num:uint = 0;
         var temp_:* = eve.currentTarget;
         if(this.Job_Info.flag2 == 0 && LocalUserInfo.getMapID() == 41)
         {
            num = uint(Math.random() * 10);
         }
         else if(this.Job_Info.flag3 == 0 && LocalUserInfo.getMapID() == 24)
         {
            num = uint(Math.random() * 10);
         }
         else
         {
            num = 1;
         }
         if(num > 5)
         {
            temp_.gotoAndStop(3);
            this.timers = GC.setGTimeout(this.SetInfo,1500);
         }
         else
         {
            temp_.gotoAndStop(2);
         }
      }
      
      private function SetInfo() : void
      {
         GC.clearGTimeout(this.timers);
         this.timers = null;
         if(LocalUserInfo.getMapID() == 41)
         {
            this.Job_Info.flag2 = 1;
         }
         else if(LocalUserInfo.getMapID() == 24)
         {
            this.Job_Info.flag3 = 1;
         }
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getItem);
         JobExpandLogic.getJobExpand().setOneJob(77,this.Job_Info);
      }
      
      private function getItem(eve:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getItem);
         this.Job_Info = eve.EventObj.obj;
         var url:String = "";
         var msg:String = "";
         if(LocalUserInfo.getMapID() == 41)
         {
            url = "resource/allJob/icon/Job77_02.swf";
            msg = "        木之能量，帶給你魔法金線！";
         }
         else if(LocalUserInfo.getMapID() == 24)
         {
            url = "resource/allJob/icon/Job77_03.swf";
            msg = "          恭喜你找到天使絲帶！";
         }
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         if(this.Job_Info.arr.indexOf(0) == -1)
         {
            GV.JobViews.showJob(77);
         }
      }
      
      private function JobFunOK(eve:MouseEvent) : void
      {
         if(LocalUserInfo.getMapID() == 41)
         {
            Alert.showAlert(GV.MC_AppLever,"你已經拿到魔法金線了哦！","",Alert.ICO_ALERT2,"E");
         }
         else if(LocalUserInfo.getMapID() == 24)
         {
            Alert.showAlert(GV.MC_AppLever,"你已經拿到天使絲帶了哦！","",Alert.ICO_ALERT2,"E");
         }
      }
      
      public function removeFun(eve:EventTaomee) : void
      {
         BC.removeEvent(this);
         if(Boolean(this.timers))
         {
            GC.clearGTimeout(this.timers);
            this.timers = null;
         }
      }
   }
}

