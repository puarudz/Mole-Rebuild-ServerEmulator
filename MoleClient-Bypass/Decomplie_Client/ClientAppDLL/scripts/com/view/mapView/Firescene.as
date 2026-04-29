package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.socket.getItemEveryDay.GetItemEveryDay;
   import com.module.activityModule.checkItem;
   import com.module.deal.Deal;
   import com.view.LamuWorld.FireBird;
   import com.view.LamuWorld.LamuWorld;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.housebase.HouseBase;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   
   public class Firescene extends HouseBase
   {
      
      private var birdBoss:FireBird;
      
      private var zhenfa:MovieClip;
      
      private var lamuArea:Sprite;
      
      private var hurtBirdMC:MovieClip;
      
      private var hurtBirdMask:Sprite;
      
      private var fbird:MovieClip;
      
      private var prop:MovieClip;
      
      private var baowu:MovieClip;
      
      public var byZhaohuan:Boolean = false;
      
      public function Firescene()
      {
         super();
      }
      
      private function hurtBoss(e:Event) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.isUserSKill == 1208000)
         {
            this.hurtBirdMC.play();
            this.toLamu();
         }
      }
      
      override protected function initView() : void
      {
         this.birdBoss = new FireBird(this.top_mc["bird"]);
         if(!LamuWorld.getInstance().isComplete)
         {
            BC.addEvent(this,GV.onlineSocket,"lamuComplete",this.setBossLive);
         }
         else
         {
            this.setBossLive();
         }
         BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.hurtBoss);
         this.zhenfa = depth_mc["zhenfa"] as MovieClip;
         this.fbird = depth_mc["fbird"] as MovieClip;
         this.hurtBirdMC = target_mc["hurtBirdMC"] as MovieClip;
         this.hurtBirdMC.visible = false;
         this.hurtBirdMask = target_mc["hurtBirdMask"] as Sprite;
         var myarr:Array = [0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
         var mycler:ColorMatrixFilter = new ColorMatrixFilter(myarr);
         this.hurtBirdMask.filters = new Array(mycler);
         BC.addEvent(this,this.hurtBirdMC,"hit_boss",this.hitBossFun);
         BC.addEvent(this,this.birdBoss.boss,"hurt_over",this.hitBossFun);
         BC.addEvent(this,this.birdBoss.boss,"dead_over",this.hitBossFun);
         this.prop = target_mc["prop"] as MovieClip;
         this.prop.mouseEnabled = false;
         this.baowu = target_mc["baowu"] as MovieClip;
         this.baowu.buttonMode = true;
         BC.addEvent(this,this.baowu,MouseEvent.CLICK,this.fireClickFun);
         BC.addEvent(this,this.prop,"get_thing",this.getThingFun);
         var addLive:SimpleButton = target_mc["addLive"] as SimpleButton;
         var addLive2:SimpleButton = target_mc["addLive2"] as SimpleButton;
         BC.addEvent(this,addLive,MouseEvent.CLICK,this.addLiveFun);
         BC.addEvent(this,addLive2,MouseEvent.CLICK,this.addLiveFun);
      }
      
      override public function init() : void
      {
         super.init();
         var people:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         this.lamuArea = people.hitBtn;
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
      
      private function setBossLive(e:* = null) : void
      {
         var live:Sprite = LamuWorld.getInstance().getBossLive(LamuWorld.FIRE_BOSS);
         top_mc.addChild(live);
         live.x = 710;
         live.y = 85;
         this.birdBoss.initBossLive(live);
         this.birdBoss.init();
         this.birdBoss.scene = this;
         this.birdBoss.target = LamuWorld.getInstance();
         BC.addEvent(this,LevelManager.stage,Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function hitBossFun(e:Event) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(e.type == "hit_boss")
         {
            this.birdBoss.behurt();
         }
         else if(e.type == "hurt_over")
         {
            if(this.birdBoss.bossLive.live <= 0)
            {
               this.birdBoss.dead();
               BC.removeEvent(this,LevelManager.stage,Event.ENTER_FRAME,this.onEnterFrame);
               this.hurtBirdMask.visible = true;
            }
         }
         else if(e.type == "dead_over")
         {
            BC.removeEvent(this,this.birdBoss.boss,"dead_over",this.hitBossFun);
            if(p.lamuinfo.hasSkill_Fire_By_Level(1))
            {
               this.givesuipian();
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
               checkItem.checkItemHandler(190593);
            }
            this.birdBoss.bossLive.hideLive();
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
            case 190593:
               Deal.BuyItem(id,1,function(... E):void
               {
                  Alert.getIconByID_Alart(id,"恭喜你得到火系信物,快去交給火系酋長吧!");
               },function(errorNum:int):void
               {
               });
               break;
            case 190589:
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(5);
               break;
            case 190587:
               BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
               GetItemEveryDay.req_getItemEveryDay(3);
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
      
      private function tipsBaowu() : void
      {
         var msg:String = "你只有使用變身小火苗技能才能得到這個寶貝哦,快去找火系酋長吧!";
         GF.showAlert(MainManager.getAppLevel(),msg,"",100,"iknow",true,false,"E");
      }
      
      private function fireClickFun(evt:MouseEvent) : void
      {
         this.getThingByLame("恭喜得到火岩石,已經放入你的百寶箱中!",190590);
      }
      
      private function getThingByLame(str:String, id:int) : void
      {
         var main:Firescene = null;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         var msg:String = str;
         main = this;
         if(p.lamuinfo.skillType == 1)
         {
            p.lamu.geocaching(this.baowu,function(mc:MovieClip):*
            {
               return id;
            },function(E:*):*
            {
               Alert.getIconByID_Alart(id,"    恭喜你獲得" + GoodsInfo.getItemNameByID(id) + "，已經放入你主人的百寶箱中了！");
            },function(E:*):*
            {
               if(main.byZhaohuan)
               {
                  Alert.getIconByID_Alart(id,"    你是通過召喚陣變身小火苗所以不能拿這個火岩石哦！");
               }
               else
               {
                  Alert.getIconByID_Alart(id,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(id) + "，明天再來看看吧！");
               }
            });
         }
         else
         {
            this.tipsBaowu();
         }
      }
      
      public function toFire() : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.isUserSKill != 1208000)
         {
            p.lamuinfo.isUserSKill = 1208000;
            p.lamu["refurbish"]();
            this.byZhaohuan = true;
         }
      }
      
      public function toLamu() : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamu))
         {
            p.lamuinfo.isUserSKill = 0;
            p.lamu["refurbish"]();
            this.byZhaohuan = false;
         }
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var flag:Boolean = false;
         var tempPoint:Point = null;
         var tn:Number = NaN;
         var angle:Number = NaN;
         var point:Point = GV.MAN_PEOPLE.localToGlobal(new Point(0,0));
         if(this.zhenfa.currentFrame == 39)
         {
            flag = this.zhenfa.hitTestPoint(point.x,point.y,true);
            if(flag)
            {
               this.zhenfa.gotoAndPlay(40);
               this.toFire();
               this.hurtBirdMask.visible = false;
               this.hurtBirdMC.visible = true;
            }
         }
         if(this.fbird.visible && this.fbird.alpha == 1)
         {
            tempPoint = new Point(this.fbird.x,this.fbird.y).subtract(new Point(point.x,point.y));
            tn = Math.atan2(tempPoint.x,tempPoint.y);
            angle = tn * 180 / Math.PI + 360;
            this.fbird.x -= 3 * Math.sin(tn);
            this.fbird.y -= 3 * Math.cos(tn);
            if(angle > 495 || angle < 225)
            {
               if(this.fbird.currentLabel != "down")
               {
                  this.fbird.gotoAndPlay("down");
               }
            }
            else if(angle < 270)
            {
               if(this.fbird.currentLabel != "down")
               {
                  this.fbird.gotoAndPlay("down");
               }
            }
            else if(angle < 315)
            {
               if(this.fbird.currentLabel != "rightup")
               {
                  this.fbird.gotoAndPlay("rightup");
               }
            }
            else if(angle < 405)
            {
               if(this.fbird.currentLabel != "up")
               {
                  this.fbird.gotoAndPlay("up");
               }
            }
            else if(angle < 450)
            {
               if(this.fbird.currentLabel != "leftup")
               {
                  this.fbird.gotoAndPlay("leftup");
               }
            }
            else if(angle < 495)
            {
               if(this.fbird.currentLabel != "leftdown")
               {
                  this.fbird.gotoAndPlay("leftdown");
               }
            }
            if(this.fbird.hitTestPoint(point.x,point.y,true))
            {
               this.birdBoss.target.behurt();
               this.fbird.alpha = 0.5;
               TweenLite.to(this.fbird,1,{
                  "alpha":1,
                  "x":271.1,
                  "y":355.5
               });
            }
         }
         if(this.birdBoss.bossLive.live <= 0)
         {
            this.birdBoss.dead();
            BC.removeEvent(this,LevelManager.stage,Event.ENTER_FRAME,this.onEnterFrame);
            this.hurtBirdMask.visible = true;
         }
         if(Boolean(GV.MAN_PEOPLE.lamuinfo) && GV.MAN_PEOPLE.lamuinfo.isUserSKill == 1208000)
         {
            this.hurtBirdMask.visible = false;
            this.hurtBirdMC.visible = true;
         }
      }
      
      override public function destroy() : void
      {
         this.toLamu();
      }
   }
}

