package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.module.deal.Deal;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ChristmasOffice extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var type_mc:MovieClip;
      
      private var runObj:Object;
      
      private var makeItemArr:Array = ["聖誕老人公仔","聖誕星星帽","聖誕蠟燭","聖誕樹","馴鹿頭","聖誕花環","聖誕小鹿","聖誕小火車","雪人男公仔","雪人女公仔"];
      
      private var makeItemXCoord:Array = new Array();
      
      private var makeItemYCoord:Array = new Array();
      
      private var makeItemArrNum:int;
      
      private var makeTimer:Timer;
      
      private var makeTimerNum:int = 20;
      
      private var makeItemSprite:Sprite;
      
      private var tarX:Number;
      
      private var tarY:Number;
      
      private var successSign:int;
      
      private var successNum:int;
      
      private var ALLNUM:int = 3;
      
      private var altObj:Object;
      
      public function ChristmasOffice()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.type_mc = GV.MC_mapFrame["type_mc"];
         this.startBtnFunction(true);
      }
      
      private function startBtnFunction(temp:Boolean) : void
      {
         if(temp)
         {
            this.target_mc.show0.visible = true;
            this.target_mc.startBtn.gotoAndStop(1);
            this.target_mc.goBtn.gotoAndStop(1);
            this.target_mc.startBtn.buttonMode = true;
            this.target_mc.startBtn.addEventListener(MouseEvent.MOUSE_MOVE,this.onStartBtn);
            this.target_mc.startBtn.addEventListener(MouseEvent.MOUSE_OUT,this.onStartBtn);
            this.target_mc.startBtn.addEventListener(MouseEvent.CLICK,this.onStartBtn);
         }
         else
         {
            this.target_mc.show0.visible = false;
            this.target_mc.startBtn.buttonMode = false;
            this.target_mc.startBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStartBtn);
            this.target_mc.startBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.onStartBtn);
            this.target_mc.startBtn.removeEventListener(MouseEvent.CLICK,this.onStartBtn);
         }
      }
      
      private function goBtnFunction(temp:Boolean) : void
      {
         if(temp)
         {
            this.target_mc.show1.visible = true;
            this.target_mc.goBtn.gotoAndStop(1);
            this.target_mc.goBtn.buttonMode = true;
            this.target_mc.goBtn.addEventListener(MouseEvent.MOUSE_MOVE,this.onGoBtn);
            this.target_mc.goBtn.addEventListener(MouseEvent.MOUSE_OUT,this.onGoBtn);
            this.target_mc.goBtn.addEventListener(MouseEvent.CLICK,this.onGoBtn);
         }
         else
         {
            this.target_mc.show1.visible = false;
            this.target_mc.goBtn.buttonMode = false;
            this.target_mc.goBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.onGoBtn);
            this.target_mc.goBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.onGoBtn);
            this.target_mc.goBtn.removeEventListener(MouseEvent.CLICK,this.onGoBtn);
         }
      }
      
      private function onGoBtn(evt:MouseEvent) : void
      {
         if(evt.type == MouseEvent.MOUSE_MOVE)
         {
            evt.currentTarget.gotoAndStop(2);
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.gotoAndStop(1);
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            this.goBtnFunction(false);
            evt.currentTarget.gotoAndStop(3);
            this.randomSuccess();
         }
      }
      
      private function onStartBtn(evt:MouseEvent) : void
      {
         if(evt.type == MouseEvent.MOUSE_MOVE)
         {
            evt.currentTarget.gotoAndStop(2);
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.gotoAndStop(1);
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            this.startBtnFunction(false);
            evt.currentTarget.gotoAndStop(3);
            GV.onlineSocket.addEventListener("Round_Over",this.onRoundOver);
            GV.onlineSocket.addEventListener("GoBtn_Yes",this.onGoBtnYes);
            GV.onlineSocket.addEventListener("GoBtn_No",this.onGoBtnNo);
            this.target_mc.shou.gotoAndPlay(2);
         }
      }
      
      private function onGoBtnYes(evt:EventTaomee) : void
      {
         this.runObj = {
            "yes":evt.EventObj.yes,
            "no":evt.EventObj.no
         };
         this.goBtnFunction(true);
      }
      
      private function onGoBtnNo(evt:EventTaomee) : void
      {
         this.runObj = null;
         this.goBtnFunction(false);
      }
      
      private function onRoundOver(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("Round_Over",this.onRoundOver);
         this.startBtnFunction(true);
      }
      
      private function randomSuccess() : void
      {
         GV.onlineSocket.removeEventListener("Round_Over",this.onRoundOver);
         GV.onlineSocket.removeEventListener("GoBtn_Yes",this.onGoBtnYes);
         GV.onlineSocket.removeEventListener("GoBtn_No",this.onGoBtnNo);
         var randomNum:int = Math.random() * 100;
         if(randomNum < 80)
         {
            this.target_mc.shou.gotoAndPlay(int(this.runObj.yes));
            this.makeItemArrNum = Math.random() * this.makeItemArr.length;
            GV.onlineSocket.addEventListener("TV_TXT",this.onTvTxt);
            this.target_mc.tv.buttonMode = true;
            this.target_mc.tv.addEventListener(MouseEvent.CLICK,this.onTv);
            this.target_mc.tv.gotoAndStop(2);
            this.target_mc.laBtn.buttonMode = true;
            this.target_mc.laBtn.addEventListener(MouseEvent.CLICK,this.onLaBtn);
         }
         else
         {
            this.target_mc.shou.gotoAndPlay(int(this.runObj.no));
            this.startBtnFunction(true);
         }
      }
      
      private function onTv(evt:MouseEvent) : void
      {
         this.topMC.itemPanel.messageTxt.text = "    一個可愛小摩爾聖誕節的願望是：希望聖誕老人把“" + this.makeItemArr[this.makeItemArrNum] + "”作為禮物。";
         this.topMC.itemPanel.gotoAndStop(this.makeItemArrNum + 1);
         this.topMC.itemPanel.closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtn);
         this.topMC.itemPanel.y = 80;
      }
      
      private function onCloseBtn(evt:MouseEvent) : void
      {
         this.topMC.itemPanel.closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseBtn);
         this.topMC.itemPanel.y = -500;
      }
      
      private function onTvTxt(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("TV_TXT",this.onTvTxt);
         if(this.target_mc.tv.currentFrame == 2)
         {
            this.target_mc.show2.visible = true;
            this.target_mc.tv.makeItemTxt.text = "“" + this.makeItemArr[this.makeItemArrNum] + "”";
         }
         else if(this.target_mc.tv.currentFrame == 4)
         {
            this.target_mc.tv.makeItemTxt.text = "找到組裝“" + this.makeItemArr[this.makeItemArrNum] + "”的各個組件吧，就在這屋子裡哦！";
            this.countTimerStart();
         }
         else if(this.target_mc.tv.currentFrame == 5)
         {
            this.target_mc.tv.makeItemTxt.text = "已完成" + this.successNum + "個禮物，\n還有" + int(this.ALLNUM - this.successNum) + "個，加油哦！繼續抽取願望吧！";
         }
      }
      
      private function onLaBtn(evt:MouseEvent) : void
      {
         this.target_mc.laBtn.buttonMode = false;
         this.target_mc.laBtn.removeEventListener(MouseEvent.CLICK,this.onLaBtn);
         this.target_mc.show2.visible = false;
         GV.onlineSocket.addEventListener("Timer_Begin",this.onTimerBegin);
         this.target_mc.laBtn.gotoAndPlay(2);
      }
      
      private function onTimerBegin(evt:Event) : void
      {
         GV.onlineSocket.addEventListener("TV_TXT",this.onTvTxt);
         this.target_mc.tv.gotoAndStop(4);
         this.makeItemsFunction(true);
         for(var panR:int = 0; panR < 3; panR++)
         {
            this.target_mc.fRunRoad["pan" + panR].gotoAndStop((this.makeItemArrNum + 1) * 3 - 1 + panR);
         }
      }
      
      private function countTimerStart() : void
      {
         this.makeTimer = new Timer(1000,20);
         this.makeTimer.addEventListener(TimerEvent.TIMER,this.onMakeTimer);
         this.makeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onMakeTimerComplete);
         this.makeTimer.start();
      }
      
      private function onMakeTimer(evt:TimerEvent) : void
      {
         --this.makeTimerNum;
         this.target_mc.tv.timerTxt.text = this.makeTimerNum;
         if(this.checkPan())
         {
            if(this.makeTimer != null)
            {
               this.makeTimer.reset();
               this.makeTimer.removeEventListener(TimerEvent.TIMER,this.onMakeTimer);
               this.makeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onMakeTimerComplete);
            }
            this.makeItemsFunction(false);
            this.successSign = 3;
            GV.onlineSocket.addEventListener("Check_Over",this.onCheckOver);
            this.target_mc.fRunRoad.play();
         }
      }
      
      private function checkPan() : Boolean
      {
         var ret:Boolean = true;
         for(var pr:int = 0; pr < 3; pr++)
         {
            if(this.target_mc.fRunRoad["pan" + pr].currentFrame < 32)
            {
               ret = false;
               break;
            }
         }
         return ret;
      }
      
      private function onMakeTimerComplete(evt:TimerEvent) : void
      {
         if(this.makeTimer != null)
         {
            this.makeTimer.reset();
            this.makeTimer.removeEventListener(TimerEvent.TIMER,this.onMakeTimer);
            this.makeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onMakeTimerComplete);
         }
         this.makeItemsFunction(false);
         for(var pr:int = 0; pr < 3; pr++)
         {
            if(this.target_mc.fRunRoad["pan" + pr].currentFrame >= 32)
            {
               ++this.successSign;
            }
         }
         GV.onlineSocket.addEventListener("Check_Over",this.onCheckOver);
         this.target_mc.fRunRoad.play();
      }
      
      private function onCheckOver(evt:Event) : void
      {
         var makeItemType:int = 0;
         GV.onlineSocket.removeEventListener("Check_Over",this.onCheckOver);
         var sf:int = this.target_mc.laBtn.currentFrame + 1;
         this.target_mc.laBtn.gotoAndPlay(sf);
         for(var makeItemRo:int = 0; makeItemRo < 30; makeItemRo++)
         {
            makeItemType = int(makeItemRo / 3);
            this.target_mc["item_" + makeItemType + "_" + makeItemRo].x = this.makeItemXCoord[makeItemRo];
            this.target_mc["item_" + makeItemType + "_" + makeItemRo].y = this.makeItemYCoord[makeItemRo];
            this.target_mc["item_" + makeItemType + "_" + makeItemRo].gotoAndStop(1);
         }
         if(this.successSign == 3)
         {
            GV.onlineSocket.addEventListener("Success",this.onMakeSuccess);
            this.depth_mc.checkBox.gotoAndPlay(218);
         }
         else
         {
            GV.onlineSocket.addEventListener("Fail",this.onMakeFail);
            this.depth_mc.checkBox.gotoAndPlay(174);
         }
         this.makeTimerNum = 20;
         this.successSign = 0;
      }
      
      private function onMakeFail(rvt:Event) : void
      {
         GV.onlineSocket.removeEventListener("Fail",this.onMakeFail);
         this.target_mc.tv.gotoAndStop(3);
         this.startBtnFunction(true);
      }
      
      private function onMakeSuccess(rvt:Event) : void
      {
         GV.onlineSocket.removeEventListener("Success",this.onMakeSuccess);
         ++this.successNum;
         GV.onlineSocket.addEventListener("MakeItemOver_Start",this.onMakeItemOverStart);
         this.depth_mc.makeItemOver.gotoAndPlay(2);
      }
      
      private function onMakeItemOverStart(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("MakeItemOver_Start",this.onMakeItemOverStart);
         if(this.successNum == this.ALLNUM)
         {
            this.target_mc.tv.gotoAndStop(6);
         }
         else
         {
            GV.onlineSocket.addEventListener("TV_TXT",this.onTvTxt);
            this.target_mc.tv.gotoAndStop(5);
         }
         GV.onlineSocket.addEventListener("Make_Over_Topl",this.onMakeOverTopl);
         this.depth_mc.makeItemOver.makeItemOver.gotoAndStop(this.makeItemArrNum + 1);
      }
      
      private function onMakeOverTopl(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("Make_Over_Topl",this.onMakeOverTopl);
         if(this.successNum == this.ALLNUM)
         {
            this.successNum = 0;
            this.target_mc.tv.removeEventListener(MouseEvent.CLICK,this.onTv);
            Deal.BuyItem(190532,1,function(... e):void
            {
               var _url:String = GoodsInfo.getItemPathByID(190532) + "190532.swf";
               var _msg:String = "    恭喜你得到" + GoodsInfo.getItemNameByID(190532) + "，拿著票去乘坐聖誕車吧！";
               altObj = Alert.showAlert(MainManager.getGameLevel(),_url,_msg,Alert.CHANG_ALERT,"go,notgo",true,false,"EMP_BUY");
               altObj.addEventListener(Alert.CLICK_ + "1",go118Event);
               altObj.addEventListener(Alert.CLICK_ + "2",go118Event2);
            });
         }
         else
         {
            this.startBtnFunction(true);
            this.target_mc.tv.gotoAndStop(1);
         }
      }
      
      private function go118Event(evt:Event) : void
      {
         this.altObj.removeEventListener(Alert.CLICK_ + "1",this.go118Event);
         this.altObj.removeEventListener(Alert.CLICK_ + "2",this.go118Event2);
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.switchMap(118,true);
      }
      
      private function go118Event2(evt:Event) : void
      {
         this.altObj.removeEventListener(Alert.CLICK_ + "1",this.go118Event);
         this.altObj.removeEventListener(Alert.CLICK_ + "2",this.go118Event2);
         this.startBtnFunction(true);
      }
      
      private function makeItemsFunction(temp:Boolean, type:int = 0) : void
      {
         var makeItemR:int = 0;
         var makeItemType:int = 0;
         if(temp)
         {
            for(makeItemR = 0; makeItemR < 30; makeItemR++)
            {
               makeItemType = int(makeItemR / 3);
               this.makeItemXCoord[makeItemR] = this.target_mc["item_" + makeItemType + "_" + makeItemR].x;
               this.makeItemYCoord[makeItemR] = this.target_mc["item_" + makeItemType + "_" + makeItemR].y;
               this.target_mc["item_" + makeItemType + "_" + makeItemR].addEventListener(MouseEvent.MOUSE_DOWN,this.onMakeItemBox);
               this.target_mc["item_" + makeItemType + "_" + makeItemR].addEventListener(MouseEvent.MOUSE_UP,this.onMakeItemBox);
               this.target_mc["item_" + makeItemType + "_" + makeItemR].addEventListener(MouseEvent.MOUSE_OVER,this.onMakeItemBox);
               this.target_mc["item_" + makeItemType + "_" + makeItemR].addEventListener(MouseEvent.MOUSE_OUT,this.onMakeItemBox);
               this.target_mc.stage.addEventListener(Event.MOUSE_LEAVE,this.leaveHandler);
               this.target_mc.stage.addEventListener(MouseEvent.MOUSE_UP,this.stageHitMcUpHandler);
            }
         }
         else if(type == 1)
         {
            this.target_mc["item_" + makeItemType + "_" + makeItemR].removeEventListener(MouseEvent.MOUSE_DOWN,this.onMakeItemBox);
         }
         else
         {
            for(makeItemR = 0; makeItemR < 30; makeItemR++)
            {
               makeItemType = int(makeItemR / 3);
               this.target_mc["item_" + makeItemType + "_" + makeItemR].removeEventListener(MouseEvent.MOUSE_DOWN,this.onMakeItemBox);
               this.target_mc["item_" + makeItemType + "_" + makeItemR].removeEventListener(MouseEvent.MOUSE_UP,this.onMakeItemBox);
               this.target_mc["item_" + makeItemType + "_" + makeItemR].removeEventListener(MouseEvent.MOUSE_OVER,this.onMakeItemBox);
               this.target_mc["item_" + makeItemType + "_" + makeItemR].removeEventListener(MouseEvent.MOUSE_OUT,this.onMakeItemBox);
               this.target_mc.stage.removeEventListener(Event.MOUSE_LEAVE,this.leaveHandler);
               this.target_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,this.stageHitMcUpHandler);
            }
         }
      }
      
      private function onMakeItemBox(evt:MouseEvent) : void
      {
         if(evt.type == MouseEvent.MOUSE_DOWN)
         {
            this.makeItemSprite = evt.currentTarget as Sprite;
            this.tarX = this.makeItemSprite.x;
            this.tarY = this.makeItemSprite.y;
            GF.setDrag(this.makeItemSprite);
         }
         else if(evt.type == MouseEvent.MOUSE_UP)
         {
            GF.stopDrag(this.makeItemSprite);
            this.checkHit(this.makeItemSprite);
            this.makeItemSprite.x = this.tarX;
            this.makeItemSprite.y = this.tarY;
         }
         else if(evt.type == MouseEvent.MOUSE_OVER)
         {
            evt.currentTarget.gotoAndStop(2);
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.gotoAndStop(1);
         }
      }
      
      private function checkHit(tempS:Sprite) : Boolean
      {
         var panFrameNum:int = 0;
         var ret:Boolean = false;
         var numArr:Array = this.makeItemSprite.name.split("_");
         for(var panR:uint = 0; panR < 3; panR++)
         {
            if(this.makeItemSprite.hitTestObject(this.target_mc.fRunRoad["pan" + panR]))
            {
               if(int(numArr[1]) == this.makeItemArrNum && int(numArr[2] % 3) == panR)
               {
                  panFrameNum = int(this.target_mc.fRunRoad["pan" + panR].currentFrame);
                  if(panFrameNum <= 31)
                  {
                     this.target_mc.fRunRoad["pan" + panR].gotoAndStop(panFrameNum + 30);
                  }
                  ret = true;
                  break;
               }
            }
         }
         return ret;
      }
      
      private function leaveHandler(event:Event) : void
      {
         if(this.makeItemSprite == null)
         {
            return;
         }
         this.makeItemSprite.x = this.tarX;
         this.makeItemSprite.y = this.tarY;
      }
      
      private function stageHitMcUpHandler(event:MouseEvent) : void
      {
         if(this.makeItemSprite == null)
         {
            return;
         }
         if(this.makeItemSprite.hitTestObject(this.depth_mc) || this.makeItemSprite.hitTestObject(this.topMC))
         {
            this.makeItemSprite.x = this.tarX;
            this.makeItemSprite.y = this.tarY;
         }
         else if(this.makeItemSprite.hitTestObject(this.botton_mc) || this.makeItemSprite.hitTestObject(this.type_mc))
         {
            this.makeItemSprite.x = this.tarX;
            this.makeItemSprite.y = this.tarY;
         }
      }
      
      override public function destroy() : void
      {
         if(this.altObj != null)
         {
            this.altObj.removeEventListener(Alert.CLICK_ + "1",this.go118Event);
            this.altObj.removeEventListener(Alert.CLICK_ + "2",this.go118Event2);
            Alert.closeAllAlert();
         }
         GV.onlineSocket.removeEventListener("Make_Over_Topl",this.onMakeOverTopl);
         GV.onlineSocket.removeEventListener("MakeItemOver_Start",this.onMakeItemOverStart);
         GV.onlineSocket.removeEventListener("Success",this.onMakeSuccess);
         GV.onlineSocket.removeEventListener("Fail",this.onMakeFail);
         GV.onlineSocket.removeEventListener("Check_Over",this.onCheckOver);
         this.makeItemsFunction(false);
         if(this.makeTimer != null)
         {
            this.makeTimer.reset();
            this.makeTimer.removeEventListener(TimerEvent.TIMER,this.onMakeTimer);
            this.makeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onMakeTimerComplete);
            this.makeTimer = null;
         }
         GV.onlineSocket.removeEventListener("Timer_Begin",this.onTimerBegin);
         this.topMC.itemPanel.closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseBtn);
         this.target_mc.tv.removeEventListener(MouseEvent.CLICK,this.onTv);
         this.target_mc.laBtn.removeEventListener(MouseEvent.CLICK,this.onLaBtn);
         GV.onlineSocket.removeEventListener("TV_TXT",this.onTvTxt);
         GV.onlineSocket.removeEventListener("Round_Over",this.onRoundOver);
         GV.onlineSocket.removeEventListener("GoBtn_Yes",this.onGoBtnYes);
         GV.onlineSocket.removeEventListener("GoBtn_No",this.onGoBtnNo);
         this.startBtnFunction(false);
         this.goBtnFunction(false);
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.topMC = null;
         this.botton_mc = null;
         this.type_mc = null;
         super.destroy();
      }
   }
}

