package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.query.QueryImpl;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class MoleOldDoorMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var button_mc:MovieClip;
      
      private var randomNum:int;
      
      private var itemId:int;
      
      private var itemCount:int;
      
      private var mcloader:MCLoader;
      
      private var loadPath:String = "module/external/taskMc/";
      
      public function MoleOldDoorMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,this.target_mc["map93_btn"],MouseEvent.CLICK,this.gotoMap93Fun);
         LocalUserInfo.setIsHideOtherMole(true);
         this.target_mc["oldDoor"].buttonMode = true;
         BC.addEvent(this,this.target_mc["oldDoor"],MouseEvent.CLICK,this.checkHaveClothFun);
         this.tasckEvent();
      }
      
      private function tasckEvent() : void
      {
         BC.addEvent(this,this.target_mc.typeBtn,MouseEvent.CLICK,this.typeHandler);
         this.target_mc.petBody.buttonMode = true;
         this.target_mc.startMC.buttonMode = true;
         BC.addEvent(this,this.target_mc.petBody,MouseEvent.CLICK,this.petBodyHandler);
         tip.tipTailDisPlayObject(this.target_mc.typeBtn,"鎮塔神燈");
         tip.tipTailDisPlayObject(this.target_mc.startMC,"鎮塔神燈");
         BC.addEvent(this,this.target_mc.startMC,MouseEvent.CLICK,this.startMCHandler);
      }
      
      private function startMCHandler(evt:MouseEvent = null) : void
      {
         if(ServerUpTime.getInstance().getMoleHours < 20 || ServerUpTime.getInstance().getMoleHours > 20)
         {
            this.target_mc.startMC.gotoAndStop(1);
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishNumFun);
            finishSomethingReq.sendReq(30021);
         }
      }
      
      private function getFinishNumFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishNumFun);
         var obj:Object = evt.EventObj;
         if(obj.Type == 30021)
         {
            if(obj.Done <= 9)
            {
               BC.addEvent(this,GV.onlineSocket,"shipMC_PlayOven",this.shipMCPlayFun);
               this.randomNum = int(Math.random() * 100);
               if(this.randomNum < 25)
               {
                  this.target_mc.startMC.gotoAndStop(2);
               }
               else if(this.randomNum < 40)
               {
                  this.target_mc.startMC.gotoAndStop(3);
               }
               else
               {
                  BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.res_GameProtocol);
                  superlamuPartySocket.treasurebowl(34);
               }
            }
         }
      }
      
      private function res_GameProtocol(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.res_GameProtocol);
         var obj:Object = evt.EventObj;
         this.itemId = obj.itemId;
         this.itemCount = obj.count;
         switch(obj.itemId)
         {
            case 1453002:
               this.target_mc.startMC.gotoAndStop(4);
               break;
            case 1453018:
               this.target_mc.startMC.gotoAndStop(5);
               break;
            case 1453016:
               this.target_mc.startMC.gotoAndStop(6);
               break;
            default:
               this.target_mc.startMC.gotoAndStop(7);
         }
      }
      
      private function shipMCPlayFun(evt:Event) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"shipMC_PlayOven",this.shipMCPlayFun);
         if(this.randomNum < 25)
         {
            msg = "    一陣怪風把燈吹滅了，什麼也沒有！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"D");
         }
         else if(this.randomNum < 40)
         {
            msg = "    很遺憾燈沒點燃，天使不會出現的。";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"D");
         }
         else if(this.itemId == 1353239)
         {
            Alert.getIconByID_Alart(this.itemId,"    " + GoodsInfo.getItemNameByID(this.itemId) + "天使很開心，送你" + this.itemCount + "個" + GoodsInfo.getItemNameByID(this.itemId) + "已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(this.itemId) + "中了，快去看看吧！");
         }
         else
         {
            Alert.getIconByID_Alart(this.itemId,"    " + this.itemCount + "個" + GoodsInfo.getItemNameByID(this.itemId) + "已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(this.itemId) + "中了，快去看看吧！");
         }
      }
      
      private function petBodyHandler(evt:MouseEvent) : void
      {
         QueryImpl["getInstance"]().QueryItem([13783],this.checkHaveClothRes2);
      }
      
      private function checkHaveClothRes2(arr:Array) : void
      {
      }
      
      private function typeHandler(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("resource/task/activitiesMC.swf","請耐心等待......",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function repairTimeFun(evt:EventTaomee) : void
      {
         this.mcVisible();
      }
      
      private function mcVisible() : void
      {
         if(!(ServerUpTime.getInstance().getMoleHours < 20 || ServerUpTime.getInstance().getMoleHours > 20))
         {
            if(this.target_mc.startMC.currentFrame == 1)
            {
               this.target_mc.startMC.gotoAndStop(2);
            }
         }
      }
      
      private function gotoMap93Fun(evt:MouseEvent) : void
      {
         this.gotoMap(93);
      }
      
      private function checkHaveClothFun(evt:MouseEvent) : void
      {
         QueryImpl.getInstance().QueryItem([13783],this.checkHaveClothRes);
      }
      
      private function checkHaveClothRes(arr:Array) : void
      {
         if(arr[0].count >= 0)
         {
            BC.addEvent(this,GV.onlineSocket,"SwitchMap",this.switchMapFun);
            this.loadSwf("map184change");
         }
         else
         {
            this.NpcHandlerFun(930,"a_1");
         }
      }
      
      private function switchMapFun(evt:Event) : void
      {
         this.gotoMap(185);
      }
      
      private function NpcHandlerFun(_npcID:int, _sayStr:String) : void
      {
         mapSay(1);
      }
      
      private function loadSwf(mcName:String, loadStr:String = "正在加載。。。") : void
      {
         this.mcloader = new MCLoader(this.loadPath + mcName + ".swf",MainManager.getAppLevel(),Loading.TITLE_AND_PERCENT,loadStr);
         this.mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.onLoadOver);
         this.mcloader.addEventListener(MCLoadEvent.ERROR,this.failLoadUI);
         this.mcloader.load();
      }
      
      private function onLoadOver(evt:MCLoadEvent) : void
      {
         this.mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.onLoadOver);
         this.mcloader.removeEventListener(MCLoadEvent.ERROR,this.failLoadUI);
         MainManager.getAppLevel().addChild(evt.getContent());
      }
      
      private function failLoadUI(evt:MCLoadEvent) : void
      {
         this.mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.onLoadOver);
         this.mcloader.removeEventListener(MCLoadEvent.ERROR,this.failLoadUI);
      }
      
      private function gotoMap(mapID:int) : void
      {
         if(GV.MapInfo_mapID != mapID)
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            GF.switchMap(mapID,true);
         }
      }
      
      override public function destroy() : void
      {
         GC.stopAllMC(this.target_mc.startMC);
         GC.clearAllChildren(this.target_mc.startMC);
         LocalUserInfo.setIsHideOtherMoleForHandler(false);
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.topMC = null;
         this.button_mc = null;
         super.destroy();
      }
   }
}

