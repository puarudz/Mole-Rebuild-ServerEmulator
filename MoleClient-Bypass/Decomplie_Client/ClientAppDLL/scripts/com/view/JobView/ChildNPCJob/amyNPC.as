package com.view.JobView.ChildNPCJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import flash.display.MovieClip;
   
   public class amyNPC extends simpleNPC
   {
      
      public function amyNPC(box:MovieClip, btn:*, mc:MovieClip, ID:int)
      {
         super(box,btn,mc,ID);
      }
      
      override internal function haveNotJob() : void
      {
         var url:String = "resource/allJob/AlertPic/" + npc_obj.npcNameE + nowJob_obj.JobID + "0.swf";
         var info:String = nowJob_obj.msg0;
         var myAle:* = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI","424,336");
         BC.addEvent(this,myAle,Alert.CLICK_ + "1",showNpcBtn,false,0,true);
      }
      
      override internal function justOverJob() : void
      {
         var myAlert:* = undefined;
         var url:String = null;
         var msg:String = "";
         var ap:int = int(nowJob_obj.JobID);
         switch(ap)
         {
            case 16:
               url = "resource/allJob/AlertPic/" + npc_obj.npcNameE + nowJob_obj.JobID + "2.swf";
               msg = nowJob_obj.msg2;
               myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.getOtherGoods,false,0,true);
               BC.addEvent(this,myAlert,Alert.CLICK_ + "2",showNpcBtn,false,0,true);
               break;
            case 17:
               ap = LocalUserInfo.getIQ();
               if(LocalUserInfo.getIQ() >= 20)
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
            case 17:
               url = "resource/allJob/icon/amy17.swf";
               msg = "    " + nowJob_obj.getGoodname[0] + "已經放入你的百寶箱中。";
         }
         myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",showNpcBtn,false,0,true);
      }
      
      private function getOtherGoods(event:*) : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOtherGoodsAlert);
         TaskOverProtocol.send(nowJob_obj.JobID);
      }
      
      private function showOtherGoodsAlert(event:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOtherGoodsAlert);
         var url:String = npc_url;
         var msg:String = "    恭喜！你的拉姆完成了照相機的拼裝，現在就擺放在出版社的沙發上，你在後續的記者就職任務中有可能會用到它哦！";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         GV.onlineSocket.dispatchEvent(new EventTaomee("showCameraMC"));
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",showNpcBtn,false,0,true);
      }
   }
}

