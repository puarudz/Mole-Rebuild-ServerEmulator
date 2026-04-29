package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.XMLInfo;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import com.module.deal.Deal;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Timer;
   
   public class BaseRescueJOB extends BaseNPCModule
   {
      
      public var NPC_ID:uint;
      
      private var npc_times:Timer = null;
      
      private var filmMC:MovieClip;
      
      public function BaseRescueJOB()
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
         var loader:MCLoader = null;
         var ID:uint = uint(npc_obj.jobid);
         var nowmode:* = GV.JobLogics.findJobTaskStatus(ID);
         if(nowmode == 0)
         {
            this.filmMC = new MovieClip();
            MainManager.getGameLevel().addChild(this.filmMC);
            loader = new MCLoader("module/external/fayeFilm.swf",this.filmMC,1,"正在加載動畫......");
            loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSuccFun);
            loader.doLoad();
         }
         else if(nowmode == 1)
         {
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.checkInfoBack);
            JobExpandLogic.getJobExpand().getOneJob(91);
         }
         else if(nowmode >= 2)
         {
         }
      }
      
      private function loadSuccFun(evt:MCLoadEvent) : void
      {
         GameframeLogic.stopMousicHandler();
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         BC.addEvent(this,GV.onlineSocket,"film_end",this.removeFilm);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadSuccFun);
         mcloader.clear();
      }
      
      private function removeFilm(evt:Event) : void
      {
         GameframeLogic.playMousicHandler();
         BC.removeEvent(this,GV.onlineSocket,"film_end",this.removeFilm);
         MainManager.getGameLevel().removeChild(this.filmMC);
         this.filmMC = null;
         this.showTipFun(0);
      }
      
      public function checkInfoBack(e:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.checkInfoBack);
         var obj:Object = e.EventObj.obj;
         if(obj.redFlag1 == 2 && obj.redFlag2 == 2 && obj.redFlag2 == 2 && obj.orangeFlag == 2 && obj.pinkFlag == 2 && obj.carFlag == 1)
         {
            this.justOverJob();
         }
         else
         {
            this.showTipFun(1);
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
      }
      
      public function showGetM(e:*) : void
      {
         this.showTipFun(4);
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
            "isGet":0,
            "redFlag1":0,
            "redFlag2":0,
            "redFlag3":0,
            "orangeFlag":0,
            "pinkFlag":0
         };
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.setJobInfoBack);
         JobExpandLogic.getJobExpand().setOneJob(npc_obj.jobid,obj);
      }
      
      private function setJobInfoBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.setJobInfoBack);
         var job_id:int = int(npc_obj.jobid);
         GV.JobViews.showJob(job_id);
         this.getBallonFun();
         BC.addEvent(this,GV.onlineSocket,"close_christmas_rescue",this.showFayeTip);
      }
      
      private function showFayeTip(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"close_christmas_rescue",this.showFayeTip);
         this.showTipFun(3);
      }
      
      private function getBallonFun(evt:Event = null) : void
      {
         Deal.BuyItem(1220118,1);
      }
      
      private function getBallonSucc(evt:Event) : void
      {
         var url:String = "resource/home/item/icon/1220118.swf";
         var msg:String = "　  這是小精靈送給你的心願傳遞氣球，快去自己的家園倉庫裡找找吧！";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
      }
      
      public function showNpcBtn(e:* = null) : void
      {
         this.dispatchEvent(new Event(SHOWNPCBTN));
      }
      
      private function startCarFun(e:Event) : void
      {
         this.showNpcBtn();
         GV.onlineSocket.dispatchEvent(new Event("start_car"));
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
               url = npc_obj.url2;
               msg = npc_obj.msg2;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showGetM);
               break;
            case 3:
               url = npc_obj.url1;
               msg = npc_obj.msg1;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.getBallonSucc);
               break;
            case 4:
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
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.startCarFun);
         }
      }
   }
}

