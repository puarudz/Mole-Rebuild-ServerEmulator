package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.mole.app.map.MapBase;
   import com.view.LamuWorld.LamuWorld;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class iceBondView extends MapBase
   {
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var roadNum:uint;
      
      private var gameBool:Boolean = false;
      
      private var btnNum:uint;
      
      private var speedNum:uint = 2;
      
      private var subTractTimer:Timer;
      
      private var isStartHurt:Boolean = false;
      
      private var go_Timer:Timer;
      
      public function iceBondView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         var num:uint = uint(Math.random() * 20);
         if(num < 5)
         {
            this.roadNum = 1;
         }
         else if(num >= 5 && num < 10)
         {
            this.roadNum = 2;
         }
         else if(num >= 10 && num < 15)
         {
            this.roadNum = 3;
         }
         else
         {
            this.roadNum = 4;
         }
         this.initRoad();
         BC.addEvent(this,this.target_mc.crystal1_mc,MouseEvent.CLICK,this.getCrystalHandler);
         BC.addEvent(this,this.target_mc.crystal2_mc,MouseEvent.CLICK,this.getCrystalHandler);
         BC.addEvent(this,this.target_mc.crystal3_mc,MouseEvent.CLICK,this.getCrystalHandler);
      }
      
      override public function init() : void
      {
         super.init();
         LamuWorld.getInstance().initLive();
      }
      
      private function getCrystalHandler(e:MouseEvent) : void
      {
         var targetMC:MovieClip = e.currentTarget as MovieClip;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Water_By_Level(2))
         {
            Alert.smileAlart("    讓拉姆使用水花碎片技能來拿吧！");
            return;
         }
         if(Boolean(p.lamuinfo) && p.lamuinfo.skillType != 2)
         {
            Alert.smileAlart("    讓拉姆使用水花碎片技能來拿吧！");
            return;
         }
         p.lamu.geocaching(targetMC,function(mc:MovieClip):*
         {
            return 190641;
         },function(E:*):*
         {
            Alert.getIconByID_Alart(190641,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190641) + "，已經放入你主人的百寶箱中了！");
         },function(E:*):*
         {
            Alert.getIconByID_Alart(190641,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190641) + "，明天再來看看吧！");
         });
      }
      
      private function initRoad() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         this.subTractTimer = new Timer(1000);
         BC.addEvent(this,this.subTractTimer,TimerEvent.TIMER,this.subtractBlood);
         for(var i:int = 1; i < 3; i++)
         {
            this.target_mc["flow_mc" + i].buttonMode = true;
            BC.addEvent(this,this.target_mc["flow_mc" + i],MouseEvent.CLICK,this.btnClickHandler);
            BC.addEvent(this,this.target_mc["flow" + i],MouseEvent.CLICK,this.flowClickHandler);
         }
      }
      
      private function btnClickHandler(evt:MouseEvent) : void
      {
         var clickNum:uint = uint(evt.currentTarget.name.substr(-1));
         if(evt.currentTarget.currentFrame == 1)
         {
            this.target_mc["flow_mc" + clickNum].buttonMode = false;
            if(this.roadNum < 3)
            {
               if(clickNum == 1)
               {
                  this.target_mc["flow_mc" + clickNum].gotoAndStop(2);
               }
               else
               {
                  this.target_mc["flow_mc" + clickNum].gotoAndStop(3);
               }
            }
            else if(clickNum == 2)
            {
               this.target_mc["flow_mc" + clickNum].gotoAndStop(2);
            }
            else
            {
               this.target_mc["flow_mc" + clickNum].gotoAndStop(3);
            }
         }
      }
      
      private function flowClickHandler(evt:MouseEvent) : void
      {
         var a:uint = 0;
         a = uint(evt.currentTarget.name.substr(-1));
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.lamuinfo.skillType == 2)
         {
            p.lamu.geocaching(this.target_mc["flow" + a],function(mc:MovieClip):*
            {
               return 190623;
            },function(E:*):*
            {
               target_mc["flow_mc" + a].gotoAndStop(1);
               target_mc["flow" + a].visible = false;
               Alert.getIconByID_Alart(190623,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190623) + "，已經放入你主人的百寶箱中了！");
            },function(E:*):*
            {
               Alert.getIconByID_Alart(190623,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190623) + "，明天再來看看吧！");
            });
         }
         else
         {
            Alert.smileAlart("    必須使用變身小水滴技能才能拿該物品哦！");
         }
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         BC.addEvent(this,this.target_mc,Event.ENTER_FRAME,this.eventFrameFun);
         switch(evt.EventObj.type)
         {
            case 1:
               this.btnNum = 1;
               this.firstEvent();
               break;
            case 2:
               this.btnNum = 2;
               this.firstEvent();
               break;
            case 3:
               this.btnNum = 3;
               this.firstEvent();
               break;
            case 4:
               this.btnNum = 4;
               this.firstEvent();
         }
      }
      
      private function firstEvent() : void
      {
         PeopleManageView(GV.MAN_PEOPLE).avatarClass.speed = PeopleManageView(GV.MAN_PEOPLE).avatarClass.speed * this.speedNum;
         PeopleManageView(GV.MAN_PEOPLE).moveTo(this.depth_mc["mc_" + this.btnNum].x,this.depth_mc["mc_" + this.btnNum].y);
         MoveTo.CanMove = false;
      }
      
      private function eventFrameFun(evt:Event) : void
      {
         var p:MovieClip = null;
         if(Boolean(this.target_mc["mc_" + this.btnNum].mc.hitTestPoint(PeopleManageView(GV.MAN_PEOPLE).x,PeopleManageView(GV.MAN_PEOPLE).y,true)))
         {
            if(!this.isStartHurt && this.roadNum != this.btnNum)
            {
               this.target_mc["mc_" + this.btnNum].gotoAndStop(uint(Math.random() * 3) + 2);
               PeopleManageView(GV.MAN_PEOPLE).avatarClass.stopToHere();
               this.subTractTimer.start();
               this.isStartHurt = true;
               MoveTo.CanMove = true;
               this.gameBool = false;
               this.go_Timer = GC.setGTimeout(function():void
               {
                  PeopleManageView(GV.MAN_PEOPLE).avatarClass.speed = 100;
                  PeopleManageView(GV.MAN_PEOPLE).x = target_mc["g_" + btnNum].x + 20;
                  PeopleManageView(GV.MAN_PEOPLE).y = target_mc["g_" + btnNum].y + 20;
               },1000);
            }
         }
         if(Boolean(this.depth_mc["mc_" + this.btnNum].hitTestPoint(PeopleManageView(GV.MAN_PEOPLE).x,PeopleManageView(GV.MAN_PEOPLE).y,true)))
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            GF.switchMap(134,true);
         }
         if(this.roadNum == this.btnNum)
         {
            p = GV.MAN_PEOPLE;
            if(PeopleManageView(GV.MAN_PEOPLE).y < 250)
            {
               TweenLite.to(p.lamu,0.8,{
                  "scaleX":0.5,
                  "scaleY":0.5
               });
            }
         }
      }
      
      private function subtractBlood(evt:TimerEvent = null) : void
      {
         this.subTractTimer.stop();
         this.isStartHurt = false;
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

