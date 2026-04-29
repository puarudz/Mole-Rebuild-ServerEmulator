package com.view.JobView.ChildNPCJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.petSocket.askingPet.PetAskReq;
   import com.logic.socket.petSocket.askingPet.PetAskRes;
   import com.logic.socket.task.TaskOverProtocol;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class guideNPC extends simpleNPC
   {
      
      public function guideNPC(box:MovieClip, btn:*, mc:MovieClip, ID:int)
      {
         super(box,btn,mc,ID);
      }
      
      override internal function haveNotJob() : void
      {
         var url:String = "resource/allJob/AlertPic/" + npc_obj.npcNameE + nowJob_obj.JobID + "0.swf";
         var info:* = nowJob_obj.msg0;
         var btns:String = "";
         var ap:int = int(nowJob_obj.JobID);
         switch(ap)
         {
            case 24:
               btns = "otherJob_begin,otherJob_no";
               break;
            case 25:
               btns = "npcgo,notgo";
               break;
            case 26:
               btns = "go,notgo";
               break;
            case 27:
               btns = "go,notgo";
         }
         var myAle:* = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,btns,true,false,"SMCUI","424,336");
         BC.addEvent(this,myAle,Alert.CLICK_ + "1",this.sandJobFun,false,0,true);
         BC.addEvent(this,myAle,Alert.CLICK_ + "2",showNpcBtn,false,0,true);
      }
      
      override internal function sandJobFun(e:*) : void
      {
         var pp:* = undefined;
         if(nowJob_obj.JobID == 26)
         {
            TaskOverProtocol.send(nowJob_obj.JobID);
         }
         else
         {
            GV.JobLogics.changJobList(nowJob_obj.JobID,1);
         }
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.chartJobFun);
      }
      
      override internal function chartJobFun(e:EventTaomee) : void
      {
         var url:String = null;
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.chartJobFun);
         var job_id:int = int(nowJob_obj.JobID);
         if(job_id == 24)
         {
            GV.JobViews.showJob(job_id);
         }
         else if(job_id == 26)
         {
            url = "resource/allJob/icon/" + nowJob_obj.getGood[0] + ".swf";
            msg = "  " + nowJob_obj.getGoodname[0] + "已經放入你的投擲欄中，你可以點擊投擲道具按鈕來使用它們。";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
         showNpcBtn();
      }
      
      override internal function overJobAlert(url:String, msg:String, JobID:uint) : void
      {
         var myAlert:* = undefined;
         if(JobID == 24)
         {
            LocalUserInfo.countYXQ(500);
            LocalUserInfo.countExp(30);
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"fetch,otherJob_no",true,false,"SMCUI","424,336");
            BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.sandAskOne,false,0,true);
            BC.addEvent(this,myAlert,Alert.CLICK_ + "2",this.showGetM,false,0,true);
         }
         else
         {
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
            BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showGetM,false,0,true);
         }
      }
      
      private function sandAskOne(e:*) : void
      {
         BC.addEvent(this,GV.onlineClass,PetAskRes.ASKONEPETBACK,this.backOnePet);
         PetAskReq.askOnePet();
         showNpcBtn();
      }
      
      private function backOnePet(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineClass,PetAskRes.ASKONEPETBACK,this.backOnePet);
         var petID:uint = uint(e.EventObj.PetID);
         var str:String = "粉色拉姆已擺放在您的小屋中,請趕快回家看看吧!";
         var cla_temp:Class = GV.Lib_Map.getClass("buy_suc");
         var AlertMC:MovieClip = new cla_temp();
         AlertMC.name = "AlertMC";
         AlertMC.x = (MainManager.getStageWidth() - AlertMC.width) / 2;
         AlertMC.y = (MainManager.getStageHeight() - AlertMC.height) / 2;
         AlertMC.info.text = str;
         BC.addEvent(this,AlertMC.btn,MouseEvent.CLICK,this.showAltBtn);
         MainManager.getAppLevel().addChild(AlertMC);
      }
      
      private function showAltBtn(event:MouseEvent) : void
      {
         var tempMC:* = undefined;
         if(Boolean(MainManager.getAppLevel().getChildByName("AlertMC")))
         {
            tempMC = MainManager.getAppLevel().getChildByName("AlertMC");
            MainManager.getAppLevel().removeChild(tempMC);
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
            case 24:
               url = "resource/allJob/icon/" + "money" + ".swf";
               msg = "  " + nowJob_obj.getGoodname[0] + "已經放入你的百寶箱中。";
               break;
            case 25:
               url = "resource/allJob/icon/" + "money" + ".swf";
               msg = "  " + nowJob_obj.getGoodname[0] + "已經放入你的百寶箱中。";
               LocalUserInfo.countYXQ(600);
               break;
            case 27:
               url = "resource/cloth/icon/" + nowJob_obj.getGood[0] + ".swf";
               msg = "  " + nowJob_obj.getGoodname[0] + "已經放入你的百寶箱中。";
         }
         myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",showNpcBtn,false,0,true);
      }
   }
}

