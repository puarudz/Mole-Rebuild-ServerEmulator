package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.*;
   import com.logic.socket.petClass.ListItem.PetStep5ClassSocket;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LamuMysticMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      private var tip:MovieClip;
      
      private var top_mc:MovieClip;
      
      private var type_mc:MovieClip;
      
      private var doorBool:Boolean = false;
      
      private var panel:MovieClip;
      
      public function LamuMysticMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.type_mc = GV.MC_mapFrame["type_mc"];
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         controlLevel["flameButterfly"].addEventListener(MouseEvent.CLICK,this.onFlameButterfly);
         controlLevel["flameButterfly"].buttonMode = true;
      }
      
      private function onFlameButterfly(evt:MouseEvent) : void
      {
         MovieClip(controlLevel["flameButterfly"]).gotoAndPlay(2);
         MovieClip(controlLevel["flameButterfly"]).addEventListener("playOver",this.playOverHandler);
      }
      
      private function playOverHandler(evt:Event) : void
      {
         MovieClip(controlLevel["flameButterfly"]).removeEventListener("playOver",this.playOverHandler);
         ActivityTmpDataManager.getTransferItem(3);
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         switch(evt.EventObj.type)
         {
            case 1:
               this.firstEvent();
               break;
            case 2:
               this.secondEvent();
               break;
            case 3:
               this.thirdlyEvent();
               break;
            case 4:
               this.fourthEvent();
         }
      }
      
      private function thirdlyEvent() : void
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.switchMap(124,true);
      }
      
      private function fourthEvent() : void
      {
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1204,this.lamuIce1204);
            PetStep5ClassSocket.askPetStep5Class(GV.MyInfo_PetObj.SpriteID,1);
         }
         else
         {
            this.depth_mc.st_btn_1.gotoAndStop(2);
         }
      }
      
      private function lamuIce1204(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1204,this.lamuIce1204);
         if(evt.EventObj.status == 0)
         {
            Alert.smileAlart("    你所帶的拉姆還沒有接受拉姆王的考驗哦，快帶它去藏寶神殿接受拉姆王的考驗吧！");
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"iceMcPlay",this.iceMcPlayOven);
            this.depth_mc.st_btn_1.gotoAndStop(3);
            MoveTo.CanMove = false;
         }
      }
      
      private function iceMcPlayOven(evt:Event) : void
      {
         var p:MovieClip = null;
         BC.removeEvent(this,GV.onlineSocket,"iceMcPlay",this.iceMcPlayOven);
         this.target_mc.btn_4.visible = false;
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            p = GV.MAN_PEOPLE;
            p.lamu_follow_off();
            p.lamu.autoMove = false;
            TweenLite.to(p.lamu,1,{
               "scaleX":0.5,
               "scaleY":0.5,
               "onComplete":this.iceTweenEvent
            });
            BC.addEvent(this,GV.onlineSocket,"lahm_go_home",this.slgoHomeFun);
         }
         else
         {
            this.target_mc.btn_4.visible = true;
            this.depth_mc.st_btn_1.gotoAndStop(1);
            MoveTo.CanMove = true;
         }
      }
      
      private function iceTweenEvent() : void
      {
         BC.addEvent(this,GV.onlineSocket,"lahm_go_home",this.slgoHomeFun);
         var p:MovieClip = GV.MAN_PEOPLE;
         p.lamu.MoveTo(this.target_mc.ice_mc.x,this.target_mc.ice_mc.y);
         BC.addEvent(this,p.lamu,PeopleManageView.ON_GO_OVER,this.pIceEvent);
      }
      
      private function slgoHomeFun(evt:*) : void
      {
         this.target_mc.btn_4.visible = true;
         this.depth_mc.st_btn_1.gotoAndStop(1);
         MoveTo.CanMove = true;
      }
      
      private function pIceEvent(evt:Event) : void
      {
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            GF.switchMap(133,true);
         }
         else
         {
            this.target_mc.btn_4.visible = true;
            this.depth_mc.st_btn_1.gotoAndStop(1);
            MoveTo.CanMove = true;
         }
      }
      
      private function secondEvent() : void
      {
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1204,this.lamu1204Second);
            PetStep5ClassSocket.askPetStep5Class(GV.MyInfo_PetObj.SpriteID,1);
         }
         else
         {
            this.depth_mc.st_btn_2.gotoAndStop(2);
         }
      }
      
      private function lamu1204Second(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1204,this.lamu1204Second);
         if(evt.EventObj.status == 0)
         {
            Alert.smileAlart("    你所帶的拉姆還沒有接受拉姆王的考驗哦，快帶它去藏寶神殿接受拉姆王的考驗吧！");
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"treeMcPlay",this.treePlayOven);
            this.depth_mc.st_btn_2.gotoAndStop(3);
            MoveTo.CanMove = false;
         }
      }
      
      private function treePlayOven(evt:Event) : void
      {
         var p:MovieClip = null;
         BC.removeEvent(this,GV.onlineSocket,"treeMcPlay",this.treePlayOven);
         this.target_mc.btn_5.visible = false;
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            p = GV.MAN_PEOPLE;
            p.lamu_follow_off();
            p.lamu.autoMove = false;
            TweenLite.to(p.lamu,1,{
               "scaleX":0.5,
               "scaleY":0.5,
               "onComplete":this.lamuTreeEventFun
            });
            BC.addEvent(this,GV.onlineSocket,"lahm_go_home",this.lahm_goHomeHandler);
         }
         else
         {
            this.target_mc.btn_5.visible = true;
            this.depth_mc.st_btn_2.gotoAndStop(1);
            MoveTo.CanMove = true;
         }
      }
      
      private function lamuTreeEventFun() : void
      {
         BC.addEvent(this,GV.onlineSocket,"lahm_go_home",this.lahm_goHomeHandler);
         var p:MovieClip = GV.MAN_PEOPLE;
         p.lamu.MoveTo(this.target_mc.tree_mc_.x,this.target_mc.tree_mc_.y);
         BC.addEvent(this,p.lamu,PeopleManageView.ON_GO_OVER,this.pOvenEventFun);
      }
      
      private function lahm_goHomeHandler(evt:*) : void
      {
         this.target_mc.btn_5.visible = true;
         this.depth_mc.st_btn_2.gotoAndStop(1);
         MoveTo.CanMove = true;
      }
      
      private function pOvenEventFun(evt:Event) : void
      {
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            GF.switchMap(128,true);
         }
         else
         {
            this.target_mc.btn_5.visible = true;
            this.depth_mc.st_btn_2.gotoAndStop(1);
            MoveTo.CanMove = true;
         }
      }
      
      private function firstEvent() : void
      {
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1204,this.lamu1204);
            PetStep5ClassSocket.askPetStep5Class(GV.MyInfo_PetObj.SpriteID,1);
         }
         else
         {
            this.depth_mc.st_btn.gotoAndStop(2);
         }
      }
      
      private function lamu1204(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1204,this.lamu1204);
         if(evt.EventObj.status == 0)
         {
            Alert.smileAlart("    你所帶的拉姆還沒有接受拉姆王的考驗哦，快帶它去藏寶神殿接受拉姆王的考驗吧！");
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"stonMcPlay",this.playOven);
            this.depth_mc.st_btn.gotoAndStop(3);
            MoveTo.CanMove = false;
         }
      }
      
      private function playOven(evt:Event) : void
      {
         var p:MovieClip = null;
         BC.removeEvent(this,GV.onlineSocket,"stonMcPlay",this.playOven);
         this.target_mc.btn_3.visible = false;
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            p = GV.MAN_PEOPLE;
            p.lamu_follow_off();
            p.lamu.autoMove = false;
            TweenLite.to(p.lamu,1,{
               "scaleX":0.5,
               "scaleY":0.5,
               "onComplete":this.lamuTweenEvent
            });
            BC.addEvent(this,GV.onlineSocket,"lahm_go_home",this.lahm_goHomeFun);
         }
         else
         {
            this.target_mc.btn_3.visible = true;
            this.depth_mc.st_btn.gotoAndStop(1);
            MoveTo.CanMove = true;
         }
      }
      
      private function lamuTweenEvent() : void
      {
         BC.addEvent(this,GV.onlineSocket,"lahm_go_home",this.lahm_goHomeFun);
         var p:MovieClip = GV.MAN_PEOPLE;
         p.lamu.MoveTo(this.target_mc.lamu_mc.x,this.target_mc.lamu_mc.y);
         BC.addEvent(this,p.lamu,PeopleManageView.ON_GO_OVER,this.pOvenEvent);
      }
      
      private function lahm_goHomeFun(evt:*) : void
      {
         this.target_mc.btn_3.visible = true;
         this.depth_mc.st_btn.gotoAndStop(1);
         MoveTo.CanMove = true;
      }
      
      private function pOvenEvent(evt:Event) : void
      {
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            GF.switchMap(125,true);
         }
         else
         {
            this.target_mc.btn_3.visible = true;
            this.depth_mc.st_btn.gotoAndStop(1);
            MoveTo.CanMove = true;
         }
      }
      
      override public function destroy() : void
      {
         controlLevel["flameButterfly"].removeEventListener(MouseEvent.CLICK,this.onFlameButterfly);
         MovieClip(controlLevel["flameButterfly"]).removeEventListener("playOver",this.playOverHandler);
         BC.removeEvent(this);
         this.depth_mc = null;
         this.depth_mc = null;
         super.destroy();
      }
   }
}

