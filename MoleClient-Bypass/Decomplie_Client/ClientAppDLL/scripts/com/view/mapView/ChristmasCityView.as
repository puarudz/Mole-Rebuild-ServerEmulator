package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.greensock.easing.Bounce;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.activityModule.Presented;
   import com.module.activityModule.checkItem;
   import com.module.deal.Deal;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ChristmasCityView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var type_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      private var mole:MovieClip;
      
      private var dozeMole:MovieClip;
      
      private var shiwu_mc:MovieClip;
      
      private var shiwu_mcPoint:Point;
      
      private var yumao_mcMove:Boolean;
      
      private var yumao_mc:MovieClip;
      
      private var yumao_mcPoint:Point;
      
      private var chitie_mc:MovieClip;
      
      private var chitie_mcPoint:Point;
      
      private var dozeMoleBool:Boolean = false;
      
      private var chrisJob92Obj:Object;
      
      public function ChristmasCityView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.type_mc = GV.MC_mapFrame["type_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         this.mole = MovieClip(this.target_mc["mole_mc0"]);
         this.dozeMole = MovieClip(this.target_mc["dozeMole_mc"]);
         this.shiwu_mc = MovieClip(this.top_mc["shiwu_mc"]);
         this.shiwu_mcPoint = new Point(this.shiwu_mc.x,this.shiwu_mc.y);
         this.yumao_mc = MovieClip(this.top_mc["yumao_mc"]);
         this.yumao_mcPoint = new Point(this.yumao_mc.x,this.yumao_mc.y);
         this.chitie_mc = MovieClip(this.top_mc["chitie_mc"]);
         this.chitie_mcPoint = new Point(this.chitie_mc.x,this.chitie_mc.y);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190527,2);
         BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.goto118);
         this.dozeMole.buttonMode = true;
         BC.addEvent(this,this.dozeMole,MouseEvent.CLICK,this.dozeMoleClick);
         BC.addEvent(this,GV.onlineSocket,"get_lamu_shiwu",this.get_lamuHandler);
      }
      
      private function get_lamuHandler(evt:Event) : void
      {
         Presented.getInstance().FreeReceive(83);
      }
      
      private function goto118(e:Event) : void
      {
         if(LocalUserInfo.isVIP())
         {
            BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
            checkItem.checkItemHandler(190532);
         }
         else
         {
            Alert.SLAlart("    找一個有超級拉姆的朋友，邀請你進去看看吧！。");
         }
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
         if(evt.EventObj.num >= 1)
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            GF.switchMap(118,true);
         }
         else
         {
            GF.showAlert(MainManager.getGameLevel(),"    你還沒有聖誕乘車票哦，趕快去禮品秘密製作基地看看，也許有意外驚喜哦!","",100,"iknow",true,false,"E");
         }
      }
      
      private function getHitTestInfo(evt:EventTaomee) : void
      {
         if(evt.EventObj.mc.userID == LocalUserInfo.getUserID())
         {
            this.depth_mc.as_code.gotoAndPlay(3);
         }
      }
      
      private function ok_mapHandler(evt:Event) : void
      {
         this.target_mc.ice_mc_.visible = false;
         this.type_mc.mc.parent.removeChild(this.type_mc.mc);
         MapModelLogic.owner.makeMapArray(true);
      }
      
      private function goToMap115Event(evt:Event) : void
      {
         this.chrisJob92Obj.flag1 = 1;
         JobExpandLogic.getJobExpand().setOneJob(92,this.chrisJob92Obj);
         this.target_mc.door_115.mouseEnabled = true;
         this.target_mc.door_115.mouseChildren = true;
      }
      
      private function dozeMoleOverClick(evt:MouseEvent) : void
      {
         if(this.dozeMoleBool)
         {
            return;
         }
         if(!this.yumao_mcMove)
         {
            return;
         }
         if(this.dozeMole.currentFrame == 4)
         {
            this.dozeMole.gotoAndStop(6);
         }
         else if(this.dozeMole.currentFrame == 6)
         {
         }
      }
      
      private function chitie_mcDownEvent(evt:MouseEvent) : void
      {
         this.chitie_mc.startDrag(true);
         this.chitie_mc.gotoAndStop(1);
         this.chitie_mc.mouseEnabled = false;
         this.chitie_mc.mouseChildren = false;
         BC.removeEvent(this,this.chitie_mc,MouseEvent.MOUSE_DOWN,this.chitie_mcDownEvent);
         BC.addEvent(this,this.chitie_mc.stage,MouseEvent.MOUSE_UP,this.chitie_mcStageUpEvent);
      }
      
      private function chitie_mcStageUpEvent(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.chitie_mc.stage,MouseEvent.MOUSE_UP,this.chitie_mcStageUpEvent);
         this.chitie_mc.stopDrag();
         this.chitie_mc.gotoAndStop(1);
         this.chitie_mc.mouseEnabled = true;
         this.chitie_mc.mouseChildren = true;
         BC.addEvent(this,this.chitie_mc,MouseEvent.MOUSE_DOWN,this.chitie_mcDownEvent);
         if(this.chitie_mc.x < 105 && this.chitie_mc.x > 47 && this.chitie_mc.y > 141 && this.chitie_mc.y < 226)
         {
            if(this.dozeMole.currentFrame == 4)
            {
               TweenLite.to(this.chitie_mc,0.1,{"autoAlpha":0});
               BC.addEvent(this,GV.onlineSocket,"get_key_ok",this.keyOkEvent);
               this.dozeMole.gotoAndStop(7);
            }
            else
            {
               TweenLite.to(this.chitie_mc,0.5,{
                  "x":this.chitie_mcPoint.x,
                  "y":this.chitie_mcPoint.y,
                  "ease":Bounce.easeInOut
               });
            }
         }
         else
         {
            TweenLite.to(this.chitie_mc,0.5,{
               "x":this.chitie_mcPoint.x,
               "y":this.chitie_mcPoint.y,
               "ease":Bounce.easeInOut
            });
         }
      }
      
      private function keyOkEvent(evt:Event) : void
      {
         this.dozeMole.gotoAndStop(1);
         Deal.BuyItem(190527,1,function(ItemnID:uint):void
         {
            chrisJob92Obj.flag2 = 1;
            JobExpandLogic.getJobExpand().setOneJob(92,chrisJob92Obj);
            dozeMoleBool = true;
            Alert.getIconByID_Alart(190527,"    恭喜你獲得聖誕屋大門鑰匙，已經放入你的百寶箱中了！");
         },function(E:*):void
         {
            Alert.getIconByID_Alart(190527,"你已經有聖誕屋大門鑰匙，不要太貪心哦!");
         });
      }
      
      private function yumao_mcDownEvent(evt:MouseEvent) : void
      {
         this.yumao_mc.startDrag(true);
         this.yumao_mc.gotoAndStop(1);
         this.yumao_mcMove = true;
         this.yumao_mc.mouseEnabled = false;
         this.yumao_mc.mouseChildren = false;
         BC.removeEvent(this,this.yumao_mc,MouseEvent.MOUSE_DOWN,this.yumao_mcDownEvent);
         BC.addEvent(this,this.yumao_mc.stage,MouseEvent.MOUSE_UP,this.yumao_mcStageUpEvent);
      }
      
      private function yumao_mcStageUpEvent(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.yumao_mc.stage,MouseEvent.MOUSE_UP,this.yumao_mcStageUpEvent);
         this.yumao_mc.stopDrag();
         this.yumao_mc.gotoAndStop(1);
         this.yumao_mcMove = false;
         this.yumao_mc.mouseEnabled = true;
         this.yumao_mc.mouseChildren = true;
         BC.addEvent(this,this.yumao_mc,MouseEvent.MOUSE_DOWN,this.yumao_mcDownEvent);
         TweenLite.to(this.yumao_mc,0.5,{
            "x":this.yumao_mcPoint.x,
            "y":this.yumao_mcPoint.y,
            "ease":Bounce.easeInOut
         });
      }
      
      private function shiwu_mcDownEvent(evt:MouseEvent) : void
      {
         this.shiwu_mc.startDrag(true);
         this.shiwu_mc.gotoAndStop(1);
         this.shiwu_mc.mouseEnabled = false;
         this.shiwu_mc.mouseChildren = false;
         BC.removeEvent(this,this.shiwu_mc,MouseEvent.MOUSE_DOWN,this.shiwu_mcDownEvent);
         BC.addEvent(this,this.shiwu_mc.stage,MouseEvent.MOUSE_UP,this.shiwu_mcStageUpEvent);
      }
      
      private function shiwu_mcStageUpEvent(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.shiwu_mc.stage,MouseEvent.MOUSE_UP,this.shiwu_mcStageUpEvent);
         this.shiwu_mc.stopDrag();
         this.shiwu_mc.gotoAndStop(1);
         this.shiwu_mc.mouseEnabled = true;
         this.shiwu_mc.mouseChildren = true;
         BC.addEvent(this,this.shiwu_mc,MouseEvent.MOUSE_DOWN,this.shiwu_mcDownEvent);
         if(this.shiwu_mc.x < 105 && this.shiwu_mc.x > 47 && this.shiwu_mc.y > 141 && this.shiwu_mc.y < 226)
         {
            if(this.dozeMole.currentFrame == 4)
            {
               TweenLite.to(this.shiwu_mc,0.5,{"autoAlpha":0});
               this.dozeMole.gotoAndStop(5);
            }
            else
            {
               TweenLite.to(this.shiwu_mc,0.5,{
                  "x":this.shiwu_mcPoint.x,
                  "y":this.shiwu_mcPoint.y,
                  "onComplete":this.shiwuTweenEvent,
                  "ease":Bounce.easeInOut
               });
            }
         }
         else
         {
            TweenLite.to(this.shiwu_mc,0.5,{
               "x":this.shiwu_mcPoint.x,
               "y":this.shiwu_mcPoint.y,
               "onComplete":this.shiwuTweenEvent,
               "ease":Bounce.easeInOut
            });
         }
      }
      
      private function shiwuTweenEvent() : void
      {
         this.shiwu_mc.gotoAndStop(3);
      }
      
      private function dozeMoleClick(evt:MouseEvent) : void
      {
         if(this.dozeMoleBool)
         {
            this.dozeMole.gotoAndStop(8);
            return;
         }
         if(this.dozeMole.currentFrame == 1)
         {
            this.dozeMole.gotoAndStop(2);
         }
         else if(this.dozeMole.currentFrame == 2)
         {
            this.dozeMole.gotoAndStop(3);
         }
         else if(this.dozeMole.currentFrame != 3)
         {
            if(this.dozeMole.currentFrame == 4)
            {
               this.dozeMole.gotoAndStop(3);
            }
         }
      }
      
      private function moleClick(evt:MouseEvent) : void
      {
         if(this.mole.currentFrame == 4)
         {
            this.mole.gotoAndStop(5);
         }
         else if(this.mole.currentFrame == 5)
         {
            this.mole.gotoAndStop(6);
         }
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         if(evt.EventObj.type == 10)
         {
            if(this.dozeMoleBool)
            {
               if(LocalUserInfo.getMapID() != 115)
               {
                  GV.Room_DefaultRoomID = 0;
                  LocalUserInfo.setMapID(0);
                  switchMapLogic.switchMapLogicHandler(115);
               }
            }
            else
            {
               Alert.smileAlart("    你沒有聖誕屋的鑰匙無法打開這扇門哦！聽說鑰匙在瞌睡蟲的身上！");
            }
         }
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.top_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

