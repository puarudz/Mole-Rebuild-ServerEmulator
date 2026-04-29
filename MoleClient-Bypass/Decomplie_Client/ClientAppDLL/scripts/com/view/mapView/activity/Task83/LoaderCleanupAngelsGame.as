package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.clearAngels.ClearAngelsGameStartSocket;
   import com.logic.socket.clearAngels.ClearAngelsOverSocket;
   import com.mole.app.map.MapManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class LoaderCleanupAngelsGame
   {
      
      private static var _instance:LoaderCleanupAngelsGame;
      
      private static var _propArr:Array;
      
      public static var begin_url:String = "resource/angelsAndDemons/swf/StartPanel.swf";
      
      public static var game_url:String = "module/external/BlackAngel.swf";
      
      private static var _prop_count:int = 0;
      
      private var target:*;
      
      private var type:int = 0;
      
      private var gift_MC:MovieClip;
      
      private var childMC:*;
      
      public function LoaderCleanupAngelsGame()
      {
         super();
      }
      
      public static function get prop_count() : int
      {
         return _prop_count;
      }
      
      public static function set prop_count(value:int) : void
      {
         _prop_count = value;
      }
      
      public static function get propArr() : Array
      {
         return _propArr;
      }
      
      public static function set propArr(value:Array) : void
      {
         _propArr = value;
      }
      
      public static function get instance() : LoaderCleanupAngelsGame
      {
         if(!_instance)
         {
            _instance = new LoaderCleanupAngelsGame();
         }
         return _instance;
      }
      
      public function addEventFun(mc:*) : void
      {
         this.target = mc;
         BC.addEvent(this,this.target,MouseEvent.CLICK,this.onCheckLoader);
      }
      
      private function onCheckLoader(e:MouseEvent) : void
      {
         if(PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.numChildren == 0)
         {
            Alert.smileAlart("    只有拉姆才能穿上飛天服，快去把你的拉姆帶來吧！");
         }
         else
         {
            this.onLoadPanel(begin_url,0);
         }
      }
      
      public function loaderClearupAngelsGame() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 7073,this.gameStart);
         ClearAngelsGameStartSocket.gameBeginFun(propArr[0]);
      }
      
      private function gameStart(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 7073,this.gameStart);
         BC.addEvent(this,GV.onlineSocket,"clearAngelsGameOver",this.onGameOverEvent);
         this.onLoadPanel(game_url,1);
      }
      
      private function onGameOverEvent(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"clearAngelsGameOver",this.onGameOverEvent);
         GameframeLogic.playMousicHandler();
         ClearAngelsOverSocket.clearAngelsOverFunt();
      }
      
      private function onLoadPanel(url:String, _type:int = 0) : void
      {
         this.type = _type;
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         if(this.type == 0)
         {
            MainManager.getAppLevel().addChild(this.gift_MC);
         }
         else if(this.type == 1)
         {
            MainManager.getGameLevel().addChild(this.gift_MC);
         }
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,"請耐心等待......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
         if(this.type == 1)
         {
            this.removeStage();
         }
      }
      
      public function clearHandler(e:* = null) : void
      {
         BC.removeEvent(this);
         GC.clearAll(this.gift_MC);
         this.childMC = null;
         this.gift_MC = null;
         BC.addEvent(this,this.target,MouseEvent.CLICK,this.onCheckLoader);
      }
      
      public function removeStage() : void
      {
         MapManager.clearMap();
      }
   }
}

