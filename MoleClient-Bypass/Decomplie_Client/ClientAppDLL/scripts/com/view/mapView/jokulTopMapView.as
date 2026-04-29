package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.JoinGameLogic.JoinGameLogic;
   import com.logic.socket.BlackSeedGetItemProtocol;
   import com.logic.socket.leaveGame.LeaveGameReq;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.superPetModule.petItemModule;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.manager.TipsManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.net.events.SocketEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class jokulTopMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      private var bit:uint;
      
      private var bitArr:Array;
      
      private var i:uint;
      
      private var _score:uint;
      
      private var mapId:uint;
      
      private var isSearch:Boolean;
      
      public function jokulTopMapView()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         GV.onlineSocket.addEventListener("openHuntGame",this.onOpenSkipSnow);
         GV.onlineSocket.addEventListener(LeaveGameReq.LEAVEGAME_CLEATNPC,this.onChangeGame);
         BufferManager.addBufferEvent(BufferManager.SEARCH_BTN_TIMES,this.onSearchGame);
         BufferManager.getBuffer(BufferManager.SEARCH_BTN_TIMES);
         BufferManager.addBufferEvent(BufferManager.ATOM_GAME_LEVEL,this.onCheckgame);
         BufferManager.getBuffer(BufferManager.ATOM_GAME_LEVEL);
         SystemEventManager.addEventListener("getItemOne",this.getItemOne);
      }
      
      private function onClickAFuHao(e:SystemEvent) : void
      {
         trace("進入阿芙號");
         MapManager.enterMap(409);
      }
      
      override protected function initView() : void
      {
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            _mapLevel.controlLevel["buyBtn"].visible = true;
            petItemModule.setPetEffectHandler(null,2);
         }
         _mapLevel.controlLevel["buyBtn"].addEventListener(MouseEvent.CLICK,this.buyHandler);
         TipsManager.addTextTips(controlLevel.giftGameBtn,"拾禮物遊戲");
         TipsManager.addTextTips(controlLevel.gameBtn,"進入環遊莊園");
      }
      
      private function onOpenSkipSnow(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("openHuntGame",this.onOpenSkipSnow);
         JoinGameLogic.joinGameAction(0,9,2,0);
         JoinGameLogic.openGame(0,109);
      }
      
      private function onChangeGame(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(LeaveGameReq.LEAVEGAME_CLEATNPC,this.onChangeGame);
         setTimeout(function():void
         {
         },2000);
      }
      
      private function buyHandler(evt:MouseEvent) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = 12299;
         itemObj.price = 0;
         itemObj.info = "0";
         clothBuyModule.buyAction(itemObj);
         petItemModule.setPetEffectHandler();
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
            playmovie = PlayMovie.play("resource/map/activity/act1207_map_37.swf",null,null,function():void
            {
               playmovie.destroy();
               mapSay(1);
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
      
      private function getItemOne(e:SystemEvent) : void
      {
         OnlineManager.addCmdListener(CommandID.BLACK_SEED_GET_ITEM,this.getActItem1);
         OnlineManager.send(CommandID.BLACK_SEED_GET_ITEM);
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("getItemOne",this.getItemOne);
         _mapLevel.controlLevel["buyBtn"].removeEventListener(MouseEvent.CLICK,this.buyHandler);
         throwHitTest.removeHitTest();
         GV.onlineSocket.removeEventListener("openHuntGame",this.onOpenSkipSnow);
         BufferManager.removeBufferEvent(BufferManager.SEARCH_BTN_TIMES,this.onSearchGame);
         BufferManager.removeBufferEvent(BufferManager.ATOM_GAME_LEVEL,this.onCheckgame);
         super.destroy();
      }
   }
}

