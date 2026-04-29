package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Alert.childAlert.customAlert;
   import com.core.MainManager;
   import com.logic.PeasMachinelogic.PeasMachine;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.NPCEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.type.ModuleType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class BankMapView extends MapBase
   {
      
      private var elaineMC:MovieClip;
      
      private var saveTime:uint;
      
      private var saveFrame:uint = 84;
      
      private var buildModul:customAlert;
      
      public function BankMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,_mapLevel.controlLevel["bankBtn"],MouseEvent.CLICK,this.loadBankEvent);
         BC.addEvent(this,_mapLevel.controlLevel["bookBtn"],MouseEvent.CLICK,this.bookBtnEvent);
         BC.addEvent(this,_mapLevel.controlLevel["ATM_btn"],MouseEvent.CLICK,this.showATMHandler);
         BC.addEvent(this,_mapLevel.controlLevel["buildCard_mc"],MouseEvent.CLICK,this.showBuildHandler);
         BC.addEvent(this,_mapLevel.controlLevel["elaine"],MouseEvent.CLICK,this.elaineBtnHandler);
         BC.addEvent(this,_mapLevel.controlLevel["elaine"],MouseEvent.MOUSE_OVER,this.elaineOverHandler);
         BC.addEvent(this,_mapLevel.controlLevel["elaine"],MouseEvent.MOUSE_OUT,this.elaineOutHandler);
         BC.addEvent(this,GV.onlineSocket,"GET_MONEY",this.getMoneyHandler);
         BC.addEvent(this,GV.onlineSocket,"SAVE_MONEY",this.svaeMoneyHandler);
         _mapLevel.controlLevel["SMC_btn"].addEventListener(MouseEvent.CLICK,this.SMC_btnHandler);
         if(MainManager.getGlobalObject().data.BankToalNum == 1)
         {
            _mapLevel.controlLevel["el_test_mc"].visible = false;
            _mapLevel.controlLevel["el_test_mc"].gotoAndStop(1);
         }
      }
      
      private function SMC_btnHandler(event:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/GetSMCPay.swf","正在打開SMC工資表",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function showATMHandler(evt:MouseEvent) : void
      {
         new PeasMachine();
      }
      
      private function showBuildHandler(evt:MouseEvent) : void
      {
         if(Boolean(this.buildModul))
         {
            return;
         }
         this.buildModul = new customAlert(GV.MC_AppLever,"buildCardView,加載中...","module/external/buildCard.swf",1);
         BC.addEvent(this,this.buildModul,Alert.ON_CUSTOM_LOADED,this.buildInit);
         this.buildModul.load();
      }
      
      private function buildIclosePan(event:*) : void
      {
         this.buildModul = null;
      }
      
      private function buildInit(event:*) : void
      {
         BC.addEvent(this,this.buildModul.TARGET,Event.REMOVED_FROM_STAGE,this.buildIclosePan);
      }
      
      private function getMoneyHandler(event:Event) : void
      {
         _mapLevel.controlLevel["getMoneyMC"].gotoAndPlay(2);
      }
      
      private function svaeMoneyHandler(event:Event) : void
      {
         this.saveTime = setInterval(this.saveMoney,40);
      }
      
      private function saveMoney() : void
      {
         --this.saveFrame;
         if(this.saveFrame > 0)
         {
            _mapLevel.controlLevel["getMoneyMC"].gotoAndStop(this.saveFrame);
         }
         else
         {
            clearInterval(this.saveTime);
            this.saveFrame = 84;
            _mapLevel.controlLevel["getMoneyMC"].gotoAndStop(1);
         }
      }
      
      private function elaineBtnHandler(event:MouseEvent) : void
      {
         NPCEvent.sendEvent(NPCEvent.GET_NPC_BUTTON,null,event.currentTarget);
      }
      
      private function colseHandler(event:MouseEvent) : void
      {
         this.elaineMC.close_btn.removeEventListener(MouseEvent.CLICK,this.colseHandler);
         this.elaineMC.konwBtn.removeEventListener(MouseEvent.CLICK,this.colseHandler);
         MainManager.getAppLevel().removeChild(this.elaineMC);
      }
      
      private function elaineOverHandler(event:MouseEvent) : void
      {
         var mc:MovieClip = event.currentTarget as MovieClip;
         mc.gotoAndPlay(2);
      }
      
      private function elaineOutHandler(event:MouseEvent) : void
      {
         var mc:MovieClip = event.currentTarget as MovieClip;
         mc.gotoAndStop(1);
      }
      
      private function loadBankEvent(evt:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.BLANK_ATM_PANEL);
      }
      
      private function bookBtnEvent(event:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("resource/besmearBook/elaineBookView.swf","正在加載書籍",MainManager.getGameLevel());
         loadGame = null;
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         clearInterval(this.saveTime);
         _mapLevel.destroy();
         _mapLevel = null;
      }
   }
}

