package com.logic.task
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.active.MaylstActiveCtl;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.jack.JackSocket;
   import com.logic.socket.moleAction.moleActionReq;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.net.MoleSharedObject;
   import com.view.PeopleView.FlyType;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TaskTaleJack
   {
      
      private static var _instance:TaskTaleJack;
      
      private var _playMovie:PlayMovie;
      
      public var count:int = 0;
      
      private var changeMapTimer:Timer;
      
      private var _timer:Timer;
      
      public function TaskTaleJack()
      {
         super();
      }
      
      public static function get inst() : TaskTaleJack
      {
         if(_instance == null)
         {
            _instance = new TaskTaleJack();
         }
         return _instance;
      }
      
      public function playMovie() : void
      {
         if(MoleSharedObject.moleObj.taleJack == undefined)
         {
            PlayMovie.play("resource/task/jackMovie.swf",null,null,null,null,MainManager.getAppLevel());
            MoleSharedObject.moleObj.taleJack = 1;
            MoleSharedObject.flush();
         }
      }
      
      public function init() : void
      {
         var obj:Object = null;
         if(LocalUserInfo.getMapID() == 10 || LocalUserInfo.getMapID() == 248)
         {
            BC.addEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FLOWER,this.hitOver,false,0,true);
            obj = {
               "btn":GV.MC_mapFrame["control_mc"].btn_tree,
               "mc":new MovieClip(),
               "id":"swf150001",
               "fre":1,
               "hide":true
            };
            throwHitTest.HitTestMC(obj);
            BC.addEvent(this,GV.onlineSocket,JackSocket.GET_TREE_INFO,this.getTreeInfoOver,false,0,true);
            JackSocket.getTreeInfo();
            BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.removeMapFunc,false,0,true);
            this.startTimer();
            BC.addEvent(this,GV.onlineSocket,JackSocket.THROW_WATHER,this.throwWaterOver,false,0,true);
         }
      }
      
      private function hitOver(e:EventTaomee) : void
      {
         var tcnt:int = 0;
         if(e.EventObj.mc.userID == LocalUserInfo.getUserID() && e.EventObj.mc.ThrowID == 150001)
         {
            JackSocket.throwWaterBall();
            tcnt = this.count;
            ++this.count;
            if(tcnt < 10 && this.count >= 10 && this.count < 20)
            {
               this.playGrowMovie(1);
            }
            else if(tcnt < 20 && this.count >= 20)
            {
               this.playGrowMovie(2);
            }
            if(tcnt >= 10 && this.count >= 10 && tcnt < 20 && this.count < 20)
            {
               GV.MC_mapFrame["depth_mc"].tree.gotoAndStop(17);
            }
            else if(tcnt >= 20 && this.count >= 20)
            {
               GV.MC_mapFrame["depth_mc"].tree.gotoAndStop(40);
            }
            this.initUI();
         }
      }
      
      private function throwWaterOver(e:EventTaomee) : void
      {
         var itemID:int = int(e.EventObj.itemID);
         if(itemID != 0)
         {
            Alert.smileAlart("    恭喜你獲得1枚慶典勳章!");
         }
      }
      
      public function playGrowMovie(state:int) : void
      {
         var tree:MovieClip = null;
         this.desMovie();
         if(LocalUserInfo.getMapID() == 10 || LocalUserInfo.getMapID() == 248)
         {
            tree = GV.MC_mapFrame["depth_mc"].tree;
            if(state == 1)
            {
               tree.gotoAndPlay(1);
            }
            else if(state == 2)
            {
               tree.gotoAndPlay(18);
            }
            else if(state == 3)
            {
               new moleActionReq().sendAction(77,GV.MAN_PEOPLE.x,GV.MAN_PEOPLE.y);
               GV.MAN_PEOPLE.fly(FlyType.PET);
               GV.MAN_PEOPLE.addEventListener("onFlyComPlete",this.gotoAirMap);
               MoveTo.CanMove = false;
               this.changeMapTimer = GC.setGTimeout(this.gotoAirMap,8000,1);
            }
            else if(state == 4)
            {
               tree.gotoAndPlay(52);
            }
         }
      }
      
      private function gotoAirMap(E:*) : void
      {
         GC.clearGTimeout(this.changeMapTimer);
         GV.MAN_PEOPLE.removeEventListener("onFlyComPlete",this.gotoAirMap);
         MapManager.enterMap(242);
      }
      
      public function openGame() : void
      {
         MaylstActiveCtl.instance.onLoadGame("module/external/flyeavesgowall.swf",true,true);
      }
      
      private function getTreeInfoOver(e:EventTaomee) : void
      {
         var tcnt:int = this.count;
         this.count = e.EventObj.count;
         if(this.count >= 10)
         {
            if(LocalUserInfo.getMapID() == 10 || LocalUserInfo.getMapID() == 248)
            {
               GV.MC_mapFrame["depth_mc"].taleJack.gotoAndStop(2);
            }
         }
         if(tcnt < 10 && this.count >= 10 && this.count < 20)
         {
            this.playGrowMovie(1);
         }
         else if(tcnt < 20 && this.count >= 20)
         {
            this.playGrowMovie(2);
         }
         else if(tcnt >= 20 && this.count < 10)
         {
            this.playGrowMovie(4);
         }
         if(tcnt >= 10 && this.count >= 10 && tcnt < 20 && this.count < 20)
         {
            GV.MC_mapFrame["depth_mc"].tree.gotoAndStop(17);
         }
         else if(tcnt >= 20 && this.count >= 20)
         {
            GV.MC_mapFrame["depth_mc"].tree.gotoAndStop(40);
         }
         this.initUI();
      }
      
      private function initUI() : void
      {
         var max:int = 0;
         if(LocalUserInfo.getMapID() == 10 || LocalUserInfo.getMapID() == 248)
         {
            max = 10;
            if(this.count > 10)
            {
               max = 20;
            }
            GV.MC_mapFrame["top_mc"].mc_bar.gotoAndStop(int(this.count / max * GV.MC_mapFrame["top_mc"].mc_bar.totalFrames));
            GV.MC_mapFrame["top_mc"].mc_bar.txt.text = "成長值: " + this.count + "/" + max;
            if(this.count > 20)
            {
               GV.MC_mapFrame["top_mc"].mc_bar.visible = false;
            }
            else
            {
               GV.MC_mapFrame["top_mc"].mc_bar.visible = true;
            }
         }
      }
      
      private function startTimer() : void
      {
         this.stopTimer();
         this._timer = new Timer(1000 * 10);
         BC.addEvent(this,this._timer,TimerEvent.TIMER,this.tick,false,0,true);
         this._timer.start();
      }
      
      private function tick(e:TimerEvent) : void
      {
         JackSocket.getTreeInfo();
      }
      
      private function stopTimer() : void
      {
         if(this._timer != null)
         {
            this._timer.stop();
            BC.removeEvent(this,this._timer,TimerEvent.TIMER,this.tick);
            this._timer = null;
         }
      }
      
      private function desMovie() : void
      {
         if(this._playMovie != null)
         {
            this._playMovie.destroy();
         }
      }
      
      public function loadJumpGame() : void
      {
         BC.addEvent(this,GV.onlineSocket,"lamuJumpGameOver",this.gameOverFun);
         var resID:int = int(DownLoadManager.add("module/game/SweetHeartGame.swf",ResType.DISPLAY_OBJECT));
         DownLoadManager.addEvent(resID,this.loadGameOver);
      }
      
      private function gameOverFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"lamuJumpGameOver",this.gameOverFun);
         GameframeLogic.playMousicHandler();
      }
      
      private function loadGameOver(e:DownLoadEvent) : void
      {
         GameframeLogic.stopMousicHandler();
         MapManager.clearMap();
         MainManager.getAppLevel().addChild(e.data);
      }
      
      private function removeMapFunc(e:EventTaomee) : void
      {
         BC.removeEvent(this);
         this.stopTimer();
      }
   }
}

