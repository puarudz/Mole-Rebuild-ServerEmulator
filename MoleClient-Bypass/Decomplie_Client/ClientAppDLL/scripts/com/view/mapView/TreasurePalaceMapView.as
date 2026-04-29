package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.petSocket.adoptPet.petInfoReq;
   import com.logic.socket.petSocket.adoptPet.petInfoRes;
   import com.logic.socket.petSocket.lamuSocket;
   import com.module.helpPanel.HelpPanel;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.lamu.LamuInfo;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.petSkill5.LamuStep5ClassView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TreasurePalaceMapView extends MapBase
   {
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var top_mc:MovieClip;
      
      private var petKingJob:LamuStep5ClassView;
      
      private var spaTimer:Timer;
      
      private var spaBeforeLevel:int;
      
      private var posType:int;
      
      private var itemidBySocket:int;
      
      public function TreasurePalaceMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.petKingJob = new LamuStep5ClassView();
         this.petKingJob.init();
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.joinHoleEvent);
      }
      
      private function showPanel(evt:MouseEvent = null) : void
      {
         HelpPanel.getInstance().panelVisible("lamuPanel");
      }
      
      private function joinHoleEvent(evt:EventTaomee) : void
      {
         var petinfo:petInfoReq = null;
         if(evt.EventObj.type == 11 || evt.EventObj.type == 12)
         {
            if(GV.MAN_PEOPLE.Petlevel > 0)
            {
               if(GV.MAN_PEOPLE.Petlevel > 3)
               {
                  Alert.showAlert(MainManager.getGameLevel(),"    你的拉姆已經長得夠大了，無需泡溫泉加速成長。","",6,"E");
               }
               else
               {
                  this.posType = evt.EventObj.type;
                  GV.onlineSocket.addEventListener(petInfoRes.GET_PETINFO_SUCC,this.showOtherMolePet);
                  petinfo = new petInfoReq();
                  petinfo.sendInfoReq(LocalUserInfo.getUserID(),PeopleManageView(GV.MAN_PEOPLE).lamuinfo.PetID);
               }
            }
            else
            {
               Alert.showAlert(MainManager.getGameLevel(),"    快帶著你的拉姆來加速成長吧！","",6,"E");
            }
         }
      }
      
      private function showOtherMolePet(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(petInfoRes.GET_PETINFO_SUCC,this.showOtherMolePet);
         var lamuInfo:Object = evt.EventObj.arr[0];
         this.spaBeforeLevel = lamuInfo.Level;
         var path:String = "";
         if(this.posType == 11)
         {
            this.itemidBySocket = 190594;
            BC.addEvent(this,GV.onlineSocket,"GoFeeSPA",this.onGoFeeSPA);
            path = "module/external/LamuWorldFeeSPAMain.swf";
         }
         else if(this.posType == 12)
         {
            this.itemidBySocket = 190592;
            BC.addEvent(this,GV.onlineSocket,"GoFreeSPA",this.onGoFreeSPA);
            path = "module/external/LamuWorldFreeSPAMain.swf";
         }
         var loadGame:LoadGame = new LoadGame(path,"正在加載溫泉",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onGoFreeSPA(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"GoFreeSPA",this.onGoFreeSPA);
         BC.removeEvent(this,GV.onlineSocket,"fireAction_select",this.joinHoleEvent);
         PeopleManageView(GV.MAN_PEOPLE).petmc.visible = false;
         BC.addEvent(this,GV.onlineSocket,"gotoOver",this.onGotoOver);
         this.target_mc.spa2.gotoAndStop(PeopleManageView(GV.MAN_PEOPLE).Petlevel);
      }
      
      private function onGoFeeSPA(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"GoFeeSPA",this.onGoFeeSPA);
         BC.removeEvent(this,GV.onlineSocket,"fireAction_select",this.joinHoleEvent);
         PeopleManageView(GV.MAN_PEOPLE).petmc.visible = false;
         BC.addEvent(this,GV.onlineSocket,"gotoOver",this.onGotoOver);
         this.target_mc.spa1.gotoAndStop(PeopleManageView(GV.MAN_PEOPLE).Petlevel);
      }
      
      private function onGotoOver(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"gotoOver",this.onGotoOver);
         if(this.posType == 11)
         {
            GF.setPetColor(this.target_mc.spa1.lamu.lm,GV.MyInfo_PetObj.Color);
         }
         else if(this.posType == 12)
         {
            GF.setPetColor(this.target_mc.spa2.lamu.lm,GV.MyInfo_PetObj.Color);
         }
         BC.addEvent(this,GV.onlineSocket,"iskaddish",this.kaddishEndHandler);
         this.spaTimer = new Timer(30000,1);
         this.spaTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSpaTimerOver);
         this.spaTimer.start();
      }
      
      private function onSpaTimerOver(evt:TimerEvent) : void
      {
         this.clearTimer();
         BC.removeEvent(this,GV.onlineSocket,"iskaddish",this.kaddishEndHandler);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-100189",this.onRead100189);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1126,this.onRead1126);
         lamuSocket.AccelerationPullulation(this.itemidBySocket);
      }
      
      private function onRead100189(evt:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-100189",this.onRead100189);
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.joinHoleEvent);
         PeopleManageView(GV.MAN_PEOPLE).petmc.visible = true;
         this.target_mc.spa2.gotoAndStop(1);
         this.target_mc.spa1.gotoAndStop(1);
         this.clearTimer();
      }
      
      private function onRead1126(evt:EventTaomee) : void
      {
         var mole:PeopleManageView = null;
         var moleobj:Object = null;
         var petid:* = undefined;
         var petColor:* = undefined;
         var lamuinfo:LamuInfo = null;
         var petlevelup:Class = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1126,this.onRead1126);
         this.target_mc.spa2.gotoAndStop(1);
         this.target_mc.spa1.gotoAndStop(1);
         PeopleManageView(GV.MAN_PEOPLE).petmc.visible = true;
         if(evt.EventObj.petLevel > this.spaBeforeLevel)
         {
            mole = GV.GF.getPeopleByID(LocalUserInfo.getUserID()) as PeopleManageView;
            moleobj = GF.getPeopleObj(LocalUserInfo.getUserID());
            petid = GV.MyInfo_PetObj.SpriteID;
            petColor = GV.MyInfo_PetObj.Color;
            lamuinfo = mole.lamuinfo;
            mole.backPet(true);
            mole.lamuinfo = lamuinfo;
            GV.MyInfo_PetObj.Level = evt.EventObj.petLevel;
            mole.PetID = petid;
            mole.PetColor = petColor;
            mole.Petlevel = evt.EventObj.petLevel;
            moleobj.Petlevel = evt.EventObj.petLevel;
            mole.lamuinfo.Petlevel = evt.EventObj.petLevel;
            mole.addPet();
            petlevelup = GV.Lib_Map.getClass("petup");
            mole = GV.GF.getPeopleByID(LocalUserInfo.getUserID());
            mole.avatarMC.pet_mc.addChild(new petlevelup());
         }
         if(this.posType == 11)
         {
            Alert.showAlert(MainManager.getGameLevel(),"    你的拉姆已經增加成長240小時，溫泉效果不錯吧！下次來繼續享受哦!","",6,"E");
         }
         else if(this.posType == 12)
         {
            Alert.showAlert(MainManager.getGameLevel(),"    你的拉姆已經增加成長24小時，溫泉效果不錯吧！下次來繼續享受哦!","",6,"E");
         }
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.joinHoleEvent);
      }
      
      private function clearTimer() : void
      {
         if(this.spaTimer != null)
         {
            this.spaTimer.reset();
            this.spaTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSpaTimerOver);
            this.spaTimer = null;
         }
      }
      
      private function kaddishEndHandler(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"iskaddish",this.kaddishEndHandler);
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.joinHoleEvent);
         PeopleManageView(GV.MAN_PEOPLE).petmc.visible = true;
         this.target_mc.spa2.gotoAndStop(1);
         this.target_mc.spa1.gotoAndStop(1);
         this.clearTimer();
      }
      
      override public function destroy() : void
      {
         GV.onlineSocket.removeEventListener(petInfoRes.GET_PETINFO_SUCC,this.showOtherMolePet);
         this.clearTimer();
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

