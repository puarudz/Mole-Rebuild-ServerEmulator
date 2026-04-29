package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.JobLogic.JobLogic;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.events.Event;
   
   public class BaseGiftJOB extends BaseNPCModule
   {
      
      public var NPC_ID:uint;
      
      private var jobObj:Object;
      
      public function BaseGiftJOB()
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
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.checkInfoBack);
            JobExpandLogic.getJobExpand().getOneJob(93);
         }
         else if(nowmode >= 2)
         {
         }
      }
      
      public function checkInfoBack(e:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.checkInfoBack);
         this.jobObj = e.EventObj.obj;
         if(this.jobObj.flag1 == 1 && this.jobObj.flag2 == 1 && this.jobObj.flag3 == 1 && this.jobObj.flag4 == 1 && this.jobObj.isNoJob == 0)
         {
            this.showTipFun(2);
         }
      }
      
      public function JobOver(evt:Event = null) : void
      {
         this.jobObj.isOver = 1;
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.setOverJobData);
         JobExpandLogic.getJobExpand().setOneJob(93,this.jobObj);
      }
      
      public function setOverJobData(e:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.setOverJobData);
         GV.JobViews.showJob(93);
      }
      
      public function sandJobFun(e:*) : void
      {
         GV.JobLogics.changJobList(npc_obj.jobid,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.setJobInfo);
      }
      
      private function setJobInfo(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.setJobInfo);
         var obj:Object = {
            "isSearch":0,
            "flag1":0,
            "flag2":0,
            "flag3":0,
            "flag4":0,
            "isOver":0
         };
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.setJobInfoBack);
         JobExpandLogic.getJobExpand().setOneJob(npc_obj.jobid,obj);
      }
      
      private function setJobInfoBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.setJobInfoBack);
         var job_id:int = int(npc_obj.jobid);
         GV.JobViews.showJob(job_id);
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
               url = npc_obj.url2;
               msg = npc_obj.msg2;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"keepGift,nextCome",true,false,"SMCUI");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.JobOver,false,0,true);
               BC.addEvent(this,myAlert,Alert.CLICK_ + "2",this.showNpcBtn,false,0,true);
         }
      }
   }
}

