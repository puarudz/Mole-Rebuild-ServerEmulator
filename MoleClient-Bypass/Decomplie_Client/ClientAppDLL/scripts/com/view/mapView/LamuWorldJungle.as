package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.BlackSeedGetItemProtocol;
   import com.logic.socket.boss.CapAnimalSocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.I_NPC;
   import com.module.npc.npcInstance.GhostNPC;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.net.events.SocketEvent;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class LamuWorldJungle extends MapBase
   {
      
      public var button_mc:MovieClip;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      private var lookMC:MovieClip;
      
      private var soneTipMC:MovieClip;
      
      private var t:I_NPC;
      
      private var arr:Array = new Array();
      
      private var bark:I_NPC;
      
      private var barkArr:Array = new Array();
      
      private var curBark:I_NPC;
      
      private var bit:uint;
      
      private var bitArr:Array;
      
      private var i:uint;
      
      private var _score:uint;
      
      private var mapId:uint;
      
      private var isSearch:Boolean;
      
      public function LamuWorldJungle()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         this.bossEvent();
         BC.addEvent(this,this.target_mc.stoneTip,MouseEvent.CLICK,this.stoneTipClickHandler);
         BC.addEvent(this,this.button_mc.hit2MC,"onHit",this.goTOMap120Handler);
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         BufferManager.addBufferEvent(BufferManager.SEARCH_BTN_TIMES,this.onSearchGame);
         BufferManager.getBuffer(BufferManager.SEARCH_BTN_TIMES);
         BufferManager.addBufferEvent(BufferManager.ATOM_GAME_LEVEL,this.onCheckgame);
         BufferManager.getBuffer(BufferManager.ATOM_GAME_LEVEL);
         SystemEventManager.addEventListener("getItemFour",this.onItemFour);
      }
      
      private function bossEvent() : void
      {
         this.showCorpse(280,449);
         this.showCorpse(690,397);
         this.showCorpse(690,393);
         this.showBarkCorpse(500,530);
         this.showBarkCorpse(400,300);
         this.showBarkCorpse(684,500);
      }
      
      private function showCorpse(hx:int, hy:int) : void
      {
         this.t = new GhostNPC("bean");
         GV.MC_Depth.addChild(this.t as DisplayObjectContainer);
         this.t.x = hx;
         this.t.y = hy;
         this.t.setMovingRange(GV.MC_mapFrame["depth_mc"].range_mc);
         this.t.autoMove = true;
         this.t.Speed = 30;
         this.arr.push(this.t);
         this.addBtnFun(this.t);
      }
      
      private function addBtnFun(t:I_NPC) : void
      {
         var cl:* = undefined;
         var tailButton:TailButtonView = new TailButtonView();
         tailButton.buttonMode = true;
         tailButton.x = t.x;
         tailButton.y = t.y;
         tailButton.fineTail3Target(t as DisplayObjectContainer);
         MapButtonView.getTarget().addChild(tailButton);
         cl = this;
         BC.addEvent(tailButton,tailButton,MouseEvent.CLICK,function(E:MouseEvent):void
         {
            var loadGame:LoadGame = null;
            var p:PeopleManageView = PeopleManageView(GV.MAN_PEOPLE);
            if(p.hasLamu && p.lamuinfo.Petlevel >= 101)
            {
               curBark = t;
               BC.addEvent(cl,GV.onlineSocket,"battle_over",buildGamdeFun);
               loadGame = new LoadGame("module/external/SimpleBattle.swf?bosstype=douya","正在打開戰鬥面板.....",MainManager.getGameLevel());
               loadGame = null;
            }
            else
            {
               Alert.smileAlart("    帶著你的超級拉姆再來和小豆芽玩吧！");
            }
         });
      }
      
      private function buildGamdeFun(evt:EventTaomee) : void
      {
         var index:int = this.barkArr.indexOf(this.curBark);
         this.barkArr.splice(index,1);
         this.curBark.clearClass();
         GC.clearAll(this.curBark);
         BC.removeEvent(this,GV.onlineSocket,"battle_over",this.buildGamdeFun);
         MapButtonView.getTarget().mouseEnabled = true;
         MapButtonView.getTarget().mouseChildren = true;
         if(Boolean(evt.EventObj.flag))
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1992,this.getAnimalBeanFun);
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + "-" + 100155,this.getAnimalBeanFun);
            CapAnimalSocket.capAnimal(1270047);
         }
      }
      
      private function getAnimalBeanFun(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1992,this.getAnimalBeanFun);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_" + "-" + 100155,this.getAnimalBeanFun);
         if(evt.type == "ERROR_CMD_" + -100155)
         {
            Alert.smileAlart("    今天你已經捉了太多小豆芽了，明天再來吧！");
            return;
         }
         if(evt.EventObj.itemID == 0)
         {
            Alert.smileAlart("    啊呀，小豆芽逃走了，試試下次再捕捉看看吧！");
         }
         else if(evt.EventObj.itemID == 1270047)
         {
            Alert.getIconByID_Alart(evt.EventObj.itemID,"　  恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.itemID) + "，已經放入你的牧場倉庫中了！");
         }
      }
      
      private function showBarkCorpse(hx:int, hy:int) : void
      {
         this.bark = new GhostNPC("bark");
         GV.MC_Depth.addChild(this.bark as DisplayObjectContainer);
         this.bark.x = hx;
         this.bark.y = hy;
         this.bark.setMovingRange(GV.MC_mapFrame["depth_mc"].range_mc);
         this.bark.autoMove = true;
         this.bark.Speed = 30;
         this.barkArr.push(this.bark);
         this.addBarkBtnFun(this.bark);
      }
      
      private function addBarkBtnFun(bark:I_NPC) : void
      {
         var tailButton:TailButtonView = null;
         var cl:* = undefined;
         tailButton = new TailButtonView();
         tailButton.buttonMode = true;
         tailButton.x = bark.x;
         tailButton.y = bark.y;
         tailButton.fineTail3Target(bark as DisplayObjectContainer);
         MapButtonView.getTarget().addChild(tailButton);
         cl = this;
         BC.addEvent(tailButton,tailButton,MouseEvent.CLICK,function(E:MouseEvent):void
         {
            var loadGame:LoadGame = null;
            if(GV.MAN_PEOPLE.Petlevel > 0)
            {
               curBark = bark;
               BC.addEvent(cl,GV.onlineSocket,"battle_over",buildBarkGamdeFun);
               loadGame = new LoadGame("module/external/SimpleBattle.swf?bosstype=bibi","正在進入戰鬥畫面.....",MainManager.getGameLevel());
               loadGame = null;
            }
            else
            {
               Alert.smileAlart("    帶著你的拉姆再來和閃光皮皮玩吧！");
            }
         });
      }
      
      private function buildBarkGamdeFun(evt:EventTaomee) : void
      {
         var index:int = this.barkArr.indexOf(this.curBark);
         this.barkArr.splice(index,1);
         this.curBark.clearClass();
         GC.clearAll(this.curBark);
         BC.removeEvent(this,GV.onlineSocket,"battle_over",this.buildBarkGamdeFun);
         MapButtonView.getTarget().mouseEnabled = true;
         MapButtonView.getTarget().mouseChildren = true;
         if(Boolean(evt.EventObj.flag))
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1992,this.getAnimalBarkFun);
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + -100155,this.getAnimalBarkFun);
            CapAnimalSocket.capAnimal(1270046);
         }
      }
      
      private function getAnimalBarkFun(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1992,this.getAnimalBarkFun);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_" + -100155,this.getAnimalBarkFun);
         if(evt.type == "ERROR_CMD_" + -100155)
         {
            Alert.smileAlart("    今天你已經捉了太多閃光皮皮了，明天再來吧！");
            return;
         }
         if(evt.EventObj.itemID == 0)
         {
            Alert.smileAlart("    啊呀，閃光皮皮逃跑了，再捕捉一次試試吧！");
         }
         else if(evt.EventObj.itemID == 1270046)
         {
            Alert.getIconByID_Alart(evt.EventObj.itemID,"　  恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.itemID) + "，已經放入你的牧場倉庫中了！");
         }
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         if(evt.EventObj.type == 2)
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            GF.switchMap(123,true);
         }
      }
      
      private function stoneTipClickHandler(e:MouseEvent) : void
      {
         var StoneTip:Class = null;
         if(this.soneTipMC == null)
         {
            StoneTip = GV.Lib_Map.getClass("StoneTip");
            this.soneTipMC = new StoneTip();
            this.soneTipMC.x = GV.MC_AppLever.stage.stageWidth / 2;
            this.soneTipMC.y = GV.MC_AppLever.stage.stageHeight / 2;
            GV.MC_TopLever.addChild(this.soneTipMC);
            BC.addEvent(this,this.soneTipMC.close_btn,MouseEvent.CLICK,this.soneTipMCCloseHanlder);
         }
         else
         {
            this.soneTipMC.x = GV.MC_AppLever.stage.stageWidth / 2;
         }
      }
      
      private function soneTipMCCloseHanlder(e:MouseEvent) : void
      {
         this.soneTipMC.x = -500;
      }
      
      private function goTOMap120Handler(e:Event) : void
      {
         BC.removeEvent(this,this.button_mc.hit2MC,"onHit",this.goTOMap120Handler);
         this.gotoMayFun();
      }
      
      private function gotoMayFun() : void
      {
         var loadGame:LoadGame = null;
         if(creatShareObject.getInstance().getMapUse() != 3)
         {
            creatShareObject.getInstance().setMapUse(3);
            BC.addEvent(this,GV.onlineSocket,"map2lameCloudsSeeEvent",this.map2lameCloudsSeeEventHandler);
            loadGame = new LoadGame("resource/movie/map2LamuCloudsSee.swf","正在打開.....",MainManager.getGameLevel());
            loadGame = null;
         }
         else
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(121);
            GF.switchMap(122,true);
         }
      }
      
      private function map2lameCloudsSeeEventHandler(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"map2lameCloudsSeeEvent",this.map2lameCloudsSeeEventHandler);
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(121);
         GF.switchMap(122,true);
      }
      
      private function onCheckgame(e:EventTaomee) : void
      {
         var bitBool:Boolean = false;
         var bool:Boolean = false;
         var playmovie:PlayMovie = null;
         this.bitArr = new Array();
         this.bit = uint(e.EventObj);
         for(this.i = 0; this.i < 9; ++this.i)
         {
            bitBool = Boolean(1 << this.i & this.bit);
            this.bitArr.push(bitBool);
         }
         for(this.i = 0; this.i < 9; ++this.i)
         {
            if(this.bitArr[this.i] == 1)
            {
               ++this._score;
            }
         }
         if(this._score == 3 && this.mapId == MapManager.curMapID)
         {
            this.mapId = 0;
            for each(bool in this.bitArr)
            {
               bool = false;
               this._score = 0;
            }
            playmovie = PlayMovie.play("resource/map/activity/act1207_map_121.swf",null,null,function():void
            {
               playmovie.destroy();
               mapSay(99);
            });
         }
      }
      
      private function getActItem1(e:SocketEvent) : void
      {
         var item1Info:BlackSeedGetItemProtocol = e.bodyInfo;
         Alert.smileAlart("恭喜你獲得" + GoodsInfo.getItemNameByID(item1Info.idOne) + item1Info.numOne + "個、" + GoodsInfo.getItemNameByID(item1Info.idTwo) + item1Info.numTwo + "個!",function():void
         {
            BufferManager.setBuffer(BufferManager.ATOM_GAME_LEVEL,0);
         });
      }
      
      private function onSearchGame(e:EventTaomee) : void
      {
         this.mapId = uint(e.EventObj);
      }
      
      private function onItemFour(e:SystemEvent) : void
      {
         OnlineManager.addCmdListener(CommandID.BLACK_SEED_GET_ITEM,this.getActItem1);
         OnlineManager.send(CommandID.BLACK_SEED_GET_ITEM);
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.soneTipMC))
         {
            GV.MC_TopLever.removeChild(this.soneTipMC);
         }
         MoveTo.CanMove = true;
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.top_mc = null;
         GC.clearAll(this);
         SystemEventManager.removeEventListener("getItemFour",this.onItemFour);
         BufferManager.removeBufferEvent(BufferManager.SEARCH_BTN_TIMES,this.onSearchGame);
         BufferManager.removeBufferEvent(BufferManager.ATOM_GAME_LEVEL,this.onCheckgame);
         super.destroy();
      }
   }
}

