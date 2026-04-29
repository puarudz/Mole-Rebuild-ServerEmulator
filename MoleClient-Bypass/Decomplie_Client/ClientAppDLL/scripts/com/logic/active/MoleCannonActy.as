package com.logic.active
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.manager.SystemTimeController;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class MoleCannonActy
   {
      
      private static var _inst:MoleCannonActy;
      
      private var movie:PlayMovie;
      
      private var scene:WaterActivityManager;
      
      private var actID:uint = 20130531;
      
      private var gameState:uint;
      
      private var gameResult:int;
      
      private var userInfoArr:Array;
      
      private var woodPt:Point = new Point(433,453);
      
      private var position:int;
      
      private var woodBtnArr:Array;
      
      private var userMcArr:Array;
      
      private var timeMcArr:Array;
      
      private var stoneMcArr:Array;
      
      private var time:int;
      
      private var timer:uint;
      
      private var fingerGuessPanel:MovieClip;
      
      private var movie0:MovieClip;
      
      private var movie1:MovieClip;
      
      private var cannonMc:MovieClip;
      
      private var mapID:Array = [41,37,4,6,7,2,3];
      
      private var posNum:int = 5;
      
      private var faceMcArr:Array;
      
      private var faceTimer:int;
      
      private var candleMovie:PlayMovie;
      
      private var prizeArr:Array;
      
      public function MoleCannonActy()
      {
         super();
      }
      
      public static function get inst() : MoleCannonActy
      {
         if(_inst == null)
         {
            _inst = new MoleCannonActy();
         }
         return _inst;
      }
      
      public function init() : void
      {
         this.scene = new WaterActivityManager();
         this.addEvents();
      }
      
      private function addEvents() : void
      {
         BC.addEvent(this,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.onEnterMap);
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
         BC.addEvent(this,this.scene,WaterActivityManager.WATER_ACTIVITY_BROADCAST,this.onBroadCast);
         BC.addEvent(this,this.scene,WaterActivityManager.WATER_ACTIVITY_AWARD,this.getAward);
         SystemEventManager.addEventListener("goWood0",this.goWood0);
         SystemEventManager.addEventListener("goWood1",this.goWood1);
         SystemEventManager.addEventListener("goWood2",this.goWood2);
         SystemEventManager.addEventListener("goWood3",this.goWood3);
         SystemEventManager.addEventListener("goWood4",this.goWood4);
      }
      
      private function getAward(e:EventTaomee) : void
      {
         var itemID:int = 0;
         var cnt:int = 0;
         var bArr:ByteArray = e.EventObj as ByteArray;
         var count:int = int(bArr.readUnsignedInt());
         var msg:String = "    恭喜你獲得";
         for(var i:int = 0; i < count; i++)
         {
            itemID = int(bArr.readUnsignedInt());
            cnt = int(bArr.readUnsignedInt());
            msg += cnt + "個" + GoodsInfo.getItemNameByID(itemID);
            if(i < count - 1)
            {
               msg += ",";
            }
         }
         msg += "!";
         if(count > 0)
         {
            Alert.smileAlart(msg);
         }
         if(this.position >= 4)
         {
            PeopleManageView(GV.MAN_PEOPLE).moveTo(495,486);
         }
      }
      
      private function goWood0(e:SystemEvent) : void
      {
         this.checkWood(0);
      }
      
      private function goWood1(e:SystemEvent) : void
      {
         this.checkWood(1);
      }
      
      private function goWood2(e:SystemEvent) : void
      {
         this.checkWood(2);
      }
      
      private function goWood3(e:SystemEvent) : void
      {
         this.checkWood(3);
      }
      
      private function goWood4(e:SystemEvent) : void
      {
         this.checkWood(4);
      }
      
      private function checkWood(pos:int) : void
      {
         if(SystemTimeController.instance.checkSysTimeAchieve(99))
         {
            this.position = pos;
            if(this.userInfoArr[pos].userID == 0)
            {
               BC.addEvent(this,this.scene,WaterActivityManager.WATER_ACTIVITY_SEAT,this.onWoodSeated);
               this.scene.seat(pos + 1);
            }
            else
            {
               Alert.smileAlart("    這個位置已經有人了，換其它位子試試吧！");
               this.leaveWood();
            }
         }
         else
         {
            Alert.smileAlart("   親愛的小摩爾，現在不是遊戲時間");
         }
      }
      
      private function onWoodSeated(e:EventTaomee) : void
      {
         BC.removeEvent(this,this.scene,WaterActivityManager.WATER_ACTIVITY_SEAT,this.onWoodSeated);
         if(e.EventObj.state == 1)
         {
            if(e.EventObj.flag == 1)
            {
               GV.MAN_PEOPLE.visible = false;
               this.timeMcArr[this.position].visible = true;
               this.timeMcArr[this.position].gotoAndPlay(2);
               this.prizeArr = e.EventObj.arr;
               this.addBg();
            }
            else if(e.EventObj.flag == 0)
            {
               GV.MAN_PEOPLE.visible = true;
               this.prizeArr = null;
               this.removeBg();
               this.leaveWood();
               this.position = -1;
            }
         }
         else
         {
            Alert.smileAlart("    這個位置已經有人了，換其它位子試試吧！");
            this.leaveWood();
         }
      }
      
      private function addBg() : Sprite
      {
         var bg:Sprite = MainManager.getAppLevel().getChildByName("myBG") as Sprite;
         if(bg == null)
         {
            bg = LevelManager.drawBG(0,0);
            bg.name = "myBG";
            bg.buttonMode = true;
            BC.addEvent(this,bg,MouseEvent.CLICK,this.clickBg);
            MainManager.getAppLevel().addChild(bg);
         }
         return bg;
      }
      
      private function clickBg(e:MouseEvent) : void
      {
         Alert.smileAlart("        確定要離開遊戲嗎？",this.leaveGame,"sure,cancel");
      }
      
      private function leaveGame(e:*) : void
      {
         BC.addEvent(this,this.scene,WaterActivityManager.WATER_ACTIVITY_SEAT,this.onWoodSeated);
         this.scene.seat(this.position + 1,true);
      }
      
      private function removeBgEvent() : void
      {
         var bg:Sprite = MainManager.getAppLevel().getChildByName("myBG") as Sprite;
         if(bg != null)
         {
            BC.removeEvent(this,bg,MouseEvent.CLICK,this.clickBg);
         }
      }
      
      private function removeBg() : void
      {
         this.removeBgEvent();
         var bg:Sprite = MainManager.getAppLevel().getChildByName("myBG") as Sprite;
         DisplayUtil.removeForParent(bg);
      }
      
      private function leaveWood() : void
      {
         PeopleManageView(GV.MAN_PEOPLE).moveTo(this.woodPt.x,this.woodPt.y);
      }
      
      private function onBroadCast(e:EventTaomee) : void
      {
         var userID:int = 0;
         var winFail:int = 0;
         var stone:int = 0;
         var lastState:int = int(this.gameState);
         var bArr:ByteArray = e.EventObj as ByteArray;
         var activityID:uint = bArr.readUnsignedInt();
         this.gameState = bArr.readUnsignedInt();
         var leftTime:int = int(bArr.readUnsignedInt());
         this.gameResult = bArr.readUnsignedInt();
         var count:int = int(bArr.readUnsignedInt());
         var tempInfoArr:Array = this.userInfoArr;
         this.userInfoArr = [];
         for(var i:int = 0; i < count; i++)
         {
            userID = int(bArr.readUnsignedInt());
            winFail = int(bArr.readUnsignedInt());
            stone = int(bArr.readUnsignedInt());
            if(tempInfoArr != null && tempInfoArr[i].isInCannon == 1)
            {
               this.userInfoArr.push({
                  "userID":userID,
                  "winFail":winFail,
                  "stone":stone,
                  "isInCannon":1
               });
            }
            else
            {
               this.userInfoArr.push({
                  "userID":userID,
                  "winFail":winFail,
                  "stone":stone,
                  "isInCannon":0
               });
            }
         }
         this.initMc();
         if(this.inPlay)
         {
            if(lastState == 1 && this.gameState == 2)
            {
               this.gameStart();
            }
            if(!(lastState == 4 && this.gameState == 4))
            {
               this.playMovie();
            }
         }
         if(lastState == 3 && this.gameState == 2 && this.inPlayAndWin)
         {
            this.loadStonePanel();
         }
         if(this.gameState != 1)
         {
            this.removeBgEvent();
         }
      }
      
      private function get inPlay() : Boolean
      {
         for(var i:int = 0; i < this.posNum; i++)
         {
            if(this.userInfoArr[i].userID == LocalUserInfo.getUserID())
            {
               return true;
            }
         }
         return false;
      }
      
      private function get inPlayAndWin() : Boolean
      {
         for(var i:int = 0; i < this.posNum; i++)
         {
            if(this.userInfoArr[i].userID == LocalUserInfo.getUserID() && this.userInfoArr[i].winFail != 1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function playMovie() : void
      {
         var i:int = 0;
         if(this.gameState == 3)
         {
            if(this.gameResult == 0)
            {
               this.movie0.gotoAndPlay(2);
               MovieClipUtil.playEndAndFunc(this.movie0,this.movie0EndFunc);
            }
            else if(this.gameResult == 1)
            {
               for(i = 0; i < this.posNum; i++)
               {
                  if(this.userInfoArr[i].winFail == 1 && this.userInfoArr[i].isInCannon == 0)
                  {
                     this.userMcArr[i].gotoAndPlay(34);
                     this.userInfoArr[i].isInCannon = 1;
                  }
               }
               this.movie1.gotoAndPlay(2);
               MovieClipUtil.playEndAndFunc(this.movie1,this.movie1EndFunc);
            }
         }
         else if(this.gameState == 4)
         {
            this.cannonMc.gotoAndPlay(2);
            MovieClipUtil.playEndAndFunc(this.cannonMc,this.cannonMcEndFunc);
         }
      }
      
      private function cannonMcEndFunc() : void
      {
         this.removeBg();
         GV.MAN_PEOPLE.visible = true;
         this.cannonMc.gotoAndStop(1);
         for(var i:int = 0; i < this.posNum; i++)
         {
            if(this.userInfoArr[i].userID == LocalUserInfo.getUserID())
            {
               if(this.userInfoArr[i].winFail == 0)
               {
                  this.leaveWood();
               }
               else
               {
                  GV.onlineSocket.addEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.shotToOtherMap);
                  MapManager.enterMap(this.mapID[int(Math.random() * this.mapID.length)]);
               }
            }
         }
         for(i = 0; i < this.userInfoArr.length; i++)
         {
            this.userInfoArr[i].userID = 0;
            this.userInfoArr[i].isInCannon = 0;
         }
      }
      
      private function shotToOtherMap(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.shotToOtherMap);
         Alert.smileAlart("    雖然沒有贏得最後勝利，不過，卻體驗了一次空中飛人！倒也還不錯哦！");
      }
      
      private function movie1EndFunc() : void
      {
         this.movie1.gotoAndStop(1);
      }
      
      private function movie0EndFunc() : void
      {
         this.movie0.gotoAndStop(1);
      }
      
      private function gameStart() : void
      {
         this.movie = PlayMovie.play("module/external/exeModule/readyGo.swf",null,null,this.playReadyOver);
      }
      
      private function playReadyOver() : void
      {
         if(Boolean(this.movie))
         {
            this.movie.destroy();
            this.movie = null;
         }
         this.loadStonePanel();
      }
      
      private function loadStonePanel() : void
      {
         var resID:int = int(DownLoadManager.add("module/external/exeModule/fingerGuessPanel.swf",ResType.DISPLAY_OBJECT));
         DownLoadManager.addEvent(resID,this.loadStonePanelOver);
      }
      
      private function loadStonePanelOver(e:DownLoadEvent) : void
      {
         DisplayUtil.removeForParent(this.fingerGuessPanel);
         this.fingerGuessPanel = (e.data as MovieClip).getChildAt(0) as MovieClip;
         MainManager.getAppLevel().addChild(this.fingerGuessPanel);
         clearInterval(this.timer);
         this.time = 5;
         this.timer = setInterval(this.tick,1000);
         for(var i:int = 0; i < 3; i++)
         {
            BC.addEvent(this,this.fingerGuessPanel["btn" + i],MouseEvent.CLICK,this.onSelectStone);
         }
         e.loader.unloadAndStop();
      }
      
      private function onSelectStone(e:MouseEvent) : void
      {
         for(var i:int = 0; i < 3; i++)
         {
            if(e.currentTarget.name == "btn" + i)
            {
               this.scene.sendResult(i);
               clearInterval(this.timer);
               DisplayUtil.removeForParent(this.fingerGuessPanel);
               this.fingerGuessPanel = null;
               break;
            }
         }
      }
      
      private function tick() : void
      {
         --this.time;
         this.fingerGuessPanel.txt.text = String(this.time);
         if(this.time == 0)
         {
            this.scene.sendResult(int(Math.random() * 3));
            clearInterval(this.timer);
            DisplayUtil.removeForParent(this.fingerGuessPanel);
            this.fingerGuessPanel = null;
         }
      }
      
      private function initMc() : void
      {
         var PeoPleMC:PeopleManageView = null;
         this.movie0 = GV.MC_mapFrame["top_mc"].movie0;
         this.movie1 = GV.MC_mapFrame["top_mc"].movie1;
         this.cannonMc = GV.MC_mapFrame["top_mc"].cannonMc;
         this.woodBtnArr = [];
         this.userMcArr = [];
         this.timeMcArr = [];
         this.stoneMcArr = [];
         this.faceMcArr = [];
         for(var i:int = 0; i < this.posNum; i++)
         {
            this.timeMcArr.push(GV.MC_mapFrame["top_mc"]["timeMc" + i]);
            this.userMcArr.push(GV.MC_mapFrame["top_mc"]["moleMc" + i]);
            this.woodBtnArr.push(GV.MC_mapFrame["control_mc"]["posBtn" + i]);
            this.stoneMcArr.push(GV.MC_mapFrame["top_mc"]["stoneMc" + i]);
            this.faceMcArr.push(GV.MC_mapFrame["top_mc"]["faceMc" + i]);
            this.faceMcArr[i].visible = false;
            if(this.userInfoArr[i].userID == 0 || this.gameState == 4)
            {
               this.userMcArr[i].stop();
               this.userMcArr[i].visible = false;
            }
            else
            {
               if(this.userInfoArr[i].isInCannon == 0)
               {
                  this.userMcArr[i].visible = true;
                  this.userMcArr[i].gotoAndPlay(1);
               }
               else
               {
                  this.userMcArr[i].visible = false;
                  this.userMcArr[i].stop();
               }
               PeoPleMC = PeopleManageView(GF.getPeopleByID(this.userInfoArr[i].userID));
               if(PeoPleMC != null)
               {
                  PeoPleMC.visible = false;
               }
            }
         }
         this.showTimeMc();
         this.showStoneMc();
         clearTimeout(this.faceTimer);
         setTimeout(this.showFaceMc,2000);
      }
      
      private function showFaceMc() : void
      {
         for(var i:int = 0; i < this.posNum; i++)
         {
            if(this.gameState == 3 || this.gameState == 4)
            {
               if(this.userInfoArr[i].userID != 0 && this.userInfoArr[i].isInCannon == 0 && this.inPlay)
               {
                  this.faceMcArr[i].gotoAndStop(this.userInfoArr[i].winFail + 1);
                  this.faceMcArr[i].visible = true;
                  this.stoneMcArr[i].visible = false;
               }
               else
               {
                  this.faceMcArr[i].visible = false;
               }
            }
            else
            {
               this.faceMcArr[i].visible = false;
            }
         }
      }
      
      private function showStoneMc() : void
      {
         for(var i:int = 0; i < this.posNum; i++)
         {
            if(this.gameState == 3 || this.gameState == 4)
            {
               if(this.userInfoArr[i].userID != 0 && this.userInfoArr[i].isInCannon == 0 && this.inPlay)
               {
                  this.stoneMcArr[i].gotoAndStop(this.userInfoArr[i].stone + 1);
                  this.stoneMcArr[i].visible = true;
               }
               else
               {
                  this.stoneMcArr[i].visible = false;
               }
            }
            else
            {
               this.stoneMcArr[i].visible = false;
            }
         }
      }
      
      private function showTimeMc() : void
      {
         for(var i:int = 0; i < this.posNum; i++)
         {
            if(this.gameState == 1)
            {
               if(this.userInfoArr[i].userID != 0)
               {
                  this.timeMcArr[i].play();
                  this.timeMcArr[i].visible = true;
               }
               else
               {
                  this.timeMcArr[i].stop();
                  this.timeMcArr[i].visible = false;
               }
            }
            else
            {
               this.timeMcArr[i].stop();
               this.timeMcArr[i].visible = false;
            }
         }
      }
      
      private function onEnterMap(e:EventTaomee) : void
      {
         this.scene.enterMap(this.actID);
      }
      
      private function onLeaveMap(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         clearInterval(this.timer);
         clearTimeout(this.faceTimer);
         this.removeBg();
         this.gameState = 0;
         DisplayUtil.removeForParent(this.fingerGuessPanel);
         this.fingerGuessPanel = null;
         for(var i:int = 0; i < this.userInfoArr.length; i++)
         {
            this.userInfoArr[i].userID = 0;
            this.userInfoArr[i].isInCannon = 0;
         }
         SystemEventManager.removeEventListener("goWood0",this.goWood0);
         SystemEventManager.removeEventListener("goWood1",this.goWood1);
         SystemEventManager.removeEventListener("goWood2",this.goWood2);
         SystemEventManager.removeEventListener("goWood3",this.goWood3);
         SystemEventManager.removeEventListener("goWood4",this.goWood4);
         this.woodBtnArr = null;
         this.userMcArr = null;
         this.timeMcArr = null;
         this.stoneMcArr = null;
         this.faceMcArr = null;
         this.prizeArr = null;
         if(Boolean(this.movie))
         {
            this.movie.destroy();
            this.movie = null;
         }
      }
   }
}

