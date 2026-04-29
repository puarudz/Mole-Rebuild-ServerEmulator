package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.randomItemDrawLogic.randomItemDrawLogic;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.logic.socket.traffic.trafficReq;
   import com.logic.socket.traffic.trafficRes;
   import com.module.hitMice.HitMice;
   import com.mole.app.map.MapBase;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   
   public class gameRoomView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var effect_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public var gameMC:MovieClip;
      
      public var joinObj:*;
      
      public var childMC:*;
      
      public var buyItem:BuyItemReq;
      
      private var danceMusic:Sound;
      
      private var musicHand:SoundChannel;
      
      public function gameRoomView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.effect_mc = GV.MC_mapFrame["effect_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         var tempMusic:Class = GV.Lib_Map.getClass("dance_music") as Class;
         this.danceMusic = new tempMusic();
         GV.onlineSocket.addEventListener(trafficRes.TRAFFIC_OVER,this.activeHandler);
         trafficReq.trafficSend(1);
         GV.onlineSocket.addEventListener("JOIN_GAME_SOUNDEVENT",this.gameSoundHandler);
         this.depth_mc.mouseEnabled = false;
         this.depth_mc.mouseChildren = false;
         this.target_mc.gameMC.Hammer.buttonMode = true;
         this.target_mc.gameMC.Hammer.gotoAndStop(68);
         this.target_mc.gameMC.arrowMC.visible = false;
         var hitMice:HitMice = new HitMice(this.target_mc.gameMC);
         this.target_mc.pushGame.buttonMode = true;
         this.target_mc.pushGame.addEventListener(MouseEvent.MOUSE_OVER,this.pushGameOverHandler);
         this.target_mc.pushGame.addEventListener(MouseEvent.MOUSE_OUT,this.pushGameOutHandler);
         this.target_mc.pushGame.addEventListener(MouseEvent.CLICK,this.pushGameClickHandler);
         this.target_mc.btn_1.buttonMode = true;
         this.target_mc.btn_2.buttonMode = true;
         this.target_mc.btn_1.addEventListener(MouseEvent.CLICK,this.helpHandler);
         this.target_mc.btn_2.addEventListener(MouseEvent.CLICK,this.helpHandler);
      }
      
      private function helpHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         var helpMC:MovieClip = null;
         var tempNum:String = evt.target.name.substr(4);
         if(!MainManager.getAppLevel().getChildByName("help_" + tempNum))
         {
            tempMC = GV.Lib_Map.getClass("mc_" + tempNum) as Class;
            helpMC = new tempMC();
            helpMC.name = "help_" + tempNum;
            MainManager.getAppLevel().addChild(helpMC);
            helpMC.x = (MainManager.getStageWidth() - helpMC.width) / 2;
            helpMC.y = (MainManager.getStageHeight() - helpMC.height) / 2;
            helpMC.closeBtn.addEventListener(MouseEvent.CLICK,this.removeHelpMC);
         }
      }
      
      private function removeHelpMC(evt:MouseEvent = null) : void
      {
         evt.currentTarget.removeEventListener(MouseEvent.CLICK,this.removeHelpMC);
         evt.currentTarget.parent.parent.removeChild(evt.currentTarget.parent);
         GC.stopAllMC(evt.currentTarget.parent);
         GC.clearChildren(evt.currentTarget.parent);
      }
      
      private function pushGameOverHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(2);
      }
      
      private function pushGameOutHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(1);
      }
      
      private function pushGameClickHandler(evt:MouseEvent) : void
      {
         if(GV.isChangeMap)
         {
            return;
         }
         var msg:String = "您要玩夾娃娃機嗎?\n每枚金幣10摩爾豆哦!";
         this.joinObj = Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.SELECT_ALERT);
         this.joinObj.addEventListener("CLICK" + 1,this.LoadpushGame);
      }
      
      private function LoadpushGame(evt:*) : void
      {
         var msg:String = null;
         var tempMC:MCLoader = null;
         if(LocalUserInfo.getYXQ() < 10)
         {
            msg = "你的摩爾豆不夠啦!";
            Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"D");
            return;
         }
         this.joinObj.removeEventListener("CLICK" + 1,this.LoadpushGame);
         if(!MainManager.getGameLevel().getChildByName("gameMC"))
         {
            this.gameMC = new MovieClip();
            this.gameMC.name = "gameMC";
            MainManager.getGameLevel().addChild(this.gameMC);
            tempMC = new MCLoader("module/singleGame/swf/nipMoppet.swf",this.gameMC,Loading.TITLE_AND_PERCENT,"正在打開夾娃娃遊戲");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadGameOverHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadGameOverHandler(evt:MCLoadEvent) : void
      {
         evt.target.removeEventListener(GF.LOAD_OVER,this.loadGameOverHandler);
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         mainMC.x = (MainManager.getStageWidth() - mainMC.width) / 2;
         mainMC.y = (MainManager.getStageHeight() - mainMC.height) / 2 - 50;
         this.addEvent();
         MCLoader(evt.currentTarget).clear();
      }
      
      private function addEvent() : void
      {
         GV.onlineSocket.addEventListener("deleteMoneyEvent",this.deleteMoneyEvent);
         GV.onlineSocket.addEventListener("getMoppetEvent",this.getMoppetEvent);
         GV.onlineSocket.addEventListener("getAllMoppetEvent",this.getAllMoppetEvent);
         GV.onlineSocket.addEventListener("haveNoMoney",this.showTipHandler);
      }
      
      private function removeHandler() : void
      {
         GV.onlineSocket.removeEventListener("deleteMoneyEvent",this.deleteMoneyEvent);
         GV.onlineSocket.removeEventListener("getMoppetEvent",this.getMoppetEvent);
         GV.onlineSocket.removeEventListener("getAllMoppetEvent",this.getAllMoppetEvent);
         GV.onlineSocket.removeEventListener("haveNoMoney",this.showTipHandler);
      }
      
      private function showTipHandler(evt:EventTaomee) : void
      {
         var msg:String = evt.EventObj.msg;
         Alert.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
      }
      
      private function deleteMoneyEvent(evt:EventTaomee) : void
      {
         var msg:String = null;
         if(LocalUserInfo.getYXQ() < 10)
         {
            msg = "你的摩爾豆不夠啦!";
            GV.onlineSocket.dispatchEvent(new EventTaomee("nipMoppet_REMOVE",{"bool":false}));
            Alert.showAlert(MainManager.getGameLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("nipMoppet_REMOVE",{"bool":true}));
            GV.onlineSocket.addEventListener("giveMoneyEvent",this.getMoneyHandler);
            randomItemDrawLogic.moneyAction([{
               "kind":0,
               "num":10
            }],1);
         }
      }
      
      private function getMoneyHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("giveMoneyEvent",this.getMoneyHandler);
         LocalUserInfo.countYXQ(-10);
      }
      
      private function getMoppetEvent(evt:EventTaomee) : void
      {
         if(this.buyItem == null)
         {
            this.buyItem = new BuyItemReq();
         }
         GV.onlineSocket.addEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.getMopperSuc);
         this.buyItem.buyItems(evt.EventObj.type,1);
      }
      
      private function getMopperSuc(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.getMopperSuc);
      }
      
      private function getAllMoppetEvent(evt:EventTaomee) : void
      {
         var msg:String = null;
         if(evt.EventObj.count > 0)
         {
            msg = "恭喜!\n" + evt.EventObj.count + "個漂亮的娃娃已經放入小屋倉庫中!";
            Alert.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         }
         this.removeMoppetHandler();
      }
      
      private function removeMoppetHandler() : void
      {
         GC.stopAllMC(this.childMC.content);
         GC.clearChildren(this.childMC.content);
         MainManager.getGameLevel().removeChild(this.gameMC);
         this.gameMC = null;
      }
      
      private function activeHandler(evt:EventTaomee) : void
      {
         var status:* = evt.EventObj.Status;
         if(Boolean(status))
         {
            this.effect_mc.mc.gotoAndStop(2);
            this.top_mc.mc_1.gotoAndStop(2);
            this.top_mc.mc_2.gotoAndStop(2);
         }
         else
         {
            this.effect_mc.mc.gotoAndStop(1);
            this.top_mc.mc_1.gotoAndStop(1);
            this.top_mc.mc_2.gotoAndStop(1);
            if(this.musicHand != null)
            {
               this.musicHand.stop();
            }
         }
      }
      
      private function gameSoundHandler(evt:EventTaomee) : void
      {
         if(this.musicHand != null)
         {
            this.musicHand.stop();
         }
      }
      
      private function stopSound() : void
      {
         if(this.musicHand != null)
         {
            this.musicHand.stop();
            this.musicHand = null;
            this.danceMusic = null;
         }
      }
      
      override public function destroy() : void
      {
         this.stopSound();
         if(this.gameMC != null)
         {
            this.removeMoppetHandler();
         }
         this.removeHandler();
         GV.onlineSocket.removeEventListener("JOIN_GAME_SOUNDEVENT",this.gameSoundHandler);
         GV.onlineSocket.removeEventListener(trafficRes.TRAFFIC_OVER,this.activeHandler);
         super.destroy();
      }
   }
}

