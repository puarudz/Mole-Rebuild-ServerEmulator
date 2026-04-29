package com.logic.task
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.ice.IceBabyAddBaseAttributeProtocol;
   import com.logic.socket.summerAct.SummerSocket;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.debug.DebugManager;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class IceBabyCtrl
   {
      
      private static var _instance:IceBabyCtrl;
      
      private var _curBath:int = -1;
      
      private var _ptArr:Array = [new Point(671,388),new Point(50,250),new Point(895,244),new Point(232,370),new Point(467,424)];
      
      private var _bathArr:Array;
      
      private var _movie:PlayMovie;
      
      private var _goBathStartTime:int;
      
      private var _userEffect:MovieClip;
      
      private var _leavePtArr:Array = [new Point(379,239),new Point(379,239),new Point(554,225)];
      
      private var _curSeat:int = -1;
      
      private var _winMovie:PlayMovie;
      
      private var _bathMap:int = 259;
      
      private var _seatArr:Array = [0,0,0];
      
      private var _lotteryMovie:PlayMovie;
      
      private var _prizeMap:int = 259;
      
      private var _pool:int;
      
      private var _itemID:int;
      
      private var _itemCnt:int;
      
      public function IceBabyCtrl()
      {
         super();
      }
      
      public static function get inst() : IceBabyCtrl
      {
         if(_instance == null)
         {
            _instance = new IceBabyCtrl();
         }
         return _instance;
      }
      
      public function initBath() : void
      {
         var i:int = 0;
         if(LocalUserInfo.getMapID() == this._bathMap)
         {
            this._goBathStartTime = 0;
            this._curSeat = -1;
            this._curBath = -1;
            BC.addEvent(this,GV.onlineSocket,SummerSocket.GET_BATH_INFO,this.getBathInfoOver,false,0,true);
            SummerSocket.getBathInfo();
            BC.addEvent(this,GV.onlineSocket,SummerSocket.ADD_GLAMOUR,this.addGlamour,false,0,true);
            this.addBathBtnEvents();
            BC.addEvent(this,GV.MC_mapFrame["control_mc"].interBtn4,MouseEvent.CLICK,this.clickInter4,false,0,true);
            BC.addEvent(this,GV.MC_mapFrame["control_mc"].interBtn5,MouseEvent.CLICK,this.clickInter5,false,0,true);
            BC.addEvent(this,GV.MC_mapFrame["control_mc"].interBtn6,MouseEvent.CLICK,this.clickInter6,false,0,true);
            for(i = 0; i < 3; i++)
            {
               BC.addEvent(this,GV.MC_mapFrame["control_mc"]["seat" + i],MouseEvent.CLICK,this.clickSeat,false,0,true);
            }
            for(i = 0; i < 3; i++)
            {
               BC.addEvent(this,GV.MC_mapFrame["control_mc"]["interBtn" + i],MouseEvent.CLICK,this.clickInter,false,0,true);
            }
            BC.addEvent(this,GV.onlineSocket,SummerSocket.THROW_EGG_FLOWER,this.throwEggFlower,false,0,true);
            BC.addEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FLOWER,this.hitOver);
            TweenLite.to(this,2,{"onComplete":this.delay2s});
         }
      }
      
      private function delay2s() : void
      {
         BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_START,this.goStart,false,0,true);
      }
      
      private function clickSeat(e:MouseEvent) : void
      {
         var seat:MovieClip = null;
         for(var i:int = 0; i < 3; i++)
         {
            seat = GV.MC_mapFrame["control_mc"]["seat" + i];
            if(e.currentTarget == seat)
            {
               BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.goSeatOver,false,0,true);
               (GV.MAN_PEOPLE as PeopleManageView).moveTo(int(seat.x),int(seat.y));
               break;
            }
         }
      }
      
      private function goSeatOver(e:*) : void
      {
         var seat:MovieClip = null;
         for(var i:int = 0; i < 3; i++)
         {
            seat = GV.MC_mapFrame["control_mc"]["seat" + i];
            if(GV.MAN_PEOPLE.x == int(seat.x) && GV.MAN_PEOPLE.y == int(seat.y))
            {
               BC.removeEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.goSeatOver);
               BC.addEvent(this,GV.onlineSocket,SummerSocket.ENTER_BATH,this.enterSeatOver,false,0,true);
               SummerSocket.enterBath(1,i + 1);
               break;
            }
         }
      }
      
      private function enterSeatOver(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SummerSocket.ENTER_BATH,this.enterSeatOver);
         if(e.EventObj.state == 1)
         {
            Alert.smileAlart("    位置上有人！");
            this.leaveSeat();
         }
      }
      
      private function leaveSeat() : void
      {
         var seat:MovieClip = null;
         for(var i:int = 0; i < 3; i++)
         {
            seat = GV.MC_mapFrame["control_mc"]["seat" + i];
            if(GV.MAN_PEOPLE.x == int(seat.x) && GV.MAN_PEOPLE.y == int(seat.y))
            {
               GV.MC_mapFrame["top_mc"].mc_bar.visible = false;
               (GV.MAN_PEOPLE as PeopleManageView).moveTo(this._leavePtArr[i].x,this._leavePtArr[i].y);
            }
         }
      }
      
      private function goStart(e:*) : void
      {
         var i:int = 0;
         if(this._curSeat != -1)
         {
            SummerSocket.enterBath(3,1);
            this.leaveSeat();
            this._curSeat = -1;
         }
         else if(this._curBath != -1)
         {
            for(i = 0; i < 5; i++)
            {
               if(GV.MAN_PEOPLE.x == this._ptArr[i].x && GV.MAN_PEOPLE.y == this._ptArr[i].y)
               {
                  BC.addEvent(this,GV.onlineSocket,SummerSocket.ENTER_BATH,this.leavelBathOver,false,0,true);
                  SummerSocket.enterBath(3,2);
               }
            }
         }
      }
      
      private function clickInter6(e:MouseEvent) : void
      {
         var tFunc:Function = null;
         var inter6:MovieClip = GV.MC_mapFrame["control_mc"].interBtn6;
         if(LocalUserInfo.isVIP())
         {
            if(this.inBath && this._curBath == 4 && inter6.currentFrame == 1)
            {
               this.visibleMole(false);
               inter6.gotoAndStop(2);
               tFunc = function():void
               {
                  visibleMole(true);
                  var rand:int = Math.random() * 10;
                  if(rand == 0)
                  {
                     OnlineManager.addCmdListener(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,addGlamourBath4Over);
                     OnlineManager.send(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,4,5,0);
                  }
               };
               TweenLite.to(this,5,{"onComplete":tFunc});
            }
         }
      }
      
      private function addGlamourBath4Over(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,this.addGlamourBath4Over);
         var pro:IceBabyAddBaseAttributeProtocol = e.bodyInfo;
         if(pro.state != 1000)
         {
            Alert.smileAlart("    搓澡力度適中，手法老道，渾身舒坦，魅力值+2。");
         }
      }
      
      private function clickInter5(e:MouseEvent) : void
      {
         var inter5:MovieClip = GV.MC_mapFrame["control_mc"].interBtn5;
         if(inter5.currentFrame == 1)
         {
            if(LocalUserInfo.isVIP())
            {
               inter5.gotoAndStop(2);
            }
            else
            {
               inter5.gotoAndStop(3);
            }
         }
      }
      
      private function clickInter4(e:MouseEvent) : void
      {
         var cattle:MovieClip = null;
         var tFunc:Function = null;
         cattle = GV.MC_mapFrame["control_mc"].interBtn4;
         if(LocalUserInfo.isVIP())
         {
            if(this.inBath && this._curBath == 4)
            {
               if(cattle.currentFrame == 1)
               {
                  cattle.gotoAndStop(2);
                  tFunc = function():void
                  {
                     cattle.gotoAndStop(1);
                  };
                  setTimeout(tFunc,60 * 1000);
               }
               else if(cattle.currentFrame == 3)
               {
                  cattle.gotoAndStop(4);
               }
            }
         }
         else
         {
            Alert.smileAlart("    海牛貌似隻理睬超級拉姆，快帶著超拉過來吧！");
         }
      }
      
      private function addGlamour(e:EventTaomee) : void
      {
         var pool:int = int(e.EventObj.pool);
         var glamour:int = int(e.EventObj.glamour);
         if(pool == 1)
         {
            GV.MC_mapFrame["top_mc"].iceMc0.play();
         }
         else if(pool == 2 && this._curBath == 1)
         {
            GV.MC_mapFrame["control_mc"].interBtn1.play();
         }
         else if(pool == 3)
         {
            GV.MC_mapFrame["top_mc"].iceMc2.play();
         }
         else if(pool == 4)
         {
            this.bubbleMovie();
         }
         else if(pool == 5)
         {
            GV.MC_mapFrame["top_mc"].iceMc4.play();
         }
      }
      
      private function bubbleMovie() : void
      {
         GV.MC_mapFrame["control_mc"].interBtn3.visible = true;
         TweenLite.to(this,10,{"onComplete":this.showBubbleOver});
         this.visibleMole(false);
      }
      
      private function visibleMole(bo:Boolean) : void
      {
         var o:Object = null;
         var i:int = 0;
         for each(o in this._bathArr)
         {
            if(o.userID == LocalUserInfo.getUserID())
            {
               if(this._curBath != -1)
               {
                  GV.MC_mapFrame["control_mc"]["bathMole" + this._curBath]["m" + i % 10].visible = bo;
               }
            }
            i++;
         }
      }
      
      private function showBubbleOver() : void
      {
         var rand:int = Math.random() * 10;
         if(rand < 5)
         {
            GV.MC_mapFrame["control_mc"].interBtn3.gotoAndStop(2);
            TweenLite.to(this,2.5,{"onComplete":this.blastOver});
         }
         else
         {
            this._movie = PlayMovie.play("resource/iceBaby/blast.swf",null,null,this.blastMovieOver);
         }
      }
      
      private function blastMovieOver() : void
      {
         this.visibleMole(true);
         this._movie.destroy();
         this._movie = null;
         this.blastOver();
         OnlineManager.addCmdListener(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,this.addGlamourBath3Over);
         OnlineManager.send(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,4,4,0);
      }
      
      private function addGlamourBath3Over(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,this.addGlamourBath3Over);
         var pro:IceBabyAddBaseAttributeProtocol = e.bodyInfo;
         if(pro.state != 1000)
         {
            Alert.smileAlart("    得到好心人幫忙，果然很有魅力，魅力+10。");
         }
      }
      
      private function blastOver() : void
      {
         GV.MC_mapFrame["control_mc"].interBtn3.gotoAndStop(1);
         GV.MC_mapFrame["control_mc"].interBtn3.visible = false;
         this.visibleMole(true);
      }
      
      private function throwEggFlower(e:EventTaomee) : void
      {
         var userID:int = int(e.EventObj.userID);
         var charm:int = int(e.EventObj.charm);
         var partScore:int = int(e.EventObj.partScore);
         var myID:int = LocalUserInfo.getUserID();
         var mcBar:MovieClip = GV.MC_mapFrame["top_mc"].mc_bar;
         if(this._curSeat != -1 && userID == LocalUserInfo.getUserID())
         {
            if(charm == 100 && this._winMovie == null)
            {
               this._winMovie = PlayMovie.play("resource/iceBaby/win.swf",null,null,this.playWinOver);
            }
         }
         mcBar.gotoAndStop(int(mcBar.totalFrames * charm / 100));
         if(myID == userID && this._curSeat == -1 && partScore != 0)
         {
            Alert.smileAlart("    恭喜你獲得" + partScore + "積分！");
         }
      }
      
      private function playWinOver() : void
      {
         this._winMovie.destroy();
         this._winMovie = null;
      }
      
      private function hitOver(e:EventTaomee) : void
      {
         var index:int = -1;
         for(var i:int = 0; i < 3; i++)
         {
            if(e.EventObj.btn == GV.MC_mapFrame["top_mc"]["rect" + i])
            {
               index = i;
               break;
            }
         }
         if(e.EventObj.mc.userID == LocalUserInfo.getUserID())
         {
            if(e.EventObj.mc.ThrowID == 150002 && index != -1 && this._seatArr[index] != 0 && this._seatArr[index] != LocalUserInfo.getUserID())
            {
               SummerSocket.throwEggFlower(this._seatArr[index],2);
            }
            else if(e.EventObj.mc.ThrowID == 150020 && index != -1 && this._seatArr[index] != 0 && this._seatArr[index] != LocalUserInfo.getUserID())
            {
               SummerSocket.throwEggFlower(this._seatArr[index],1);
            }
         }
         if(e.EventObj.mc.userID == LocalUserInfo.getUserID() || this._seatArr[index] == LocalUserInfo.getUserID())
         {
            if(e.EventObj.mc.ThrowID == 150020)
            {
               GV.MC_mapFrame["top_mc"].mc_plus.x = GV.MC_mapFrame["control_mc"]["seat" + index].x;
               GV.MC_mapFrame["top_mc"].mc_plus.gotoAndPlay(2);
            }
         }
      }
      
      private function addHit(seatArr:Array) : void
      {
         var p0:MovieClip = GV.MC_mapFrame["top_mc"].rect0;
         var p1:MovieClip = GV.MC_mapFrame["top_mc"].rect1;
         var p2:MovieClip = GV.MC_mapFrame["top_mc"].rect2;
         var obj00:Object = {
            "btn":p0,
            "mc":new MovieClip(),
            "id":"swf150002",
            "fre":1,
            "hide":true
         };
         var obj01:Object = {
            "btn":p0,
            "mc":new MovieClip(),
            "id":"swf150020",
            "fre":1,
            "hide":true
         };
         var obj10:Object = {
            "btn":p1,
            "mc":new MovieClip(),
            "id":"swf150002",
            "fre":1,
            "hide":true
         };
         var obj11:Object = {
            "btn":p1,
            "mc":new MovieClip(),
            "id":"swf150020",
            "fre":1,
            "hide":true
         };
         var obj20:Object = {
            "btn":p2,
            "mc":new MovieClip(),
            "id":"swf150002",
            "fre":1,
            "hide":true
         };
         var obj21:Object = {
            "btn":p2,
            "mc":new MovieClip(),
            "id":"swf150020",
            "fre":1,
            "hide":true
         };
         throwHitTest.HitTestMC(obj00,obj01,obj10,obj11,obj20,obj21);
      }
      
      private function getBathInfoOver(e:EventTaomee) : void
      {
         var index:int = 0;
         var seatArr:Array = e.EventObj.seat;
         this._seatArr = seatArr;
         for(var i:int = 0; i < 3; i++)
         {
            if(this._seatArr[i] != 0)
            {
               GV.MC_mapFrame["control_mc"]["seat" + i].gotoAndStop(2);
            }
            else
            {
               GV.MC_mapFrame["control_mc"]["seat" + i].gotoAndStop(1);
            }
         }
         var tIndex:int = index;
         index = seatArr.indexOf(LocalUserInfo.getUserID());
         if(tIndex != -1 && index == -1)
         {
            this.leaveSeat();
         }
         this._curSeat = index;
         if(this._curSeat != -1)
         {
            GV.MC_mapFrame["top_mc"].mc_bar.visible = true;
            GV.MC_mapFrame["top_mc"].mc_bar.x = GV.MC_mapFrame["control_mc"]["seat" + this._curSeat].x;
         }
         else
         {
            GV.MC_mapFrame["top_mc"].mc_bar.visible = false;
         }
         this.addHit(seatArr);
         var inBathBefore:Boolean = this.inBath;
         this._bathArr = e.EventObj.arr;
         if(!inBathBefore && this.inBath)
         {
            this.goBath();
         }
         else if(inBathBefore && !this.inBath)
         {
            this.leaveBathSuc();
         }
         this.showBathPeople();
      }
      
      private function showBathPeople() : void
      {
         var o:Object = null;
         var arr:Array = null;
         var mc:MovieClip = null;
         var i:int = 0;
         for each(o in this._bathArr)
         {
            mc = GV.MC_mapFrame["control_mc"]["bathMole" + int(i / 10)]["m" + i % 10];
            if(o.userID != 0)
            {
               mc.gotoAndStop(1);
               mc.visible = true;
            }
            else
            {
               mc.gotoAndStop(2);
               mc.visible = false;
            }
            i++;
         }
         arr = PeopleCountLogic.getAllPeopleList();
         for each(o in arr)
         {
            if(this.isInBath(o.ID))
            {
               o.Instance.visible = false;
            }
            else
            {
               o.Instance.visible = true;
            }
         }
      }
      
      private function isInBath(userID:int) : Boolean
      {
         var o:Object = null;
         for each(o in this._bathArr)
         {
            if(o.userID == userID)
            {
               return true;
            }
         }
         return false;
      }
      
      private function goBath() : void
      {
         this._goBathStartTime = getTimer();
         this._curBath = this.bathIndex;
         GV.MAN_PEOPLE.visible = false;
      }
      
      private function levelBath0(e:*) : void
      {
         BC.addEvent(this,GV.onlineSocket,SummerSocket.ENTER_BATH,this.leavelBathOver,false,0,true);
         SummerSocket.enterBath(3,2);
      }
      
      private function leavelAlert(e:MouseEvent) : void
      {
         var alert:* = Alert.smileAlart("    確定要離開溫泉嗎？",this.levelBath0,"sure,cancel");
         alert.addEventListener(Alert.CLICK_ + "2",this.cancelLeave);
      }
      
      private function clickInter(e:MouseEvent) : void
      {
         var interBtn:MovieClip = null;
         if(this._curBath != -1)
         {
            interBtn = GV.MC_mapFrame["control_mc"]["interBtn" + this._curBath];
            if(e.currentTarget == interBtn)
            {
               if(this._curBath == 0)
               {
                  interBtn.play();
                  TweenLite.to(this,2.5,{
                     "onComplete":this.flowerMovieOver,
                     "onCompleteParams":[1629]
                  });
               }
               else if(this._curBath == 1)
               {
                  this.playBeautyMovie();
               }
               else if(this._curBath == 2)
               {
                  interBtn.gotoAndStop(2);
                  TweenLite.to(this,2,{"onComplete":this.waterFallMovieOver});
               }
            }
         }
      }
      
      private function waterFallMovieOver() : void
      {
         GV.MC_mapFrame["control_mc"].interBtn2.gotoAndStop(1);
         this.flowerMovieOver(1630);
      }
      
      private function playBeautyMovie() : void
      {
         var index:int = 0;
         GV.MC_mapFrame["control_mc"].interBtn1.gotoAndStop(1);
         var rand:int = Math.random() * 10;
         if(rand <= 2)
         {
            index = 0;
         }
         else if(rand > 2 && rand <= 7)
         {
            index = 1;
         }
         else
         {
            index = 2;
         }
         this._movie = PlayMovie.play("resource/iceBaby/fmovie" + index + ".swf",null,null,this.playfMovieOver,[index]);
      }
      
      private function playfMovieOver(index:int) : void
      {
         GV.MC_mapFrame["control_mc"].interBtn1.gotoAndStop(1);
         this._movie.destroy();
         this._movie = null;
         if(index == 2)
         {
            OnlineManager.addCmdListener(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,this.addGlamourBath1Over);
            OnlineManager.send(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,4,2,0);
         }
      }
      
      private function addGlamourBath1Over(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE,this.addGlamourBath1Over);
         var pro:IceBabyAddBaseAttributeProtocol = e.bodyInfo;
         if(pro.state != 1000)
         {
            Alert.smileAlart("    巧遇冰泉美人魚，冰泉寶貝魅力值+10！");
            ActivityTmpDataManager.getTransferItem(0);
         }
      }
      
      private function flowerMovieOver(type:int) : void
      {
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getPropBath0Over,false,0,true);
         exchange.exchange_goods(type);
      }
      
      private function getPropBath0Over(e:EventTaomee) : void
      {
         if(e.EventObj.type == 1629 || e.EventObj.type == 1630)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getPropBath0Over);
            if(e.EventObj.type == 1629)
            {
               Alert.smileAlart("    恭喜你獲得3個花瓣泉泉水投擲道具，已放入你的投擲欄中！");
            }
            else
            {
               Alert.smileAlart("    恭喜你獲得3個冰片泉泉水投擲道具，已放入你的投擲欄中！");
            }
         }
      }
      
      private function cancelLeave(e:Event) : void
      {
         e.currentTarget.removeEventListener(Alert.CLICK_ + "2",this.cancelLeave);
      }
      
      private function leavelBathOver(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SummerSocket.ENTER_BATH,this.leavelBathOver);
         if(e.EventObj.state == 0)
         {
            this.leaveBathSuc();
         }
      }
      
      private function leaveBathSuc() : void
      {
         if(this._goBathStartTime != 0 && getTimer() - this._goBathStartTime >= 30 * 1000)
         {
            this._goBathStartTime = 0;
            if(this._curBath == 0)
            {
               this.addMovieOnUser(0);
            }
            else if(this._curBath == 2)
            {
               this.addMovieOnUser(2);
            }
            else if(this._curBath == 4)
            {
               this.addMovieOnUser(int(Math.random() * 2));
            }
         }
         GV.MC_mapFrame["control_mc"].interBtn1.gotoAndStop(1);
         GV.MC_mapFrame["control_mc"].interBtn6.gotoAndStop(1);
         this._curBath = -1;
         this.addBathBtnEvents();
         GV.MAN_PEOPLE.visible = true;
         MoveTo.CanMove = true;
      }
      
      private function addMovieOnUser(index:int) : void
      {
         var path:String = null;
         if(index == 0)
         {
            path = "resource/iceBaby/flower.swf";
         }
         else if(index == 2)
         {
            path = "resource/iceBaby/leaf.swf";
         }
         var resID:int = int(DownLoadManager.add(path,ResType.DISPLAY_OBJECT));
         DownLoadManager.addEvent(resID,this.loadUserMovieOver);
      }
      
      private function loadUserMovieOver(e:DownLoadEvent) : void
      {
         this.clearUserMovie();
         this._userEffect = e.data as MovieClip;
         GV.MAN_PEOPLE.addChild(this._userEffect);
         TweenLite.to(this,20,{"onComplete":this.clearUserMovie});
      }
      
      private function clearUserMovie() : void
      {
         DisplayUtil.removeForParent(this._userEffect);
         this._userEffect = null;
      }
      
      private function addBathBtnEvents() : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            BC.addEvent(this,GV.MC_mapFrame["control_mc"]["bathBtn" + i],MouseEvent.CLICK,this.clickBathBtn,false,0,true);
         }
      }
      
      private function removeBathBtnEvents() : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            BC.removeEvent(this,GV.MC_mapFrame["control_mc"]["bathBtn" + i],MouseEvent.CLICK,this.clickBathBtn);
         }
      }
      
      private function clickBathBtn(e:MouseEvent) : void
      {
         var i:int = 0;
         if(this._curBath == -1)
         {
            for(i = 0; i < 5; i++)
            {
               if(e.currentTarget == GV.MC_mapFrame["control_mc"]["bathBtn" + i])
               {
                  BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.onGoOver,false,0,true);
                  (GV.MAN_PEOPLE as PeopleManageView).moveTo(this._ptArr[i].x,this._ptArr[i].y);
                  break;
               }
            }
         }
         else
         {
            DebugManager.traceMsg("正在泡溫泉， 不能直接去泡其他溫泉");
         }
      }
      
      private function onGoOver(e:*) : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            if(GV.MAN_PEOPLE.x == this._ptArr[i].x && GV.MAN_PEOPLE.y == this._ptArr[i].y)
            {
               if(i == 4 && LocalUserInfo.isVIP() || i != 4)
               {
                  BC.addEvent(this,GV.onlineSocket,SummerSocket.ENTER_BATH,this.enterBath,false,0,true);
                  SummerSocket.enterBath(2,i + 1);
               }
               else if(i == 4 && !LocalUserInfo.isVIP())
               {
                  Alert.smileAlart("    只有帶著超級拉姆的遊客，才能進入牛奶泉哦！");
               }
               break;
            }
         }
      }
      
      private function enterBath(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SummerSocket.ENTER_BATH,this.enterBath);
         if(e.EventObj.state == 0)
         {
            this.removeBathBtnEvents();
         }
         else
         {
            Alert.smileAlart("    沒位置了");
         }
      }
      
      public function initLottery() : void
      {
         if(LocalUserInfo.getMapID() == this._prizeMap)
         {
            BC.addEvent(this,GV.onlineSocket,SummerSocket.LOTTERY,this.getRandPrize,false,0,true);
         }
      }
      
      private function getRandPrize(e:EventTaomee) : void
      {
         this._pool = e.EventObj.pool;
         this._itemID = e.EventObj.itemID;
         this._itemCnt = e.EventObj.itemCnt;
         this._lotteryMovie = PlayMovie.play("resource/iceBaby/movie" + (this._pool - 1) + ".swf",null,null,this.lotteryMovieOver,null,LevelManager.mapLevel);
      }
      
      private function lotteryMovieOver() : void
      {
         this._lotteryMovie.destroy();
         this._lotteryMovie = null;
         if(this._curBath == this._pool - 1)
         {
            this._lotteryMovie = PlayMovie.play("resource/iceBaby/pmovie" + (this._pool - 1) + ".swf",null,null,this.getLotteryOver);
         }
      }
      
      private function getLotteryOver() : void
      {
         this._lotteryMovie.destroy();
         this._lotteryMovie = null;
         if(this._itemID != 1)
         {
            Alert.smileAlart("    恭喜你獲得" + this._itemCnt + "個" + GoodsInfo.getItemNameByID(this._itemID) + "，已放入你的" + GoodsInfo.getItemCollectionBoxNameByID(this._itemID) + "中！");
         }
         else
         {
            Alert.smileAlart("    恭喜你獲得" + this._itemCnt + "點魅力值！");
         }
      }
      
      private function get bathIndex() : int
      {
         var o:Object = null;
         if(this._bathArr == null)
         {
            return -1;
         }
         for each(o in this._bathArr)
         {
            if(o.userID == LocalUserInfo.getUserID())
            {
               return o.index - 1;
            }
         }
         return -1;
      }
      
      private function get inBath() : Boolean
      {
         var o:Object = null;
         if(this._bathArr == null)
         {
            return false;
         }
         for each(o in this._bathArr)
         {
            if(o.userID == LocalUserInfo.getUserID())
            {
               return true;
            }
         }
         return false;
      }
      
      public function get bathArr() : Array
      {
         return this._bathArr;
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         this._curSeat = -1;
         this.clearUserMovie();
         TweenLite.killTweensOf(this);
         this._bathArr = null;
         if(this._movie != null)
         {
            this._movie.destroy();
            this._movie = null;
         }
         if(this._winMovie != null)
         {
            this._winMovie.destroy();
            this._winMovie = null;
         }
      }
   }
}

