package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.examinePack.examinePackStuff;
   import com.logic.socket.task.TaskOverProtocol;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BaseCityJOB extends BaseNPCModule
   {
      
      public var NPC_ID:uint;
      
      private var jobObj:Object;
      
      private var target_mc:MovieClip;
      
      public function BaseCityJOB()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
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
            JobExpandLogic.getJobExpand().getOneJob(92);
         }
         else if(nowmode >= 2)
         {
         }
      }
      
      public function checkInfoBack(e:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.checkInfoBack);
         this.jobObj = e.EventObj.obj;
         BC.addEvent(this,GV.onlineSocket,"read_" + 1915,this.getItemCountBack);
         examinePackStuff.examinePack_create([190527,190529]);
      }
      
      private function getItemCountBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1915,this.getItemCountBack);
         var itemObj:Object = evt.EventObj;
         if(itemObj.Count == 0)
         {
            this.jobObj.flag2 = 0;
            this.jobObj.flag4 = 0;
         }
         else if(itemObj.Count == 1)
         {
            if(itemObj.arr[0].itemID == 190527)
            {
               this.jobObj.flag2 = 1;
               this.jobObj.flag4 = 0;
            }
            else
            {
               this.jobObj.flag2 = 0;
               this.jobObj.flag4 = 1;
            }
         }
         else
         {
            this.jobObj.flag2 = 1;
            this.jobObj.flag4 = 1;
         }
         if(this.jobObj.flag1 == 1 && this.jobObj.flag2 == 1 && this.jobObj.flag3 == 1 && this.jobObj.flag4 == 1 && this.jobObj.flag5 == 1 && this.jobObj.flag6 == 1)
         {
            this.target_mc.npc92MC.play();
            BC.addEvent(this,GV.onlineSocket,"canOverJobNow",this.JobOver);
         }
         else
         {
            this.showTipFun(1);
         }
      }
      
      public function JobOver(evt:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         TaskOverProtocol.send(92);
      }
      
      private function showOverJobAlert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         this.showTipFun(2);
      }
      
      private function showGetM(e:* = null) : void
      {
         this.target_mc.npc92MC.play();
         this.showTipFun(3);
      }
      
      private function sandJobFun(evt:Event) : void
      {
         GV.JobLogics.changJobList(92,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.addJobData);
      }
      
      private function addJobData(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.addJobData);
         var obj:Object = {
            "flag1":0,
            "flag2":0,
            "flag3":0,
            "flag4":0,
            "flag5":0,
            "flag6":0
         };
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.setJobDataBack);
         JobExpandLogic.getJobExpand().setOneJob(92,obj);
      }
      
      private function setJobDataBack(evt:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.setJobDataBack);
         GV.JobViews.showJob(92);
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
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn,false,0,true);
               break;
            case 2:
               url = npc_obj.url2;
               msg = npc_obj.msg2;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showGetM,false,0,true);
               break;
            case 3:
               msg = "    恭喜你獲得聖誕小精靈服，已經放入你的百寶箱中了！";
               Alert.getIconByID_Alart(npc_obj.goodsID,msg);
         }
      }
   }
}

