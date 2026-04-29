package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.events.Event;
   
   public class BaseOverJob extends BaseNPCModule
   {
      
      public function BaseOverJob()
      {
         super();
      }
      
      public function makeInfo(NPC_ID:String) : void
      {
         var obj:Object = XMLInfo.npcXML[NPC_ID];
         setInfo(obj);
      }
      
      override public function npcClientFun(a:* = null) : void
      {
         var ID:uint = uint(npc_obj.jobid);
         var nowmode:* = GV.JobLogics.findJobTaskStatus(ID);
         if(nowmode == 1)
         {
            GV.JobLogics.chartNowJobArr(ID);
            BC.addEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.showJobOver);
         }
         else if(nowmode >= 2)
         {
            if(npc_obj.msg3 != "no")
            {
               this.showTipFun(3);
            }
         }
         else if(nowmode == 0)
         {
            this.showTipFun(0);
         }
      }
      
      public function showJobOver(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.showJobOver);
         var get_arr:Array = e.EventObj.arr;
         if(get_arr.indexOf(0) != -1)
         {
            this.showTipFun(1);
         }
         else
         {
            if(npc_obj.jobid == 161)
            {
               if(LocalUserInfo.getCharm() >= 20)
               {
                  this.justOverJob();
                  return;
               }
               this.showTipFun(1);
               return;
            }
            this.justOverJob();
         }
      }
      
      public function justOverJob() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         TaskOverProtocol.send(npc_obj.jobid);
      }
      
      public function showOverJobAlert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         this.showTipFun(2);
      }
      
      public function showGetM(e:*) : void
      {
         this.showTipFun(4);
      }
      
      public function showNpcBtn(e:* = null) : void
      {
         this.dispatchEvent(new Event(SHOWNPCBTN));
      }
      
      public function showTipFun(type:uint) : void
      {
         var myAlert:* = undefined;
         var url:String = null;
         var msg:String = "";
         switch(type)
         {
            case 0:
               url = npc_obj.url0;
               msg = npc_obj.msg0;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
               break;
            case 1:
               url = npc_obj.url1;
               msg = npc_obj.msg1;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
               break;
            case 2:
               url = npc_obj.url2;
               msg = npc_obj.msg2;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showGetM);
               break;
            case 3:
               url = npc_obj.url3;
               msg = npc_obj.msg3;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
               break;
            case 4:
               url = npc_obj.url4;
               msg = npc_obj.msg4;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
         }
      }
   }
}

