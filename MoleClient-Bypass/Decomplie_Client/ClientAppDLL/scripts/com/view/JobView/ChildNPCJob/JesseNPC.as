package com.view.JobView.ChildNPCJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import flash.display.MovieClip;
   
   public class JesseNPC extends simpleNPC
   {
      
      public function JesseNPC(box:MovieClip, btn:*, mc:MovieClip, ID:int)
      {
         super(box,btn,mc,ID);
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
            case 0:
               if(LocalUserInfo.getCharm() >= 20)
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
            case 0:
               url = "resource/cloth/icon/" + nowJob_obj.getGood[0] + ".swf";
               msg = "  " + nowJob_obj.getGoodname[0] + "已經放入你的百寶箱中。";
               LocalUserInfo.countExp(50);
         }
         myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",showNpcBtn,false,0,true);
      }
   }
}

