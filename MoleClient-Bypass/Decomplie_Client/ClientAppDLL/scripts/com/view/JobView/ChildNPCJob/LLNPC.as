package com.view.JobView.ChildNPCJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.giveMeMoney.*;
   import com.logic.socket.task.TaskOverProtocol;
   import com.mole.app.task.TaskManager;
   import flash.display.MovieClip;
   
   public class LLNPC extends simpleNPC
   {
      
      private var giveCS:giveMeMoneyReq;
      
      public function LLNPC(box:MovieClip, btn:*, mc:MovieClip, ID:int)
      {
         super(box,btn,mc,ID);
      }
      
      override internal function JobView() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.BAGOTHERLIST,this.chartAddGoodsFun);
         GV.JobLogics.sandBeg(128);
      }
      
      private function chartAddGoodsFun(evt:EventTaomee) : void
      {
         var url:String = null;
         var info:String = null;
         var myAle:* = undefined;
         var taskState:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,JobLogic.BAGOTHERLIST,this.chartAddGoodsFun);
         var bag_arr:Array = evt.EventObj.obj.arr;
         var goods_arr:Array = new Array();
         for(var ad:uint = 0; ad < bag_arr.length; ad++)
         {
            goods_arr.push(bag_arr[ad].id);
         }
         botton_mc.visible = false;
         var btns:String = "Job_begin,nextCome";
         for(var i:int = 0; i < npc_obj.npcJob.length; i++)
         {
            nowJob_obj = npc_obj.npcJob[i];
            taskState = TaskManager.getTaskState(nowJob_obj.JobID);
            if(taskState == 0)
            {
               this.haveNotJob();
               break;
            }
            if(taskState == 1)
            {
               if(nowJob_obj.JobID != 26)
               {
                  GV.JobLogics.chartNowJobArr(nowJob_obj.JobID);
                  BC.addEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,showJobOver);
               }
               break;
            }
            if(taskState >= 2)
            {
               if(nowJob_obj.msg3 != "no")
               {
                  this.UpdateOverJob();
                  break;
               }
            }
         }
      }
      
      override internal function UpdateOverJob() : void
      {
         var info:String = null;
         var myAle:* = undefined;
         var url:String = "resource/allJob/AlertPic/PoliceDuty/001.swf";
         info = nowJob_obj.msg3;
         myAle = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         BC.addEvent(this,myAle,Alert.CLICK_ + "1",showNpcBtn,false,0,true);
      }
      
      override internal function haveNotJob() : void
      {
         if(npc_obj.npcTip != "no")
         {
            npcTitFun();
         }
      }
      
      override internal function justOverJob() : void
      {
         var myAlert:* = undefined;
         var url:String = null;
         var msg:String = "";
         var ap:int = int(nowJob_obj.JobID);
         switch(ap)
         {
            case 8:
               if(LocalUserInfo.getStrong() >= 20)
               {
                  BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,showOverJobAlert);
                  TaskOverProtocol.send(nowJob_obj.JobID);
               }
               else
               {
                  url = "resource/allJob/AlertPic/" + npc_obj.npcNameE + nowJob_obj.JobID + "1.swf";
                  msg = nowJob_obj.msg1;
                  myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
                  BC.addEvent(this,myAlert,Alert.CLICK_ + "1",showNpcBtn,false,0,true);
               }
         }
      }
      
      override internal function showGetM(e:*) : void
      {
         var myAlert:* = undefined;
         var url:String = "";
         var msg:String = "";
         var ap:int = int(nowJob_obj.JobID);
         switch(ap)
         {
            case 8:
               url = "resource/cloth/icon/" + nowJob_obj.getGood[0] + ".swf";
               msg = "  " + nowJob_obj.getGoodname[0] + "已經放入你的百寶箱中。";
               LocalUserInfo.countExp(50);
         }
         myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",showNpcBtn,false,0,true);
      }
   }
}

