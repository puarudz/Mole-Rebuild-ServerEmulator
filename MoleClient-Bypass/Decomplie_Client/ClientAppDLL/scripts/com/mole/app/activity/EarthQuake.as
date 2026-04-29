package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.fightTree.FightTreeCheckPeoinfProtocol;
   import com.logic.socket.fightTree.FightTreeFightWorksProtocol;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.mole.app.event.PeopleEvent;
   import com.mole.app.manager.PeopleManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.net.events.SocketEvent;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.net.tmf.HeadInfo;
   
   public class EarthQuake
   {
      
      private static var _inst:EarthQuake;
      
      private var controlLevel:MovieClip;
      
      private var topLevel:MovieClip;
      
      private var depthLevel:MovieClip;
      
      private var frameStateArr:Array = [[26,35],[17,26],[13,20],[24,38],[8,12]];
      
      private var randNum:uint;
      
      private var selfPosID:uint = 100;
      
      private var expType:uint = 0;
      
      private var finishNum:uint = 0;
      
      private var ballBar:MovieClip;
      
      private var ballTime:MovieClip;
      
      private var startTime:Timer;
      
      private var overTime:Timer;
      
      private var gameTime:Timer;
      
      private var selfView:PeopleManageView;
      
      private var inPosBg:Sprite;
      
      private var _movie:PlayMovie;
      
      private var alt:*;
      
      public function EarthQuake()
      {
         super();
      }
      
      public static function get inst() : EarthQuake
      {
         if(_inst == null)
         {
            _inst = new EarthQuake();
         }
         return _inst;
      }
      
      public function init(controlLevel:MovieClip, topLevel:MovieClip, depthLevel:MovieClip) : void
      {
         this.controlLevel = controlLevel;
         this.topLevel = topLevel;
         this.depthLevel = depthLevel;
         MapManageView.inst.addEventListener(Event.INIT,this.initHandle);
      }
      
      private function initHandle(e:Event) : void
      {
         MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
         this.ballBar = this.topLevel["progressBarMC"];
         this.ballBar.gotoAndStop(1);
         this.ballBar.visible = false;
         this.ballTime = this.topLevel["timeMC"];
         this.ballTime.gotoAndStop(1);
         this.ballTime.visible = false;
         BC.addEvent(this,GV.onlineSocket,SocketEvent.DATA + "8845",this.getNewPos);
         BC.addEvent(this,GV.onlineSocket,SocketEvent.DATA + "8846",this.getPosUserID);
         GV.onlineSocket.addCmdListener(8921,this.getBallFlag,false,99);
         this.inPosBg = LevelManager.drawBG(0,0,null);
         this.inPosBg.name = "inPosBg_map68";
         FightTreeCheckPeoinfProtocol.send();
         this.selfView = PeopleManager.getPeopleView(LocalUserInfo.getUserID());
      }
      
      private function getPosUserID(e:SocketEvent) : void
      {
         var ball_btn:SimpleButton = null;
         BC.removeEvent(this,GV.onlineSocket,SocketEvent.DATA + "8846",this.getPosUserID);
         var info:FightTreeCheckPeoinfProtocol = e.bodyInfo;
         var arr:Array = new Array();
         arr = info.stateList;
         for(var i:uint = 0; i < 3; i++)
         {
            ball_btn = this.controlLevel["ball_" + i];
            BC.addEvent(this,ball_btn,MouseEvent.CLICK,this.beginAirBallGame);
         }
      }
      
      private function getBallFlag(e:*) : void
      {
         var man:PeopleManageView = null;
         var bodyData:ByteArray = e.data as ByteArray;
         var userID:uint = bodyData.readUnsignedInt();
         var posID:uint = bodyData.readUnsignedInt();
         var state:uint = bodyData.readUnsignedInt();
         if(state == 3)
         {
            man = PeopleManager.getPeopleView(userID);
            man.visible = false;
            if(userID == LocalUserInfo.getUserID())
            {
               this.ballBar.visible = false;
               this.ballBar.gotoAndStop(1);
               this._movie = PlayMovie.play("resource/movie/firecracker.swf",null,null,this.overMovie,null,LevelManager.appLevel,false);
            }
         }
      }
      
      private function overMovie() : void
      {
         this._movie.destroy();
         this._movie = null;
      }
      
      private function beginAirBallGame(e:MouseEvent) : void
      {
         if(this.selfPosID < 100)
         {
            return;
         }
         this.selfPosID = this.getStringArr(e.currentTarget.name);
         this.selfMoveToPosMC();
      }
      
      private function selfMoveToPosMC() : void
      {
         BC.addEvent(this,this.selfView,PeopleManageView.ON_GO_OVER,this.bodyGoToPosMC);
         GV.onlineSocket.addEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
         var setMC:MovieClip = this.controlLevel["set_" + this.selfPosID];
         this.selfView.moveTo(setMC.x,setMC.y);
      }
      
      private function onLeaveSeat(e:Event) : void
      {
         BC.removeEvent(this,this.selfView,PeopleManageView.ON_GO_OVER,this.bodyGoToPosMC);
         GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
         this.selfPosID = 100;
      }
      
      private function bodyGoToPosMC(e:Event) : void
      {
         BC.removeEvent(this,this.selfView,PeopleManageView.ON_GO_OVER,this.bodyGoToPosMC);
         if(this.selfView.hitTestObject(this.controlLevel["set_" + this.selfPosID]))
         {
            FightTreeFightWorksProtocol.send(1,this.selfPosID);
            LevelManager.topLevel.addChild(this.inPosBg);
            this.selfView.sitDown(2);
         }
         else
         {
            this.selfPosID = 100;
         }
      }
      
      private function unExchangeFun(e:Event) : void
      {
         BC.removeEvent(this,this.alt,Alert.CLICK_ + "2",this.unExchangeFun);
         this.alt = null;
         FightTreeFightWorksProtocol.send(0,this.selfPosID);
         LevelManager.topLevel.removeChild(this.inPosBg);
      }
      
      private function exchangeFun(e:* = null) : void
      {
         if(Boolean(this.alt))
         {
            BC.removeEvent(this,this.alt,Alert.CLICK_ + "2",this.unExchangeFun);
            this.alt = null;
         }
         GV.onlineSocket.addEventListener(SocketEvent.ERROR,this.getErrorSecket);
         BC.addEvent(this,GV.onlineSocket,"read_1242",this.getExpItems);
         superlamuPartySocket.treasurebowl(241);
      }
      
      private function getExpItems(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1242",this.getExpItems);
         var itemID:int = int(e.EventObj.itemId);
         var count:int = int(e.EventObj.count);
         if(this.expType == 2279)
         {
            if(e.EventObj.Count == 0)
            {
               this.selfOnPos();
            }
         }
         else
         {
            Alert.smileAlart("    恭喜你成功了，獲得" + count + "個" + GoodsInfo.getItemNameByID(itemID) + "。");
         }
      }
      
      private function getErrorSecket(e:SocketEvent) : void
      {
         var obj:HeadInfo = e.headInfo;
         if(obj.commandID == 1243 && obj.result == -11119 && this.expType == 2279)
         {
            GV.onlineSocket.removeEventListener(SocketEvent.ERROR,this.getErrorSecket);
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getExpItems);
            FightTreeFightWorksProtocol.send(0,this.selfPosID);
            LevelManager.topLevel.removeChild(this.inPosBg);
         }
      }
      
      private function getNewPos(e:SocketEvent) : void
      {
         var pos:* = e.bodyInfo;
         var ball_btn:SimpleButton = this.controlLevel["ball_" + pos.pos];
         var body:PeopleManageView = PeopleManager.getPeopleView(pos.userID);
         if(pos.flag == 1)
         {
            ball_btn.visible = false;
            if(pos.userID == LocalUserInfo.getUserID())
            {
               BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.setFinishNum);
               finishSomethingReq.sendReq(30181);
               this.selfOnPos();
            }
            else if(this.selfPosID < 100 && this.selfPosID == pos.pos)
            {
               BC.removeEvent(this,this.selfView,PeopleManageView.ON_GO_OVER,this.bodyGoToPosMC);
               this.selfView.visible = true;
               this.selfView.moveTo(843,335);
               this.selfPosID = 100;
               Alert.smileAlart("    當前位置已經有人了，去其他的位置試試吧！");
            }
         }
         else
         {
            body.visible = true;
            body.moveTo(843,335);
            ball_btn.visible = true;
            if(pos.userID == LocalUserInfo.getUserID())
            {
               this.selfPosID = 100;
            }
         }
      }
      
      private function setFinishNum(e:EventTaomee) : void
      {
         var type:int = int(e.EventObj.Type);
         if(type != 30181)
         {
            return;
         }
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.setFinishNum);
         this.finishNum = e.EventObj.Done;
         if(this.finishNum >= 10)
         {
            return;
         }
         this.selfOnPos();
      }
      
      private function selfOnPos() : void
      {
         this.ballTime.gotoAndPlay(2);
         this.ballTime.visible = true;
         this.ballBar.visible = true;
         var _temp_2:* = this;
         var _temp_1:* = GC;
         with({})
         {
            _temp_2.startTime = _temp_1.setGTimeout(function startBar():void
            {
               GC.clearGTimeout(startTime);
               randNum = 2;
               ballBar.gotoAndStop(randNum);
               startTime = null;
               ballTime.visible = false;
               ballTime.gotoAndStop(1);
               LevelManager.stage.focus = LevelManager.stage;
               LevelManager.stage.addEventListener(KeyboardEvent.KEY_UP,getKeyEvent);
               GF.sendSocket(8921,1);
               gameTime = GC.setGTimeout(unGetKeyEvent,6000);
            },5000);
         }
         
         private function unGetKeyEvent() : void
         {
            LevelManager.stage.removeEventListener(KeyboardEvent.KEY_UP,this.getKeyEvent);
            if(Boolean(this.gameTime))
            {
               GC.clearGTimeout(this.gameTime);
               this.gameTime = null;
            }
            GF.sendSocket(8921,1);
            this.overTime = GC.setGTimeout(this.airBallOver,100,2);
         }
         
         private function getKeyEvent(e:KeyboardEvent) : void
         {
            var moveTimeNum:uint = 0;
            var frame:uint = 0;
            var flag:uint = 0;
            if(e.keyCode == 32)
            {
               if(Boolean(this.gameTime))
               {
                  GC.clearGTimeout(this.gameTime);
                  this.gameTime = null;
               }
               LevelManager.stage.removeEventListener(KeyboardEvent.KEY_UP,this.getKeyEvent);
               this.ballBar.stop();
               moveTimeNum = 3000;
               frame = uint(this.topLevel["progressBarMC"]["progress" + this.randNum + "_mc"].currentFrame);
               flag = 0;
               trace(this.frameStateArr[this.randNum - 2][0],this.frameStateArr[this.randNum - 2][1]);
               if(frame < this.frameStateArr[this.randNum - 2][0])
               {
                  flag = 4;
                  moveTimeNum = 300;
               }
               else if(frame >= this.frameStateArr[this.randNum - 2][0] && frame < this.frameStateArr[this.randNum - 2][1])
               {
                  flag = 3;
                  moveTimeNum = 6500;
               }
               else if(frame >= this.frameStateArr[this.randNum - 2][1])
               {
                  flag = 4;
                  moveTimeNum = 300;
               }
               GF.sendSocket(8921,flag);
               this.overTime = GC.setGTimeout(this.airBallOver,moveTimeNum,flag);
            }
         }
         
         private function airBallOver(flag:uint) : void
         {
            this.selfView.visible = true;
            GC.clearGTimeout(this.overTime);
            this.overTime = null;
            this.ballBar.visible = false;
            this.ballBar.gotoAndStop(1);
            switch(flag)
            {
               case 2:
                  Alert.angryAlart("    哎呀，沒有點燃引線哦，小摩爾再試試吧!");
                  break;
               case 3:
                  if(this.finishNum <= 10)
                  {
                     this.expType = 241;
                     this.exchangeFun();
                  }
                  else
                  {
                     Alert.smileAlart("    恭喜你成功了");
                  }
                  break;
               case 4:
                  Alert.angryAlart("    哎呀，沒有點燃引線哦，小摩爾再試試吧");
            }
            FightTreeFightWorksProtocol.send(0,this.selfPosID);
            LevelManager.topLevel.removeChild(this.inPosBg);
         }
         
         private function getStringArr(str:String) : uint
         {
            var arr:Array = str.split("_");
            return uint(arr[1]);
         }
         
         public function destroy() : void
         {
            this.controlLevel = null;
            this.topLevel = null;
            this.depthLevel = null;
            BC.removeEvent(this,GV.onlineSocket,SocketEvent.DATA + "8845",this.getNewPos);
            BC.removeEvent(this,GV.onlineSocket,SocketEvent.DATA + "8846",this.getPosUserID);
            GV.onlineSocket.removeCmdListener(8921,this.getBallFlag);
            MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
            if(Boolean(this.startTime))
            {
               GC.clearGTimeout(this.startTime);
               this.startTime = null;
            }
            if(Boolean(this.overTime))
            {
               GC.clearGTimeout(this.overTime);
               this.overTime = null;
            }
            if(Boolean(this.gameTime))
            {
               GC.clearGTimeout(this.gameTime);
               this.gameTime = null;
            }
            try
            {
               LevelManager.stage.removeEventListener(KeyboardEvent.KEY_UP,this.getKeyEvent);
            }
            catch(e:*)
            {
            }
            if(Boolean(LevelManager.topLevel.getChildByName("inPosBg_map68")))
            {
               LevelManager.topLevel.removeChild(this.inPosBg);
               this.inPosBg = null;
            }
            BC.removeEvent(this,this.selfView,PeopleManageView.ON_GO_OVER,this.bodyGoToPosMC);
            GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
            MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
            GV.onlineSocket.removeEventListener(SocketEvent.ERROR,this.getErrorSecket);
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getExpItems);
            BC.removeEvent(this);
         }
      }
   }
   
   