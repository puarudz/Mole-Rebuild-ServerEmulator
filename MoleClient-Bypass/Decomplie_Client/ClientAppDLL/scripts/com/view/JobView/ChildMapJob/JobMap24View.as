package com.view.JobView.ChildMapJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   
   public class JobMap24View
   {
      
      private static var JobID:uint = 171;
      
      private var JobInfo:Object;
      
      public function JobMap24View()
      {
         super();
         this.JobInfo = GV.JobLogics.findJobArr(JobID);
         if(this.JobInfo.TaskStatus == 0)
         {
            this.beginJob();
         }
         else if(this.JobInfo.TaskStatus < 2)
         {
            this.chartJob();
         }
      }
      
      private function beginJob() : void
      {
         this.showAlert(4);
      }
      
      private function chartJob() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.chartBack);
         GV.JobLogics.chartNewJobArr(JobID);
      }
      
      private function chartBack(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.chartBack);
         var Arr:Array = event.EventObj.arr;
         if(Arr.indexOf(0) != -1)
         {
            this.showAlert(2);
         }
         else
         {
            this.justOverJob();
         }
      }
      
      private function justOverJob() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         TaskOverProtocol.send(JobID);
      }
      
      private function showOverJobAlert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         this.showAlert(1);
      }
      
      private function sandJobFun(e:*) : void
      {
         GV.JobLogics.changJobList(JobID,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.chartJobFun);
      }
      
      private function chartJobFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.chartJobFun);
         GV.JobViews.showJob(JobID);
      }
      
      private function showAlert(type:uint = 0) : void
      {
         var myAlert:* = undefined;
         var url:String = "";
         var msg:String = "";
         switch(type)
         {
            case 1:
               url = "resource/cloth/icon/12273.swf";
               msg = "    你獲得了一件充滿魔力的蛛絲隱身衣，它能使你消失的無影無踪哦！";
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
               break;
            case 2:
               url = "resource/allJob/AlertPic/loom.swf";
               msg = "    非常遺憾，因為你沒有足夠的材料，所以還無法製作蛛絲隱身衣，請繼續加油哦！";
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
               break;
            case 4:
               url = "resource/allJob/AlertPic/loom.swf";
               msg = "    這是一台充滿魔力的織布機，現在你只需要收集3根蜘蛛絲、5個空氣結晶和1個閃光粉，放入魔法織布機內就能製作成一件神奇的蛛絲隱身衣，穿上它後你將會變的無影無踪，任何摩爾都無法發現你哦！rr    是否馬上開始蛛絲隱身衣製作任務？";
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"Job_begin,notgo",true,false,"SMCUI");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.sandJobFun);
         }
      }
   }
}

