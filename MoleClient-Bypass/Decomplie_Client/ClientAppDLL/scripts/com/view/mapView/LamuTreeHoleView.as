package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.module.activityModule.Presented;
   import com.mole.app.map.MapBase;
   import com.view.LamuWorld.LamuWorld;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class LamuTreeHoleView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var temp_mc:MovieClip;
      
      public var type_mc:MovieClip;
      
      public var hertaos:Array;
      
      private var moveWalnuts:Array;
      
      private var timer:Timer;
      
      private var gravity:Number = 5;
      
      private var ci_mc:MovieClip;
      
      private var touchArea:MovieClip;
      
      private var subone_mc:MovieClip;
      
      private var tortoise_mc:MovieClip;
      
      private var stopArea:MovieClip;
      
      private var timeID:int;
      
      private var hitSaveTime:Boolean;
      
      private var i:int = 0;
      
      private var leftGotted:Boolean;
      
      private var rightGotted:Boolean;
      
      public function LamuTreeHoleView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         var i:int = 0;
         var swifWalnt:MovieClip = null;
         var moveWalnut:MovieClip = null;
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.temp_mc = GV.MC_mapFrame["temp_mc"];
         this.type_mc = GV.MC_mapFrame["type_mc"];
         this.stopArea = this.type_mc.stopArea;
         this.type_mc.removeChild(this.stopArea);
         MapModelLogic.owner.makeMapArray(true);
         this.tortoise_mc = this.temp_mc.tortoise_mc;
         this.ci_mc = this.target_mc.ci_mc;
         this.touchArea = this.botton_mc.touchArea;
         this.subone_mc = this.top_mc.subone_mc;
         this.subone_mc.x = -500;
         this.timer = new Timer(1200);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this.timer.start();
         this.hertaos = [];
         this.moveWalnuts = [];
         var Walnut:Class = GV.Lib_Map.getClass("Walnut");
         for(i = 1; i < 7; i++)
         {
            swifWalnt = this.top_mc["hetao" + i];
            swifWalnt.i = i;
            swifWalnt.gotoAndPlay(int(Math.random() * swifWalnt.totalFrames) + 1);
            this.hertaos.push(swifWalnt);
            moveWalnut = new Walnut();
            if(i == 1 || i == 5)
            {
               moveWalnut.scaleX = moveWalnut.scaleY = swifWalnt.scaleX = swifWalnt.scaleY = 2;
               swifWalnt.buttonMode = true;
               BC.addEvent(this,swifWalnt,MouseEvent.CLICK,this.gotWalnutHandler);
            }
            moveWalnut.i = i;
            moveWalnut.x = swifWalnt.x;
            moveWalnut.y = swifWalnt.y;
            moveWalnut.vy = 0;
            moveWalnut.origerY = moveWalnut.y;
            if(i == 1 || i == 2 || i == 5 || i == 6)
            {
               moveWalnut.desty = 385;
            }
            else if(i == 3)
            {
               moveWalnut.desty = 152;
            }
            else if(i == 4)
            {
               moveWalnut.desty = 198;
            }
            moveWalnut.visible = false;
            this.top_mc.addChild(moveWalnut);
            this.moveWalnuts.push(moveWalnut);
         }
         BC.addEvent(this,this.top_mc.hit2MC1,"onHit",this.gotoRightHandler);
         BC.addEvent(this,this.top_mc.hit2MC2,"onHit",this.gotoLeftHandler);
         BC.addEvent(this,this.target_mc.modenghua_mc,MouseEvent.CLICK,this.getFlourHandler);
         BC.addEvent(this,this.tortoise_mc,"takeAwayHetaoEvent",this.takeAwayHetaoEventHandler);
      }
      
      override public function init() : void
      {
         super.init();
         BC.addEvent(this,LevelManager.stage,Event.ENTER_FRAME,this.onEntreFrameHandler);
      }
      
      private function getFlourHandler(e:MouseEvent) : void
      {
         Presented.getInstance().FreeReceiveBy1117(22);
      }
      
      private function takeAwayHetaoEventHandler(e:Event) : void
      {
         e.stopImmediatePropagation();
         this.tortoise_mc.buttonMode = true;
         BC.addEvent(this,this.tortoise_mc,MouseEvent.CLICK,this.tortoiseClickHandler);
      }
      
      private function tortoiseClickHandler(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.tortoise_mc,MouseEvent.CLICK,this.tortoiseClickHandler);
         this.tortoise_mc.buttonMode = false;
         BC.addEvent(this,this.tortoise_mc,"gotTortoiseSonEvent",this.gotTortoiseSonEventHandler);
         this.tortoise_mc.gotoAndStop(4);
         this.top_mc.tortoise_mc.gotoAndStop(4);
      }
      
      private function gotTortoiseSonEventHandler(e:Event) : void
      {
         e.stopImmediatePropagation();
         BC.removeEvent(this,this.tortoise_mc,"gotTortoiseSonEvent",this.gotTortoiseSonEventHandler);
         setTimeout(this.goBackToShell,1500);
         if(!LocalUserInfo.isVIP())
         {
            Alert.SLAlart("    只有超級拉姆的神奇能力才能帶小烏龜回家哦！我們期待你的加入！");
            return;
         }
         Presented.getInstance().FreeReceiveBy1117(23);
      }
      
      private function goBackToShell() : void
      {
         this.tortoise_mc.gotoAndStop(1);
         this.top_mc.tortoise_mc.gotoAndStop(1);
      }
      
      private function gotWalnutHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = e.currentTarget as MovieClip;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Wood_By_Level(1))
         {
            Alert.smileAlart("    等你能變成小樹苗了再來收集吧！");
            return;
         }
         if(p.lamuinfo.skillType != 3)
         {
            return;
         }
         p.lamu.geocaching(mc,function(mc:MovieClip):*
         {
            return 190612;
         },function(E:*):*
         {
            mc.alpha = 0.9;
            mc.addEventListener(Event.ENTER_FRAME,subAlphaHandler);
            tortoise_mc.isOk = 1;
            if(Boolean(timer))
            {
               timer.stop();
               timer = null;
            }
            Alert.getIconByID_Alart(190612,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190612) + "，已經放入你主人的百寶箱中了！");
         },function(E:*):*
         {
            mc.alpha = 0.9;
            mc.addEventListener(Event.ENTER_FRAME,subAlphaHandler);
            Alert.getIconByID_Alart(190612,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190612) + "，明天再來看看吧！");
         });
      }
      
      private function subAlphaHandler(e:Event) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         var targetAlpha:Number = mc.alpha - 0.1;
         if(targetAlpha <= 0)
         {
            targetAlpha = 0;
            mc.alpha = 0;
            mc.removeEventListener(Event.ENTER_FRAME,this.subAlphaHandler);
            if(mc.i == 1)
            {
               mc.parent.removeChild(mc);
            }
            if(mc.i == 1)
            {
               this.tortoise_mc.gotoAndStop(3);
               this.top_mc.tortoise_mc.gotoAndStop(3);
            }
         }
         mc.alpha = targetAlpha;
         if(targetAlpha == 0 && mc.i == 5)
         {
            mc.alpha = 1;
         }
      }
      
      private function gotoRightHandler(e:Event) : void
      {
         GV.MAN_PEOPLE.x = -500;
         this.top_mc.shuteng_mc.visible = false;
         this.top_mc.shur.visible = true;
         this.top_mc.shur.play();
         this.top_mc.lamur.visible = true;
         this.top_mc.lamur.play();
         BC.addEvent(this,this.top_mc.lamur,"gotoRightEvent",this.gotoRightEventHandler);
      }
      
      private function gotoRightEventHandler(e:Event) : void
      {
         BC.removeEvent(this,this.top_mc.lamur,"gotoRightEvent",this.gotoRightEventHandler);
         this.top_mc.shur.gotoAndStop(1);
         this.top_mc.shur.visible = false;
         this.top_mc.lamur.visible = false;
         this.top_mc.shuteng_mc.visible = true;
         this.top_mc.lamur.gotoAndStop(1);
         GV.MAN_PEOPLE.x = 655;
         GV.MAN_PEOPLE.y = 160;
      }
      
      private function gotoLeftHandler(e:Event) : void
      {
         GV.MAN_PEOPLE.x = -500;
         this.top_mc.shuteng_mc.visible = false;
         this.top_mc.shul.visible = true;
         this.top_mc.shul.play();
         this.top_mc.lamul.visible = true;
         this.top_mc.lamul.play();
         BC.addEvent(this,this.top_mc.lamul,"gotoLeftEvent",this.gotoLeftEventHandler);
      }
      
      private function gotoLeftEventHandler(e:Event) : void
      {
         BC.removeEvent(this,this.top_mc.lamul,"gotoLeftEvent",this.gotoLeftEventHandler);
         this.top_mc.shul.gotoAndStop(1);
         this.top_mc.shul.visible = false;
         this.top_mc.lamul.visible = false;
         this.top_mc.shuteng_mc.visible = true;
         this.top_mc.lamul.gotoAndStop(1);
         GV.MAN_PEOPLE.x = 253;
         GV.MAN_PEOPLE.y = 192;
      }
      
      private function onEntreFrameHandler(e:Event) : void
      {
         if(this.hitSaveTime)
         {
            return;
         }
         if(this.touchArea.hitTestPoint(GV.MAN_PEOPLE.x,GV.MAN_PEOPLE.y,true))
         {
            if(this.ci_mc.currentFrame < 40)
            {
               --LamuWorld.getInstance().lives;
               this.subone_mc.x = GV.MAN_PEOPLE.x;
               this.subone_mc.y = GV.MAN_PEOPLE.y - 30;
               this.subone_mc.play();
               this.subone_mc.addEventListener(Event.ENTER_FRAME,this.subOneEnterFrame);
               this.timeID = setTimeout(this.hitSaveTimeOut,1.6 * 1000);
               this.hitSaveTime = true;
            }
         }
      }
      
      private function timerHandler(e:TimerEvent) : void
      {
         var swifmc:MovieClip = this.hertaos[this.i];
         if(swifmc.visible == false || swifmc.alpha < 1)
         {
            ++this.i;
            if(this.i == this.moveWalnuts.length)
            {
               this.i = 0;
            }
            return;
         }
         swifmc.stop();
         swifmc.visible = false;
         var mc:MovieClip = this.moveWalnuts[this.i];
         mc.visible = true;
         this.moveFun(mc);
         ++this.i;
         if(this.i == this.moveWalnuts.length)
         {
            this.i = 0;
         }
      }
      
      private function moveFun(mc:MovieClip) : void
      {
         mc.addEventListener(Event.ENTER_FRAME,this.mcEnterFrameHandler);
      }
      
      private function mcEnterFrameHandler(e:Event) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.vy += this.gravity;
         mc.y += mc.vy;
         if(mc.hitTestPoint(GV.MAN_PEOPLE.x,GV.MAN_PEOPLE.y - 30))
         {
            mc.gotoAndPlay("hitBom");
            mc.removeEventListener(Event.ENTER_FRAME,this.mcEnterFrameHandler);
            mc.addEventListener("bomCompleteEvent",this.bomCompleteEventHandler);
            return;
         }
         if(mc.y >= mc.desty)
         {
            mc.y = mc.desty;
            mc.gotoAndPlay("floorBom");
            mc.removeEventListener(Event.ENTER_FRAME,this.mcEnterFrameHandler);
            mc.addEventListener("bomCompleteEvent",this.bomCompleteEventHandler);
            if(mc.i == 1 && this.tortoise_mc.isOk == 0)
            {
               this.tortoise_mc.gotoAndStop(2);
            }
         }
      }
      
      private function bomCompleteEventHandler(e:Event) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.removeEventListener("bomCompleteEvent",this.bomCompleteEventHandler);
         if(mc.currentFrame == mc.totalFrames)
         {
            --LamuWorld.getInstance().lives;
            this.subone_mc.x = GV.MAN_PEOPLE.x;
            this.subone_mc.y = GV.MAN_PEOPLE.y - 30;
            this.subone_mc.play();
            this.subone_mc.addEventListener(Event.ENTER_FRAME,this.subOneEnterFrame);
         }
         mc.visible = false;
         mc.y = mc.origerY;
         mc.vy = 0;
         mc.gotoAndStop(1);
         var swifmc:MovieClip = this.hertaos[mc.i - 1];
         swifmc.visible = true;
         swifmc.alpha = 0;
         swifmc.play();
         swifmc.addEventListener(Event.ENTER_FRAME,this.alphaHadler);
      }
      
      private function subOneEnterFrame(e:Event) : void
      {
         this.subone_mc.x = GV.MAN_PEOPLE.x;
         this.subone_mc.y = GV.MAN_PEOPLE.y - 30;
         if(this.subone_mc.currentFrame == this.subone_mc.totalFrames)
         {
            this.subone_mc.removeEventListener(Event.ENTER_FRAME,this.subOneEnterFrame);
            this.subone_mc.x = -500;
            if(LamuWorld.getInstance().lives <= 0)
            {
               LamuWorld.getInstance().dead();
            }
         }
      }
      
      private function alphaHadler(e:Event) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.alpha += 0.1;
         if(mc.alpha >= 1)
         {
            mc.alpha = 1;
            mc.removeEventListener(Event.ENTER_FRAME,this.alphaHadler);
         }
      }
      
      private function hitSaveTimeOut() : void
      {
         this.hitSaveTime = false;
         clearTimeout(this.timeID);
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer = null;
         }
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

