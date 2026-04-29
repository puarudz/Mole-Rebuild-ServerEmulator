package com.view.mapView.activity.Task83
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ModuleType;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SuperPrivilegeCtl
   {
      
      private static var _instance:SuperPrivilegeCtl;
      
      private var gift_MC:MovieClip;
      
      private var childMC:Loader;
      
      public function SuperPrivilegeCtl()
      {
         super();
      }
      
      public static function getInstance() : SuperPrivilegeCtl
      {
         if(_instance == null)
         {
            _instance = new SuperPrivilegeCtl();
         }
         return _instance;
      }
      
      public function onOpenSuperLamuGift() : void
      {
         if(LocalUserInfo.isVIP())
         {
            StatisticsClass.getInstance().init(67744888);
         }
         else
         {
            StatisticsClass.getInstance().init(67744889);
         }
         BC.addEvent(this,GV.onlineSocket,"superLamuGiftCloseEvent",this.onCloseSuperLamuGift);
         this.onLoadPanel("module/external/SuperLamuGiftMain.swf");
      }
      
      private function onCloseSuperLamuGift(event:EventTaomee) : void
      {
         if(event.EventObj.mapID == 0)
         {
            return;
         }
         BC.removeEvent(this,GV.onlineSocket,"superLamuGiftCloseEvent",this.onCloseSuperLamuGift);
         this.clearHandler();
         this.switchMap(event.EventObj.mapID);
      }
      
      public function onOpenSuperPrivilegeBook(num:uint = 1) : void
      {
         if(LocalUserInfo.isVIP())
         {
            StatisticsClass.getInstance().init(67744897);
         }
         else
         {
            StatisticsClass.getInstance().init(67744887);
         }
         ModuleManager.openPanel(ModuleType.SUPER_LAHM_INTRO_PANEL,num);
      }
      
      private function onOpenSuperGift(event:Event) : void
      {
         this.onCloseSuperPrivilegeBook();
         this.onOpenSuperLamuGift();
      }
      
      private function onOpenSuperGoGo(event:Event) : void
      {
         this.onCloseSuperPrivilegeBook();
         StatisticsClass.getInstance().init(67744851);
         ModuleManager.openPanel("SuperGoGoPanel");
      }
      
      private function onCloseSuperPrivilegeBook(e:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"superLamuPrivilegeOnOpenSuperGift",this.onOpenSuperGift);
         BC.removeEvent(this,GV.onlineSocket,"superLamuPrivilegeOnOpenSuperGoGo",this.onOpenSuperGoGo);
         BC.removeEvent(this,GV.onlineSocket,"superLamuPrivilegeClose",this.onCloseSuperPrivilegeBook);
         BC.removeEvent(this,GV.onlineSocket,"superLamuPrivilegeSwitchMap",this.oneSuperPrivilegeBookToSwitchMap);
         this.clearHandler();
      }
      
      private function oneSuperPrivilegeBookToSwitchMap(e:EventTaomee) : void
      {
         if(e.EventObj.mapID == 0)
         {
            return;
         }
         BC.removeEvent(this,GV.onlineSocket,"superLamuPrivilegeClose",this.onCloseSuperPrivilegeBook);
         BC.removeEvent(this,GV.onlineSocket,"superLamuPrivilegeSwitchMap",this.oneSuperPrivilegeBookToSwitchMap);
         this.clearHandler();
         this.switchMap(e.EventObj.mapID);
      }
      
      private function switchMap(mapID:int) : void
      {
         if(mapID == 0)
         {
            return;
         }
         MapManager.enterMap(mapID);
      }
      
      private function onLoadPanel(url:String, waitText:String = "正在加載......") : void
      {
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         MainManager.getAppLevel().addChild(this.gift_MC);
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,waitText);
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
         var mcloader:MCLoader = e.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         mcloader.clear();
      }
      
      public function clearHandler() : void
      {
         GC.clearAll(this.gift_MC);
         GC.clearAll(this.childMC);
         this.gift_MC = null;
         this.childMC = null;
      }
   }
}

