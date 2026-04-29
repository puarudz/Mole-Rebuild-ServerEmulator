package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.module.activityModule.Presented;
   import com.module.deal.Deal;
   import com.module.helpPanel.HelpPanel;
   import com.module.loadExtentPanel.LoadGame;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MagicRoom extends BasicMapView
   {
      
      private var mouse0ver:MovieClip;
      
      private var bookMC:MovieClip;
      
      private var roundSign:Boolean;
      
      private var roundImageType:int;
      
      private var roundCLType:int;
      
      private var myTimer:Timer;
      
      private var staticMoleTimer:Timer;
      
      private var jingziSign:int;
      
      private var pingziCount:int;
      
      private var yupenSign:int;
      
      private var checkFindObjectSign:int;
      
      private var birdSign:Boolean;
      
      private var huArray:Array = [false,false,false,false];
      
      public function MagicRoom()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.mouse0ver = GV.MC_mapFrame["mouse0ver"];
         this.bookMC = GV.MC_mapFrame["bookMC"];
         this.initRound();
         this.initMagicHat();
         this.initPingZiHelp();
         this.initStarBtn();
         this.initXianzhiqiu();
         this.initBookBtn();
         this.initMagicMirror();
         this.initTanzi();
         this.initTipsMessage();
      }
      
      private function initRound() : void
      {
         target_mc.roundRunBtn.addEventListener(MouseEvent.CLICK,this.onRoundRunBtn);
      }
      
      private function onRoundRunBtn(evt:MouseEvent) : void
      {
         target_mc.roundImage.isStop1 = false;
         target_mc.roundCL.isStop = false;
         target_mc.tage.gotoAndStop(1);
         target_mc.roundImage.addEventListener("StopMc",this.onStopMc);
         target_mc.roundImage.play();
      }
      
      private function onStopMc(evt:EventTaomee) : void
      {
         target_mc.roundImage.removeEventListener("StopMc",this.onStopMc);
         this.roundImageType = evt.EventObj.sign;
         target_mc.roundCL.addEventListener("StopMc_CL",this.onStopMcCL);
         target_mc.roundCL.play();
      }
      
      private function onStopMcCL(evt:EventTaomee) : void
      {
         target_mc.roundCL.removeEventListener("StopMc_CL",this.onStopMcCL);
         this.roundCLType = evt.EventObj.sign;
         if(this.roundImageType != 0 && this.roundCLType != 0)
         {
            if(this.roundCLType == this.roundImageType)
            {
               if(this.roundCLType == 1)
               {
                  depth_mc.hu.gotoAndStop(2);
                  this.bookMC.starOk = true;
               }
               else if(this.roundCLType == 2)
               {
                  depth_mc.hu.gotoAndStop(3);
                  this.bookMC.ballOk = true;
               }
               target_mc.tage.gotoAndStop(3);
               this.staticMoleTimer = new Timer(10000,1);
               this.staticMoleTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onStaticMoleTimer);
               this.mouse0ver.gotoAndStop(2);
               target_mc.showStar.x = GV.MAN_PEOPLE.x;
               target_mc.showStar.y = GV.MAN_PEOPLE.y + target_mc.showStar.height;
               this.staticMoleTimer.start();
            }
            else
            {
               target_mc.tage.gotoAndStop(2);
               depth_mc.hu.gotoAndStop(4);
            }
         }
         else
         {
            target_mc.tage.gotoAndStop(2);
            depth_mc.hu.gotoAndStop(4);
         }
         this.roundImageType = 0;
      }
      
      private function onStaticMoleTimer(evt:TimerEvent) : void
      {
         if(this.staticMoleTimer != null)
         {
            this.staticMoleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onStaticMoleTimer);
            this.staticMoleTimer.stop();
            this.staticMoleTimer = null;
         }
         this.mouse0ver.gotoAndStop(1);
         target_mc.showStar.x = 1100;
         target_mc.showStar.y = 400;
         target_mc.lahmyaowan.visible = true;
         depth_mc.lahmyaowan.visible = true;
         target_mc.lahmyaowan.addEventListener(MouseEvent.CLICK,this.onLahmyaowan);
      }
      
      private function onLahmyaowan(evt:MouseEvent) : void
      {
         target_mc.lahmyaowan.removeEventListener(MouseEvent.CLICK,this.onLahmyaowan);
         target_mc.lahmyaowan.visible = false;
         depth_mc.lahmyaowan.visible = false;
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            top_mc.lahmVideo.x = 708;
            top_mc.lahmVideo.y = 428;
            top_mc.lahmVideo.addEventListener("lahmVideo_Over",this.onLahmVideoOver);
            top_mc.lahmVideo.play();
            GV.onlineClass.chating(0,"/hc");
            if(this.roundCLType == 1)
            {
               Deal.BuyItem(190415,1,function(... e):*
               {
                  Alert.getIconByID_Alart(190415,"    恭喜你得到魔法星星變身丸，已經放入你的百寶箱中了！");
               },function(... e):*
               {
                  Alert.smileAlart("    魔法星星變身丸獲取失敗！");
               });
               this.roundCLType = 0;
            }
            else if(this.roundCLType == 2)
            {
               Deal.BuyItem(190416,1,function(... e):*
               {
                  Alert.getIconByID_Alart(190416,"    恭喜你得到魔法先知球變身丸，已經放入你的百寶箱中了！");
               },function(... e):*
               {
                  Alert.smileAlart("    魔法先知球變身丸獲取失敗！");
               });
               this.roundCLType = 0;
            }
         }
         else
         {
            Presented.getInstance().FreeReceive(18);
         }
      }
      
      private function onLahmVideoOver(evt:Event) : void
      {
         top_mc.lahmVideo.removeEventListener("lahmVideo_Over",this.onLahmVideoOver);
         target_mc.bookBtn.gotoAndStop(2);
         top_mc.lahmVideo.x = 708;
         top_mc.lahmVideo.y = -296;
      }
      
      private function initMagicHat() : void
      {
         target_mc.yaoshui.buttonMode = true;
         target_mc.yaoshui.addEventListener(MouseEvent.CLICK,this.onYaoShui);
      }
      
      private function onYaoShui(evt:MouseEvent) : void
      {
         target_mc.jingzi.gotoAndStop(1);
         target_mc.yaoshui.addEventListener("yaoshui_over",this.onYaoShuiOver);
         target_mc.yaoshui.play();
      }
      
      private function onYaoShuiOver(evt:Event) : void
      {
         target_mc.yaoshui.removeEventListener("yaoshui_over",this.onYaoShuiOver);
         target_mc.jingzi.buttonMode = true;
         target_mc.jingzi.addEventListener("getObject",this.onJingZi);
         target_mc.jingzi.gotoAndStop(2);
      }
      
      private function onJingZi(evt:Event) : void
      {
         target_mc.jingzi.removeEventListener("getObject",this.onJingZi);
         this.jingziSign = evt.currentTarget.currentFrame;
         target_mc.jingzi.addEventListener(MouseEvent.CLICK,this.onJingZiClick);
      }
      
      private function onJingZiClick(evt:MouseEvent) : void
      {
         target_mc.jingzi.removeEventListener(MouseEvent.CLICK,this.onJingZiClick);
         if(this.jingziSign == 3)
         {
            target_mc.yaoshui.gotoAndStop(1);
            target_mc.jingzi.gotoAndStop(1);
            target_mc.jingzi.buttonMode = false;
            trace("輸出魔法帽子!!");
            if(GV.MAN_PEOPLE.Petlevel != 101)
            {
               GF.showAlert(GV.MC_AppLever,"\t只有超級拉姆的神奇能力才能幫你獲得這頂神奇的魔法帽！","",100,"iknow",true,false,"E");
            }
         }
         else if(this.jingziSign == 4)
         {
            target_mc.jingzi.buttonMode = false;
            target_mc.yaoshui.gotoAndStop(1);
            target_mc.jingzi.gotoAndStop(1);
         }
         else if(this.jingziSign == 6)
         {
            target_mc.jingzi.buttonMode = false;
            trace("輸出魔法鏡子!!");
            if(GV.MAN_PEOPLE.Petlevel == 101)
            {
               Deal.BuyItem(160424,1,function(... e):*
               {
                  Alert.getIconByID_Alart(160424,"    恭喜你，獲得一件拉姆魔法鏡，已放入你的小屋倉庫中了！");
               },function(... e):*
               {
                  Alert.smileAlart("    你已經擁有這件寶貝啦，所以不能再領取了哦！");
               });
            }
            else
            {
               GF.showAlert(GV.MC_AppLever,"\t只有超級拉姆的神奇能力才能幫你獲得這面神奇的魔鏡哦！","",100,"iknow",true,false,"E");
            }
         }
         this.jingziSign = 0;
      }
      
      private function initPingZiHelp() : void
      {
         for(var pingziRound:int = 0; pingziRound < 5; pingziRound++)
         {
            target_mc["ping" + pingziRound].buttonMode = true;
            target_mc["ping" + pingziRound].addEventListener(MouseEvent.CLICK,this.onPingBox);
         }
      }
      
      private function onPingBox(evt:MouseEvent) : void
      {
         evt.currentTarget.play();
      }
      
      private function onPinghelp(evt:MouseEvent) : void
      {
         trace("瓶子幫助");
         var loadGame:LoadGame = new LoadGame("module/external/FantasyHouseMain.swf","正在打開面板",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function initStarBtn() : void
      {
         target_mc.starBtn.buttonMode = true;
         target_mc.starBtn.addEventListener(MouseEvent.CLICK,this.onStarBtn);
      }
      
      private function onStarBtn(evt:MouseEvent) : void
      {
         target_mc.starBtn.removeEventListener(MouseEvent.CLICK,this.onStarBtn);
         target_mc.starBtn.gotoAndPlay(2);
         target_mc.bigStar.buttonMode = true;
         target_mc.bigStar.addEventListener(MouseEvent.CLICK,this.onBigStar);
         target_mc.bigStar.gotoAndPlay(2);
      }
      
      private function onBigStar(evt:MouseEvent) : void
      {
         trace("星星幫助");
         creatShareObject.getInstance().setLahuWood(XMLInfo.MantraArray1[0]);
         PeopleManageView(GV.MAN_PEOPLE).addWoodPet(XMLInfo.MantraArray1[0]);
         GC.clearGTimeout(this.myTimer);
         this.myTimer = GC.setGTimeout(function():*
         {
            creatShareObject.getInstance().setLahuWood("");
            GC.clearAllChildren(GV.MAN_PEOPLE.avatarMC.pet_mc);
            PeopleManageView(GV.MAN_PEOPLE).addPet();
         },10000);
      }
      
      private function initXianzhiqiu() : void
      {
         target_mc.xianzhiqiu.buttonMode = true;
         target_mc.xianzhiqiu.addEventListener(MouseEvent.CLICK,this.onXianzhiqiu);
      }
      
      private function onXianzhiqiu(evt:MouseEvent) : void
      {
         target_mc.xianzhiqiu.removeEventListener(MouseEvent.CLICK,this.onXianzhiqiu);
         target_mc.xianzhiqiu.gotoAndPlay(2);
         target_mc.bigXianzhiqiu.buttonMode = true;
         target_mc.bigXianzhiqiu.addEventListener(MouseEvent.CLICK,this.onBigXianzhiqiu);
         target_mc.bigXianzhiqiu.gotoAndPlay(2);
      }
      
      private function onBigXianzhiqiu(evt:MouseEvent) : void
      {
         trace("先知球幫助");
         creatShareObject.getInstance().setLahuWood(XMLInfo.MantraArray1[1]);
         PeopleManageView(GV.MAN_PEOPLE).addWoodPet(XMLInfo.MantraArray1[1]);
         GC.clearGTimeout(this.myTimer);
         this.myTimer = GC.setGTimeout(function():*
         {
            creatShareObject.getInstance().setLahuWood("");
            GC.clearAllChildren(GV.MAN_PEOPLE.avatarMC.pet_mc);
            PeopleManageView(GV.MAN_PEOPLE).addPet();
         },10000);
      }
      
      private function initBookBtn() : void
      {
         target_mc.bookBtn.buttonMode = true;
         target_mc.bookBtn.addEventListener(MouseEvent.CLICK,this.onBookBtn);
      }
      
      private function onBookBtn(evt:MouseEvent) : void
      {
         trace("點魔法書");
         target_mc.zhezhu.gotoAndStop(2);
         this.bookMC.mofacidian.gotoAndStop(1);
         this.bookMC.mofacidian.visible = true;
         this.bookMC.mofacidian.x = 685;
      }
      
      private function initMagicMirror() : void
      {
         target_mc.mafaqiu.buttonMode = true;
         target_mc.mafaqiu.addEventListener(MouseEvent.CLICK,this.onMafaqiu);
         target_mc.yupen.buttonMode = true;
         target_mc.yupen.addEventListener(MouseEvent.CLICK,this.onYupen);
         target_mc.zhuanshibook.buttonMode = true;
         target_mc.zhuanshibook.addEventListener(MouseEvent.CLICK,this.onZSBook);
         target_mc.bird0.buttonMode = true;
         target_mc.bird0.addEventListener(MouseEvent.CLICK,this.onBird);
         target_mc.bird1.buttonMode = true;
         target_mc.bird1.addEventListener(MouseEvent.CLICK,this.onBird);
         depth_mc.hu.addEventListener("hu_over",this.onHuOver);
      }
      
      private function onMafaqiu(evt:MouseEvent) : void
      {
         target_mc.mafaqiu.removeEventListener(MouseEvent.CLICK,this.onMafaqiu);
         target_mc.mafaqiu.buttonMode = false;
         evt.currentTarget.gotoAndStop(2);
         this.huArray[0] = true;
      }
      
      private function onYupen(evt:MouseEvent) : void
      {
         target_mc.yupen.removeEventListener(MouseEvent.CLICK,this.onYupen);
         target_mc.yupen.addEventListener("yupen_over",this.onYuPen);
         evt.currentTarget.gotoAndPlay(evt.currentTarget.currentFrame + 1);
      }
      
      private function onYuPen(evt:Event) : void
      {
         target_mc.yupen.removeEventListener("yupen_over",this.onYuPen);
         target_mc.yupen.addEventListener(MouseEvent.CLICK,this.onYupen);
         if(this.yupenSign == 2)
         {
            target_mc.yupen.removeEventListener(MouseEvent.CLICK,this.onYupen);
            evt.currentTarget.buttonMode = false;
            this.huArray[1] = true;
         }
         ++this.yupenSign;
      }
      
      private function onZSBook(evt:MouseEvent) : void
      {
         target_mc.zhuanshibook.addEventListener("book_down",this.onBookDown);
         evt.currentTarget.nextFrame();
      }
      
      private function onBookDown(evt:Event) : void
      {
         target_mc.zhuanshibook.removeEventListener("book_down",this.onBookDown);
         if(evt.currentTarget.currentFrame == 4)
         {
            target_mc.zhuanshibook.removeEventListener(MouseEvent.CLICK,this.onZSBook);
            evt.currentTarget.buttonMode = false;
            this.huArray[2] = true;
         }
      }
      
      private function onBird(evt:MouseEvent) : void
      {
         evt.currentTarget.removeEventListener(MouseEvent.CLICK,this.onBird);
         if(!this.birdSign)
         {
            evt.currentTarget.addEventListener("bird_over",this.onBirdOver);
            evt.currentTarget.gotoAndPlay(2);
            this.birdSign = true;
         }
      }
      
      private function onBirdOver(evt:Event) : void
      {
         var birdNum:int = int(String(evt.currentTarget.name).slice(4));
         evt.currentTarget.removeEventListener("bird_over",this.onBirdOver);
         target_mc.bird0.buttonMode = false;
         target_mc.bird0.removeEventListener(MouseEvent.CLICK,this.onBird);
         target_mc.bird1.buttonMode = false;
         target_mc.bird1.removeEventListener(MouseEvent.CLICK,this.onBird);
         target_mc["yezi" + birdNum].visible = true;
         target_mc["yezi" + birdNum].buttonMode = true;
         target_mc["yezi" + birdNum].addEventListener(MouseEvent.CLICK,this.onYezi);
      }
      
      private function onYezi(evt:MouseEvent) : void
      {
         evt.currentTarget.removeEventListener(MouseEvent.CLICK,this.onYezi);
         evt.currentTarget.gotoAndPlay(2);
         this.huArray[3] = true;
      }
      
      private function onHuOver(evt:Event) : void
      {
         if(Boolean(this.huArray[0]) && Boolean(this.huArray[1]) && Boolean(this.huArray[2]) && Boolean(this.huArray[3]))
         {
            depth_mc.hu.removeEventListener("hu_over",this.onHuOver);
            depth_mc.hu.gotoAndStop(6);
            target_mc.jingzi.addEventListener("over",this.onJingZiOver);
         }
      }
      
      private function onJingZiOver(evt:Event) : void
      {
         target_mc.jingzi.removeEventListener("over",this.onJingZiOver);
         this.jingziSign = 6;
         target_mc.jingzi.buttonMode = true;
         target_mc.jingzi.addEventListener(MouseEvent.CLICK,this.onJingZiClick);
      }
      
      private function initTanzi() : void
      {
         target_mc.tanzi.buttonMode = true;
         target_mc.tanzi.addEventListener(MouseEvent.CLICK,this.onTanzi);
      }
      
      private function onTanzi(evt:MouseEvent) : void
      {
         target_mc.tanzi.gotoAndPlay(2);
      }
      
      private function initTipsMessage() : void
      {
         target_mc.tipsMessage.addEventListener(MouseEvent.CLICK,this.onTipsMessage);
      }
      
      private function onTipsMessage(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("tips");
      }
      
      override public function destroy() : void
      {
         GC.clearGTimeout(this.myTimer);
         target_mc.tanzi.removeEventListener(MouseEvent.CLICK,this.onTanzi);
         target_mc.jingzi.removeEventListener("over",this.onJingZiOver);
         depth_mc.hu.removeEventListener("hu_over",this.onHuOver);
         target_mc.yezi0.removeEventListener(MouseEvent.CLICK,this.onYezi);
         target_mc.yezi1.removeEventListener(MouseEvent.CLICK,this.onYezi);
         target_mc.bird0.removeEventListener(MouseEvent.CLICK,this.onBird);
         target_mc.bird1.removeEventListener(MouseEvent.CLICK,this.onBird);
         target_mc.bird0.removeEventListener("bird_over",this.onBirdOver);
         target_mc.bird1.removeEventListener("bird_over",this.onBirdOver);
         target_mc.zhuanshibook.removeEventListener("book_down",this.onBookDown);
         target_mc.zhuanshibook.removeEventListener(MouseEvent.CLICK,this.onZSBook);
         target_mc.yupen.removeEventListener("yupen_over",this.onYuPen);
         target_mc.yupen.removeEventListener(MouseEvent.CLICK,this.onYupen);
         target_mc.mafaqiu.removeEventListener(MouseEvent.CLICK,this.onMafaqiu);
         target_mc.bookBtn.removeEventListener(MouseEvent.CLICK,this.onBookBtn);
         target_mc.bigXianzhiqiu.removeEventListener(MouseEvent.CLICK,this.onBigXianzhiqiu);
         target_mc.xianzhiqiu.removeEventListener(MouseEvent.CLICK,this.onXianzhiqiu);
         target_mc.bigStar.removeEventListener(MouseEvent.CLICK,this.onBigStar);
         target_mc.starBtn.removeEventListener(MouseEvent.CLICK,this.onStarBtn);
         target_mc.pinghelp.removeEventListener(MouseEvent.CLICK,this.onPinghelp);
         for(var pingziRound:int = 0; pingziRound < 5; pingziRound++)
         {
            target_mc["ping" + pingziRound].buttonMode = false;
            target_mc["ping" + pingziRound].removeEventListener(MouseEvent.CLICK,this.onPingBox);
         }
         target_mc.jingzi.removeEventListener(MouseEvent.CLICK,this.onJingZiClick);
         target_mc.jingzi.removeEventListener("getObject",this.onJingZi);
         target_mc.yaoshui.removeEventListener("yaoshui_over",this.onYaoShuiOver);
         target_mc.yaoshui.removeEventListener(MouseEvent.CLICK,this.onYaoShui);
         target_mc.lahmyaowan.removeEventListener(MouseEvent.CLICK,this.onLahmyaowan);
         top_mc.lahmVideo.removeEventListener("lahmVideo_Over",this.onLahmVideoOver);
         target_mc.lahmyaowan.removeEventListener(MouseEvent.CLICK,this.onLahmyaowan);
         if(this.staticMoleTimer != null)
         {
            this.staticMoleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onStaticMoleTimer);
            this.staticMoleTimer.stop();
            this.staticMoleTimer = null;
         }
         target_mc.roundCL.removeEventListener("StopMc_CL",this.onStopMcCL);
         target_mc.roundImage.removeEventListener("StopMc",this.onStopMc);
         target_mc.roundRunBtn.removeEventListener(MouseEvent.CLICK,this.onRoundRunBtn);
         super.destroy();
      }
   }
}

