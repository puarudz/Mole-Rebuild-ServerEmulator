package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.smc.JobSocket;
   import com.logic.socket.task.TaskOverProtocol;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BaseMomoJob extends BaseNPCModule
   {
      
      private var inviteMC:MovieClip;
      
      private var hatID:uint;
      
      public function BaseMomoJob()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventFunc);
      }
      
      public function makeInfo(NPC_ID:String) : void
      {
         var obj:Object = XMLInfo.npcXML[NPC_ID];
         setInfo(obj);
         BC.addEvent(this,GV.onlineSocket,"give_invite",this.sandMomoJob);
         BC.addEvent(this,GV.onlineSocket,"select_momo_hat",this.selectHatFun);
      }
      
      private function selectHatFun(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"select_momo_hat",this.selectHatFun);
         if(this.inviteMC != null)
         {
            return;
         }
         this.inviteMC = new MovieClip();
         MainManager.getAppLevel().addChild(this.inviteMC);
         var loader:MCLoader = new MCLoader("module/external/momoJob/momoJobSelect.swf",this.inviteMC,1,"加載禮帽...");
         loader.doLoad();
         loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.hatLoadSucc);
      }
      
      private function hatLoadSucc(evt:MCLoadEvent = null) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         BC.addEvent(this,GV.onlineSocket,"closeMomo",this.closeFun);
         BC.addEvent(this,GV.onlineSocket,"overMomoJob",this.JobOver);
         var loader:MCLoader = evt.currentTarget as MCLoader;
         loader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.hatLoadSucc);
         loader.clear();
      }
      
      private function JobOver(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"overMomoJob",this.JobOver);
         this.closeFun();
         this.hatID = evt.EventObj.clothID;
         BC.addEvent(this,GV.onlineSocket,"read_" + 1916,this.getHatOk);
         BC.addEvent(this,GV.onlineSocket,"momoJob_errorID",this.getHatError);
         JobSocket.pickMomoHat(this.hatID);
      }
      
      private function getHatOk(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1916,this.getHatOk);
         BC.removeEvent(this,GV.onlineSocket,"momoJob_errorID",this.getHatError);
         this.showTipFun(4);
         this.overJob();
      }
      
      private function getHatError(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1916,this.getHatOk);
         BC.removeEvent(this,GV.onlineSocket,"momoJob_errorID",this.getHatError);
         Alert.showAlert(MainManager.getAppLevel(),"    你已經領取過禮帽了哦!","",6,"D");
         this.overJob();
      }
      
      private function overJob() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         TaskOverProtocol.send(npc_obj.jobid);
      }
      
      private function showOverJobAlert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
      }
      
      private function sandMomoJob(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"give_invite",this.sandMomoJob);
         this.inviteMC = new MovieClip();
         MainManager.getAppLevel().addChild(this.inviteMC);
         var loader:MCLoader = new MCLoader("module/external/momoJob/invitePanel.swf",this.inviteMC,1,"加載邀請卡...");
         loader.doLoad();
         loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.inviteLoadSucc);
      }
      
      private function sandJobFun(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"sandMomoJob",this.sandJobFun);
         this.closeFun();
         GV.JobLogics.changJobList(npc_obj.jobid,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.sandNextJob);
      }
      
      private function sandNextJob(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.sandNextJob);
         GV.JobLogics.changJobList(87,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.sandThirdJob);
      }
      
      private function sandThirdJob(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.sandThirdJob);
         GV.JobLogics.changJobList(88,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showBtnFun);
      }
      
      private function showBtnFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showBtnFun);
         var obj:Object = {"signFlag":0};
         JobExpandLogic.getJobExpand().setOneJob(88,obj);
         GV.JobViews.showJob(1005);
      }
      
      private function showTipFun(type:uint) : void
      {
         var myAlert:* = undefined;
         var url:String = null;
         var names:String = null;
         var msg:String = "";
         switch(type)
         {
            case 4:
               if(GF.getItemName(this.hatID).@Name == null)
               {
                  url = String(GF.getItemName(this.hatID).@typeObject.path) + this.hatID + ".swf";
                  names = String(GF.getItemName(this.hatID).@Name);
               }
               else
               {
                  url = String(GoodsInfo.getInfoById(this.hatID).typeObject.path) + this.hatID + ".swf";
                  names = GoodsInfo.getItemNameByID(this.hatID);
               }
               msg = "  " + names + "已經放入你的百寶箱中。";
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
      }
      
      private function inviteLoadSucc(evt:MCLoadEvent = null) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         var mc:MovieClip = childMC.content.root as MovieClip;
         mc.user_name.htmlText = "親愛的<font color=\'#ff0000\'>" + LocalUserInfo.getNickName() + "</font>:";
         BC.addEvent(this,GV.onlineSocket,"closeMomoInvite",this.closeInviteFun);
         BC.addEvent(this,GV.onlineSocket,"sandMomoJob",this.sandJobFun);
         var loader:MCLoader = evt.currentTarget as MCLoader;
         loader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.inviteLoadSucc);
         loader.clear();
      }
      
      private function closeInviteFun(evt:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,"give_invite",this.sandMomoJob);
         BC.removeEvent(this,GV.onlineSocket,"closeMomoInvite",this.closeInviteFun);
         MainManager.getAppLevel().removeChild(this.inviteMC);
         this.inviteMC = null;
      }
      
      private function closeFun(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"closeMomo",this.closeFun);
         MainManager.getAppLevel().removeChild(this.inviteMC);
         this.inviteMC = null;
      }
      
      private function removeEventFunc(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this);
      }
   }
}

