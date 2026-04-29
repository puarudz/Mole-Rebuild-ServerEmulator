package com.module.hitMice
{
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.randomItemDrawLogic.randomItemDrawLogic;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.errors.MemoryError;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class HitMice
   {
      
      private var timer1:Timer;
      
      private var timer3:Timer;
      
      private var main:MovieClip;
      
      private var num:int;
      
      private var hitMouse:int;
      
      private var hitGenius:int;
      
      private var gameOver:*;
      
      private var good:*;
      
      private var lose:*;
      
      private var tree:*;
      
      private var arrow:*;
      
      private var hitMusic:Sound;
      
      private var mouseRun:Sound;
      
      private var comeMusic:Sound;
      
      private var geniusNum:Number;
      
      private var mouseNum:Number;
      
      private var treeX:Number;
      
      private var treeContain:MovieClip;
      
      private var valFunc:uint;
      
      private var flag:Boolean;
      
      private var gameOverBool:Boolean;
      
      private var hitBool:Boolean;
      
      private var soundChannel1:SoundChannel;
      
      public function HitMice(mainline:MovieClip)
      {
         super();
         this.main = new MovieClip();
         this.main = mainline;
         this.main.Hammer.addEventListener(MouseEvent.CLICK,this.startGame);
      }
      
      private function startGame(event:MouseEvent) : void
      {
         GV.isChangeMap = true;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeHandler);
         this.main.Hammer.removeEventListener(MouseEvent.CLICK,this.startGame);
         this.hideToolHandler();
         this.treeContain = new MovieClip();
         this.main.addChild(this.treeContain);
         this.soundChannel1 = new SoundChannel();
         this.gameOverBool = false;
         this.hitBool = false;
         this.geniusNum = 0.3;
         this.mouseNum = 0.7;
         this.main.Hammer.gotoAndStop(1);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.HammerMouseOver);
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.HammerMouseDown);
         this.timer1 = new Timer(300000,1);
         this.timer1.addEventListener(TimerEvent.TIMER_COMPLETE,this.timer1Handler);
         this.timer1.start();
         try
         {
            this.valFunc = setInterval(this.interFunc,800);
         }
         catch(e:MemoryError)
         {
         }
         this.timer3 = new Timer(60000,5);
         this.timer3.addEventListener(TimerEvent.TIMER,this.timer3Handler);
         this.timer3.start();
      }
      
      private function timer3Handler(event:TimerEvent) : void
      {
         switch(this.timer3.currentCount)
         {
            case 1:
               this.geniusNum = 0.25;
               this.mouseNum = 0.75;
               break;
            case 2:
               this.geniusNum = 0.2;
               this.mouseNum = 0.8;
               break;
            case 3:
               this.geniusNum = 0.15;
               this.mouseNum = 0.85;
               break;
            case 4:
               this.geniusNum = 0.1;
               this.mouseNum = 0.9;
               break;
            case 5:
               this.geniusNum = 0.08;
               this.mouseNum = 0.92;
         }
      }
      
      private function HammerMouseOver(event:MouseEvent) : void
      {
         Mouse.hide();
         this.main.Hammer.x = event.stageX;
         this.main.Hammer.y = event.stageY;
         event.updateAfterEvent();
         if(Boolean(this.main.Hammer.hitTestObject(this.main.hit_mc)))
         {
            this.main.arrowMC.visible = true;
            this.main.arrowMC.gotoAndPlay(2);
         }
         else
         {
            this.main.arrowMC.visible = false;
            this.main.arrowMC.gotoAndStop(1);
         }
      }
      
      private function HammerMouseDown(event:MouseEvent) : void
      {
         this.main.Hammer.gotoAndPlay(10);
         if(Boolean(this.main.Hammer.hitTestObject(this.main.hit_mc)))
         {
            this.hitBool = true;
            this.timer1Handler();
         }
         if(this.num > 0)
         {
            if(this.main["Hog" + [this.num]].currentFrame >= 4 && this.main["Hog" + [this.num]].currentFrame <= 16)
            {
               if(Boolean(this.main.Hammer.hitTestPoint(this.main["Hog" + [this.num]].x,this.main["Hog" + [this.num]].y,true)))
               {
                  this.main["Hog" + [this.num]].gotoAndPlay(22);
                  this.hitMusic = new (GV.Lib_Map.getClass("HitMusic") as Class)();
                  this.soundChannel1 = this.hitMusic.play();
                  this.judgeName(this.main["Hog" + [this.num]].name);
                  this.gameOverHandler();
               }
            }
            else
            {
               this.mouseRun = new (GV.Lib_Map.getClass("MouseRun") as Class)();
               this.soundChannel1 = this.mouseRun.play();
            }
         }
      }
      
      private function judgeName(nameStr:String) : void
      {
         switch(nameStr)
         {
            case "Hog1":
               ++this.hitMouse;
               this.treeRand();
               break;
            case "Hog2":
               ++this.hitMouse;
               this.treeRand();
               break;
            case "Hog3":
               ++this.hitMouse;
               this.treeRand();
               break;
            case "Hog4":
               ++this.hitMouse;
               this.treeRand();
               break;
            case "Hog5":
               ++this.hitMouse;
               this.treeRand();
               break;
            case "Hog6":
               ++this.hitMouse;
               this.treeRand();
               break;
            case "Hog7":
               ++this.hitMouse;
               this.treeRand();
               break;
            case "Hog8":
               ++this.hitMouse;
               this.treeRand();
               break;
            case "Hog9":
               ++this.hitMouse;
               this.treeRand();
               break;
            case "Hog10":
               ++this.hitGenius;
               break;
            case "Hog11":
               ++this.hitGenius;
               break;
            case "Hog12":
               ++this.hitGenius;
               break;
            case "Hog13":
               ++this.hitGenius;
               break;
            case "Hog14":
               ++this.hitGenius;
               break;
            case "Hog15":
               ++this.hitGenius;
               break;
            case "Hog16":
               ++this.hitGenius;
               break;
            case "Hog17":
               ++this.hitGenius;
               break;
            case "Hog18":
               ++this.hitGenius;
         }
      }
      
      private function interFunc() : void
      {
         var randNum:Number = Math.random();
         if(randNum <= this.geniusNum)
         {
            this.num = Math.ceil(Math.random() * 9 + 9);
            this.main["Hog" + [this.num]].gotoAndPlay(2);
            this.mouseCome();
         }
         else if(randNum <= this.mouseNum)
         {
            this.num = Math.round(Math.random() * 8 + 1);
            this.main["Hog" + [this.num]].gotoAndPlay(2);
            this.mouseCome();
         }
      }
      
      private function mouseCome() : void
      {
         this.comeMusic = new (GV.Lib_Map.getClass("ComeMusic") as Class)();
         this.soundChannel1 = this.comeMusic.play();
      }
      
      private function gameOverHandler() : void
      {
         if(this.hitMouse == 20)
         {
            this.flag = true;
            this.goodPanle();
            this.clearEvent();
         }
         if(this.hitGenius == 10)
         {
            this.flag = false;
            this.losePanle();
            this.clearEvent();
         }
      }
      
      private function clearEvent() : void
      {
         this.gameOverBool = true;
         this.timer1Handler();
      }
      
      private function sinkerPlace() : void
      {
         try
         {
            this.main.Hammer.x = 500.2;
            this.main.Hammer.y = 234;
            this.main.Hammer.gotoAndPlay(44);
         }
         catch(E:Error)
         {
            trace(E,this);
         }
      }
      
      private function jumpPanle() : void
      {
         try
         {
            this.gameOver = new (GV.Lib_Map.getClass("Panle") as Class)();
            MainManager.getAppLevel().addChild(this.gameOver);
            this.gameOver.x = (MainManager.getStageWidth() - this.gameOver.width) / 2;
            this.gameOver.y = (MainManager.getStageHeight() - this.gameOver.height) / 2;
            if(this.flag == true)
            {
               this.clearGood();
               this.gameOver.pic.gotoAndStop(1);
               GV.onlineSocket.addEventListener("giveMoneyEvent",this.getMoneyHandler);
               randomItemDrawLogic.moneyAction([{
                  "kind":17001,
                  "num":1
               }],0);
            }
            else
            {
               this.clearLose();
               this.gameOver.pic.gotoAndStop(2);
               this.gameOver.panle_txt.text = "你誤打了10個拉姆。";
            }
            MainManager.getAppLevel().addChild(this.gameOver);
            this.gameOver.panleBtn.addEventListener(MouseEvent.CLICK,this.clickPanleHandler);
            this.gameOver.panlemc.addEventListener(MouseEvent.MOUSE_DOWN,this.gameOverMouseDown);
            this.gameOver.panlemc.addEventListener(MouseEvent.MOUSE_DOWN,this.gameOverMouseOver);
         }
         catch(E:Error)
         {
            trace(E,this);
         }
      }
      
      private function getMoneyHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("giveMoneyEvent",this.getMoneyHandler);
         this.gameOver.panle_txt.text = "   厲害！你打中20個樹洞怪" + "\n" + "物，獲得1個稻草人果實.";
      }
      
      private function goodPanle() : void
      {
         this.good = new (GV.Lib_Map.getClass("GOOD") as Class)();
         this.good.x = 400;
         this.good.y = 130;
         MainManager.getAppLevel().addChild(this.good);
      }
      
      private function losePanle() : void
      {
         this.lose = new (GV.Lib_Map.getClass("LOSE") as Class)();
         this.lose.x = 400;
         this.lose.y = 130;
         MainManager.getAppLevel().addChild(this.lose);
      }
      
      private function treeRand() : void
      {
         this.treeX = Math.random() * 230 + 240;
         this.tree = new (GV.Lib_Map.getClass("TREE") as Class)();
         this.tree.x = this.treeX;
         this.tree.y = 0;
         this.tree.name = "tree" + this.treeX;
         this.treeContain.addChild(this.tree);
      }
      
      private function clearGood() : void
      {
         MainManager.getAppLevel().removeChild(this.good);
         this.good = null;
      }
      
      private function clearLose() : void
      {
         MainManager.getAppLevel().removeChild(this.lose);
         this.lose = null;
      }
      
      private function clearTree() : void
      {
         var treeMc:DisplayObject = null;
         for(var i:int = this.treeContain.numChildren - 1; i >= 0; i--)
         {
            treeMc = this.treeContain.getChildAt(i);
            DisplayUtil.removeForParent(treeMc,false);
         }
      }
      
      private function clickPanleHandler(event:MouseEvent) : void
      {
         this.gameOver.panleBtn.removeEventListener(MouseEvent.CLICK,this.clickPanleHandler);
         this.gameOver.panleBtn.removeEventListener(MouseEvent.CLICK,this.clickPanleHandler);
         this.gameOver.panlemc.removeEventListener(MouseEvent.MOUSE_DOWN,this.gameOverMouseDown);
         this.gameOver.panlemc.removeEventListener(MouseEvent.MOUSE_DOWN,this.gameOverMouseOver);
         MainManager.getAppLevel().removeChild(this.gameOver);
         this.gameOver = null;
         this.main.Hammer.addEventListener(MouseEvent.CLICK,this.startGame);
      }
      
      private function gameOverMouseDown(event:MouseEvent) : void
      {
         GF.setDrag(this.gameOver);
      }
      
      private function gameOverMouseOver(event:MouseEvent) : void
      {
         GF.stopDrag(this.gameOver);
      }
      
      private function timer1Handler(event:* = null) : void
      {
         this.showToolHandler();
         GV.isChangeMap = false;
         Mouse.show();
         this.hitMouse = 0;
         this.hitGenius = 0;
         clearInterval(this.valFunc);
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.HammerMouseOver);
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.HammerMouseDown);
         if(Boolean(this.timer1))
         {
            this.timer1.stop();
            this.timer1.removeEventListener(TimerEvent.TIMER_COMPLETE,this.timer1Handler);
            this.timer1 = null;
         }
         if(Boolean(this.timer3))
         {
            this.timer3.stop();
            this.timer3.removeEventListener(TimerEvent.TIMER,this.timer3Handler);
            this.timer3 = null;
         }
         if(this.soundChannel1 != null)
         {
            this.soundChannel1.stop();
         }
         if(this.hitBool == false)
         {
            this.main.Hammer.gotoAndPlay(28);
            try
            {
               setTimeout(this.sinkerPlace,1000);
            }
            catch(E:*)
            {
            }
         }
         else
         {
            this.main.Hammer.gotoAndPlay(68);
            this.main.Hammer.x = 500.2;
            this.main.Hammer.y = 234;
         }
         this.clearTree();
         DisplayUtil.removeForParent(this.treeContain);
         if(this.gameOverBool)
         {
            setTimeout(this.jumpPanle,2000);
         }
         else
         {
            this.main.Hammer.addEventListener(MouseEvent.CLICK,this.startGame);
         }
      }
      
      private function removeHandler(evt:EventTaomee) : void
      {
         this.timer1Handler();
         DisplayUtil.removeForParent(this.main);
         BC.removeEvent(this);
      }
      
      private function hideToolHandler() : void
      {
         var toolBar_MC:* = MainManager.getToolLevel().getChildByName("tool_mc");
         if(toolBar_MC != null)
         {
            toolBar_MC.house2_btn.visible = false;
            toolBar_MC.friend_btn.visible = false;
            toolBar_MC.bag_btn.visible = false;
         }
      }
      
      private function showToolHandler() : void
      {
         var toolBar_MC:* = MainManager.getToolLevel().getChildByName("tool_mc");
         if(toolBar_MC != null)
         {
            toolBar_MC.house2_btn.visible = true;
            toolBar_MC.friend_btn.visible = true;
            toolBar_MC.bag_btn.visible = true;
         }
      }
   }
}

