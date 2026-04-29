package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.module.deal.Deal;
   import com.mole.app.manager.ActivityTmpDataManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import flash.media.SoundLoaderContext;
   import flash.net.URLRequest;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class lamuPartyView extends BasicMapView
   {
      
      public var mouse_mc:MovieClip;
      
      private var move_mc:MovieClip;
      
      private var bookMC:MovieClip;
      
      private var treasure_mc:MovieClip;
      
      private var cloudA:MovieClip;
      
      private var cloudB:MovieClip;
      
      private var cloudC:MovieClip;
      
      private var cloudD:MovieClip;
      
      private var book:MovieClip;
      
      private var detail:MovieClip;
      
      private var codeA:uint = 0;
      
      private var codeB:uint = 0;
      
      private var codeC:uint = 0;
      
      private var codeD:uint = 0;
      
      private var secenAframe:uint = 920;
      
      private var secenBframe:uint = 1872;
      
      private var IntervalID:uint = 0;
      
      private var status:uint = 0;
      
      private var presentTime:uint = 0;
      
      private var TOTAL_TIME:uint = 30;
      
      private var isDoorOpen:Boolean = false;
      
      private var isCodeCorrect:Boolean = false;
      
      private var TimeoutID:uint = 0;
      
      private var startSound:Sound = new Sound(null,new SoundLoaderContext());
      
      private var sound_A:Sound = new Sound(null,new SoundLoaderContext());
      
      private var sound_B:Sound = new Sound(null,new SoundLoaderContext());
      
      private var sound_C:Sound = new Sound(null,new SoundLoaderContext());
      
      public function lamuPartyView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         depth_mc.mouseEnabled = false;
         depth_mc.mouseChildren = false;
         this.treasure_mc = GV.MC_mapFrame["treasure_mc"];
         this.move_mc = GV.MC_mapFrame["move_mc"];
         this.bookMC = GV.MC_mapFrame["bookMC"];
         this.cloudA = GV.MC_mapFrame["cloudA"];
         this.cloudB = GV.MC_mapFrame["cloudB"];
         this.cloudC = GV.MC_mapFrame["cloudC"];
         this.cloudD = GV.MC_mapFrame["cloudD"];
         this.detail = GV.MC_mapFrame["detail"];
         this.keyInit();
      }
      
      private function keyInit() : void
      {
         this.getRandomCode();
         this.treasure_mc.x = -500;
         target_mc.coderB.x = -200;
         target_mc.coderC.x = -100;
         target_mc.getBuildCard_mc.addEventListener(MouseEvent.CLICK,this.showCaseHandler);
         target_mc.door.addEventListener(MouseEvent.CLICK,this.doorHandler);
         this.move_mc.gotoAndStop(1);
         this.isDoorOpen = true;
         this.presentTime = this.TOTAL_TIME;
         clearInterval(this.IntervalID);
         this.IntervalID = setInterval(this.timeDown,1000);
         this.move_mc.addEventListener("arrive_a",this.arriveHandler);
         this.move_mc.addEventListener("arrive_b",this.arriveHandler);
         this.move_mc.addEventListener("arrive_c",this.arriveHandler);
         this.move_mc.addEventListener("sound_a",this.soundHandler);
         this.move_mc.addEventListener("sound_b",this.soundHandler);
         this.move_mc.addEventListener("sound_c",this.soundHandler);
         this.addCodeInput();
         this.treasure_mc.cipher_mc0.mouseEnabled = false;
         this.treasure_mc.cipher_mc1.mouseEnabled = false;
         this.treasure_mc.cipher_mc2.mouseEnabled = false;
         this.treasure_mc.cipher_mc3.mouseEnabled = false;
         this.target_mc.successCase.visible = false;
         MainManager.getGameLevel().addChild(this.treasure_mc);
         MainManager.getGameLevel().addChild(target_mc.coderB);
         MainManager.getGameLevel().addChild(target_mc.coderC);
         MainManager.getGameLevel().addChild(this.bookMC);
         MainManager.getGameLevel().addChild(this.detail);
         target_mc.coderB_btn.addEventListener(MouseEvent.CLICK,this.showCodeB);
         target_mc.book_btn.addEventListener(MouseEvent.CLICK,this.showBook);
         target_mc.detailOpen.addEventListener(MouseEvent.CLICK,this.showDetail);
         this.cloudA.visible = false;
         this.cloudB.visible = false;
         this.cloudC.visible = false;
         this.cloudD.visible = false;
         this.cloudA.addEventListener(MouseEvent.CLICK,this.aClickHandler);
         this.cloudB.addEventListener(MouseEvent.CLICK,this.bClickHandler);
         this.cloudC.addEventListener(MouseEvent.CLICK,this.cClickHandler);
         this.cloudD.addEventListener(MouseEvent.CLICK,this.dClickHandler);
         this.loaderSound("resource/bgSounds/72/1.mp3",this.startSound);
         this.loaderSound("resource/bgSounds/72/2.mp3",this.sound_A);
         this.loaderSound("resource/bgSounds/72/3.mp3",this.sound_B);
         this.loaderSound("resource/bgSounds/72/4.mp3",this.sound_C);
      }
      
      private function showBook(e:MouseEvent) : void
      {
         this.bookMC.x = 470;
         this.bookMC.gotoAndStop(1);
      }
      
      private function showDetail(e:MouseEvent) : void
      {
         this.detail.x = 280;
      }
      
      private function aClickHandler(e:MouseEvent) : void
      {
         this.cloudA.visible = false;
         if(LocalUserInfo.isVIP())
         {
            Deal.BuyItem(12991,1,this.dealASuccess,this.dealFailed);
         }
         else
         {
            Alert.smileAlart("\t\t啊呀雲朵之翼消失了！只有超級拉姆的力量才可以捕獲雲朵之翼哦！");
         }
      }
      
      private function bClickHandler(e:MouseEvent) : void
      {
         this.cloudB.visible = false;
         Deal.BuyItem(190434,1,this.dealBSuccess,this.dealFailed);
      }
      
      private function cClickHandler(e:MouseEvent) : void
      {
         this.cloudC.visible = false;
         if(LocalUserInfo.isVIP())
         {
            Deal.BuyItem(12991,1,this.dealASuccess,this.dealFailed);
         }
         else
         {
            Alert.smileAlart("\t\t啊呀雲朵之翼消失了！只有超級拉姆的力量才可以捕獲雲朵之翼哦！");
         }
      }
      
      private function dClickHandler(e:MouseEvent) : void
      {
         this.cloudD.visible = false;
         Deal.BuyItem(190434,1,this.dealBSuccess,this.dealFailed);
      }
      
      private function dealASuccess(e:int) : void
      {
         Alert.getIconByID_Alart(12991,"\t \t恭喜你獲得雲朵之翼，已放入你的百寶箱中了!");
      }
      
      private function dealBSuccess(e:int) : void
      {
         Alert.getIconByID_Alart(190434,"\t 恭喜你獲得一片雲朵，已放入你的百寶箱中了！");
      }
      
      private function showCodeB(e:MouseEvent) : void
      {
         target_mc.coderB.x = 640;
         SimpleButton(target_mc.coderB.close_btn).addEventListener(MouseEvent.CLICK,this.closeCodeB);
      }
      
      private function showCodeC(e:MouseEvent) : void
      {
         target_mc.coderC.x = 920;
         SimpleButton(target_mc.coderC.close_btn).addEventListener(MouseEvent.CLICK,this.closeCodeC);
         ActivityTmpDataManager.getTransferItem(5);
      }
      
      private function closeCodeB(e:MouseEvent) : void
      {
         target_mc.coderB.x = -200;
      }
      
      private function closeCodeC(e:MouseEvent) : void
      {
         target_mc.coderC.x = -100;
      }
      
      private function doorHandler(e:MouseEvent) : void
      {
         if(this.isDoorOpen == false)
         {
            return;
         }
         if(this.status == 0)
         {
            GF.switchMap(83,true);
         }
         if(this.status == 1)
         {
            GF.switchMap(37,true);
         }
         if(this.status == 2)
         {
            GF.switchMap(33,true);
         }
      }
      
      private function randomCloud() : void
      {
         if(Math.random() > 0.5)
         {
            if(Math.random() > 0.5)
            {
               this.cloudA.gotoAndStop(2);
               this.cloudA.visible = true;
            }
            else
            {
               this.cloudB.gotoAndStop(2);
               this.cloudB.visible = true;
            }
         }
         else if(Math.random() > 0.5)
         {
            this.cloudC.gotoAndStop(2);
            this.cloudC.visible = true;
         }
         else
         {
            this.cloudD.gotoAndStop(2);
            this.cloudD.visible = true;
         }
      }
      
      private function timeDown() : void
      {
         --this.presentTime;
         var tempTen:uint = Math.floor(this.presentTime / 10);
         var tempUint:uint = this.presentTime - tempTen * 10;
         target_mc.timeCounter.ten.gotoAndStop(tempTen + 1);
         target_mc.timeCounter.unit.gotoAndStop(tempUint + 1);
         if(this.presentTime == 10)
         {
            this.startSound.play(0,2);
         }
         if(this.presentTime == 0)
         {
            this.presentTime = this.TOTAL_TIME;
            clearInterval(this.IntervalID);
            this.isDoorOpen = false;
            this.randomCloud();
            target_mc.coderC_btn0.addEventListener(MouseEvent.CLICK,this.showCodeC);
            target_mc.coderC_btn1.addEventListener(MouseEvent.CLICK,this.showCodeC);
            target_mc.coderC_btn2.addEventListener(MouseEvent.CLICK,this.showCodeC);
            target_mc.door.enabled = false;
            if(this.status == 0)
            {
               this.move_mc.gotoAndPlay(2);
               top_mc.top.gotoAndPlay(2);
            }
            else if(this.status == 1)
            {
               this.move_mc.gotoAndPlay(this.secenAframe);
               top_mc.top.gotoAndPlay(this.secenAframe);
            }
            else if(this.status == 2)
            {
               this.move_mc.gotoAndPlay(this.secenBframe);
               top_mc.top.gotoAndPlay(this.secenBframe);
            }
            else
            {
               trace("地圖狀態錯誤",this.status);
            }
         }
      }
      
      private function soundHandler(e:Event) : void
      {
         if(e.type == "sound_a")
         {
            this.sound_A.play(0,1);
         }
         if(e.type == "sound_b")
         {
            this.sound_B.play(0,1);
         }
         if(e.type == "sound_c")
         {
            this.sound_C.play(0,1);
         }
      }
      
      private function arriveHandler(e:Event) : void
      {
         this.move_mc.stop();
         if(e.type == "arrive_a")
         {
            trace("到達雪山頂");
            this.status = 1;
            top_mc.top.stop();
         }
         if(e.type == "arrive_b")
         {
            trace("到達城堡");
            this.status = 2;
            top_mc.top.stop();
         }
         if(e.type == "arrive_c")
         {
            trace("到達摩爾空地");
            this.status = 3;
            top_mc.top.stop();
            GF.switchMap(83,true);
            return;
         }
         clearInterval(this.IntervalID);
         this.IntervalID = setInterval(this.timeDown,1000);
         this.isDoorOpen = true;
         target_mc.coderC_btn0.removeEventListener(MouseEvent.CLICK,this.showCodeC);
         target_mc.coderC_btn1.removeEventListener(MouseEvent.CLICK,this.showCodeC);
         target_mc.coderC_btn2.removeEventListener(MouseEvent.CLICK,this.showCodeC);
         target_mc.door.enabled = true;
         this.cloudA.visible = false;
         this.cloudB.visible = false;
         this.cloudC.visible = false;
         this.cloudD.visible = false;
         this.cloudA.gotoAndStop(1);
         this.cloudB.gotoAndStop(1);
         this.cloudC.gotoAndStop(1);
         this.cloudD.gotoAndStop(1);
      }
      
      private function showCaseHandler(e:MouseEvent) : void
      {
         if(this.isCodeCorrect)
         {
            return;
         }
         this.treasure_mc.mouseChildren = true;
         this.treasure_mc.x = 470;
         target_mc.getBuildCard_mc.removeEventListener(MouseEvent.CLICK,this.showCaseHandler);
         SimpleButton(this.treasure_mc.close_btn).addEventListener(MouseEvent.CLICK,this.hideCaseHandler);
         SimpleButton(this.treasure_mc.submit_btn).addEventListener(MouseEvent.CLICK,this.submitHandler);
      }
      
      private function dealSuccess(e:int) : void
      {
         Alert.getIconByID_Alart(190427,"\t 恭喜你獲得炫風摩托車鑰匙，趕快去摩爾空地將它開走吧！");
      }
      
      private function dealFailed(e:int) : void
      {
         Alert.smileAlart("\t 你已經有這個寶貝啦，不能太貪心哦！");
      }
      
      private function hideCaseHandler(e:MouseEvent) : void
      {
         this.treasure_mc.mouseChildren = false;
         this.treasure_mc.x = -500;
         SimpleButton(this.treasure_mc.close_btn).removeEventListener(MouseEvent.CLICK,this.hideCaseHandler);
         target_mc.getBuildCard_mc.addEventListener(MouseEvent.CLICK,this.showCaseHandler);
         SimpleButton(this.treasure_mc.submit_btn).removeEventListener(MouseEvent.CLICK,this.submitHandler);
      }
      
      private function getRandomCode() : void
      {
         this.codeA = Math.random() * 9;
         this.codeB = 9;
         this.codeC = Math.random() * 9;
         this.codeD = 4;
         target_mc.coderB.code.gotoAndStop(this.codeA + 1);
         target_mc.coderC.code.gotoAndStop(this.codeC + 1);
      }
      
      private function submitHandler(e:MouseEvent) : void
      {
         var tempUint0:uint = this.treasure_mc.cipher_mc0.currentFrame - 1;
         var tempUint1:uint = this.treasure_mc.cipher_mc1.currentFrame - 1;
         var tempUint2:uint = this.treasure_mc.cipher_mc2.currentFrame - 1;
         var tempUint3:uint = this.treasure_mc.cipher_mc3.currentFrame - 1;
         if(this.codeA == tempUint0 && this.codeB == tempUint1 && this.codeC == tempUint2 && this.codeD == tempUint3)
         {
            trace("密碼輸入成功");
            this.treasure_mc.correct.gotoAndPlay(2);
            SimpleButton(this.treasure_mc.close_btn).removeEventListener(MouseEvent.CLICK,this.hideCaseHandler);
            target_mc.getBuildCard_mc.addEventListener(MouseEvent.CLICK,this.showCaseHandler);
            SimpleButton(this.treasure_mc.submit_btn).removeEventListener(MouseEvent.CLICK,this.submitHandler);
            clearTimeout(this.TimeoutID);
            this.TimeoutID = setTimeout(this.hideCase,1000);
            this.isCodeCorrect = true;
         }
         else
         {
            trace("密碼輸入失敗");
            this.treasure_mc.wrong.gotoAndPlay(2);
            this.isCodeCorrect = false;
         }
      }
      
      private function hideCase() : void
      {
         this.treasure_mc.x = -500;
         this.treasure_mc.mouseChildren = false;
         target_mc.getBuildCard_mc.visible = false;
         this.target_mc.successCase.visible = true;
         this.target_mc.successCase.gotoAndPlay(1);
         if(LocalUserInfo.isVIP())
         {
            Deal.BuyItem(190427,1,this.dealSuccess,this.dealFailed);
         }
         else
         {
            Alert.smileAlart("\t\t你很聰明哦，但是還需要超級拉姆的力量才可以拿起炫風摩托車鑰匙哦！");
         }
      }
      
      private function addCodeInput() : void
      {
         this.treasure_mc.btn0.addEventListener(MouseEvent.CLICK,this.changeCodeA);
         this.treasure_mc.btn1.addEventListener(MouseEvent.CLICK,this.changeCodeB);
         this.treasure_mc.btn2.addEventListener(MouseEvent.CLICK,this.changeCodeC);
         this.treasure_mc.btn3.addEventListener(MouseEvent.CLICK,this.changeCodeD);
      }
      
      private function changeCodeA(e:MouseEvent) : void
      {
         var tmepFrame:uint = uint(this.treasure_mc.cipher_mc0.currentFrame);
         if(tmepFrame == this.treasure_mc.cipher_mc0.totalFrames)
         {
            tmepFrame = 0;
         }
         this.treasure_mc.cipher_mc0.gotoAndStop(tmepFrame + 1);
         this.treasure_mc.effect0.gotoAndPlay(1);
      }
      
      private function changeCodeB(e:MouseEvent) : void
      {
         var tmepFrame:uint = uint(this.treasure_mc.cipher_mc1.currentFrame);
         if(tmepFrame == this.treasure_mc.cipher_mc1.totalFrames)
         {
            tmepFrame = 0;
         }
         this.treasure_mc.cipher_mc1.gotoAndStop(tmepFrame + 1);
         this.treasure_mc.effect1.gotoAndPlay(1);
      }
      
      private function changeCodeC(e:MouseEvent) : void
      {
         var tmepFrame:uint = uint(this.treasure_mc.cipher_mc2.currentFrame);
         if(tmepFrame == this.treasure_mc.cipher_mc2.totalFrames)
         {
            tmepFrame = 0;
         }
         this.treasure_mc.cipher_mc2.gotoAndStop(tmepFrame + 1);
         this.treasure_mc.effect2.gotoAndPlay(1);
      }
      
      private function changeCodeD(e:MouseEvent) : void
      {
         var tmepFrame:uint = uint(this.treasure_mc.cipher_mc3.currentFrame);
         if(tmepFrame == this.treasure_mc.cipher_mc3.totalFrames)
         {
            tmepFrame = 0;
         }
         this.treasure_mc.cipher_mc3.gotoAndStop(tmepFrame + 1);
         this.treasure_mc.effect3.gotoAndPlay(1);
      }
      
      private function loaderSound(Curl:String, Csound:Sound) : void
      {
         var request:URLRequest = VL.getURLRequest(Curl);
         Csound.load(request);
      }
      
      override public function destroy() : void
      {
         clearTimeout(this.TimeoutID);
         clearInterval(this.IntervalID);
         MainManager.getGameLevel().removeChild(this.treasure_mc);
         MainManager.getGameLevel().removeChild(target_mc.coderB);
         MainManager.getGameLevel().removeChild(target_mc.coderC);
         super.destroy();
      }
   }
}

