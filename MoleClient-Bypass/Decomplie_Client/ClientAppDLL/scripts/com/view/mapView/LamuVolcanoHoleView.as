package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.getItemEveryDay.GetItemEveryDay;
   import com.mole.app.map.MapBase;
   import com.view.LamuWorld.LamuWorld;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class LamuVolcanoHoleView extends MapBase
   {
      
      private static var isFirstInMap:Boolean;
      
      public var type_mc:MovieClip;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var temp_mc:MovieClip;
      
      private var lightBallMC:MovieClip;
      
      private var stoneBrigeMC:MovieClip;
      
      private var touchAreaMC1:MovieClip;
      
      private var touchAreaMC2:MovieClip;
      
      private var touchAreaMC3:MovieClip;
      
      private var touchAreaMC4:MovieClip;
      
      private var touchAreaMC5:MovieClip;
      
      private var touchAreaMC6:MovieClip;
      
      private var movedStoneMC:MovieClip;
      
      private var movedStoneMC2:MovieClip;
      
      private var fireBallMC:MovieClip;
      
      private var fireMC1:MovieClip;
      
      private var fireMC2:MovieClip;
      
      private var fireMC3:MovieClip;
      
      private var fireMC4:MovieClip;
      
      private var fireMC5:MovieClip;
      
      private var stonedoorMC:MovieClip;
      
      private var hasDownIntoRiver:Boolean = false;
      
      private var initPoint:Point;
      
      private var hasKey:Boolean;
      
      private var canWalkArea1:MovieClip;
      
      private var canWalkArea2:MovieClip;
      
      private var hasFireTigerHat:Boolean;
      
      private var checkKeyTimeID:int;
      
      private var timeID:uint;
      
      private var hasFireed:Boolean;
      
      private var molerOnArea1:Boolean;
      
      private var molerOnArea2:Boolean;
      
      public function LamuVolcanoHoleView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.type_mc = GV.MC_mapFrame["type_mc"];
         this.temp_mc = GV.MC_mapFrame["temp_mc"];
      }
      
      override public function init() : void
      {
         super.init();
         LamuWorld.getInstance().initLive();
         this.initGotoNextDoor();
      }
      
      private function initGotoNextDoor() : void
      {
         var i:int = 0;
         var userInstance:PeopleManageView = null;
         BC.addEvent(this,this.target_mc.stage,Event.ENTER_FRAME,this.onEntreFrameHandler);
         this.stoneBrigeMC = this.botton_mc.stoneBrige;
         BC.addEvent(this,this.stoneBrigeMC,"stoneBrigeDownEvent",this.stoneBrigeDownEventHandler);
         this.touchAreaMC1 = this.botton_mc.touchArea1;
         this.touchAreaMC2 = this.botton_mc.touchArea2;
         this.touchAreaMC3 = this.botton_mc.touchArea3;
         this.touchAreaMC4 = this.botton_mc.touchArea4;
         this.touchAreaMC5 = this.botton_mc.touchArea5;
         this.touchAreaMC6 = this.botton_mc.touchArea6;
         this.fireMC1 = this.botton_mc.fire1;
         this.fireMC2 = this.botton_mc.fire2;
         this.fireMC3 = this.botton_mc.fire3;
         this.fireMC4 = this.botton_mc.fire4;
         this.fireMC5 = this.botton_mc.fire5;
         this.canWalkArea1 = this.botton_mc.canWalkArea1;
         this.canWalkArea2 = this.botton_mc.canWalkArea2;
         this.stonedoorMC = this.target_mc.stonedoormc;
         BC.addEvent(this,this.fireMC1,"firedEvent",this.firedEventHandler);
         BC.addEvent(this,this.fireMC2,"firedEvent",this.firedEventHandler);
         BC.addEvent(this,this.fireMC3,"firedEvent",this.firedEventHandler);
         BC.addEvent(this,this.fireMC4,"firedEvent",this.firedEventHandler);
         BC.addEvent(this,this.fireMC5,"firedEvent",this.firedEventHandler);
         this.movedStoneMC = this.temp_mc.movedStone;
         this.movedStoneMC2 = this.temp_mc.movedStone2;
         this.fireBallMC = this.temp_mc.fireBall;
         BC.addEvent(this,this.target_mc.hit2MC2,"onHit",this.openPopBoxHandler);
         BC.addEvent(this,this.botton_mc.hit2MC1,"onHit",this.gotoMap126Handler);
         this.initPoint = new Point();
         this.initPoint.x = PeopleManageView(GV.MAN_PEOPLE).x;
         this.initPoint.y = PeopleManageView(GV.MAN_PEOPLE).y;
         PeopleManageView(GV.MAN_PEOPLE).stopAction("left");
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getPayNumHandler);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190599,2);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),1200036,2);
         BC.addEvent(this,GV.onlineSocket,"read_1117",this.read117Handler);
         this.type_mc.mc.parent.removeChild(this.type_mc.mc);
         MapModelLogic.owner.makeMapArray(true);
         if(!isFirstInMap)
         {
            this.stoneBrigeMC.visible = true;
         }
         else
         {
            this.temp_mc.stonebrige2_mc.visible = true;
            this.botton_mc.removeChild(this.touchAreaMC4);
            this.touchAreaMC4 = null;
            this.botton_mc.removeChild(this.stoneBrigeMC);
            this.depth_mc.hit_mc.removeChild(this.depth_mc.hit_mc.autoMC);
         }
         if(this.initPoint.y > 250)
         {
            if(!isFirstInMap)
            {
               isFirstInMap = true;
               this.depth_mc.lamusmc.visible = true;
               this.depth_mc.lamusmc.play();
               BC.addEvent(this,this.depth_mc.lamusmc,"lamusEscapedEvent",this.lamusEscapedEventHandler);
            }
         }
         BC.addEvent(this,this.target_mc["huodi"],MouseEvent.CLICK,this.gotFireStarHandler);
         BC.addEvent(this,this.target_mc.huojin1_mc,MouseEvent.CLICK,this.gotHuojinHandler);
         BC.addEvent(this,this.target_mc.huojin2_mc,MouseEvent.CLICK,this.gotHuojinHandler);
         for(i = 0; i < PeopleCountLogic.FloorLayerPList.length; i++)
         {
            userInstance = PeopleCountLogic.FloorLayerPList[i].Instance as PeopleManageView;
            BC.addEvent(this,userInstance,PeopleManageView.ON_GO_ENTERFRAME,this.checkIsHitObj);
         }
         BC.addEvent(this,PeopleCountLogic.owner,PeopleCountLogic.ONPEOPLEINMAP,this.inmap);
      }
      
      private function inmap(e:EventTaomee) : void
      {
         var userInstance:PeopleManageView = e.EventObj as PeopleManageView;
         BC.addEvent(this,userInstance,PeopleManageView.ON_GO_ENTERFRAME,this.checkIsHitObj);
      }
      
      private function checkIsHitObj(e:Event) : void
      {
         var p:PeopleManageView = PeopleManageView(e.target);
         if(p == GV.MAN_PEOPLE)
         {
            return;
         }
         if(Boolean(this.depth_mc.hit_mc.hitTestPoint(p.x,p.y,true)))
         {
            p.avatarClass.stopToHere();
            p.stopAction();
         }
      }
      
      private function gotHuojinHandler(e:MouseEvent) : void
      {
         var targetMC:MovieClip = e.currentTarget as MovieClip;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Fire_By_Level(2))
         {
            Alert.smileAlart("    只有第五階段的拉姆使用旺盛火焰技能才能領取哦！");
            return;
         }
         if(p.lamuinfo.skillType != 1)
         {
            Alert.smileAlart("    只有第五階段的拉姆使用旺盛火焰技能才能領取哦！");
            return;
         }
         p.lamu.geocaching(targetMC,function(mc:MovieClip):*
         {
            return 190640;
         },function(E:*):*
         {
            Alert.getIconByID_Alart(190640,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190640) + "，已經放入你主人的百寶箱中了！");
         },function(E:*):*
         {
            Alert.getIconByID_Alart(190640,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190640) + "，明天再來看看吧！");
         });
      }
      
      private function gotFireStarHandler(e:MouseEvent) : void
      {
         var p:PeopleManageView = null;
         var firestarMC:MovieClip = e.currentTarget as MovieClip;
         if(firestarMC.buttonMode)
         {
            p = GV.MAN_PEOPLE as PeopleManageView;
            if(Boolean(p.lamuinfo) && !p.lamuinfo.hasSkill_Fire_By_Level(1))
            {
               Alert.smileAlart("    讓拉姆使用小火苗技能來拿吧！");
               return;
            }
            if(p.lamuinfo.skillType != 1)
            {
               Alert.smileAlart("    讓拉姆使用小火苗技能來拿吧！");
               return;
            }
            p.lamu.geocaching(firestarMC,function(mc:MovieClip):*
            {
               return 190592;
            },function(E:*):*
            {
               Alert.getIconByID_Alart(190592,"    恭喜你獲得" + GoodsInfo.getItemNameByID(190592) + "，已經放入你主人的百寶箱中了！");
            },function(E:*):*
            {
               Alert.getIconByID_Alart(190592,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(190592) + "，明天再來看看吧！");
            });
         }
      }
      
      private function lamusEscapedEventHandler(e:Event) : void
      {
         BC.removeEvent(this,this.depth_mc.lamusmc,"lamusEscapedEvent",this.lamusEscapedEventHandler);
      }
      
      private function read117Handler(e:EventTaomee) : void
      {
         if(e.EventObj.itmeCount == 0)
         {
            Alert.smileAlart("    這個箱子現在是空的，下次再來看看吧！");
         }
         else
         {
            Alert.getIconByID_Alart(e.EventObj.itemid);
         }
      }
      
      private function getPayNumHandler(eve:EventTaomee) : void
      {
         var obj:Object = null;
         var arr:Array = eve.EventObj.obj.arr;
         for each(obj in arr)
         {
            if(obj.id == 190599)
            {
               if(obj.itemCount > 0)
               {
                  this.hasKey = true;
               }
            }
            else if(obj.id == 1200036)
            {
               if(obj.itemCount > 0)
               {
                  this.hasFireTigerHat = true;
               }
            }
         }
      }
      
      private function gotoMap126Handler(e:Event) : void
      {
         this.stonedoorMC.gotoAndStop(2);
         setTimeout(this.gotoMap125,3 * 1000);
      }
      
      private function gotoMap125() : *
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(125);
         GF.switchMap(126,true);
      }
      
      private function openPopBoxHandler(e:Event) : void
      {
         if(this.target_mc.propbocmc.currentFrame == this.target_mc.propbocmc.totalFrames)
         {
            return;
         }
         BC.addEvent(this,this.target_mc.propbocmc,"gotKeyFromBoxEvent",this.gotKeyFromBoxEventHandler);
         this.target_mc.propbocmc.play();
      }
      
      private function gotKeyFromBoxEventHandler(e:Event) : void
      {
         BC.removeEvent(this,this.target_mc.propbocmc,"gotKeyFromBoxEvent",this.gotKeyFromBoxEventHandler);
         if(LocalUserInfo.isVIP())
         {
            if(this.hasFireTigerHat)
            {
               Alert.smileAlart("    這個箱子現在是空的，下次再來看看吧！");
            }
            else
            {
               GetItemEveryDay.req_getItemEveryDay(4);
            }
         }
         else
         {
            Alert.smileAlart("    這個箱子現在是空的，下次再來看看吧！");
         }
      }
      
      private function checkKey() : void
      {
         clearTimeout(this.checkKeyTimeID);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190599,2);
      }
      
      private function firedEventHandler(e:Event) : void
      {
         --LamuWorld.getInstance().lives;
         if(LamuWorld.getInstance().lives <= 0)
         {
            LamuWorld.getInstance().dead();
         }
         this.hasDownIntoRiver = false;
         PeopleManageView(GV.MAN_PEOPLE).x = this.initPoint.x;
         PeopleManageView(GV.MAN_PEOPLE).y = this.initPoint.y;
      }
      
      private function onEntreFrameHandler(e:Event) : void
      {
         if(this.hasDownIntoRiver)
         {
            return;
         }
         if(this.touchAreaMC1.hitTestPoint(PeopleManageView(GV.MAN_PEOPLE).x,PeopleManageView(GV.MAN_PEOPLE).y,true))
         {
            if(!(this.movedStoneMC.currentFrame >= 155 && this.movedStoneMC.currentFrame <= 205 || this.movedStoneMC.currentFrame >= 315 && this.movedStoneMC.currentFrame <= 360))
            {
               this.hasDownIntoRiver = true;
               PeopleManageView(GV.MAN_PEOPLE).avatarClass.stopToHere();
               this.fireMC1.play();
            }
            return;
         }
         if(this.touchAreaMC2.hitTestPoint(PeopleManageView(GV.MAN_PEOPLE).x,PeopleManageView(GV.MAN_PEOPLE).y,true))
         {
            if(!(this.movedStoneMC.currentFrame >= 50 && this.movedStoneMC.currentFrame <= 110 || this.movedStoneMC.currentFrame >= 398 && this.movedStoneMC.currentFrame <= 455))
            {
               this.hasDownIntoRiver = true;
               PeopleManageView(GV.MAN_PEOPLE).avatarClass.stopToHere();
               this.fireMC2.play();
            }
            return;
         }
         if(this.touchAreaMC3.hitTestPoint(PeopleManageView(GV.MAN_PEOPLE).x,PeopleManageView(GV.MAN_PEOPLE).y,true))
         {
            if(!(this.movedStoneMC2.currentFrame <= 9 || this.movedStoneMC2.currentFrame > 287 || this.movedStoneMC2.currentFrame >= 75 && this.movedStoneMC2.currentFrame < 199))
            {
               this.hasDownIntoRiver = true;
               PeopleManageView(GV.MAN_PEOPLE).avatarClass.stopToHere();
               this.fireMC3.play();
            }
         }
         else if(this.touchAreaMC4 != null && this.touchAreaMC4.hitTestPoint(PeopleManageView(GV.MAN_PEOPLE).x,PeopleManageView(GV.MAN_PEOPLE).y,true))
         {
            this.hasDownIntoRiver = true;
            PeopleManageView(GV.MAN_PEOPLE).avatarClass.stopToHere();
            this.fireMC4.play();
         }
         else if(this.touchAreaMC5.hitTestPoint(PeopleManageView(GV.MAN_PEOPLE).x,PeopleManageView(GV.MAN_PEOPLE).y,true))
         {
            this.hasDownIntoRiver = true;
            PeopleManageView(GV.MAN_PEOPLE).avatarClass.stopToHere();
            this.fireMC5.play();
         }
         else if(this.touchAreaMC6.hitTestPoint(PeopleManageView(GV.MAN_PEOPLE).x,PeopleManageView(GV.MAN_PEOPLE).y,true))
         {
            if(this.hasFireed)
            {
               return;
            }
            if(this.fireBallMC.currentFrame >= 4 && this.fireBallMC.currentFrame <= 45)
            {
               --LamuWorld.getInstance().lives;
               if(LamuWorld.getInstance().lives <= 0)
               {
                  LamuWorld.getInstance().dead();
               }
               this.hasFireed = true;
               GV.onlineClass.chating(0,"/zk");
               this.timeID = setTimeout(this.fireSaveTimeOut,2 * 1000);
            }
         }
      }
      
      private function fireSaveTimeOut() : void
      {
         this.hasFireed = false;
         clearTimeout(this.timeID);
      }
      
      private function stoneBrigeDownEventHandler(e:Event) : void
      {
         e.stopPropagation();
         this.botton_mc.removeChild(this.touchAreaMC4);
         this.touchAreaMC4 = null;
         this.temp_mc.addChild(this.stoneBrigeMC);
         this.depth_mc.hit_mc.removeChild(this.depth_mc.hit_mc.autoMC);
      }
      
      override public function destroy() : void
      {
         MoveTo.CanPathPoint = true;
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

