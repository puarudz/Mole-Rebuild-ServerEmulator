package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import com.mole.app.task.TaskManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BaseMJob extends Sprite
   {
      
      private var jobIDArr:Array = [94,95,96,97];
      
      public function BaseMJob()
      {
         super();
      }
      
      public function doJob1() : void
      {
         var taskState:uint = TaskManager.getTaskState(this.jobIDArr[0]);
         if(taskState == 0)
         {
            GV.JobLogics.changJobList(this.jobIDArr[0],1);
            BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.acceptJob1Back);
         }
         else if(taskState == 1)
         {
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJob1DataBack);
            JobExpandLogic.getJobExpand().getOneJob(this.jobIDArr[0]);
         }
      }
      
      private function getJob1DataBack(evt:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJob1DataBack);
         var obj:Object = evt.EventObj.obj;
         if(obj.flag == 2)
         {
            this.jobOver1();
         }
      }
      
      private function jobOver1() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob1Alert);
         TaskOverProtocol.send(this.jobIDArr[0]);
      }
      
      public function showOverJob1Alert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob1Alert);
         this.sandJob2();
      }
      
      private function acceptJob1Back(e:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.acceptJob1Back);
         GV.onlineSocket.dispatchEvent(new Event("accept_job94"));
         GV.JobViews.showJob(this.jobIDArr[0]);
      }
      
      private function sandJob2() : void
      {
         GV.JobLogics.changJobList(this.jobIDArr[1],1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.acceptJob2Back);
      }
      
      private function acceptJob2Back(e:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.acceptJob2Back);
         var msg:String = "    恭喜你獲得了神秘地圖1，已經放入你的百寶箱中！";
         var url:String = "resource/cloth/icon/13166.swf";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showJob2Alert);
      }
      
      private function showJob2Alert(evt:Event) : void
      {
         GV.JobViews.showJob(this.jobIDArr[0]);
      }
      
      public function jobOver2() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob2Alert);
         TaskOverProtocol.send(this.jobIDArr[1]);
      }
      
      public function showOverJob2Alert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob2Alert);
         this.sandJob3();
      }
      
      private function sandJob3() : void
      {
         GV.JobLogics.changJobList(this.jobIDArr[2],1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.acceptJob3Back);
      }
      
      private function acceptJob3Back(e:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.acceptJob3Back);
         var msg:String = "    恭喜你獲得了神秘地圖2，已經放入你的百寶箱中！";
         var url:String = "resource/cloth/icon/13167.swf";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showJob3Alert);
      }
      
      private function showJob3Alert(evt:Event) : void
      {
         GV.JobViews.showJob(this.jobIDArr[0]);
      }
      
      public function jobOver3() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob3Alert);
         TaskOverProtocol.send(this.jobIDArr[2]);
      }
      
      public function showOverJob3Alert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob3Alert);
         this.sandJob4();
      }
      
      private function sandJob4() : void
      {
         GV.JobLogics.changJobList(this.jobIDArr[3],1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.acceptJob4Back);
      }
      
      private function acceptJob4Back(e:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.acceptJob4Back);
         var msg:String = "    恭喜你獲得了神秘地圖3，已經放入你的百寶箱中！";
         var url:String = "resource/cloth/icon/13216.swf";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showJob4Alert);
      }
      
      private function showJob4Alert(evt:Event) : void
      {
         GV.JobViews.showJob(this.jobIDArr[0]);
      }
      
      public function jobOver4() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob4Alert);
         TaskOverProtocol.send(this.jobIDArr[3]);
      }
      
      public function showOverJob4Alert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob4Alert);
         var msg:String = "    恭喜你獲得了拉姆世界地圖，已經放入你的百寶箱中！";
         var url:String = "resource/allJob/icon/190579.swf";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
   }
}

