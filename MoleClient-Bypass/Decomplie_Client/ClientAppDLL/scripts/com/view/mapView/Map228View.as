package com.view.mapView
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import com.core.newloader.MCLoader;
   import com.module.angelFight.AngelFightMain;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.view.mapView.activity.Task83.TestAngelFight;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Map228View extends MapBase
   {
      
      public function Map228View()
      {
         super();
      }
      
      override protected function initView() : void
      {
         var _temp_4:* = BC;
         var _temp_3:* = this;
         var _temp_2:* = controlLevel.mapBtn;
         var _temp_1:* = MouseEvent.CLICK;
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function h(e:MouseEvent):void
            {
               AngelFightMain.instance.OpenFightMapHandler();
            });
            SystemEventManager.addEventListener("gina_Buy",this.onOpenBuy);
            SystemEventManager.addEventListener("gina_Swap",this.onOpenSwap);
            SystemEventManager.addEventListener("saya358_JoinFight",this.onOpenFightMapHandler);
            SystemEventManager.addEventListener("saya358_ShowAngelFightDemo",this.onShowAngelFightDemo);
         }
         
         private function onOpenFightMapHandler(e:Event) : void
         {
            AngelFightMain.instance.OpenFightMapHandler();
         }
         
         private function onShowAngelFightDemo(e:Event) : void
         {
            BC.addOnceEvent(this,GV.onlineSocket,"task336Three",function(e:Event):void
            {
               mapSay(6);
            });
            MCLoader.LoadModule("module/external/taskMc/task336/task336MC3.swf","正在打開...",LevelManager.appLevel,function(content:*):void
            {
               content.colorObj = GV.myInfo_Color;
            });
         }
         
         private function onOpenBuy(e:SystemEvent) : void
         {
            TestAngelFight.getInstance().momoType = 2;
            TestAngelFight.getInstance().loaderMomoMonsterBuy();
         }
         
         private function onOpenSwap(e:SystemEvent) : void
         {
            TestAngelFight.getInstance().momoType = 1;
            TestAngelFight.getInstance().loaderMomoMonsterBuy();
         }
         
         private function openCardGuide(evt:*) : void
         {
            new LoadGame("module/external/Bibabo.swf","正在加載...",MainManager.getAppLevel());
         }
         
         override public function destroy() : void
         {
            SystemEventManager.removeEventListener("gina_Buy",this.onOpenBuy);
            SystemEventManager.removeEventListener("gina_Swap",this.onOpenSwap);
            SystemEventManager.removeEventListener("saya358_JoinFight",this.onOpenFightMapHandler);
            SystemEventManager.removeEventListener("saya358_ShowAngelFightDemo",this.onShowAngelFightDemo);
            super.destroy();
         }
      }
   }
   
   