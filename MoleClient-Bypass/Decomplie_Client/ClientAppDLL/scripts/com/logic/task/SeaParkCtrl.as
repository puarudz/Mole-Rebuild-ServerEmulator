package com.logic.task
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.data.HashMap;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.summerAct.SummerSocket;
   import com.logic.socket.throwItem.ThrowItemReq;
   import com.module.popupMsg.PopupMsgCtl;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.ui.LoadingPanel;
   import com.mole.app.utils.AnimaLite;
   import com.mole.app.utils.PlayMovie;
   import com.mole.app.utils.Tool;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   public class SeaParkCtrl
   {
      
      private static var _instance:SeaParkCtrl;
      
      private var _spoutInterval:int = 10;
      
      private var _spoutMapArr:Array = [256,257];
      
      private var _sTime:Timer;
      
      private var _surgeMapID:int = 257;
      
      private var _surTimer:Timer;
      
      private var _crabRect:Rectangle = new Rectangle(486,325,517,211);
      
      private var _surPrizeArr:Array = [];
      
      private var _surPrizeNum:int = 6;
      
      private var _surRandArr:Array = [190960,190961,190962];
      
      private var _surTypeHm:HashMap;
      
      private var _bucketMapID:int = 256;
      
      private var _fullNum:int = 200;
      
      private var _mc_bar:MovieClip;
      
      private var _bucketArea:MovieClip;
      
      private var _prizeArr:Array = [];
      
      private var _whalePt:Point = new Point(434,100);
      
      private var _barPt:Point = new Point(595,508);
      
      private var _movie:PlayMovie;
      
      private var _surPanel:MovieClip;
      
      private var _open:Boolean = false;
      
      private var _num0:int = 0;
      
      private var _num1:int = 0;
      
      private var _num2:int = 0;
      
      private var _surgeMovie:PlayMovie;
      
      public function SeaParkCtrl()
      {
         super();
      }
      
      public static function get inst() : SeaParkCtrl
      {
         if(_instance == null)
         {
            _instance = new SeaParkCtrl();
         }
         return _instance;
      }
      
      public function initSpout() : void
      {
         var i:int = 0;
         var len:int = int(this._spoutMapArr.length);
         for(i = 0; i < len; i++)
         {
            if(LocalUserInfo.getMapID() == this._spoutMapArr[i])
            {
               this.startSTimer();
               break;
            }
         }
      }
      
      private function startSTimer() : void
      {
         this.stopSTimer();
         this._sTime = new Timer(1000);
         BC.addEvent(this,this._sTime,TimerEvent.TIMER,this.sTick,false,0,true);
         this._sTime.start();
      }
      
      private function stopSTimer() : void
      {
         if(this._sTime != null)
         {
            this._sTime.stop();
            BC.removeEvent(this,this._sTime,TimerEvent.TIMER,this.sTick);
            this._sTime = null;
         }
      }
      
      private function sTick(e:TimerEvent) : void
      {
         var rand:int = 0;
         var dateNow:Date = ServerUpTime.getInstance().date;
         if(dateNow.seconds % this._spoutInterval == 0)
         {
            rand = Math.random() * 3;
            GV.MC_mapFrame["depth_mc"]["fountain" + rand].play();
            this.spoutPeople(rand);
         }
      }
      
      private function spoutPeople(rand:int) : void
      {
         var user:PeopleManageView = null;
         var tFunc:Function = null;
         user = GV.MAN_PEOPLE;
         var depth_mc:MovieClip = GV.MC_mapFrame["depth_mc"];
         var rect:Rectangle = new Rectangle(depth_mc["fountain" + rand].x - 50,depth_mc["fountain" + rand].y - 25,100,50);
         if(rect.contains(user.x,user.y) && user.visible)
         {
            tFunc = function(userMc:PeopleManageView):void
            {
               var ran:int = Math.random() * 10;
               if(ran <= 3)
               {
                  loadSpoutGame();
               }
               MoveTo.CanMove = true;
               TweenLite.to(user.avatarMC,1,{"y":user.avatarMC.y + 80});
            };
            MoveTo.CanMove = false;
            if(user.avatarMC != null)
            {
               TweenLite.to(user.avatarMC,1,{"y":user.avatarMC.y - 80});
               TweenLite.to(user,3.5,{
                  "onComplete":tFunc,
                  "onCompleteParams":[user]
               });
            }
         }
      }
      
      private function loadSpoutGame() : void
      {
         BC.addEvent(this,GV.onlineSocket,"lamuJumpGameOver",this.gameOverFun);
         var resID:int = int(DownLoadManager.add("module/game/SpoutGame.swf",ResType.DISPLAY_OBJECT));
         DownLoadManager.addEvent(resID,this.loadGameOver);
      }
      
      private function loadGameOver(e:DownLoadEvent) : void
      {
         GameframeLogic.stopMousicHandler();
         MapManager.clearMap();
         MainManager.getAppLevel().addChild(e.data);
      }
      
      private function gameOverFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"lamuJumpGameOver",this.gameOverFun);
         GameframeLogic.playMousicHandler();
      }
      
      public function initSurge() : void
      {
         if(LocalUserInfo.getMapID() == this._surgeMapID)
         {
            this._open = false;
            SystemEventManager.addEventListener("exePrize",this.exePrize,false,0,true);
            SystemEventManager.addEventListener("openCircleGame",this.openCircleGame,false,0,true);
            this._surTypeHm = new HashMap();
            this._surTypeHm.add(190960,1601);
            this._surTypeHm.add(190961,1602);
            this._surTypeHm.add(190962,1603);
            this.startSurTimer();
            this.addSurgePanel();
         }
      }
      
      private function openCircleGame(e:*) : void
      {
         Alert.smileAlart("    街邊套圈圈需要10枚遊戲代幣，是否繼續玩？",this.enterCircleGame,"sure,cancel");
      }
      
      private function enterCircleGame(e:*) : void
      {
         OnlineManager.addErrorListener(1243,this.enterCircleError);
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.enterCircleGameOver,false,0,true);
         exchange.exchange_goods(1598);
      }
      
      private function enterCircleError(e:SocketEvent) : void
      {
         if(e.cmdID == 1243)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.enterCircleGameOver);
            OnlineManager.removeErrorListener(1243,this.enterCircleError);
         }
      }
      
      private function enterCircleGameOver(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.enterCircleGameOver);
         var resID:int = int(DownLoadManager.add("module/external/tou.swf",ResType.DISPLAY_OBJECT));
         LoadingPanel.addRes(resID);
         DownLoadManager.addEvent(resID,this.addTou);
      }
      
      private function addTou(e:DownLoadEvent) : void
      {
         MapManager.clearMap();
         MainManager.getAppLevel().addChild(e.data);
      }
      
      private function realExe() : void
      {
         BC.addEvent(this,GV.onlineSocket,SummerSocket.SURGE_EXE,this.exePrizeOver,false,0,true);
         SummerSocket.surgeExe();
      }
      
      private function exePrize(e:*) : void
      {
         if(this._num0 >= 3 && this._num1 >= 3 && this._num2 >= 3)
         {
            GV.MC_mapFrame["depth_mc"].btn_snail.gotoAndStop(2);
            TweenLite.to(this,5,{"onComplete":this.realExe});
         }
      }
      
      private function exePrizeOver(e:EventTaomee) : void
      {
         var count:int = 0;
         var itemID:int = 0;
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exePrizeOver);
         if(e.EventObj.state == 1)
         {
            count = int(e.EventObj.count);
            itemID = int(e.EventObj.itemID);
            msg = "    恭喜你獲得" + count + "個" + GoodsInfo.getItemNameByID(itemID) + ",已放入你的" + GoodsInfo.getItemCollectionBoxNameByID(itemID) + "中!";
            Alert.smileAlart(msg);
            this._num0 -= 3;
            this._num1 -= 3;
            this._num2 -= 3;
            this.initSurgePanelUI();
         }
      }
      
      private function addSurgePanel() : void
      {
         var resID:int = int(DownLoadManager.add("resource/task/seaPark/surfPanel.swf",ResType.DISPLAY_OBJECT));
         DownLoadManager.addEvent(resID,this.loadSurgePanelOver);
      }
      
      private function loadSurgePanelOver(e:DownLoadEvent) : void
      {
         this._surPanel = (e.data as MovieClip).getChildAt(0) as MovieClip;
         MainManager.getAppLevel().addChild(this._surPanel);
         BC.addEvent(this,this._surPanel.btn,MouseEvent.CLICK,this.clickBtn,false,0,true);
         this.getNum();
      }
      
      private function getNum() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkOver);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190960,2,190963);
      }
      
      private function checkOver(e:EventTaomee) : void
      {
         this._num0 = 0;
         this._num1 = 0;
         this._num2 = 0;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkOver);
         var arr:Array = e.EventObj.obj.arr;
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i].id == 190960)
            {
               this._num0 = arr[i].Count;
            }
            else if(arr[i].id == 190961)
            {
               this._num1 = arr[i].Count;
            }
            else if(arr[i].id == 190962)
            {
               this._num2 = arr[i].Count;
            }
         }
         this.initSurgePanelUI();
      }
      
      private function initSurgePanelUI() : void
      {
         this._surPanel.num0.num0.gotoAndStop(int(this._num0 / 10) + 1);
         this._surPanel.num0.num1.gotoAndStop(int(this._num0 % 10) + 1);
         this._surPanel.num1.num0.gotoAndStop(int(this._num1 / 10) + 1);
         this._surPanel.num1.num1.gotoAndStop(int(this._num1 % 10) + 1);
         this._surPanel.num2.num0.gotoAndStop(int(this._num2 / 10) + 1);
         this._surPanel.num2.num1.gotoAndStop(int(this._num2 % 10) + 1);
         if(int(this._num0 / 10) == 0)
         {
            this._surPanel.num0.num0.visible = false;
         }
         else
         {
            this._surPanel.num0.num0.visible = true;
         }
         if(int(this._num1 / 10) == 0)
         {
            this._surPanel.num1.num0.visible = false;
         }
         else
         {
            this._surPanel.num1.num0.visible = true;
         }
         if(int(this._num2 / 10) == 0)
         {
            this._surPanel.num2.num0.visible = false;
         }
         else
         {
            this._surPanel.num2.num0.visible = true;
         }
      }
      
      private function clickBtn(e:MouseEvent) : void
      {
         BC.removeEvent(this,this._surPanel.btn,MouseEvent.CLICK,this.clickBtn);
         if(!this._open)
         {
            this._open = true;
            TweenLite.to(this._surPanel,0.5,{
               "x":this._surPanel.x - 100,
               "onComplete":this.moveOver
            });
         }
         else
         {
            this._open = false;
            TweenLite.to(this._surPanel,0.5,{
               "x":this._surPanel.x + 100,
               "onComplete":this.moveOver
            });
         }
      }
      
      private function moveOver() : void
      {
         BC.addEvent(this,this._surPanel.btn,MouseEvent.CLICK,this.clickBtn,false,0,true);
      }
      
      private function startSurTimer() : void
      {
         this.stopSurTimer();
         this._surTimer = new Timer(1000);
         BC.addEvent(this,this._surTimer,TimerEvent.TIMER,this.surTick,false,0,true);
         this._surTimer.start();
      }
      
      private function stopSurTimer() : void
      {
         if(this._surTimer != null)
         {
            this._surTimer.stop();
            BC.removeEvent(this,this._surTimer,TimerEvent.TIMER,this.surTick);
            this._surTimer = null;
         }
      }
      
      private function surTick(e:TimerEvent) : void
      {
         var dateNow:Date = ServerUpTime.getInstance().date;
         var hours:int = ServerUpTime.getInstance().getMoleHours;
         var min:int = dateNow.minutes;
         if(dateNow.day == 5 || dateNow.day == 6 || dateNow.day == 0)
         {
            if(hours == 13 && min >= 30 && min % 5 == 0 && dateNow.seconds <= 5 || hours == 18 && min >= 30 && min % 5 == 0 && dateNow.seconds <= 5)
            {
               this.surgeCome();
            }
         }
      }
      
      private function surgeCome() : void
      {
         if(this._surgeMovie == null)
         {
            this._surgeMovie = PlayMovie.play("resource/task/seaPark/surge.swf",this.loadSurgeOver,null,this.playSurgeOver,null,LevelManager.mapLevel,false);
         }
      }
      
      private function playSurgeOver() : void
      {
         this._surgeMovie.destroy();
         this._surgeMovie = null;
      }
      
      private function loadSurgeOver() : void
      {
         TweenLite.to(this,3,{"onComplete":this.addPrize});
      }
      
      private function change() : void
      {
         var user:PeopleManageView = GV.MAN_PEOPLE;
         if(this._crabRect.contains(user.x,user.y))
         {
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exeOver,false,0,true);
            exchange.exchange_goods(1605);
         }
      }
      
      private function addPrize() : void
      {
         var o:Object = null;
         var i:int = 0;
         var itemID:int = 0;
         var ldr:Loader = null;
         var re:URLRequest = null;
         var s:Sprite = null;
         this.change();
         for each(o in this._surPrizeArr)
         {
            DisplayUtil.removeForParent(o.icon);
         }
         this._surPrizeArr = [];
         for(i = 0; i < this._surPrizeNum; i++)
         {
            itemID = int(this._surRandArr[int(Math.random() * 3)]);
            ldr = new Loader();
            re = VL.getURLRequest(GoodsInfo.GetFullURLByItemId(itemID));
            ldr.load(re);
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,new Function(),false,0,true);
            s = new Sprite();
            s.buttonMode = true;
            s.addChild(ldr);
            LevelManager.mapLevel.addChildAt(s,LevelManager.mapLevel.numChildren - 2);
            s.x = this._crabRect.x + (this._crabRect.width - 100) * Math.random();
            s.y = this._crabRect.y + (this._crabRect.height - 100) * Math.random();
            BC.addEvent(this,s,MouseEvent.CLICK,this.clickSurPrize,false,0,true);
            this._surPrizeArr.push({
               "icon":s,
               "itemID":itemID
            });
         }
      }
      
      private function clickSurPrize(e:MouseEvent) : void
      {
         var len:int;
         var i:int;
         var tFunc:Function = null;
         BC.removeEvent(this,e.currentTarget,MouseEvent.CLICK,this.clickSurPrize);
         len = int(this._surPrizeArr.length);
         for(i = 0; i < len; i++)
         {
            if(e.currentTarget == this._surPrizeArr[i].icon)
            {
               tFunc = function(s:Sprite):void
               {
                  var tFunc2:Function = function():void
                  {
                     DisplayUtil.removeForParent(s);
                  };
                  AnimaLite.FadeOut(s,0.5,tFunc2);
               };
               MainManager.getAppLevel().addChild(this._surPrizeArr[i].icon);
               TweenLite.to(this._surPrizeArr[i].icon,1,{
                  "x":this._barPt.x,
                  "y":this._barPt.y,
                  "onComplete":tFunc,
                  "onCompleteParams":[this._surPrizeArr[i].icon]
               });
               PopupMsgCtl.PopupMsg("要發發！要發發！恭喜你獲得了" + GoodsInfo.getItemNameByID(this._surPrizeArr[i].itemID),3000);
               exchange.exchange_goods(this._surTypeHm.getValue(this._surPrizeArr[i].itemID));
               if(this._surPrizeArr[i].itemID == 190960)
               {
                  ++this._num0;
               }
               else if(this._surPrizeArr[i].itemID == 190961)
               {
                  ++this._num1;
               }
               else if(this._surPrizeArr[i].itemID == 190962)
               {
                  ++this._num2;
               }
               this.initSurgePanelUI();
               this._surPrizeArr.splice(i,1);
               break;
            }
         }
      }
      
      private function exeOver(e:EventTaomee) : void
      {
         if(e.EventObj.type == 1605)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exeOver);
            new ThrowItemReq().throwEffectItem(17033,LocalUserInfo.getUserID());
         }
      }
      
      public function initBucket() : void
      {
         var obj:Object = null;
         SystemEventManager.addEventListener("goSurf",this.goSurf);
         var dateNow:Date = ServerUpTime.getInstance().date;
         if(LocalUserInfo.getMapID() == this._bucketMapID && (dateNow.hours == 13 || dateNow.hours == 18) && (dateNow.day == 5 || dateNow.day == 6 || dateNow.day == 0))
         {
            this._mc_bar = GV.MC_mapFrame["top_mc"].mc_bar;
            this._mc_bar.txt.text = "0/" + this._fullNum;
            this._bucketArea = GV.MC_mapFrame["top_mc"].bucketArea;
            BC.addEvent(this,GV.onlineSocket,SummerSocket.GET_WOOD_STATE,this.getWoodState,false,0,true);
            BC.addEvent(this,GV.onlineSocket,SummerSocket.THROW_WATER,this.throwWatherOver,false,0,true);
            BC.addEvent(this,GV.onlineSocket,SummerSocket.THROW_OVER,this.throwOver,false,0,true);
            BC.addEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FLOWER,this.hitOver,false,0,true);
            obj = {
               "btn":this._bucketArea,
               "mc":new MovieClip(),
               "id":"swf150001",
               "fre":1,
               "hide":true
            };
            throwHitTest.HitTestMC(obj);
         }
      }
      
      private function goSurf(e:*) : void
      {
         SystemEventManager.removeEventListener("goSurf",this.goSurf);
         GV.MAN_PEOPLE.visible = false;
         if(this._movie == null)
         {
            this._movie = PlayMovie.play("resource/task/seaPark/movie" + int(Math.random() * 2) + ".swf",null,null,this.playSlideOver,null,LevelManager.mapLevel);
         }
      }
      
      private function playSlideOver() : void
      {
         GV.MAN_PEOPLE.visible = true;
         GV.MAN_PEOPLE.x = 580;
         GV.MAN_PEOPLE.y = 466;
         this._movie.destroy();
         this._movie = null;
         SystemEventManager.addEventListener("goSurf",this.goSurf);
         var rand:int = Math.random() * 10;
         if(rand == 0)
         {
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exeSlideOver,false,0,true);
            exchange.exchange_goods(1597);
         }
      }
      
      private function exeSlideOver(e:EventTaomee) : void
      {
         if(e.EventObj.type == 1597)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exeSlideOver);
            Alert.smileAlart("    腳底一滑，發現身邊有2枚海底樂園遊戲幣。今天真是幸運！！");
         }
      }
      
      private function hitOver(e:EventTaomee) : void
      {
         if(e.EventObj.mc.userID == LocalUserInfo.getUserID() && e.EventObj.mc.ThrowID == 150001)
         {
            SummerSocket.throwWater();
         }
      }
      
      private function getWoodState(e:EventTaomee) : void
      {
         var state:int = int(e.EventObj.state);
         this._mc_bar.txt.text = state + "/" + this._fullNum;
         this._mc_bar.gotoAndStop(int(this._mc_bar.totalFrames * state / this._fullNum));
         var mc:MovieClip = GV.MC_mapFrame["top_mc"].mc_whale.getChildAt(0);
         mc.gotoAndStop(int(mc.totalFrames * state / this._fullNum));
      }
      
      private function throwWatherOver(e:EventTaomee) : void
      {
         var state:int = int(e.EventObj.state);
         this._mc_bar.txt.text = state + "/" + this._fullNum;
         this._mc_bar.gotoAndStop(int(this._mc_bar.totalFrames * state / this._fullNum));
         var mc:MovieClip = GV.MC_mapFrame["top_mc"].mc_whale.getChildAt(0);
         mc.gotoAndStop(int(mc.totalFrames * state / this._fullNum));
      }
      
      private function throwOver(e:EventTaomee) : void
      {
         var o:Object = null;
         var arr:Array = null;
         var len:int = 0;
         var i:int = 0;
         var itemID:int = 0;
         var count:int = 0;
         var j:int = 0;
         var ldr:Loader = null;
         var re:URLRequest = null;
         var s:Sprite = null;
         for each(o in this._prizeArr)
         {
            DisplayUtil.removeForParent(o.icon);
         }
         this._prizeArr = [];
         GV.MC_mapFrame["top_mc"].mc_whale.gotoAndStop(2);
         arr = e.EventObj.arr;
         len = int(arr.length);
         for(i = 0; i < len; i++)
         {
            itemID = int(arr[i].itemID);
            count = int(arr[i].count);
            for(j = 0; j < count; j++)
            {
               ldr = new Loader();
               re = VL.getURLRequest(GoodsInfo.GetFullURLByItemId(itemID));
               ldr.load(re);
               ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadIconOver,false,0,true);
               s = new Sprite();
               this._prizeArr.push({
                  "icon":s,
                  "itemID":itemID
               });
               s.buttonMode = true;
               s.addChild(ldr);
               MainManager.getAppLevel().addChildAt(s,0);
               s.x = this._whalePt.x;
               s.y = this._whalePt.y;
               BC.addEvent(this,s,MouseEvent.CLICK,this.clickPrize,false,0,true);
            }
         }
      }
      
      private function clickPrize(e:MouseEvent) : void
      {
         var len:int;
         var i:int;
         var tFunc:Function = null;
         BC.removeEvent(this,e.currentTarget,MouseEvent.CLICK,this.clickPrize);
         len = int(this._prizeArr.length);
         for(i = 0; i < len; i++)
         {
            if(e.currentTarget == this._prizeArr[i].icon)
            {
               tFunc = function(s:Sprite):void
               {
                  var tFunc2:Function = function():void
                  {
                     DisplayUtil.removeForParent(s);
                  };
                  AnimaLite.FadeOut(s,0.5,tFunc2);
               };
               TweenLite.to(this._prizeArr[i].icon,1,{
                  "x":this._barPt.x,
                  "y":this._barPt.y,
                  "onComplete":tFunc,
                  "onCompleteParams":[this._prizeArr[i].icon]
               });
               PopupMsgCtl.PopupMsg("要發發！要發發！恭喜你獲得了" + GoodsInfo.getItemNameByID(this._prizeArr[i].itemID),3000);
               SummerSocket.pickUp(this._prizeArr[i].itemID);
               this._prizeArr.splice(i,1);
               break;
            }
         }
      }
      
      private function loadIconOver(e:Event) : void
      {
         var ldrInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         ldrInfo.removeEventListener(Event.COMPLETE,this.loadIconOver);
         var s:Sprite = ldrInfo.loader.parent as Sprite;
         var endPt:Point = new Point();
         var rand:int = Math.random() * 2;
         if(rand == 0)
         {
            endPt.x = this._whalePt.x - 100 - 100 * Math.random();
         }
         else
         {
            endPt.x = this._whalePt.x + 100 + 100 * Math.random();
         }
         endPt.y = this._whalePt.y + 200 + 100 * Math.random();
         var pt1:Point = new Point(this._whalePt.x + (endPt.x - this._whalePt.x) / 3,this._whalePt.y - 100);
         Tool.prizeCome(s,this._whalePt,pt1,endPt);
      }
      
      public function openSeaParkExePanel() : void
      {
         var resID:int = int(DownLoadManager.add("module/external/SeaParkExePanel.swf",ResType.DISPLAY_OBJECT));
         LoadingPanel.addRes(resID);
         DownLoadManager.addEvent(resID,this.loadExeOver);
      }
      
      private function loadExeOver(e:DownLoadEvent) : void
      {
         MainManager.getAppLevel().addChild(e.data);
      }
      
      public function destroy() : void
      {
         SystemEventManager.removeEventListener("exePrize",this.exePrize);
         SystemEventManager.removeEventListener("openCircleGame",this.openCircleGame);
         SystemEventManager.removeEventListener("goSurf",this.goSurf);
         BC.removeEvent(this);
         TweenLite.killTweensOf(this);
         this.stopSTimer();
         this.stopSurTimer();
         _instance = null;
      }
   }
}

