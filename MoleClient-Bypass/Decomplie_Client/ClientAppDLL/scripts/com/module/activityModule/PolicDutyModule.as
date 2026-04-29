package com.module.activityModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.socket.action.ActionReq;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.finishSomething.finishedSomethingReq;
   import com.logic.socket.finishSomething.finishedSomethingRes;
   import com.mole.app.task.TaskManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PolicDutyModule
   {
      
      private static var instance:PolicDutyModule;
      
      private var tagetMC:MovieClip;
      
      private var workTimer:Timer;
      
      private var actionReq:ActionReq;
      
      private var nowTime:Number = 0;
      
      private var taskObj:Object;
      
      public function PolicDutyModule()
      {
         super();
      }
      
      public static function getInstance() : PolicDutyModule
      {
         if(instance == null)
         {
            instance = new PolicDutyModule();
         }
         return instance;
      }
      
      public function init(target:MovieClip) : void
      {
         this.tagetMC = target;
         if(!this.checkCloth())
         {
            this.autoMove();
            this.errorTip();
            return;
         }
         var task9State:uint = TaskManager.getTaskState(9);
         if(task9State == 0)
         {
            this.noTaskTip();
            this.autoMove();
            return;
         }
         if(task9State == 2)
         {
            this.taskOverForWeekView();
            this.autoMove();
            return;
         }
         JobExpandLogic.getJobExpand().addEventListener(JobExpandLogic.ONEJOBINFO,this.getTaskEvent);
         JobExpandLogic.getJobExpand().getOneJob(9);
      }
      
      private function getTaskEvent(evt:EventTaomee) : void
      {
         JobExpandLogic.getJobExpand().removeEventListener(JobExpandLogic.ONEJOBINFO,this.getTaskEvent);
         this.taskObj = evt.EventObj.obj;
         JobExpandLogic.getJobExpand().addEventListener(JobExpandLogic.NOWTIMES,this.getServerTime);
         JobExpandLogic.getJobExpand().getServerTime();
      }
      
      private function getServerTime(evt:EventTaomee) : void
      {
         JobExpandLogic.getJobExpand().removeEventListener(JobExpandLogic.NOWTIMES,this.getServerTime);
         if(this.taskObj.mapID != LocalUserInfo.getMapID())
         {
            this.errorPathView();
            this.autoMove();
            return;
         }
         if(evt.EventObj.obj - this.taskObj.times >= 86400 * 7000)
         {
            this.noTaskTip();
            this.autoMove();
            return;
         }
         if(this.taskObj.Flag >= 2)
         {
            this.taskOverView();
            this.autoMove();
            return;
         }
         this.checkIswork();
      }
      
      private function checkIswork() : void
      {
         finishSomethingReq.sendReq(102);
         GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
      }
      
      private function dofinishSomething(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
         if(e.EventObj.Type == 102)
         {
            if(e.EventObj.Done == 1)
            {
               this.alreadyView();
               this.autoMove();
               return;
            }
            this.timeForWork();
            this.tagetMC.policBtn.gotoAndStop(2);
            this.justDo();
         }
      }
      
      private function timeForWork() : void
      {
         if(this.workTimer == null)
         {
            this.workTimer = new Timer(120000);
         }
         this.correctTip();
         this.workTimer.addEventListener(TimerEvent.TIMER,this.cleanWorkEvent);
         GV.onlineSocket.addEventListener("iskaddish",this.leaveEvent);
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
         this.workTimer.start();
      }
      
      private function cleanWorkEvent(evt:TimerEvent) : void
      {
         this.leaveEvent();
         this.autoMove();
         this.sendServer();
      }
      
      private function sendServer() : void
      {
         GV.onlineSocket.addEventListener(finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.dofinishwork);
         finishedSomethingReq.sendReq(102);
      }
      
      private function dofinishwork(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.dofinishwork);
         ++this.taskObj.Flag;
         if(this.taskObj.Flag >= 2)
         {
            this.taskOverView();
         }
         else
         {
            this.finishView();
         }
         JobExpandLogic.getJobExpand().setOneJob(this.taskObj.job,this.taskObj);
      }
      
      private function removeEventHandler(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         this.leaveEvent();
      }
      
      private function leaveEvent(evt:Event = null) : void
      {
         this.workTimer.removeEventListener(TimerEvent.TIMER,this.cleanWorkEvent);
         GV.onlineSocket.removeEventListener("iskaddish",this.leaveEvent);
         this.tagetMC.policBtn.gotoAndStop(1);
         this.workTimer.stop();
         this.workTimer.reset();
      }
      
      private function checkCloth() : Boolean
      {
         if(Boolean(GV.JobLogics.chartbagClothFun([[12057,12058,12059]])))
         {
            return true;
         }
         return false;
      }
      
      private function SMCTip() : void
      {
         var msg:String = "    你還不是SMC警官哦，還不可以在這裡值勤。快去莊園警署" + "找艾爾警官，加入到SMC警官的隊伍中吧！";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/001.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function noTaskTip() : void
      {
         var msg:String = "    做為一名稱職的警官你有義務去維護莊園的安定和平，每個SMC警官" + "都必須付出自己的努力，進行日常的站崗值勤！如果你想加入值勤可以直接點擊右" + "上角的SMC徽章。";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/001.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function errorTip() : void
      {
         var msg:String = "    你想為保護莊園出一份力嗎？請你先完成警官任務，穿好警官服，再來站崗" + "值勤吧！莊園的安全需要大家的共同努力哦！";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/002.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function correctTip() : void
      {
         var msg:String = "    你已經開始站崗了，兩分鐘不要動哦！加油！";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/003.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function alreadyView() : void
      {
         var msg:String = "    你今天已經站過一次崗啦，是一名很稱職的警官哦！如果你想保護我們" + "的莊園，為摩爾莊園的公民財產盡一份力，那就請明天再來站崗吧，今天請你好好休息哦！";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/005.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function finishView() : void
      {
         var msg:String = "    這次值勤已經完成，你得到了一次考勤記錄，可以在任務面板裡面" + "查看哦！辛苦啦！莊園公民向你致敬！";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/004.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function errorPathView() : void
      {
         var msg:String = "    這裡不是你負責的區域哦！快快查看你的值勤說明，找到" + "正確的站崗地點，為保護莊園出一份力吧！";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/006.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function taskOverView() : void
      {
         var msg:String = "    現在你已經完成了所有的站崗任務，趕快到摩爾莊園警署的公告欄上簽到吧！";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/001.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function taskOverForWeekView() : void
      {
         var msg:String = "    這週你已經完成任務了，是一名很稱職的警官哦！如果你想保護我們的莊" + "園，那就請下週再來站崗吧，這週請你好好休息!";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/006.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function autoMove() : void
      {
         var tempX:int = 0;
         var tempY:int = 0;
         if(Boolean(this.tagetMC))
         {
            this.tagetMC.policBtn.gotoAndStop(1);
            tempX = int(GV.MAN_PEOPLE.x);
            tempY = GV.MAN_PEOPLE.y + 80;
            MoveTo.AutoFind(tempX,tempY,GV.MAN_PEOPLE);
         }
      }
      
      private function justDo() : void
      {
         GV.MAN_PEOPLE.avatarClass.addEventListener("wave_警察_down",this.stopHandler);
         if(Boolean(GV.MAN_PEOPLE.wave()))
         {
            GV.MAN_PEOPLE.avatarClass.removeEventListener("wave_警察_down",this.stopHandler);
            if(this.actionReq == null)
            {
               this.actionReq = new ActionReq();
            }
            this.actionReq.actions(2,0);
         }
      }
      
      private function stopHandler(E:Event) : void
      {
         GC.setGTimeout(function():void
         {
            var tempPeople:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
            if(Boolean(tempPeople) && Boolean(tempPeople.avatarMC) && Boolean(tempPeople.avatarMC.Visualize_mc))
            {
               GC.stopAllMC(tempPeople.avatarMC.Visualize_mc);
            }
         },1000);
      }
   }
}

