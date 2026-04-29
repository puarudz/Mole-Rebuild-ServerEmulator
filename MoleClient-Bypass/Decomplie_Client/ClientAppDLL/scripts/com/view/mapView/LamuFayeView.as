package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.module.activityModule.Presented;
   import com.module.npc.I_NPC;
   import com.module.npc.npcInstance.GhostNPC;
   import com.mole.app.map.MapBase;
   import com.view.LamuWorld.LamuWorld;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class LamuFayeView extends MapBase
   {
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var attachTimer:Timer;
      
      private var subTractTimer:Timer;
      
      private var addBloodTimer:Timer;
      
      private var attachMC1:MovieClip;
      
      private var isStartHurtArr:Array = [false,false];
      
      private var isSubtract:Boolean = true;
      
      private var hurtBloodCount:Number = 0;
      
      private var hx:Number = 570;
      
      private var hy:Number = 368;
      
      private var kingFilmMC:MovieClip;
      
      public function LamuFayeView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,this.target_mc.heikuang1_mc,MouseEvent.CLICK,this.getHeikuangHandler);
         BC.addEvent(this,this.target_mc.heikuang2_mc,MouseEvent.CLICK,this.getHeikuangHandler);
      }
      
      override public function init() : void
      {
         super.init();
         LamuWorld.getInstance().initLive();
         this.initScene();
      }
      
      private function getHeikuangHandler(e:MouseEvent) : void
      {
         var targetMC:MovieClip = e.currentTarget as MovieClip;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Wood_By_Level(2))
         {
            Alert.smileAlart("    讓拉姆使用樹根纏繞技能來拿吧！");
            return;
         }
         if(p.lamuinfo.skillType != 3)
         {
            Alert.smileAlart("    讓拉姆使用樹根纏繞技能來拿吧！");
            return;
         }
         p.lamu.geocaching(targetMC,function(mc:MovieClip):*
         {
            return 190642;
         },function(E:*):*
         {
            Alert.getIconByID_Alart(190642,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190642) + "，已經放入你主人的百寶箱中了！");
         },function(E:*):*
         {
            Alert.getIconByID_Alart(190642,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190642) + "，明天再來看看吧！");
         });
      }
      
      private function initScene() : void
      {
         this.initLamuGuard();
         this.initTimer();
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.gotoSafeArea);
         BC.addEvent(this,this.botton_mc.falseroom_btn,MouseEvent.CLICK,this.noEnterTip);
         BC.addEvent(this,this.target_mc.seed_btn,MouseEvent.CLICK,this.btnClickFun);
         if(Boolean(GV.MAN_PEOPLE.lamuinfo.hasSkill_Wood()))
         {
            this.botton_mc.lockroom_btn.visible = true;
         }
         else
         {
            this.botton_mc.lock_btn.visible = true;
            BC.addEvent(this,this.botton_mc.lock_btn,MouseEvent.CLICK,this.lockAlertFun);
         }
      }
      
      private function lockAlertFun(evt:MouseEvent = null) : void
      {
         Alert.smileAlart("    看來這裡已經被封鎖無法進入，看看還有其他入口嗎！");
      }
      
      private function btnClickFun(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.target_mc.seed_btn,MouseEvent.CLICK,this.btnClickFun);
         this.target_mc.seed_btn.visible = false;
         Presented.getInstance().FreeReceiveBy1117(25);
      }
      
      private function noEnterTip(evt:MouseEvent = null) : void
      {
         Alert.smileAlart("    這扇門無法打開，好像需要機關開啟才能進入哦！");
      }
      
      private function openDoorFun(evt:MouseEvent = null) : void
      {
         this.target_mc.open_btn.gotoAndStop(2);
         this.botton_mc.open_btn.visible = false;
         this.botton_mc.falseroom_btn.visible = false;
         this.botton_mc.room1_btn.visible = true;
         this.depth_mc.open_mc.play();
      }
      
      private function gotoSafeArea(evt:EventTaomee = null) : void
      {
         if(evt.EventObj.type == 1)
         {
            this.isSubtract = false;
            this.attachTimer.stop();
            this.depth_mc.pureLight.gotoAndStop(2);
            this.addBloodTimer.start();
            BC.addEvent(this,GV.onlineSocket,"iskaddish",this.stopSafeArea);
         }
         else if(evt.EventObj.type == 2)
         {
            this.openDoorFun();
         }
      }
      
      private function stopSafeArea(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"iskaddish",this.stopSafeArea);
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.moveTo(606,339);
         this.depth_mc.pureLight.gotoAndStop(1);
         this.isSubtract = true;
         this.attachTimer.start();
         this.addBloodTimer.stop();
      }
      
      private function initLamuGuard() : void
      {
         var n:I_NPC = new GhostNPC("lamuGuard");
         depthLevel.addChild(n as DisplayObjectContainer);
         n.x = this.hx;
         n.y = this.hy;
         n.setMovingRange(depthLevel.range_mc);
         n.autoMove = true;
         n.Speed = 60;
         BC.addEvent(this,n,"getDlight",this.updateAttachedMC);
      }
      
      private function initTimer() : void
      {
         this.attachTimer = new Timer(100);
         BC.addEvent(this,this.attachTimer,TimerEvent.TIMER,this.checkAttachHandler);
         this.attachTimer.start();
         this.subTractTimer = new Timer(1000);
         BC.addEvent(this,this.subTractTimer,TimerEvent.TIMER,this.subtractBlood);
         this.addBloodTimer = new Timer(3000);
         BC.addEvent(this,this.addBloodTimer,TimerEvent.TIMER,this.addBlood);
      }
      
      private function updateAttachedMC(evt:* = null) : void
      {
         this.attachMC1 = evt.EventObj as MovieClip;
      }
      
      private function checkAttachHandler(evt:TimerEvent = null) : void
      {
         for(var i:uint = 1; i <= 1; i++)
         {
            if(Boolean(this["attachMC" + i]))
            {
               if(Boolean(GV.MAN_PEOPLE.pet_hitBtn.hitTestObject(this["attachMC" + i])))
               {
                  if(!this.isStartHurtArr[0])
                  {
                     LamuWorld.getInstance().behurt(1);
                     this.subTractTimer.start();
                  }
                  if(!this.isStartHurtArr[i - 1])
                  {
                     ++this.hurtBloodCount;
                     this.isStartHurtArr[i - 1] = true;
                  }
               }
               else if(Boolean(this.isStartHurtArr[i - 1]))
               {
                  this.isStartHurtArr[i - 1] = false;
                  --this.hurtBloodCount;
                  if(!this.isStartHurtArr[0])
                  {
                     this.subTractTimer.stop();
                  }
               }
            }
         }
      }
      
      private function subtractBlood(evt:TimerEvent = null) : void
      {
         LamuWorld.getInstance().behurt(this.hurtBloodCount);
      }
      
      private function addBlood(evt:TimerEvent = null) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.PetCloth == 1200035)
         {
            if(LamuWorld.getInstance().lives < 20)
            {
               LamuWorld.getInstance().behurt(-1);
            }
         }
         else if(LamuWorld.getInstance().lives < 16)
         {
            LamuWorld.getInstance().behurt(-1);
         }
      }
      
      override public function destroy() : void
      {
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

