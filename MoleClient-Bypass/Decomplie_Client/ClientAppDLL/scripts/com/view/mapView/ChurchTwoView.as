package com.view.mapView
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.helpPanel.HelpPanel;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.mapModule.Map70Doctor;
   import com.module.npc.dialog.TalkEvent;
   import com.mole.app.map.MapBase;
   import com.view.JobView.ChildMapJob.Job161MapView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ChurchTwoView extends MapBase
   {
      
      private var JobMapLoadGame:Job161MapView;
      
      private var Map70Doctors:Map70Doctor;
      
      private var task80Obje:Object;
      
      public function ChurchTwoView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.JobMapLoadGame = new Job161MapView();
         this.Map70Doctors = new Map70Doctor();
         this.initControl();
         this.initGetCure();
         this.initLanDocBook();
         controlLevel.arrowMc.visible = false;
         BC.addEvent(this,TalkEvent,"anday_andayEvent",function(e:Event):void
         {
            controlLevel.npc_mc.btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         });
         super.initView();
      }
      
      private function initLanDocBook() : void
      {
         buttonLevel.bootBtn.addEventListener(MouseEvent.CLICK,this.onBootBtn);
      }
      
      private function onBootBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("resource/besmearBook/lanDocBookView.swf","正在打開......",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function initGetCure() : void
      {
         controlLevel.getCure.addEventListener(MouseEvent.CLICK,this.onGetCure);
      }
      
      private function onGetCure(evt:MouseEvent) : void
      {
         if(Boolean(MainManager.getGameLevel().getChildByName("hlepBuyUI")))
         {
            return;
         }
         GV.onlineSocket.addEventListener("CURE_CLICK",this.onCureClick);
         HelpPanel.getInstance().panelVisible("BuyUI");
      }
      
      private function onCureClick(evt:EventTaomee) : void
      {
         var cureItemId:int = int(evt.EventObj.itemId);
         var itemObj:Object = new Object();
         itemObj.id = cureItemId;
         itemObj.price = "";
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj,false);
      }
      
      private function initControl() : void
      {
         controlLevel.konwBoard.buttonMode = true;
         controlLevel.konwBoard.addEventListener(MouseEvent.CLICK,this.onKonwBoard);
      }
      
      private function onKonwBoard(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("Konw");
      }
      
      override public function destroy() : void
      {
         controlLevel.konwBoard.removeEventListener(MouseEvent.CLICK,this.onKonwBoard);
         GV.onlineSocket.removeEventListener("CURE_CLICK",this.onCureClick);
         buttonLevel.bootBtn.removeEventListener(MouseEvent.CLICK,this.onBootBtn);
         controlLevel.getCure.removeEventListener(MouseEvent.CLICK,this.onGetCure);
         super.destroy();
      }
   }
}

