package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.getItemEveryDay.GetItemEveryDay;
   import com.module.activityModule.checkItem;
   import com.module.deal.Deal;
   import com.view.LamuWorld.IceBall;
   import com.view.LamuWorld.IceBoss;
   import com.view.LamuWorld.IceStock;
   import com.view.LamuWorld.LamuWorld;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.housebase.HouseBase;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class Icescene extends HouseBase
   {
      
      public const BOTTOM:int = 474;
      
      private var Ball:Class;
      
      private var ball:IceBall;
      
      private var changeBtn:SimpleButton;
      
      private var tuopan:MovieClip;
      
      private var currentMode:int;
      
      private var iceBoss:IceBoss;
      
      private var prop:MovieClip;
      
      private var icestock:IceStock;
      
      private var baowu:MovieClip;
      
      private var toMan:Boolean = false;
      
      private var countBall:int = 0;
      
      public function Icescene()
      {
         super();
      }
      
      override protected function initView() : void
      {
      }
      
      override public function init() : void
      {
         super.init();
         if(GV.MAN_PEOPLE.Petlevel < 2)
         {
            return;
         }
         this.iceBoss = new IceBoss(this.top_mc["zhangyu"]);
         this.tuopan = top_mc["tuopan"] as MovieClip;
         if(!LamuWorld.getInstance().isComplete)
         {
            BC.addEvent(this,GV.onlineSocket,"lamuComplete",this.setBossLive);
         }
         else
         {
            this.setBossLive();
         }
         this.Ball = GV.Lib_Map.getClass("Ball") as Class;
         this.changeBtn = target_mc["c_btn"] as SimpleButton;
         this.prop = target_mc["prop"] as MovieClip;
         BC.addEvent(this,this.iceBoss.boss,"hurt_over",this.hitBossFun);
         BC.addEvent(this,this.iceBoss.boss,"dead_over",this.hitBossFun);
         BC.addEvent(this,this.prop,"get_thing",this.getThingFun);
         BC.addEvent(this,this.changeBtn,MouseEvent.CLICK,this.changeClick);
         BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.dutyHandler);
         this.baowu = target_mc["baowu"] as MovieClip;
         BC.addEvent(this,this.baowu,MouseEvent.CLICK,this.fireClickFun);
         var addLive:SimpleButton = target_mc["addLive"] as SimpleButton;
         var addLive2:SimpleButton = target_mc["addLive2"] as SimpleButton;
         BC.addEvent(this,addLive,MouseEvent.CLICK,this.addLiveFun);
         BC.addEvent(this,addLive2,MouseEvent.CLICK,this.addLiveFun);
      }
      
      private function addLiveFun(e:Event) : void
      {
         (e.currentTarget as SimpleButton).visible = false;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         var itemID:int = p.lamuinfo.PetCloth;
         var max:int = 0;
         if(itemID == 1200035)
         {
            max = 20;
         }
         else
         {
            max = 16;
         }
         var num:int = Math.min(max,LamuWorld.getInstance().lives + 4);
         LamuWorld.getInstance().behurt(LamuWorld.getInstance().lives - num);
      }
      
      private function fireClickFun(evt:MouseEvent) : void
      {
         this.getThingByLame(190624);
      }
      
      private function getThingByLame(id:int) : void
      {
         var p:PeopleManageView;
         var main:Icescene;
         if(this.tuopan.visible)
         {
            return;
         }
         p = GV.MAN_PEOPLE as PeopleManageView;
         main = this;
         if(p.lamuinfo.skillType == 2)
         {
            p.lamu.geocaching(this.baowu,function(mc:MovieClip):*
            {
               return id;
            },function(E:*):*
            {
               Alert.getIconByID_Alart(id,"    恭喜你獲得" + GoodsInfo.getItemNameByID(id) + "，已經放入你主人的百寶箱中了！");
            },function(E:*):*
            {
               Alert.getIconByID_Alart(id,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(id) + "，明天再來看看吧！");
            });
         }
         else
         {
            this.tipsBaowu();
         }
      }
      
      private function tipsBaowu() : void
      {
         var msg:String = "你只有使用變身小水滴技能才能得到這個寶貝哦,快去找水系酋長吧!";
         GF.showAlert(MainManager.getAppLevel(),msg,"",100,"iknow",true,false,"E");
      }
      
      private function getThingFun(e:EventTaomee) : void
      {
         var id:int = 0;
         var msg:String = null;
         id = e.EventObj as int;
         switch(id)
         {
            case 0:
               msg = "這是一個空箱子,下次再來吧!";
               GF.showAlert(MainManager.getAppLevel(),msg,"",100,"iknow",true,false,"E");
               break;
            case 190628:
               Deal.BuyItem(id,1,function(... E):void
               {
                  Alert.getIconByID_Alart(id,"恭喜你得到水系信物,快去交給水系酋長吧!");
               },function(errorNum:int):void
               {
               });
               break;
            case 190619:
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(29);
               break;
            case 190621:
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(30);
               break;
            case 190620:
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(31);
               break;
            case 190622:
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(32);
         }
      }
      
      private function read117Handler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
         if(e.EventObj.itmeCount == 0)
         {
            Alert.smileAlart("今天你已經得到太多" + GoodsInfo.getItemNameByID(e.EventObj.itemid) + "，明天再來看看吧！");
         }
         else
         {
            Alert.getIconByID_Alart(e.EventObj.itemid);
         }
      }
      
      private function hitBossFun(e:Event) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(e.type == "hit_boss")
         {
            this.iceBoss.behurt();
         }
         else if(e.type == "hurt_over")
         {
            if(this.iceBoss.bossLive.live <= 0)
            {
               this.iceBoss.dead();
               this.setMode(0);
            }
         }
         else if(e.type == "dead_over")
         {
            if(p.lamuinfo.hasSkill_Water_By_Level(1))
            {
               this.givesuipian();
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
               checkItem.checkItemHandler(190628);
            }
            this.iceBoss.bossLive.hideLive();
         }
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
         if(evt.EventObj.num <= 0)
         {
            this.giveyinji();
         }
         else
         {
            this.givesuipian();
         }
      }
      
      private function givesuipian() : void
      {
         this.prop.gotoAndPlay("抽奖");
      }
      
      private function giveyinji() : void
      {
         this.prop.gotoAndPlay("打完鸟后露出宝箱");
      }
      
      private function setBossLive(e:* = null) : void
      {
         var live:Sprite = LamuWorld.getInstance().getBossLive(LamuWorld.ICE_BOSS);
         top_mc.addChild(live);
         live.x = 710;
         live.y = 85;
         this.iceBoss.initBossLive(live);
         this.iceBoss.init();
         this.iceBoss.scene = this;
         this.icestock = new IceStock(this.tuopan);
         this.setMode(0);
      }
      
      private function setMode(value:int = 0) : void
      {
         var pd:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(value))
         {
            if(this.iceBoss.bossLive.live <= 0)
            {
               this.iceBoss.dead();
               this.setMode(0);
               return;
            }
            if(this.toMan)
            {
               this.toMan = false;
               return;
            }
            this.currentMode = value;
            GV.MAN_PEOPLE.visible = false;
            pd.pet_hitBtn.enabled = false;
            this.tuopan.visible = true;
            this.tuopan.gotoAndPlay(2);
            MoveTo.CanMove = false;
            BC.addEvent(this,LevelManager.stage,Event.ENTER_FRAME,this.onEnterFrame);
            this.iceBoss.target = this.icestock;
         }
         else
         {
            BC.removeEvent(this,LevelManager.stage,Event.ENTER_FRAME,this.onEnterFrame);
            if(Boolean(this.ball))
            {
               this.removeBall();
            }
            this.currentMode = value;
            GV.MAN_PEOPLE.visible = true;
            pd.pet_hitBtn.enabled = true;
            this.tuopan.visible = false;
            this.tuopan.gotoAndStop(1);
            MoveTo.CanMove = true;
            this.iceBoss.target = LamuWorld.getInstance();
         }
      }
      
      private function removeBall() : void
      {
         BC.removeEvent(this,this.ball.content,"level",this.levelHandler);
         this.ball.removed();
         this.ball = null;
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var tball:Sprite = null;
         if(this.ball == null)
         {
            if(this.tuopan.currentFrame == this.tuopan.totalFrames)
            {
               if(this.countBall < 10)
               {
                  ++this.countBall;
                  return;
               }
               this.countBall = 0;
               tball = new this.Ball();
               this.tuopan.addChild(tball);
               this.ball = new IceBall(tball,top_mc);
               this.ball.place = new Point(0,-this.ball.content.height / 2);
               BC.addEvent(this,this.ball.content,"level",this.levelHandler);
               BC.addEvent(this,this.ball.content,"tohurt",this.hurtHandler);
               BC.addEvent(this,LevelManager.stage,MouseEvent.MOUSE_UP,this.onRelease);
            }
         }
         else
         {
            this.ball.updata();
         }
         var targetX:Number = Math.max(124,Math.min(LevelManager.stage.mouseX,805));
         this.tuopan.x += (targetX - this.tuopan.x) / 10;
      }
      
      private function levelHandler(e:Event) : void
      {
         if(this.tuopan.visible)
         {
            this.icestock.behurt();
         }
         else
         {
            LamuWorld.getInstance().behurt();
         }
         this.removeBall();
      }
      
      private function hurtHandler(e:Event) : void
      {
         this.iceBoss.behurt();
      }
      
      private function onRelease(e:MouseEvent) : void
      {
         BC.removeEvent(this,LevelManager.stage,MouseEvent.MOUSE_UP,this.onRelease);
         this.ball.canMove = true;
      }
      
      private function dutyHandler(e:Event) : void
      {
         if(!this.currentMode)
         {
            this.setMode(1);
         }
      }
      
      private function changeClick(e:MouseEvent) : void
      {
         if(Boolean(this.currentMode))
         {
            this.setMode(0);
            this.toMan = true;
         }
      }
      
      override public function destroy() : void
      {
         this.icestock = null;
         this.Ball = null;
         super.destroy();
      }
   }
}

