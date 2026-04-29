package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BaseMillerJob extends BaseNPCModule
   {
      
      private var inviteMC:MovieClip;
      
      private var hatID:uint;
      
      public function BaseMillerJob()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventFunc);
      }
      
      public function makeInfo(NPC_ID:String) : void
      {
         var obj:Object = XMLInfo.npcXML[NPC_ID];
         setInfo(obj);
         BC.addEvent(this,GV.onlineSocket,"accept_christmas_job",this.sandMillerJob);
         BC.addEvent(this,GV.onlineSocket,"over_christmas_job",this.overJob);
      }
      
      private function overJob(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"over_christmas_job",this.overJob);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         TaskOverProtocol.send(npc_obj.jobid);
      }
      
      private function showOverJobAlert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         this.showTipFun();
      }
      
      private function sandMillerJob(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"accept_christmas_job",this.sandMillerJob);
         this.inviteMC = new MovieClip();
         MainManager.getAppLevel().addChild(this.inviteMC);
         var loader:MCLoader = new MCLoader("module/external/christmas/card.swf",this.inviteMC,1,"加載卡片...");
         loader.doLoad();
         loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.inviteLoadSucc);
      }
      
      private function sandJobFun(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"sandMillerJob",this.sandJobFun);
         this.closeFun();
         GV.JobLogics.changJobList(npc_obj.jobid,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showBtnFun);
      }
      
      private function showBtnFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showBtnFun);
         var obj:Object = {
            "lingFlag":0,
            "lingFlag2":0,
            "treeFlag":0,
            "gunFlag":0
         };
         JobExpandLogic.getJobExpand().setOneJob(90,obj);
         GV.JobViews.showJob(90);
      }
      
      private function showTipFun() : void
      {
         var url:String = "resource/goods/icon/160602.swf";
         var msg:String = "    恭喜你獲得聖誕壁爐，已經放入你的小屋倉庫中了！";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      private function inviteLoadSucc(evt:MCLoadEvent = null) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         var mc:MovieClip = childMC.content.root as MovieClip;
         mc.user_name.htmlText = "親愛的<font color=\'#ff0000\'>" + LocalUserInfo.getNickName() + "</font>:";
         BC.addEvent(this,GV.onlineSocket,"closeMiller",this.closeInviteFun);
         BC.addEvent(this,GV.onlineSocket,"sandMillerJob",this.sandJobFun);
         var loader:MCLoader = evt.currentTarget as MCLoader;
         loader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.inviteLoadSucc);
         loader.clear();
      }
      
      private function closeInviteFun(evt:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,"accept_christmas_job",this.sandMillerJob);
         BC.removeEvent(this,GV.onlineSocket,"closeMiller",this.closeInviteFun);
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

