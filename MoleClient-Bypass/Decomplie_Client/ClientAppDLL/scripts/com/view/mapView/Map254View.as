package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.ModuleType;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Map254View extends MapBase
   {
      
      private var _game_2:SimpleButton;
      
      public function Map254View()
      {
         super();
         Map255View.setPrevMapID(254);
      }
      
      override protected function initView() : void
      {
         GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.onStartPoke);
         this.addGoMap255Events();
         this._game_2 = controlLevel["game_2"];
         this._game_2.addEventListener(MouseEvent.CLICK,this.onOpenPoke);
      }
      
      override public function init() : void
      {
         super.init();
      }
      
      private function addGoMap255Events() : void
      {
         controlLevel.go255Btn.buttonMode = true;
         BC.addEvent(this,controlLevel.go255Btn,MouseEvent.MOUSE_OVER,this.on255BtnOver,false,0,true);
         BC.addEvent(this,controlLevel.go255Btn,MouseEvent.MOUSE_OUT,this.on255BtnOut,false,0,true);
         BC.addEvent(this,controlLevel.go255Btn,MouseEvent.CLICK,this.on255BtnClick,false,0,true);
      }
      
      private function on255BtnClick(e:MouseEvent) : void
      {
         GV.MAN_PEOPLE.moveTo(790,350);
         BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.goOver);
      }
      
      private function goOver(e:*) : void
      {
         if(GV.MAN_PEOPLE.x == 790 && GV.MAN_PEOPLE.y == 350)
         {
            BC.removeEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.goOver);
            MapManager.enterMap(255);
         }
      }
      
      private function on255BtnOver(e:MouseEvent) : void
      {
         controlLevel.go255Mc.gotoAndStop(2);
      }
      
      private function on255BtnOut(e:MouseEvent) : void
      {
         controlLevel.go255Mc.gotoAndStop(1);
      }
      
      private function onOpenPoke(e:Event) : void
      {
         ModuleManager.openPanel(ModuleType.POKE_BUBBLES_PANEL);
      }
      
      private function onStartPoke(e:EventTaomee) : void
      {
         var appCtl:AppModuleControl = null;
         var finishPro:finishSomethingRes = e.EventObj as finishSomethingRes;
         if(finishPro.Type == 1579)
         {
            appCtl = ModuleManager.openPanel(ModuleType.POKE_BUBBLES_PANEL);
            appCtl.addEventListener(ModuleEvent.DESTROY,function(e:ModuleEvent):void
            {
               appCtl.removeEventListener(ModuleEvent.DESTROY,arguments.callee);
               if(Boolean(e.data))
               {
                  BC.addOnceEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,onSwapSucc);
                  exchange.exchange_goods(1579);
               }
            });
         }
      }
      
      private function onSwapSucc(e:EventTaomee) : void
      {
         if(e.EventObj.Count != 0)
         {
            Alert.smileAlart("　　恭喜你獲得了庫拉私藏的寶貝：2個海洋之星。");
         }
      }
      
      override public function destroy() : void
      {
         this._game_2.removeEventListener(MouseEvent.CLICK,this.onOpenPoke);
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.onStartPoke);
         super.destroy();
      }
   }
}

