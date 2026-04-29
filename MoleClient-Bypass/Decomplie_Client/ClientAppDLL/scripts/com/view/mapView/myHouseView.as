package com.view.mapView
{
   import com.core.info.LocalUserInfo;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.pet.petLogic;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class myHouseView
   {
      
      public static var isMyHouse:Boolean = false;
      
      public static var editMode:Boolean = false;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var petUIMC:MovieClip;
      
      private var myTimeout:*;
      
      public function myHouseView()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         setTimeout(this.init,100);
      }
      
      public function init() : void
      {
         editMode = false;
         if(LocalUserInfo.getMapID() == LocalUserInfo.getUserID())
         {
            isMyHouse = true;
         }
         else
         {
            isMyHouse = false;
         }
         petLogic.init();
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeHandler);
         this.initBtn();
      }
      
      public function initBtn() : void
      {
         this.target_mc.door_btn.addEventListener(MouseEvent.CLICK,this.leaveHome);
         this.target_mc.door_btn.addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
         this.target_mc.door_btn.addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
      }
      
      public function leaveHome(e:Event) : void
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.clearTip();
         this.target_mc.door_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.goto2);
         this.target_mc.door_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         switchMapLogic.switchMapLogicHandler(GV.MyInfo_PrevMap);
      }
      
      public function goto2(e:*) : void
      {
         this.showtip(e.target);
         if(e.target.name == "door_btn")
         {
            this.target_mc["door"].gotoAndStop(2);
         }
      }
      
      public function goto1(e:Event) : void
      {
         this.cleartip();
         if(e.target.name == "door_btn")
         {
            this.target_mc["door"].gotoAndStop(1);
         }
      }
      
      public function showtip(mc:DisplayObject) : void
      {
         var btnName:String = null;
         btnName = mc.name;
         this.cleartip();
         this.myTimeout = setTimeout(function():*
         {
            switch(btnName)
            {
               case "door_btn":
                  GF.showTip("離開小屋",{
                     "x":240,
                     "y":220
                  });
            }
         },300);
      }
      
      private function cleartip() : void
      {
         if(this.myTimeout != null)
         {
            clearTimeout(this.myTimeout);
            GF.clearTip();
         }
      }
      
      private function removeHandler(evt:Event) : void
      {
      }
   }
}

