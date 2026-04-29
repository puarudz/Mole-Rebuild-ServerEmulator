package com.logic.active
{
   import com.common.Alert.Alert;
   import com.common.Alert.type.AlertType;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.action.ActionReq;
   import com.logic.socket.lookBag.LookBagReq;
   import com.logic.socket.lookBag.LookBagRes;
   import com.module.LocusWork.NumSprite;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SceneActivityManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class LovePartyActy
   {
      
      private static var _inst:LovePartyActy;
      
      private var _seatIndex:uint;
      
      private var seatArr:Array;
      
      private var scene:SceneActivityManager;
      
      private var userArr:Array;
      
      private var partyUserArr:Array;
      
      private var choiceIDArr:Array;
      
      private var moleMcArr:Array;
      
      private var bandBtnArr:Array;
      
      private var bandMcArr:Array;
      
      private var failMcArr:Array;
      
      private var lightMc:MovieClip;
      
      private var spaceMc:MovieClip;
      
      private var failMc:MovieClip;
      
      private var partyBtn:MovieClip;
      
      private var actID:uint = 201304261;
      
      private var tempTimer:uint;
      
      private var bandPt:Point = new Point(348,193);
      
      private var partyPt:Point = new Point(488,477);
      
      private var gameState:uint;
      
      private var leftTime:uint;
      
      private var timer:uint;
      
      private var timeMc:MovieClip;
      
      private var momoMc:MovieClip;
      
      private var momoMovie:PlayMovie;
      
      private var position:int = -1;
      
      private var typeArr:Array = [1351513,1351511,1351512];
      
      private var npcMovie:PlayMovie;
      
      private var bgm:Sound;
      
      private var bgmChannel:SoundChannel;
      
      private var myAlert:*;
      
      private var candleMovie:PlayMovie;
      
      public function LovePartyActy()
      {
         super();
      }
      
      public static function get inst() : LovePartyActy
      {
         if(_inst == null)
         {
            _inst = new LovePartyActy();
         }
         return _inst;
      }
      
      public function init() : void
      {
         this.scene = new SceneActivityManager();
         this.addEvents();
      }
      
      private function addEvents() : void
      {
         BC.addEvent(this,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.onEnterMap);
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
         BC.addEvent(this,this.scene,SceneActivityManager.SCENE_ACTIVITY_BROADCAST,this.onBroadCast);
         BC.addEvent(this,this.scene,SceneActivityManager.SCENE_ACTIVITY_AWARD,this.getAward);
         GV.onlineSocket.addCmdListener(CommandID.LOVE_PARTY_NPC_INTER,this.npcInter);
         GV.onlineSocket.addCmdListener(CommandID.LOVE_PARTY_SPACE,this.onSpaceInter);
         BC.addEvent(this,GV.onlineSocket,"Love_Party_Pick_Prize",this.pickPrize);
         for(var i:uint = 1; i < 11; i++)
         {
            SystemEventManager.addEventListener("Seat",this.onEnterSeat);
         }
      }
      
      private function onEnterSeat(e:SystemEvent) : void
      {
         this._seatIndex = uint(e.data);
         if(!this.isWearing())
         {
            this.myAlert = Alert.smileAlart("請帶著背包裡的變身手表，如還未獲得,可邀請1名好友去奇可餐廳領取" + "需要現在前往麼？",function(e:Event):void
            {
               MapManager.enterMap(203);
            },AlertType.SURE + "," + AlertType.CANCEL);
            this.myAlert.addEventListener(Alert.CLICK_ + "2",this.choseCancleHandle);
         }
         else
         {
            this.setPosition(this._seatIndex);
         }
      }
      
      private function choseCancleHandle(e:*) : void
      {
         this.myAlert.addEventListener(Alert.CLICK_ + "2",this.choseCancleHandle);
         trace("站到" + this._seatIndex + "位置上");
         this.setPosition(this._seatIndex);
      }
      
      private function onSelfKeyDown(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.SCENE_ACTIVITY_SEND_RESULT,this.onSelfKeyDown);
         var bArr:ByteArray = e.data as ByteArray;
         var state:int = int(bArr.readUnsignedInt());
         var index:int = this.userArr.indexOf(LocalUserInfo.getUserID());
         if(state == 1)
         {
            if(index >= 0)
            {
               DisplayUtil.stopAllMovieClip(this.failMcArr[index]);
               this.failMcArr[index].visible = false;
               this.bandMcArr[index].visible = true;
               DisplayUtil.playAllMovieClip(this.bandMcArr[index]);
            }
         }
         else
         {
            DisplayUtil.playAllMovieClip(this.failMcArr[index]);
            this.failMcArr[index].visible = true;
            this.bandMcArr[index].visible = false;
            DisplayUtil.stopAllMovieClip(this.bandMcArr[index]);
         }
      }
      
      private function onSpaceInter(e:SocketEvent) : void
      {
         var userID:int = 0;
         var sucess:int = 0;
         var bArr:ByteArray = e.data as ByteArray;
         var spaceArr:Array = [];
         for(var i:int = 0; i < 3; i++)
         {
            userID = int(bArr.readUnsignedInt());
            sucess = int(bArr.readUnsignedInt());
            spaceArr.push({
               "userID":userID,
               "sucess":sucess
            });
            if(userID != 0)
            {
               if(sucess == 1)
               {
                  DisplayUtil.stopAllMovieClip(this.failMcArr[i]);
                  this.failMcArr[i].visible = false;
                  this.bandMcArr[i].visible = true;
                  DisplayUtil.playAllMovieClip(this.bandMcArr[i]);
               }
               else
               {
                  DisplayUtil.playAllMovieClip(this.failMcArr[i]);
                  this.failMcArr[i].visible = true;
                  this.bandMcArr[i].visible = false;
                  DisplayUtil.stopAllMovieClip(this.bandMcArr[i]);
               }
            }
            else
            {
               DisplayUtil.stopAllMovieClip(this.failMcArr[i]);
               DisplayUtil.stopAllMovieClip(this.bandMcArr[i]);
               this.failMcArr[i].visible = false;
               this.bandMcArr[i].visible = false;
            }
            if(userID == LocalUserInfo.getUserID())
            {
               this.lightMc.visible = false;
               this.spaceMc.visible = false;
            }
         }
      }
      
      private function pickPrize(e:Event) : void
      {
         var seat:MovieClip = null;
         BC.removeEvent(this,GV.onlineSocket,"Love_Party_Pick_Prize",this.pickPrize);
         if(Boolean(this.npcMovie))
         {
            this.npcMovie.destroy();
            this.npcMovie = null;
         }
         for each(seat in this.seatArr)
         {
            seat.gotoAndStop(1);
         }
         GV.MC_mapFrame["depth_mc"].silter.visible = true;
         GV.onlineSocket.addCmdListener(CommandID.LOVE_PARTY_PICK_PRIZE,this.getPrizeOver);
         GF.sendSocket(CommandID.LOVE_PARTY_PICK_PRIZE);
      }
      
      private function getPrizeOver(e:SocketEvent) : void
      {
         var itemID:int = 0;
         var cnt:int = 0;
         StatisticsManager.send(229);
         GV.onlineSocket.removeCmdListener(CommandID.LOVE_PARTY_PICK_PRIZE,this.getPrizeOver);
         var bArr:ByteArray = e.data as ByteArray;
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
         this.showTarPeople();
         MoveTo.CanMove = true;
      }
      
      private function npcInter(e:SocketEvent) : void
      {
         var bArr:ByteArray = e.data as ByteArray;
         var index:int = int(bArr.readUnsignedInt());
         GV.MC_mapFrame["depth_mc"].silter.visible = false;
         if(index == 3)
         {
            this.bgmChannel.stop();
            this.bgmChannel = null;
            this.npcMovie = PlayMovie.play("resource/movie/lpmovie" + (index - 1) + ".swf",null,null,this.playOver,null,LevelManager.mapLevel);
         }
         else
         {
            this.npcMovie = PlayMovie.play("resource/movie/lpmovie" + (index - 1) + ".swf",null,null,this.playOver2,null,LevelManager.mapLevel);
         }
      }
      
      private function playOver() : void
      {
         this.bgmChannel = this.bgm.play(0,999);
         this.npcMovie.movie_mc.stop();
      }
      
      private function playOver2() : void
      {
         this.npcMovie.movie_mc.stop();
      }
      
      private function partyClothPutOn(e:*) : void
      {
         var maskID:int = this.wearingMask();
         if(maskID > 0)
         {
            BC.addEvent(this,this.scene,SceneActivityManager.SCENE_ACTIVITY_SEAT,this.onPartySeated);
            this.scene.seat(4,2);
         }
         else
         {
            this.checkBag();
            PeopleManageView(GV.MAN_PEOPLE).moveTo(this.partyPt.x,this.partyPt.y);
         }
      }
      
      private function checkBag() : void
      {
         BC.addEvent(this,GV.onlineSocket,LookBagRes.BAG_OVER,this.lookBagOver);
         LookBagReq.send(LocalUserInfo.getUserID(),1,0);
      }
      
      private function lookBagOver(e:EventTaomee) : void
      {
         var count:int = 0;
         var i:int = 0;
         var bagObj:Object = e.EventObj.obj;
         if(bagObj.UserID == LocalUserInfo.getUserID())
         {
            BC.removeEvent(this,GV.onlineSocket,LookBagRes.BAG_OVER,this.lookBagOver);
            count = int(bagObj.Count);
            for(i = 0; i < count; i++)
            {
               if(bagObj.arr[i].id >= 14913 && bagObj.arr[i].id <= 14914)
               {
                  break;
               }
            }
            if(i == count)
            {
               Alert.smileAlart("    小摩爾，你可以去奇可餐廳找奇可，免費領取1個手表哦！",this.goMap2,"sure,cancel");
            }
         }
      }
      
      private function goMap2(e:*) : void
      {
         MapManager.enterMap(2);
      }
      
      private function wearingMask() : int
      {
         var obj:Object = null;
         var arr:Array = LocalUserInfo.getClothItem();
         for each(obj in arr)
         {
            if(obj.ItemID >= 14855 && obj.ItemID <= 14866)
            {
               return obj.ItemID;
            }
         }
         return 0;
      }
      
      private function onPartySeated(e:EventTaomee) : void
      {
         BC.removeEvent(this,this.scene,SceneActivityManager.SCENE_ACTIVITY_SEAT,this.onPartySeated);
         if(e.EventObj.state == 1)
         {
            if(e.EventObj.flag == 0)
            {
               PeopleManageView(GV.MAN_PEOPLE).moveTo(this.partyPt.x,this.partyPt.y);
            }
         }
         else
         {
            PeopleManageView(GV.MAN_PEOPLE).moveTo(this.partyPt.x,this.partyPt.y);
            Alert.smileAlart("    小摩爾，舞池裡已經站滿15人了！下一輪愛心舞會，我們不見不散哦！");
         }
      }
      
      private function leaveParty(e:MouseEvent) : void
      {
         BC.removeEvent(this,e.currentTarget,MouseEvent.CLICK,this.leaveParty);
         this.removeBg();
         PeopleManageView(GV.MAN_PEOPLE).moveTo(this.partyPt.x,this.partyPt.y);
         this.scene.seat(4,2,true);
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
         else
         {
            Alert.smileAlart("    小摩爾，再接再厲！要相信自己是有音樂天賦的！");
         }
         if(Boolean(this.bgmChannel))
         {
            this.bgmChannel.stop();
            this.bgmChannel = null;
         }
         GV.MC_mapFrame["depth_mc"].silter.visible = false;
         this.playCandleOver();
         if(this.position >= 4)
         {
            PeopleManageView(GV.MAN_PEOPLE).moveTo(495,486);
         }
      }
      
      private function playCandleOver() : void
      {
         this.bgmChannel = this.bgm.play(0,999);
         MoveTo.CanMove = true;
         this.showTarPeople();
      }
      
      private function addBg() : Sprite
      {
         var bg:Sprite = MainManager.getAppLevel().getChildByName("myBG") as Sprite;
         if(bg == null)
         {
            bg = LevelManager.drawBG(0,0);
            bg.name = "myBG";
            MainManager.getAppLevel().addChild(bg);
         }
         bg.buttonMode = false;
         BC.removeEvent(this,bg,MouseEvent.CLICK,this.leaveParty);
         return bg;
      }
      
      private function removeBg() : void
      {
         var bg:Sprite = MainManager.getAppLevel().getChildByName("myBG") as Sprite;
         DisplayUtil.removeForParent(bg);
      }
      
      private function onBroadCast(e:EventTaomee) : void
      {
         var m:uint = 0;
         var bArr:ByteArray = e.EventObj as ByteArray;
         var activityID:uint = bArr.readUnsignedInt();
         var tempGameState:int = int(this.gameState);
         this.gameState = bArr.readUnsignedInt();
         this.leftTime = bArr.readUnsignedInt();
         this.partyUserArr = [];
         this.choiceIDArr = [];
         for(var i:uint = 0; i < 10; i++)
         {
            this.partyUserArr.push(bArr.readUnsignedInt());
            this.choiceIDArr.push(bArr.readUnsignedInt());
         }
         if(this.gameState == 2)
         {
            this.hideTarPeople();
            for(m = 0; m < this.partyUserArr.length; m++)
            {
               if(this.partyUserArr[m] != 0)
               {
                  MovieClip(this.seatArr[m]).gotoAndStop(this.choiceIDArr[m] + 3);
                  setTimeout(this.showTarPeople,60000);
               }
            }
         }
         trace("partyUserArr" + this.partyUserArr);
         trace("choiceIDArr" + this.choiceIDArr);
         var index:int = this.partyUserArr.indexOf(LocalUserInfo.getUserID());
         if(index >= 0)
         {
            this.position = 1 + index;
         }
         if(this.position > 0 && this.gameState != 1 && tempGameState != 2)
         {
            MoveTo.CanMove = false;
         }
         else if(!(this.position >= 4 && this.gameState == 1))
         {
            MoveTo.CanMove = true;
            this.removeBg();
         }
         clearInterval(this.timer);
         if(tempGameState == 2 && this.gameState == 1)
         {
            this.initMc();
            MoveTo.CanMove = true;
         }
         this.tick();
         this.timer = setInterval(this.tick,1000);
         if(tempGameState == 1 && this.gameState == 3 && this.userArr.indexOf(LocalUserInfo.getUserID()) >= 0)
         {
            this.lightMc.visible = true;
            this.lightMc.play();
            MovieClipUtil.playEndAndFunc(this.lightMc,this.lightMcPlayEnd);
         }
         this.checkParty();
      }
      
      private function onEnterMap(e:EventTaomee) : void
      {
         GameframeLogic.stopMousicHandler();
         var cls:Class = GV.Lib_Map.getClass("Res_Party_BGM");
         this.bgm = new cls();
         this.bgmChannel = this.bgm.play(0,999);
         this.scene.enterMap(this.actID);
         this.initMc();
      }
      
      private function setPosition(pos:int) : void
      {
         if(LocalUserInfo.roleType == 0)
         {
            if(this.partyUserArr[pos - 1] == 0)
            {
               this.position = pos;
               if(this.gameState == 1)
               {
                  this.checkCloth();
               }
               else
               {
                  Alert.smileAlart("    本輪舞會正在進行中，下一輪的愛心舞會，我們不見不散！");
                  PeopleManageView(GV.MAN_PEOPLE).moveTo(495,471);
               }
            }
            else
            {
               PeopleManageView(GV.MAN_PEOPLE).moveTo(495,471);
            }
         }
         else
         {
            Alert.smileAlart("    你要先變回摩爾才能參加舞會喲！");
            PeopleManageView(GV.MAN_PEOPLE).moveTo(this.bandPt.x,this.bandPt.y);
         }
      }
      
      private function checkCloth() : void
      {
         BC.addEvent(this,this.scene,SceneActivityManager.SCENE_ACTIVITY_SEAT,this.onBandSeated);
         this.scene.seat(this.position,1);
      }
      
      private function isWearing() : Boolean
      {
         var obj:Object = null;
         var arr:Array = LocalUserInfo.getClothItem();
         var w0:Boolean = false;
         var w1:Boolean = false;
         for each(obj in arr)
         {
            if(obj.ItemID == 14913)
            {
               w0 = true;
            }
            if(obj.ItemID == 14914)
            {
               w1 = true;
            }
         }
         if(w0 || w1)
         {
            return true;
         }
         return false;
      }
      
      private function putOnCloth(e:*) : void
      {
         MapManager.enterMap(203);
      }
      
      private function onBandSeated(e:EventTaomee) : void
      {
         BC.removeEvent(this,this.scene,SceneActivityManager.SCENE_ACTIVITY_SEAT,this.onBandSeated);
         if(e.EventObj.state == 1)
         {
            if(e.EventObj.flag == 1)
            {
               if(this.gameState == 1)
               {
                  BC.addEvent(this,this.scene,SceneActivityManager.SCENE_ACTIVITY_SEAT,this.onBandSeated);
                  BC.addEvent(this,MainManager.getStage(),MouseEvent.CLICK,this.leaveBandSeat);
               }
            }
            else if(e.EventObj.flag == 0)
            {
               this.position = -1;
               MoveTo.CanMove = true;
            }
         }
      }
      
      private function leaveBandSeat(e:MouseEvent) : void
      {
         BC.removeEvent(this,MainManager.getStage(),MouseEvent.CLICK,this.leaveBandSeat);
         this.scene.seat(this.position,1,true);
      }
      
      private function goJLGL(e:*) : void
      {
         ModuleManager.openPanel("GabbleConcertPanel");
      }
      
      private function initMc() : void
      {
         var seat:MovieClip = null;
         this.timeMc = GV.MC_mapFrame["control_mc"].time_mc;
         this.momoMc = GV.MC_mapFrame["control_mc"].momo_mc;
         this.lightMc = GV.MC_mapFrame["buttonLevel"].lightMc;
         this.spaceMc = GV.MC_mapFrame["buttonLevel"].spaceMc;
         this.partyBtn = GV.MC_mapFrame["depth_mc"].partyBtn;
         this.momoMc.visible = false;
         this.lightMc.visible = false;
         this.spaceMc.visible = false;
         this.moleMcArr = [];
         this.bandBtnArr = [];
         this.bandMcArr = [];
         this.failMcArr = [];
         for(var i:int = 0; i < 3; i++)
         {
            this.moleMcArr.push(GV.MC_mapFrame["depth_mc"]["mole" + i]);
            this.bandBtnArr.push(GV.MC_mapFrame["depth_mc"]["bandBtn" + i]);
            this.bandMcArr.push(GV.MC_mapFrame["depth_mc"]["bandMc" + i]);
            this.failMcArr.push(GV.MC_mapFrame["depth_mc"]["failMc" + i]);
            DisplayUtil.stopAllMovieClip(this.bandMcArr[i]);
            DisplayUtil.stopAllMovieClip(this.moleMcArr[i]);
            DisplayUtil.stopAllMovieClip(this.failMcArr[i]);
            this.bandMcArr[i].visible = false;
            this.moleMcArr[i].visible = false;
            this.failMcArr[i].visible = false;
         }
         this.seatArr = [];
         for(var j:uint = 1; j < 11; j++)
         {
            seat = GV.MC_mapFrame["control_mc"]["seat_" + j];
            this.seatArr.push(seat);
         }
      }
      
      private function tick() : void
      {
         if(this.gameState == 1)
         {
            this.momoMc.visible = false;
            this.timeMc.visible = true;
            new NumSprite(this.timeMc.min,int(this.leftTime / 60));
            new NumSprite(this.timeMc.sec,this.leftTime % 60);
         }
         else
         {
            this.timeMc.visible = false;
            this.momoMc.visible = true;
         }
         if(this.leftTime > 0)
         {
            --this.leftTime;
            this.setBandMc();
         }
      }
      
      private function checkParty() : void
      {
         var waitMc:MovieClip = null;
         var user:PeopleManageView = null;
         var id:int = 0;
         var onlineList:Array = null;
         var obj:Object = null;
         for each(id in this.partyUserArr)
         {
            user = PeopleManageView(GF.getPeopleByID(id));
            if(Boolean(user))
            {
               waitMc = user.getChildByName("waitingMc") as MovieClip;
               if(this.gameState == 1)
               {
                  if(waitMc == null)
                  {
                     waitMc = GV.Lib_Map.getMovieClip("Res_Wating_Mc") as MovieClip;
                     if(Boolean(waitMc))
                     {
                        waitMc.name = "waitingMc";
                        waitMc.y = -75;
                        user.addChild(waitMc);
                     }
                  }
               }
               else
               {
                  DisplayUtil.removeForParent(waitMc);
                  if(id == LocalUserInfo.getUserID())
                  {
                     if(Boolean(GV.MAN_PEOPLE.dance()))
                     {
                        ActionReq.actions1(1,0);
                     }
                  }
               }
            }
         }
         onlineList = PeopleCountLogic.getAllPeopleList();
         for each(obj in onlineList)
         {
            if(this.partyUserArr.indexOf(obj.ID) == -1)
            {
               user = PeopleManageView(GF.getPeopleByID(obj.ID));
               if(Boolean(user))
               {
                  waitMc = user.getChildByName("waitingMc") as MovieClip;
                  if(waitMc != null)
                  {
                     DisplayUtil.removeForParent(waitMc);
                  }
               }
            }
         }
      }
      
      private function lightMcPlayEnd() : void
      {
         this.lightMc.stop();
         this.spaceMc.visible = true;
         this.spaceMc.play();
         BC.addEvent(this,MainManager.getStage(),KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onKeyDown(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.SPACE)
         {
            BC.removeEvent(this,MainManager.getStage(),KeyboardEvent.KEY_DOWN,this.onKeyDown);
            this.lightMc.visible = false;
            this.spaceMc.visible = false;
            GV.onlineSocket.addCmdListener(CommandID.SCENE_ACTIVITY_SEND_RESULT,this.onSelfKeyDown);
            GF.sendSocket(CommandID.SCENE_ACTIVITY_SEND_RESULT);
         }
      }
      
      private function setBandMc() : void
      {
         var i:int = 0;
         if(this.gameState == 1)
         {
            for(i = 0; i < 3; i++)
            {
               this.bandMcArr[i].visible = false;
               this.bandBtnArr[i].visible = true;
               this.moleMcArr[i].visible = false;
               DisplayUtil.stopAllMovieClip(this.moleMcArr[i]);
            }
         }
         else
         {
            for(i = 0; i < 3; i++)
            {
               this.moleMcArr[i].visible = false;
            }
         }
      }
      
      private function hideTarPeople() : void
      {
         var obj:Object = null;
         var onlineUser:Array = PeopleCountLogic.getAllPeopleList();
         for each(obj in onlineUser)
         {
            if(this.partyUserArr.indexOf(obj.ID) >= 0)
            {
               PeopleManageView(obj.Instance).visible = false;
            }
            else
            {
               PeopleManageView(obj.Instance).visible = true;
            }
         }
      }
      
      private function showTarPeople() : void
      {
         var obj:Object = null;
         var onlineUser:Array = PeopleCountLogic.getAllPeopleList();
         for each(obj in onlineUser)
         {
            PeopleManageView(obj.Instance).visible = true;
            MoveTo.CanMove = true;
         }
      }
      
      private function onLeaveMap(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         var waitMc:MovieClip = null;
         for(var i:uint = 1; i < 11; i++)
         {
            SystemEventManager.removeEventListener("Seat",this.onEnterSeat);
         }
         BC.removeEvent(this);
         this.removeBg();
         this.scene.destroy();
         this.scene = null;
         this.moleMcArr = null;
         this.bandBtnArr = null;
         var user:PeopleManageView = PeopleManageView(GF.getPeopleByID(LocalUserInfo.getUserID()));
         if(Boolean(user))
         {
            waitMc = user.getChildByName("waitingMc") as MovieClip;
            DisplayUtil.removeForParent(waitMc);
         }
         clearTimeout(this.tempTimer);
         clearInterval(this.timer);
         this.timeMc = null;
         this.momoMc = null;
         this.bgmChannel.stop();
         this.bgmChannel = null;
         if(Boolean(this.momoMovie))
         {
            this.momoMovie.destroy();
            this.momoMovie = null;
         }
         if(Boolean(this.candleMovie))
         {
            this.candleMovie.destroy();
            this.candleMovie = null;
         }
      }
   }
}

