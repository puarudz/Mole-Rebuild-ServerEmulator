package com.view.JobView.ChildNPCModule.ChildNpc
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.raceSport.RaceSportJoin;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.TaskManager;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DriveNpcJob2 extends Sprite
   {
      
      public var targetMC:SimpleButton;
      
      private var jobID:uint = 141;
      
      private var npc_obj:Object;
      
      public function DriveNpcJob2()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEvent);
         this.init();
      }
      
      private function init() : void
      {
         this.npc_obj = XMLInfo.npcXML[this.jobID];
      }
      
      public function setTargetMC(MC:SimpleButton) : void
      {
         this.targetMC = MC;
         BC.addEvent(this,this.targetMC,MouseEvent.CLICK,this.clickFun);
      }
      
      public function clickFun(event:MouseEvent = null) : void
      {
         this.npcClientFun();
      }
      
      public function npcClientFun() : void
      {
         var myAlert:* = undefined;
         var url:String = "";
         var msg:String = "";
         var taskState:uint = TaskManager.getTaskState(this.jobID);
         if(taskState == 0)
         {
            url = this.npc_obj.url0;
            msg = this.npc_obj.msg0;
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
         else if(taskState == 1)
         {
            BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkJobBack);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190426,2);
         }
         else if(taskState >= 2)
         {
            url = this.npc_obj.url3;
            msg = this.npc_obj.msg3;
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
      }
      
      private function checkJobBack(eve:EventTaomee) : void
      {
         var myAlert:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkJobBack);
         var url:String = "";
         var msg:String = "";
         var obj:Object = eve.EventObj.obj;
         if(obj.Count <= 0)
         {
            this.addGameFun();
         }
         else
         {
            msg = "    你已經順利的通過學習，拿到了炫風駕照哦！快去找交通署裡的拉姆蔣誠信，看看他有什麼驚喜準備給你吧！";
            myAlert = Alert.showAlert(MainManager.getAppLevel(),msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function addGameFun() : void
      {
         if(Boolean(MainManager.getGameLevel().getChildByName("panle")))
         {
            return;
         }
         MapManager.clearMap();
         SoundManager.stopAll();
         var url:String = "module/game/driverGame.swf";
         var msg:String = "正在加載駕駛員考試";
         BC.addEvent(this,GV.onlineSocket,"contact_close",this.overAddGame);
         new LoadGame(url,msg,MainManager.getGameLevel());
      }
      
      private function overAddGame(eve:EventTaomee) : void
      {
         var temp:* = undefined;
         SoundManager.openAll();
         MapManager.refreshMap();
         BC.removeEvent(this,GV.onlineSocket,"contact_close",this.overAddGame);
         if(Boolean(eve.EventObj.bln))
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1699,this.getDriveCardBack);
            RaceSportJoin.getDriveCard();
         }
         if(Boolean(MainManager.getGameLevel().getChildByName("panle")))
         {
            temp = MainManager.getGameLevel().getChildByName("panle");
            MainManager.getGameLevel().removeChildAt(temp);
            temp = null;
         }
      }
      
      private function getDriveCardBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1699,this.getDriveCardBack);
         var url:String = "resource/allJob/icon/190426.swf";
         var msg:String = "    炫風駕照已放入你的百寶箱了，快去找交通署裡的拉姆蔣誠信交任務吧！";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      public function removeEvent(eve:*) : void
      {
         BC.removeEvent(this);
      }
   }
}

