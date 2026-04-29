package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import com.mole.app.task.TaskManager;
   import flash.display.Sprite;
   
   public class BaseExpoJob extends Sprite
   {
      
      private var jobID:uint = 117;
      
      private var step:uint;
      
      public function BaseExpoJob()
      {
         super();
      }
      
      public function doJob1() : void
      {
         var taskState:uint = TaskManager.getTaskState(this.jobID);
         if(taskState == 0)
         {
            GV.JobLogics.changJobList(this.jobID,1);
            BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.acceptJob1Back);
         }
         else
         {
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJob1DataBack);
            JobExpandLogic.getJobExpand().getOneJob(this.jobID);
         }
      }
      
      private function acceptJob1Back(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.acceptJob1Back);
         GV.JobViews.showJob(this.jobID);
      }
      
      private function getJob1DataBack(evt:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJob1DataBack);
         if(evt.EventObj.obj.flag1 == 1 && evt.EventObj.obj.flag2 == 1 && evt.EventObj.obj.flag3 == 1)
         {
            BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob1Alert);
            TaskOverProtocol.send(this.jobID);
         }
      }
      
      private function showOverJob1Alert(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob1Alert);
         Alert.smileAlart("    恭喜你獲得10個青瓜和10個馬鈴薯，已經放入你的百寶箱中了！");
      }
   }
}

