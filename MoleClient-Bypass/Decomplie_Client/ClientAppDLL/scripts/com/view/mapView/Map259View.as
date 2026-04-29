package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.ice.IceBabyAddBaseAttributeProtocol;
   import com.logic.socket.temp.Map259Socket;
   import com.logic.task.IceBabyCtrl;
   import com.module.activityModule.Presented;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.IceBabyManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ModuleType;
   import com.mole.app.ui.LoadingPanel;
   import com.mole.app.utils.PlayMovie;
   import com.mole.net.MoleSharedObject;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   
   public class Map259View extends MapBase
   {
      
      private var _siren_mc:MovieClip;
      
      private var fish_btn:MovieClip;
      
      private var _dingpipi:MovieClip;
      
      private var _tennis_mc:DisplayObject;
      
      private var _myScore:uint;
      
      public function Map259View()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this._siren_mc = controlLevel["siren_mc"];
         this._siren_mc.visible = false;
         topLevel["npc_10098"].visible = false;
         SystemEventManager.addEventListener("check10105Say",this.onCheck10105Say);
         SystemEventManager.addEventListener("rndSeeSiren",this.onRndSeeSiren);
         SystemEventManager.addEventListener("HideSiren",this.onHideSiren);
         SystemEventManager.addEventListener("getSirenAward",this.onGetSirenAward);
         SystemEventManager.addEventListener("openFish",this.onOpenFish);
         SystemEventManager.addEventListener("openTennis",this.onOpenTennis);
         SystemEventManager.addEventListener("openDingpipi",this.onOpenDingpipi);
         SystemEventManager.addEventListener("openAnswer",this.onOpenAnswer);
         SystemEventManager.addEventListener("getFlower",this.onGetFlower);
         SystemEventManager.addEventListener("getTomato",this.onGetTomato);
         BC.addEvent(this,controlLevel["ice_btn"],MouseEvent.CLICK,function(e:Event):void
         {
            ModuleManager.openPanel(ModuleType.ICE_BABY_SHOW_PANEL);
         });
         BC.addEvent(this,topLevel["card_btn"],MouseEvent.CLICK,function(e:Event):void
         {
            ModuleManager.openPanel(ModuleType.ICE_BABY_SHOW_CARD_PANEL);
         });
         BC.addEvent(this,topLevel["card1_mc"],MouseEvent.CLICK,function(e:Event):void
         {
            ModuleManager.openPanel(ModuleType.HAPPY_SUMMER_PANEL);
         });
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onCheckSeeSiren);
         finishSomethingReq.sendReq(31417);
         this.fish_btn = depthLevel.getChildByName("fish_btn") as MovieClip;
         GV.onlineSocket.addEventListener("read_" + Map259Socket.PAPA_QUE,this.papaQueHandler);
         BC.addEvent(this,this.fish_btn,"playOver",this.fishPlayOver);
         IceBabyCtrl.inst.initBath();
         IceBabyCtrl.inst.initLottery();
      }
      
      override public function init() : void
      {
         super.init();
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         peopleView.hideMount();
      }
      
      private function fishPlayOver(e:Event) : void
      {
         if(this.fish_btn.currentFrame == 2)
         {
            Alert.smileAlart("    嫻熟的技藝，強力的臂腕，烤出來的美食獲得一致好評！獲得寶貝魅力5點！",null,"sure");
         }
         else
         {
            Alert.angryAlart("    技藝不夠，東西烤焦了，回去再做10下俯臥撐。",null,"sure");
         }
      }
      
      private function papaQueHandler(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + Map259Socket.PAPA_QUE,this.papaQueHandler);
         var value:int = int(event.EventObj as uint);
         Alert.smileAlart("    恭喜你獲得" + value + "點魅力值。",null,"sure");
      }
      
      private function onGetFlower(e:Event) : void
      {
         Presented.getInstance().celebrate1225(1627);
      }
      
      private function onGetTomato(e:Event) : void
      {
         Presented.getInstance().celebrate1225(1628);
      }
      
      private function onOpenFish(e:Event) : void
      {
         if(this.fish_btn.currentFrame != 1)
         {
            return;
         }
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishInfoOver);
         finishSomethingReq.sendReq(50032);
      }
      
      private function getFinishInfoOver(e:EventTaomee) : void
      {
         var type:int = int(e.EventObj.Type);
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishInfoOver);
         if(type == 50032)
         {
            if(e.EventObj.Done >= 15)
            {
               Alert.smileAlart("    今天獲得已到上限啦，明天再來吧!",null,"sure");
            }
            else if(Math.random() > 0.7)
            {
               OnlineManager.addCmdListener(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,this.onAddBaseAttribute);
               OnlineManager.send(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,5,0,0);
            }
            else
            {
               this.fish_btn.gotoAndStop(3);
            }
         }
         else if(type == 50033)
         {
            if(e.EventObj.Done >= 3)
            {
               Alert.smileAlart("    今天獲得已到上限啦，明天再來吧!",null,"sure");
            }
            else
            {
               ModuleManager.openModule("PapaQues",null,"module/external/PapaQues/");
            }
         }
      }
      
      private function onAddBaseAttribute(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,this.onAddBaseAttribute);
         var attributePro:IceBabyAddBaseAttributeProtocol = e.bodyInfo;
         if(attributePro.state == 0)
         {
            this.fish_btn.gotoAndStop(2);
         }
         else
         {
            this.fish_btn.gotoAndStop(3);
         }
      }
      
      public function openDingpipi() : void
      {
         OnlineManager.addCmdListener(CommandID.FINISH_SOMETHING,this.onCheckDingpipiSomething);
         finishSomethingReq.sendReq(50028);
      }
      
      private function onCheckDingpipiSomething(evt:SocketEvent) : void
      {
         var resID:uint = 0;
         var somethingPro:finishSomethingRes = evt.bodyInfo;
         if(somethingPro.Type == 50028)
         {
            OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.onCheckDingpipiSomething);
            if(somethingPro.Done <= 10)
            {
               resID = DownLoadManager.add("resource/newTask/task10004/ice_dingpipi.swf",ResType.DISPLAY_OBJECT,true);
               LoadingPanel.addRes(resID);
               DownLoadManager.addEvent(resID,this.onLoadDingpipiSucc);
            }
            else
            {
               Alert.smileAlart("　　今天次數已達上限！");
            }
         }
      }
      
      private function onLoadDingpipiSucc(e:DownLoadEvent) : void
      {
         SoundManager.stopAll();
         LevelManager.stage.focus = LevelManager.stage;
         this._dingpipi = e.data;
         LevelManager.gameLevel.addChild(this._dingpipi);
         MapManager.clearMap();
         GV.onlineSocket.addEventListener("IceBaby_DingPipi",this.onDingpipiSubmitScore);
      }
      
      private function onDingpipiSubmitScore(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("IceBaby_DingPipi",this.onDingpipiSubmitScore);
         DisplayUtil.removeForParent(this._dingpipi);
         MapManager.refreshMap();
         SoundManager.openAll();
         if(e.EventObj != 0)
         {
            IceBabyManager.addAttribute(2,1,e.EventObj as uint);
         }
      }
      
      private function onOpenTennis(e:Event) : void
      {
         OnlineManager.addCmdListener(CommandID.FINISH_SOMETHING,this.onCheckTennisSomething);
         finishSomethingReq.sendReq(50029);
      }
      
      private function onCheckTennisSomething(evt:SocketEvent) : void
      {
         var resID:uint = 0;
         var somethingPro:finishSomethingRes = evt.bodyInfo;
         if(somethingPro.Type == 50029)
         {
            OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.onCheckTennisSomething);
            if(somethingPro.Done <= 10)
            {
               resID = DownLoadManager.add("resource/newTask/task10004/IceBabyTennisGame.swf",ResType.DISPLAY_OBJECT,true);
               LoadingPanel.addRes(resID);
               DownLoadManager.addEvent(resID,this.onLoadTennisSucc);
            }
            else
            {
               Alert.smileAlart("　　今天次數已達上限！");
            }
         }
      }
      
      private function onLoadTennisSucc(e:DownLoadEvent) : void
      {
         MapManager.clearMap();
         SoundManager.stopAll();
         this._tennis_mc = e.data;
         LevelManager.gameLevel.addChild(this._tennis_mc);
         this._tennis_mc.addEventListener(Event.COMPLETE,this.onTennisSubmitScore);
         this._tennis_mc.addEventListener(Event.CLOSE,this.onTennisSubmitScore);
      }
      
      private function onTennisSubmitScore(e:Event) : void
      {
         var score:uint = 0;
         if(this._tennis_mc["userScore"] != 0)
         {
            this._myScore = this._tennis_mc["userScore"];
         }
         var npcScore:uint = uint(this._tennis_mc["npcScore"]);
         if(e.type == Event.CLOSE || npcScore >= 5)
         {
            this._tennis_mc.removeEventListener(Event.CLOSE,this.onTennisSubmitScore);
            this._tennis_mc.removeEventListener(Event.COMPLETE,this.onTennisSubmitScore);
            this._tennis_mc["dispose"]();
            Mouse.show();
            MapManager.refreshMap();
            score = this._myScore * 2;
            score = score > 30 ? 30 : score;
            if(score != 0)
            {
               IceBabyManager.addAttribute(2,2,score);
            }
            SoundManager.openAll();
         }
      }
      
      private function onOpenAnswer(e:Event) : void
      {
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishInfoOver,false,0,true);
         finishSomethingReq.sendReq(50033);
      }
      
      private function onOpenDingpipi(e:Event) : void
      {
         this.openDingpipi();
      }
      
      private function onRndSeeSiren(e:SystemEvent) : void
      {
         var movie:PlayMovie = null;
         movie = PlayMovie.play("resource/newTask/task10004/task_movie_10004_101.swf",null,null,function():void
         {
            movie.destroy();
            mapSay(20);
         });
      }
      
      private function onCheckSeeSiren(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onCheckSeeSiren);
         if(evt.EventObj.Done == 0)
         {
            topLevel["npc_10098"].visible = true;
         }
      }
      
      private function onHideSiren(e:SystemEvent) : void
      {
         topLevel["npc_10098"].x = false;
         DisplayUtil.removeForParent(topLevel["npc_10098"]);
         LevelManager.mapLevel.addChild(this._siren_mc);
         this._siren_mc.visible = true;
         this._siren_mc.x = Math.random() * 600 + 180;
         this._siren_mc.y = Math.random() * 300 + 130;
         this._siren_mc.buttonMode = true;
         this._siren_mc.mouseChildren = false;
         BC.addEvent(this,this._siren_mc,MouseEvent.CLICK,this.onSeeSirenSucc);
      }
      
      private function onSeeSirenSucc(e:Event) : void
      {
         mapSay(24);
      }
      
      private function onGetSirenAward(e:Event) : void
      {
         DisplayUtil.removeForParent(this._siren_mc);
         Presented.getInstance().celebrate1225(1626);
      }
      
      private function onCheck10105Say(e:SystemEvent) : void
      {
         var movie:PlayMovie = null;
         if(Boolean(MoleSharedObject.moleObj.say10105))
         {
            mapSay(10);
         }
         else
         {
            MoleSharedObject.moleObj.say10105 = true;
            movie = PlayMovie.play("resource/newTask/task10004/task_movie_10004_1.swf",null,null,function():void
            {
               movie.destroy();
               mapSay(10);
            });
         }
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("openFish",this.onOpenFish);
         SystemEventManager.removeEventListener("openTennis",this.onOpenTennis);
         SystemEventManager.removeEventListener("openDingpipi",this.onOpenDingpipi);
         SystemEventManager.removeEventListener("rndSeeSiren",this.onRndSeeSiren);
         SystemEventManager.removeEventListener("HideSiren",this.onHideSiren);
         SystemEventManager.removeEventListener("getSirenAward",this.onGetSirenAward);
         SystemEventManager.removeEventListener("SeeSirenSucc",this.onSeeSirenSucc);
         SystemEventManager.removeEventListener("openAnswer",this.onOpenAnswer);
         SystemEventManager.removeEventListener("check10105Say",this.onCheck10105Say);
         GV.onlineSocket.removeEventListener("read_" + Map259Socket.PAPA_QUE,this.papaQueHandler);
         OnlineManager.removeCmdListener(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,this.onAddBaseAttribute);
         OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.onCheckDingpipiSomething);
         OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.onCheckTennisSomething);
         SystemEventManager.removeEventListener("getFlower",this.onGetFlower);
         SystemEventManager.removeEventListener("getTomato",this.onGetTomato);
         if(Boolean(this._tennis_mc))
         {
            this._tennis_mc.removeEventListener(Event.CLOSE,this.onTennisSubmitScore);
            this._tennis_mc.removeEventListener(Event.COMPLETE,this.onTennisSubmitScore);
         }
         IceBabyCtrl.inst.destroy();
         super.destroy();
      }
   }
}

