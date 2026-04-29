package com.view.mapView
{
   import com.core.info.LocalUserInfo;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.sendBirthdayCard.ChargeGiveThing;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BoxMapView extends MapBase
   {
      
      public var topMC:MovieClip;
      
      private var num:int = 1;
      
      private var caomei:int = 0;
      
      public function BoxMapView()
      {
         super();
      }
      
      private function get target_mc() : MovieClip
      {
         return _mapLevel.controlLevel as MovieClip;
      }
      
      private function get depth_mc() : MovieClip
      {
         return _mapLevel.depthLevel as MovieClip;
      }
      
      override protected function initView() : void
      {
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.target_mc.chocolate_Lamu_mc.buttonMode = true;
         this.depth_mc.mouseChildren = true;
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            this.target_mc.getCloths1_mc.visible = true;
            this.target_mc.getCloths2_mc.visible = true;
         }
         else
         {
            this.target_mc.getCloths1_mc.visible = false;
            this.target_mc.getCloths2_mc.visible = false;
         }
         BC.addEvent(this,this.depth_mc,"getProp",this.getProp);
         BC.addEvent(this,this.target_mc.TimeGate_mc,"over",this.changeMap);
         BC.addEvent(this,this.target_mc.hitMC,"onHit",this.leverMap);
         BC.addEvent(this,this.target_mc.getCloths1_mc,MouseEvent.CLICK,this.getMole1Cloths);
         BC.addEvent(this,this.target_mc.getCloths2_mc,MouseEvent.CLICK,this.getMole2Cloths);
         BC.addEvent(this,this.target_mc.sz_mc,MouseEvent.CLICK,this.getSZ);
      }
      
      override public function init() : void
      {
         this.getCakeBox();
      }
      
      private function getSZ(E:MouseEvent) : void
      {
         GV.itemID = 3;
         var itemObj:Object = new Object();
         itemObj.id = 12534;
         itemObj.price = 0;
         itemObj.info = "0";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function getMole1Cloths(E:Event) : void
      {
         var itemObj:Object = null;
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            GV.itemID = 3;
            itemObj = new Object();
            itemObj.id = 12217;
            itemObj.price = 0;
            itemObj.info = "0";
            clothBuyModule.buyAction(itemObj);
         }
      }
      
      private function getMole2Cloths(E:Event) : void
      {
         var itemObj:Object = null;
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            GV.itemID = 3;
            itemObj = new Object();
            itemObj.id = 12216;
            itemObj.price = 0;
            itemObj.info = "0";
            clothBuyModule.buyAction(itemObj);
         }
      }
      
      private function getProp(E:Event) : void
      {
         var g:Number = Math.random();
         if(g < 0.05)
         {
            this.topMC.yadan_mc.play();
         }
         else if(g < 0.3)
         {
            if(this.caomei < 2)
            {
               this.getItemEvent();
               ++this.caomei;
            }
         }
      }
      
      private function getItemEvent() : void
      {
         var chargeGiveThing:ChargeGiveThing = new ChargeGiveThing();
         chargeGiveThing.itemID = 180044;
         chargeGiveThing.itemCount = 1;
         chargeGiveThing.msg = "        你得到了一個草莓派！";
         chargeGiveThing.url = "resource/pet/icon/180044.swf";
         chargeGiveThing.panle = 0;
         chargeGiveThing.getThing();
      }
      
      private function changeMap(E:Event) : void
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         switchMapLogic.switchMapLogicHandler(73);
      }
      
      private function leverMap(E:*) : void
      {
         GF.switchPrevMap();
      }
      
      private function eatCakeFun(E:MouseEvent) : void
      {
         var mc:MovieClip = E.currentTarget as MovieClip;
         mc.play();
      }
      
      private function getNextCake(E:Event) : void
      {
         var mc:MovieClip = E.currentTarget as MovieClip;
         mc.buttonMode = false;
         mc.filters = [];
         BC.removeEvent(this,mc);
         this.target_mc.cake_shadow_mc.gotoAndStop(this.num);
         this.getCakeBox();
         if(mc.name == "m29_mc")
         {
            GV.MC_mapFrame["top_mc"].liwu_mc.play();
            this.topMC.filters_mc.gotoAndStop(1);
         }
      }
      
      private function showFilters(E:Event) : void
      {
         var mc:MovieClip = E.currentTarget as MovieClip;
         mc.filters = this.topMC.filters_mc.mc.filters;
      }
      
      private function getCakeBox() : void
      {
         var p:PeopleManageView = null;
         var n:int = this.num;
         if(n < 30)
         {
            this.topMC.filters_mc.play();
            p = GV.MAN_PEOPLE as PeopleManageView;
            p.showWordBoxMSG({"EventObj":{"msg":"/hc"}});
            GV.onlineClass.chating(0,"/hc");
            BC.addEvent(this,this.depth_mc["m" + n + "_mc"],MouseEvent.CLICK,this.eatCakeFun);
            BC.addEvent(this,this.depth_mc["m" + n + "_mc"],"over",this.getNextCake);
            BC.addEvent(this,this.depth_mc["m" + n + "_mc"],Event.ENTER_FRAME,this.showFilters);
            this.depth_mc["m" + n + "_mc"].buttonMode = true;
            ++this.num;
         }
      }
   }
}

