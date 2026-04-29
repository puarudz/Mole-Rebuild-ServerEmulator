package com.view.JobView.ChildNPCJob
{
   import com.common.Alert.Alert;
   import com.common.tip.*;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import com.module.ListSMC.ExNPC;
   import com.mole.app.task.TaskManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class simpleNPC extends MovieClip
   {
      
      internal var target_mc:MovieClip;
      
      internal var botton_mc:*;
      
      internal var tipbox_mc:MovieClip;
      
      internal var NPC_ID:int;
      
      internal var loop_num:int = 0;
      
      internal var LoopTipTimer:Timer = null;
      
      internal var IsCloseNpcTip:Boolean = false;
      
      internal var closeTipTimer:Timer = null;
      
      internal var nowJob_obj:Object;
      
      internal var nowJob_btns:String = "";
      
      internal var npc_obj:* = null;
      
      internal var npc_url:String;
      
      public function simpleNPC(box:MovieClip, btn:*, mc:MovieClip, ID:int)
      {
         super();
         this.target_mc = mc;
         this.botton_mc = btn;
         this.tipbox_mc = box;
         this.tipbox_mc.visible = false;
         this.NPC_ID = ID;
         this.npc_obj = ExNPC.ExNPC_arr[this.NPC_ID];
         this.npc_url = "resource/allJob/AlertPic/" + this.npc_obj.npcNameE + ".swf";
         BC.addEvent(this,this.botton_mc,MouseEvent.CLICK,this.CLICKFun);
         BC.addEvent(this,this.botton_mc,MouseEvent.MOUSE_OVER,this.OVERFun);
         BC.addEvent(this,this.botton_mc,MouseEvent.MOUSE_OUT,this.OUTFun);
         this.init();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEvent);
      }
      
      internal function init() : void
      {
         if(GV.isInMap[LocalUserInfo.getMapID() - 1] == 0)
         {
            this.chartObjMsg();
            this.otherChartMap();
         }
      }
      
      internal function otherChartMap() : void
      {
      }
      
      internal function chartObjMsg() : void
      {
         var ss:String = null;
         if(this.npc_obj.npcMsg != "no")
         {
            ss = String(this.npc_obj.npcMsg);
            if(ss.indexOf(";") == -1)
            {
               this.showNpcTip(this.npc_obj.npcMsg);
            }
            else
            {
               this.loop_num = 0;
               this.ShowLoopTip();
               this.LoopTipTimer = new Timer(10000,0);
               BC.addEvent(this,this.LoopTipTimer,TimerEvent.TIMER,this.ShowLoopTip);
               this.LoopTipTimer.start();
            }
         }
      }
      
      internal function npcTitFun() : void
      {
         this.botton_mc.visible = false;
         var url:String = this.npc_url;
         var msg:String = this.npc_obj.npcTip;
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"npcUI","424,336");
         BC.addEvent(this,myAlert,"CLOSED",this.showNpcBtn);
      }
      
      internal function JobView() : void
      {
         var url:String = null;
         var info:String = null;
         var myAle:* = undefined;
         var nowmode:uint = 0;
         this.botton_mc.visible = false;
         var btns:String = "Job_begin,nextCome";
         for(var i:int = 0; i < this.npc_obj.npcJob.length; i++)
         {
            this.nowJob_obj = this.npc_obj.npcJob[i];
            nowmode = TaskManager.getTaskState(this.nowJob_obj.JobID);
            if(nowmode == 0)
            {
               this.haveNotJob();
               break;
            }
            if(nowmode == 1)
            {
               if(this.nowJob_obj.JobID != 26)
               {
                  GV.JobLogics.chartNowJobArr(this.nowJob_obj.JobID);
                  BC.addEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.showJobOver);
               }
               break;
            }
            if(nowmode >= 2)
            {
               if(this.nowJob_obj.msg3 != "no")
               {
                  this.UpdateOverJob();
                  break;
               }
            }
         }
      }
      
      internal function UpdateOverJob() : void
      {
         var url:String = null;
         var info:String = null;
         var myAle:* = undefined;
         url = this.npc_url;
         info = this.nowJob_obj.msg3;
         myAle = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         BC.addEvent(this,myAle,Alert.CLICK_ + "1",this.showNpcBtn,false,0,true);
      }
      
      internal function showJobOver(e:EventTaomee) : void
      {
         var myAlert:* = undefined;
         var url:String = null;
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.showJobOver);
         var p:Boolean = false;
         var nowjob_arrs:* = e.EventObj.arr;
         for(var i:int = 0; i < nowjob_arrs.length; i++)
         {
            if(nowjob_arrs[i] == 0)
            {
               p = true;
            }
         }
         var msg:String = "";
         if(p)
         {
            url = "resource/allJob/AlertPic/" + this.npc_obj.npcNameE + this.nowJob_obj.JobID + "1.swf";
            msg = this.nowJob_obj.msg1;
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
            BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn,false,0,true);
         }
         else
         {
            this.justOverJob();
         }
      }
      
      internal function CLICKFun(evt:MouseEvent = null) : void
      {
         if(this.LoopTipTimer != null)
         {
            BC.removeEvent(this,this.LoopTipTimer,TimerEvent.TIMER,this.ShowLoopTip);
            this.LoopTipTimer.stop();
            this.LoopTipTimer = null;
            this.loop_num = 0;
         }
         if(this.closeTipTimer != null)
         {
            BC.removeEvent(this,this.closeTipTimer,TimerEvent.TIMER_COMPLETE,this.closeTipFun);
            this.closeTipTimer.stop();
            this.closeTipTimer = null;
         }
         this.cartoonFun(1);
         if(this.npc_obj.npcTip == "no" && this.npc_obj.Job == "no")
         {
            this.trySetOtherJob();
            return;
         }
         if(this.npc_obj.Job != "no")
         {
            this.JobView();
            return;
         }
         if(this.npc_obj.npcTip != "no")
         {
            this.npcTitFun();
            return;
         }
      }
      
      internal function showNpcBtn(e:* = null) : void
      {
         this.botton_mc.visible = true;
      }
      
      internal function OVERFun(evt:MouseEvent) : void
      {
         if(!this.IsCloseNpcTip)
         {
            this.cartoonFun();
         }
      }
      
      internal function OUTFun(evt:MouseEvent) : void
      {
         if(!this.IsCloseNpcTip)
         {
            this.cartoonFun(1);
         }
      }
      
      internal function setNowJobbtns(str:String = "Job_begin,nextCome") : void
      {
         this.nowJob_btns = str;
      }
      
      internal function getNowJobbtns() : String
      {
         return this.nowJob_btns;
      }
      
      internal function trySetOtherJob() : void
      {
      }
      
      internal function haveNotJob() : void
      {
         var url:String = "resource/allJob/AlertPic/" + this.npc_obj.npcNameE + this.nowJob_obj.JobID + "0.swf";
         var info:String = this.nowJob_obj.msg0;
         var myAle:* = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,this.nowJob_btns,true,false,"SMCUI","424,336");
         BC.addEvent(this,myAle,Alert.CLICK_ + "1",this.sandJobFun,false,0,true);
         BC.addEvent(this,myAle,Alert.CLICK_ + "2",this.showNpcBtn,false,0,true);
      }
      
      internal function justOverJob() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         TaskOverProtocol.send(this.nowJob_obj.JobID);
      }
      
      internal function showOverJobAlert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         this.overJobAlert(this.npc_url,this.nowJob_obj.msg2,this.nowJob_obj.JobID);
      }
      
      internal function overJobAlert(url:String, msg:String, JobID:uint) : void
      {
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showGetM,false,0,true);
      }
      
      internal function showGetM(e:*) : void
      {
         var ap:uint = uint(this.nowJob_obj.getGood[0]);
         var url:* = "resource/allJob/icon/" + ap + ".swf";
         var msg:* = "  " + GF.getItemName(ap).@Name + "已經放入你的百寶箱中。";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn,false,0,true);
      }
      
      internal function sandJobFun(e:*) : void
      {
         GV.JobLogics.changJobList(this.nowJob_obj.JobID,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.chartJobFun);
      }
      
      internal function chartJobFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.chartJobFun);
         var job_id:int = int(this.nowJob_obj.JobID);
         GV.JobViews.showJob(job_id);
         this.showNpcBtn();
      }
      
      internal function ShowLoopTip(e:TimerEvent = null) : void
      {
         var s:String = this.npc_obj.npcMsg;
         var arr:Array = s.split(";");
         if(this.loop_num < arr.length)
         {
            this.loop_num += 1;
         }
         if(this.loop_num == arr.length)
         {
            this.LoopTipTimer.stop();
            BC.removeEvent(this,this.LoopTipTimer,TimerEvent.TIMER,this.ShowLoopTip);
            this.LoopTipTimer = null;
         }
         this.showNpcTip(arr[this.loop_num - 1]);
      }
      
      internal function showNpcTip(msg:* = "no") : void
      {
         npcTip.showTip(this.tipbox_mc,msg);
         this.cartoonFun();
      }
      
      internal function closeTipFun(e:TimerEvent = null) : void
      {
         if(Boolean(this.closeTipTimer))
         {
            this.closeTipTimer.stop();
            BC.removeEvent(this,this.closeTipTimer,TimerEvent.TIMER_COMPLETE,this.closeTipFun);
         }
         this.cartoonFun(1);
      }
      
      internal function cartoonFun(type:int = 0) : void
      {
         if(type == 0)
         {
            this.IsCloseNpcTip = true;
            if(this.target_mc.shoe_mc.currentFrame == 1)
            {
               this.target_mc.visible = true;
               this.target_mc.mole_mc.body_mc.gotoAndPlay(2);
               this.target_mc.hear_mc.gotoAndPlay(2);
               this.target_mc.shoe_mc.gotoAndPlay(2);
               this.target_mc.cloth_mc.gotoAndPlay(2);
               this.closeTipTimer = new Timer(5000,1);
               BC.addEvent(this,this.closeTipTimer,TimerEvent.TIMER_COMPLETE,this.closeTipFun);
               this.closeTipTimer.start();
            }
         }
         else
         {
            this.IsCloseNpcTip = false;
            npcTip.hideTip(this.tipbox_mc);
            this.target_mc.gotoAndStop(1);
            this.target_mc.mole_mc.body_mc.gotoAndStop(1);
            this.target_mc.hear_mc.gotoAndStop(1);
            this.target_mc.shoe_mc.gotoAndStop(1);
            this.target_mc.cloth_mc.gotoAndStop(1);
         }
      }
      
      public function removeEvent(evt:Event = null) : void
      {
         this.removeOther();
         BC.removeEvent(this);
         if(this.closeTipTimer != null)
         {
            this.closeTipTimer.stop();
            this.closeTipTimer = null;
         }
         if(this.LoopTipTimer != null)
         {
            this.LoopTipTimer.stop();
            this.LoopTipTimer = null;
         }
         npcTip.hideTip(this.tipbox_mc);
         GC.stopAllMC(this.target_mc);
         this.target_mc = null;
         this.botton_mc = null;
         this.tipbox_mc = null;
         this.NPC_ID = NaN;
      }
      
      public function removeOther() : void
      {
      }
   }
}

