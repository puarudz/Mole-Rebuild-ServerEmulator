package com.view.JobView.ChildNPCModule.ChildNpc
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.task.TaskOverProtocol;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.task.TaskManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class DriveNpcJob extends Sprite
   {
      
      private var jobID:uint = 141;
      
      private var npc_obj:Object;
      
      public function DriveNpcJob()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEvent);
         this.init();
      }
      
      private function init() : void
      {
         this.npc_obj = XMLInfo.npcXML[this.jobID];
         SystemEventManager.addEventListener("baita_openSMC",this.onOpenSmc);
      }
      
      public function onOpenSmc(e:Event) : void
      {
         var myAlert:* = undefined;
         var url:String = "";
         var msg:String = "";
         var taskState:uint = TaskManager.getTaskState(this.jobID);
         if(taskState == 0)
         {
            url = this.npc_obj.url0;
            msg = this.npc_obj.msg0;
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
         else if(taskState == 1)
         {
            BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkJobBack);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190426,2);
         }
         else if(taskState >= 2)
         {
            url = this.npc_obj.url3;
            msg = this.npc_obj.msg3;
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
      }
      
      private function checkJobBack(eve:EventTaomee) : void
      {
         var myAlert:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkJobBack);
         var url:String = "";
         var msg:String = "";
         var obj:Object = eve.EventObj.obj;
         if(obj.Count <= 0)
         {
            url = this.npc_obj.url1;
            msg = this.npc_obj.msg1;
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
         else
         {
            url = this.npc_obj.url2;
            msg = this.npc_obj.msg2;
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
            BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.overJobFun);
         }
      }
      
      private function overJobFun(eve:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         TaskOverProtocol.send(this.jobID);
      }
      
      private function showOverJobAlert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         var url:String = this.npc_obj.url4;
         var msg:String = this.npc_obj.msg4;
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      public function removeEvent(eve:*) : void
      {
         SystemEventManager.removeEventListener("baita_openSMC",this.onOpenSmc);
         BC.removeEvent(this);
      }
   }
}

