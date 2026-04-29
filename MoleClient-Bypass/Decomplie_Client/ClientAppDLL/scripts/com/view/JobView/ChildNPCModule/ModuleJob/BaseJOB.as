package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.events.Event;
   import flash.utils.Timer;
   
   public class BaseJOB extends BaseNPCModule
   {
      
      public var NPC_ID:uint;
      
      private var npc_times:Timer = null;
      
      public function BaseJOB()
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
         if(nowmode == 0)
         {
            this.showTipFun(0);
         }
         else if(nowmode == 1)
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
      }
      
      override public function removeEventFun() : void
      {
         if(this.npc_times != null)
         {
            GC.clearGTimeout(this.npc_times);
            this.npc_times = null;
         }
         BC.removeEvent(this);
      }
      
      public function showJobOver(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.showJobOver);
         var get_arr:Array = e.EventObj.arr;
         if(get_arr.indexOf(0) != -1)
         {
            if(npc_obj.jobid == 70)
            {
               GV.JobViews.showJob(npc_obj.job_id);
            }
            else
            {
               this.showTipFun(1);
            }
         }
         else
         {
            this.justOverJob();
         }
      }
      
      public function justOverJob() : void
      {
         this.JobOver();
      }
      
      public function JobOver() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         TaskOverProtocol.send(npc_obj.jobid);
      }
      
      public function showOverJobAlert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         this.showTipFun(2);
         if(npc_obj.jobid == 152)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("petAction_suc_over"));
         }
      }
      
      public function showGetM(e:*) : void
      {
         if(npc_obj.jobid == 172)
         {
            GV.MC_mapFrame["control_mc"].cat_mc.mc.gotoAndStop(2);
            this.npc_times = GC.setGTimeout(this.showTipFun,4000,4);
         }
         else
         {
            this.showTipFun(4);
         }
      }
      
      public function sandJobFun(e:*) : void
      {
         GV.JobLogics.changJobList(npc_obj.jobid,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showBtnFun);
      }
      
      public function showBtnFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showBtnFun);
         var job_id:int = int(npc_obj.jobid);
         GV.JobViews.showJob(job_id);
         this.showNpcBtn();
         if(npc_obj.jobid == 152)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("show_game_btn"));
         }
      }
      
      public function showNpcBtn(e:* = null) : void
      {
         this.dispatchEvent(new Event(SHOWNPCBTN));
      }
      
      public function showTipFun(type:uint) : void
      {
         var myAlert:* = undefined;
         var url:String = null;
         var names:String = null;
         var msg:String = "";
         switch(type)
         {
            case 0:
               url = npc_obj.url0;
               msg = npc_obj.msg0;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"Job_begin,nextCome",true,false,"SMCUI");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.sandJobFun,false,0,true);
               BC.addEvent(this,myAlert,Alert.CLICK_ + "2",this.showNpcBtn,false,0,true);
               break;
            case 1:
               url = npc_obj.url1;
               msg = npc_obj.msg1;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
               break;
            case 2:
               if(npc_obj.jobid == 152)
               {
                  return;
               }
               url = npc_obj.url2;
               msg = npc_obj.msg2;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showGetM);
               break;
            case 3:
               if(npc_obj.jobid == 152)
               {
                  return;
               }
               url = npc_obj.url3;
               msg = npc_obj.msg3;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
               break;
            case 4:
               if(npc_obj.jobid == 152)
               {
                  return;
               }
               if(this.npc_times != null)
               {
                  GC.clearGTimeout(this.npc_times);
                  this.npc_times = null;
               }
               if(GF.getItemName(npc_obj.goodsID).@Name == null)
               {
                  url = String(GF.getItemName(npc_obj.goodsID).@typeObject.path) + npc_obj.goodsID + ".swf";
                  names = String(GF.getItemName(npc_obj.goodsID).@Name);
               }
               else
               {
                  url = String(GoodsInfo.getInfoById(npc_obj.goodsID).typeObject.path) + npc_obj.goodsID + ".swf";
                  names = GoodsInfo.getItemNameByID(npc_obj.goodsID);
               }
               msg = "  " + names + "已經放入你的百寶箱中。";
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
         }
      }
   }
}

