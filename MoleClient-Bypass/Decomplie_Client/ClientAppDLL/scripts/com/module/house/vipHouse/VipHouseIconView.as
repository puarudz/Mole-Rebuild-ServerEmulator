package com.module.house.vipHouse
{
   import com.core.info.LocalUserInfo;
   import com.logic.switchMapLogic.switchMapLogic;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class VipHouseIconView
   {
      
      private static const ICON_STRING:String = "houseMC";
      
      protected var iconMC:MovieClip;
      
      protected var nameText:TextField;
      
      protected var bgMC:MovieClip;
      
      protected var button:SimpleButton;
      
      protected var id:int;
      
      protected var name:String;
      
      public function VipHouseIconView(icon_str:String = "")
      {
         super();
         if(icon_str == "")
         {
            icon_str = ICON_STRING;
         }
         this.iconMC = VipHouseManager.getMovieClip(icon_str);
         this.button = this.iconMC["btn"];
         this.bgMC = this.iconMC["name_bg"];
         this.bgMC.visible = false;
         this.nameText = this.iconMC["name_txt"];
         this.nameText.autoSize = TextFieldAutoSize.CENTER;
         this.initHandler();
      }
      
      public function clear() : void
      {
         this.button.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.button.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this.button.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this.nameText = null;
         this.bgMC = null;
         this.button = null;
         this.iconMC = null;
      }
      
      public function getIconMC() : MovieClip
      {
         return this.iconMC;
      }
      
      public function setID(i:int) : void
      {
         if(i != 58)
         {
            this.id = i + GV.TwentyBillion;
         }
         else
         {
            this.id = i;
         }
      }
      
      public function setName(i:String) : void
      {
         this.name = i;
      }
      
      private function initHandler() : void
      {
         this.button.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.button.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this.button.addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         this.iconMC.parent.addChildAt(this.iconMC,this.iconMC.parent.numChildren - 1);
         this.iconMC.gotoAndStop(2);
         this.nameText.text = this.name + "的家園";
         this.countTextPosition();
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         this.iconMC.gotoAndStop(1);
         this.nameText.text = "";
         this.bgMC.visible = false;
      }
      
      protected function clickHandler(event:MouseEvent) : void
      {
         if(this.id == LocalUserInfo.getMapID())
         {
            return;
         }
         if(GV.MapInfo_mapID < 1000)
         {
            GV.MyInfo_PrevMap = GV.MapInfo_mapID;
         }
         LocalUserInfo.setMapID(0);
         GV.Room_DefaultRoomID = this.id;
         switchMapLogic.switchMapLogicHandler(this.id);
      }
      
      private function countTextPosition() : void
      {
         this.bgMC.visible = true;
         this.bgMC.width = this.nameText.width + 8;
         this.bgMC.height = this.nameText.height + 8;
         this.nameText.x = this.bgMC.x + 4;
         this.nameText.y = this.bgMC.y + 4;
      }
   }
}

