package com.view.mapView
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.module.ninePicGame.ninePicGame;
   import com.module.ninePicGame.tuya;
   import com.module.superPetModule.petItemModule;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class underRoomView extends MapBase
   {
      
      private var help:MovieClip;
      
      public function underRoomView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         if(LocalUserInfo.isVIP() && GV.MAN_PEOPLE.Petlevel == 101)
         {
            buttonLevel.room_btn_down.visible = true;
            buttonLevel.change_1.visible = true;
            petItemModule.setPetEffectHandler(null,2);
         }
         else
         {
            buttonLevel.room_btn_down.visible = false;
            buttonLevel.change_1.visible = false;
         }
         GV.onlineSocket.addEventListener("openthedoor",this.openDoorHandler);
         new ninePicGame(controlLevel.nineMC.mc7,3);
         tuya.init(controlLevel);
         petItemModule.itemVisibleHandler(controlLevel);
         controlLevel.helpBtn.addEventListener(MouseEvent.CLICK,this.helpHandler);
      }
      
      private function helpHandler(event:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!MainManager.getAppLevel().getChildByName("help"))
         {
            tempMC = GV.Lib_Map.getClass("RUSSIA_HELP");
            this.help = new tempMC();
            this.help.name = "help";
            MainManager.getAppLevel().addChild(this.help);
            MainManager.centerObj(this.help);
            this.help.closeBtn.addEventListener(MouseEvent.CLICK,this.closeBtnHandler);
         }
      }
      
      private function closeBtnHandler(event:MouseEvent) : void
      {
         this.help.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeBtnHandler);
         MainManager.getAppLevel().removeChild(this.help);
         this.help = null;
      }
      
      private function openDoorHandler(evt:Event) : void
      {
         buttonLevel.room_btn_down.visible = true;
         buttonLevel.change_1.visible = true;
      }
      
      override public function destroy() : void
      {
         controlLevel.helpBtn.removeEventListener(MouseEvent.CLICK,this.helpHandler);
         GV.onlineSocket.removeEventListener("openthedoor",this.openDoorHandler);
         super.destroy();
      }
   }
}

