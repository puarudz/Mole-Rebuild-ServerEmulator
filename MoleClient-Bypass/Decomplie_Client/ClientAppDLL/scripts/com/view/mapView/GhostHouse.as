package com.view.mapView
{
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import com.module.collectItem.CollectBreadItem;
   import com.module.ninePicGame.fourDoor;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GhostHouse extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      private var startGameMC:MovieClip;
      
      private var key:MovieClip;
      
      private var boxMC:MovieClip;
      
      private var hitNum:int = 0;
      
      public function GhostHouse()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.target_mc.room_mc.visible = false;
         this.target_mc.room_new.visible = false;
         this.target_mc.guessBtn.addEventListener(MouseEvent.CLICK,this.guessGameHandler);
         new fourDoor(this.target_mc,GV.MC_mapFrame["top_mc"]);
         var task85State:uint = TaskManager.getTaskState(85);
         if(task85State == 1)
         {
            this.target_mc.box_btn.visible = true;
            BC.addEvent(this,this.target_mc.box_btn,MouseEvent.CLICK,this.Showbox_btnHandler);
         }
      }
      
      private function Showbox_btnHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         var i:int = 0;
         if(!MainManager.getAppLevel().getChildByName("boxMC"))
         {
            tempMC = GV.Lib_Map.getClass("boxMC") as Class;
            this.boxMC = new tempMC();
            this.boxMC.name = "boxMC";
            MainManager.getAppLevel().addChild(this.boxMC);
            BC.addEvent(this,this.boxMC.close_btn,MouseEvent.CLICK,this.removeboxMCHandler);
            for(i = 1; i <= 2; i++)
            {
               this.boxMC["btn_" + i].buttonMode = true;
               BC.addEvent(this,this.boxMC["btn_" + i],MouseEvent.CLICK,this.boxClickHandler);
            }
         }
      }
      
      private function boxClickHandler(evt:MouseEvent) : void
      {
         if(evt.currentTarget.currentFrame == evt.currentTarget.totalFrames)
         {
            evt.currentTarget.gotoAndStop(1);
         }
         else
         {
            evt.currentTarget.nextFrame();
         }
         this.boxOKEvent();
      }
      
      private function boxOKEvent() : void
      {
         this.hitNum = 0;
         for(var j:uint = 1; j <= 2; j++)
         {
            if(this.boxMC["btn_" + j].currentFrame == 1)
            {
               ++this.hitNum;
            }
         }
         this.hitMCPlay();
      }
      
      private function hitMCPlay() : void
      {
         BC.addEvent(this,GV.onlineSocket,"task_game_box",this.eventBtnBoxHandler);
         if(this.hitNum == 2)
         {
            this.boxMC.gotoAndStop(2);
         }
      }
      
      private function eventBtnBoxHandler(evt:Event) : void
      {
         CollectBreadItem.getInstance().jobID = 85;
         CollectBreadItem.getInstance().goodLen = 4;
         CollectBreadItem.getInstance().itemCount = 1;
         CollectBreadItem.getInstance().startItemID = 190450;
         CollectBreadItem.getInstance().endItemID = 190454;
         CollectBreadItem.getInstance().getItemStr = "你已經拿過靈芝啦。";
         CollectBreadItem.getInstance().jobStr = "    恭喜你獲得靈芝，已經放入你的百寶箱中了！";
         CollectBreadItem.getInstance().jobSortNum = 1;
         CollectBreadItem.getInstance().buyChargeItem(190451);
         this.removeboxMCHandler();
      }
      
      private function removeboxMCHandler(evt:* = null) : void
      {
         BC.removeEvent(this,this.boxMC.close_btn,MouseEvent.CLICK,this.removeboxMCHandler);
         GC.clearAllChildren(this.boxMC);
         this.boxMC = null;
      }
      
      private function guessGameHandler(event:MouseEvent) : void
      {
         var JoinGame:Class = null;
         if(!MainManager.getAppLevel().getChildByName("startGameMC"))
         {
            JoinGame = GV.Lib_Map.getClass("JOIN_GAME");
            this.startGameMC = new JoinGame() as MovieClip;
            this.startGameMC.x = (MainManager.getStageWidth() - this.startGameMC.width) / 2;
            this.startGameMC.y = (MainManager.getStageHeight() - this.startGameMC.height) / 2;
            this.startGameMC.name = "startGameMC";
            MainManager.getAppLevel().addChild(this.startGameMC);
            this.startGameMC.confirmBtn.addEventListener(MouseEvent.CLICK,this.confirmBtnHandler);
            this.startGameMC.cancleBtn.addEventListener(MouseEvent.CLICK,this.cancleBtnHandler);
         }
      }
      
      private function cancleBtnHandler(event:MouseEvent) : void
      {
         this.startGameMC.confirmBtn.removeEventListener(MouseEvent.CLICK,this.confirmBtnHandler);
         this.startGameMC.cancleBtn.removeEventListener(MouseEvent.CLICK,this.cancleBtnHandler);
         MainManager.getAppLevel().removeChild(this.startGameMC);
         this.startGameMC = null;
      }
      
      private function confirmBtnHandler(event:MouseEvent) : void
      {
         var guessMC:MovieClip = null;
         var mcloader:MCLoader = null;
         this.cancleBtnHandler(null);
         if(!MainManager.getGameLevel().getChildByName("guessMC"))
         {
            guessMC = new MovieClip();
            guessMC.name = "guessMC";
            MainManager.getGameLevel().addChild(guessMC);
            mcloader = new MCLoader("module/game/GuessGame.swf",guessMC,1,"正在加載遊戲");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.onLoadGame);
            mcloader.doLoad();
         }
      }
      
      private function onLoadGame(event:MCLoadEvent) : void
      {
         var container:DisplayObjectContainer = event.getParent();
         var content:DisplayObject = event.getContent();
         container.addChild(content);
      }
      
      private function keyHandler(event:MouseEvent) : void
      {
         this.key.confirmBtn.removeEventListener(MouseEvent.CLICK,this.keyHandler);
         MainManager.getAppLevel().removeChild(this.key);
         this.key = null;
      }
      
      override public function destroy() : void
      {
         this.target_mc.guessBtn.removeEventListener(MouseEvent.CLICK,this.guessGameHandler);
         this.target_mc = null;
         this.depth_mc = null;
         super.destroy();
      }
   }
}

