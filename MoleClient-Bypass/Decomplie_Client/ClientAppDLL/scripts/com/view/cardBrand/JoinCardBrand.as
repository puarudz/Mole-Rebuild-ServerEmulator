package com.view.cardBrand
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.queryTrainResult.queryTrainResult;
   import com.module.activityModule.SoundControlModule;
   import com.module.npc.I_NPC;
   import com.module.npc.npcInstance.GhostNPC;
   import com.mole.app.map.MapManager;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   
   public class JoinCardBrand
   {
      
      private static var owner:JoinCardBrand;
      
      public static var retNum:int;
      
      private var locationNum:int;
      
      private var type:int;
      
      private var gLocationNum:int;
      
      private var gameNum:int;
      
      private var bool:Boolean;
      
      private var bossNum:int;
      
      private var bark:I_NPC;
      
      public var barkArr:Array = new Array();
      
      public function JoinCardBrand()
      {
         super();
         owner = this;
      }
      
      public static function getInstance() : JoinCardBrand
      {
         return Boolean(owner) ? owner : new JoinCardBrand();
      }
      
      public function startGame(_type:int = 1, _gLocationNum:int = 1, _gameNum:int = 39, _locationNum:int = 5) : void
      {
         this.type = _type;
         this.locationNum = _locationNum;
         this.gLocationNum = _gLocationNum;
         this.gameNum = _gameNum;
         this.openGame();
      }
      
      private function openGame() : void
      {
         if(retNum == 1)
         {
            this.initGame();
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"read_1223",this.onQueryNewCardBook);
            queryTrainResult.queryNewCardBook();
         }
      }
      
      private function onQueryNewCardBook(evt:EventTaomee) : void
      {
         var msg:String = null;
         var url:String = null;
         var alert:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,"read_1223",this.onQueryNewCardBook);
         if(evt.EventObj.ret == 0)
         {
            msg = "    你還沒有騎士卡牌冊！沒辦法和怪物戰鬥！快去森林訓練場找土林長老，領取卡牌冊再回來吧！";
            url = "resource/allJob/AlertPic/sunday.swf";
            alert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"go,notgo",true,false,"SMCUI");
            BC.addEvent(this,alert,Alert.CLICK_ + "1",this.gotoMapEvent,false,0,true);
         }
         else if(evt.EventObj.ret == 1)
         {
            retNum = 1;
            this.initGame();
         }
      }
      
      private function initGame() : void
      {
         GameframeLogic.cardGameType = this.type;
         var loginGame:* = GF.loginGame(this.locationNum,this.gLocationNum,this.gameNum);
         loginGame.addEventForCard();
         loginGame.beforehandLoadGame();
      }
      
      private function gotoMapEvent(e:*) : void
      {
         MapManager.enterMap(152);
      }
      
      public function sceneStartGame(_str:String, hx:int, hy:int, _type:int = 1, _gLocationNum:int = 1, _bool:Boolean = false, _speed:int = 30, _gameNum:int = 39, _locationNum:int = 5) : void
      {
         this.type = _type;
         this.locationNum = _locationNum;
         this.gLocationNum = _gLocationNum;
         this.bool = _bool;
         this.gameNum = _gameNum;
         this.bark = new GhostNPC(_str);
         GV.MC_Depth.addChild(this.bark as DisplayObjectContainer);
         this.bark.x = hx;
         this.bark.y = hy;
         this.bark.autoMove = true;
         this.bark.Speed = _speed;
         this.barkArr.push(this.bark);
         this.addBarkBtnFun(this.bark);
      }
      
      private function addBarkBtnFun(bark:I_NPC) : void
      {
         var cl:*;
         var tailButton:TailButtonView = new TailButtonView();
         tailButton.buttonMode = true;
         tailButton.x = bark.x;
         tailButton.y = bark.y;
         tailButton.fineTail3Target(bark as DisplayObjectContainer);
         MapButtonView.getTarget().addChild(tailButton);
         cl = this;
         BC.addEvent(tailButton,tailButton,MouseEvent.CLICK,function(E:MouseEvent):void
         {
            if(bool)
            {
               SoundControlModule.getInstance().stopSund();
            }
            openGame();
         });
      }
   }
}

