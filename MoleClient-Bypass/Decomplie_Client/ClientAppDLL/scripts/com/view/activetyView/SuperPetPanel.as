package com.view.activetyView
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.lockHome.lockHomeRes;
   import com.module.activityModule.CheckVip;
   import com.module.pet.petLogic;
   import com.view.toolView.SaveMoney;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SuperPetPanel
   {
      
      private static var instance:SuperPetPanel;
      
      private static var petNewNum:String = "22";
      
      private var target_mc:MovieClip;
      
      private var url:String = "";
      
      private var isActivation:Boolean = true;
      
      private var testLoadObj:MCLoader;
      
      private var superPetUI:MovieClip;
      
      private var testChildMC:*;
      
      public function SuperPetPanel()
      {
         super();
      }
      
      public static function getInstance() : SuperPetPanel
      {
         if(instance == null)
         {
            instance = new SuperPetPanel();
         }
         return instance;
      }
      
      public function init(target:MovieClip = null) : void
      {
         this.target_mc = target;
         this.addEvent();
         petLogic.isSuperPet(true);
         this.initURL();
      }
      
      private function checkSupetEvent(evt:Event) : void
      {
      }
      
      private function initURL() : void
      {
         var checkvip:CheckVip = null;
         if(LocalUserInfo.isVIP())
         {
            checkvip = new CheckVip();
            GV.onlineSocket.addEventListener(CheckVip.VIP_DAYS,this.showPetHandler);
            checkvip.listVip();
         }
         else if(Boolean(LocalUserInfo.getVip() >> 5 & 1))
         {
            LocalUserInfo.vipDays = -1;
            this.url = "resource/superPetUI/superPull.swf";
            this.initSuperPetHandler();
         }
         else
         {
            this.url = "resource/superPetUI/superPull.swf";
            this.initSuperPetHandler();
         }
      }
      
      private function addEvent() : void
      {
         GV.onlineSocket.addEventListener(petLogic.IS_SUPER_PET_SUCCESS,this.refurbishPetUI);
         GV.onlineSocket.addEventListener(lockHomeRes.USER_LOCKHOME,this.refurbishVipUrlHandler);
      }
      
      private function showPetHandler(evt:EventTaomee) : void
      {
         if(!evt.EventObj.flag)
         {
            LocalUserInfo.setSupetPet(false);
            this.isActivation = false;
            this.url = "resource/superPetUI/Wizard.swf";
         }
         else if(Boolean(evt.EventObj.bool))
         {
            this.url = "resource/superPetUI/superPull.swf";
         }
         else
         {
            this.url = "resource/superPetUI/superPull.swf";
         }
         this.initSuperPetHandler();
         if(!this.isActivation)
         {
            this.petClickHnadler();
         }
      }
      
      private function initSuperPetHandler() : void
      {
         this.showNewPetUI();
         this.target_mc.petBtn.visible = true;
         GV.onlineSocket.addEventListener(SaveMoney.SL_NEW_DISCOVER,this.petClickHnadler);
      }
      
      private function refurbishPetUI(evt:Event) : void
      {
      }
      
      private function petClickHnadler(evt:Event = null) : void
      {
         if(!GV.MC_AppLever.getChildByName("superPetUI"))
         {
            this.flushShardObj();
            this.superPetUI = new MovieClip();
            this.superPetUI.name = "superPetUI";
            GV.MC_AppLever.addChild(this.superPetUI);
            this.testLoadObj = new MCLoader(this.url,this.superPetUI,1,"正在打開面板......");
            this.testLoadObj.addEventListener(MCLoadEvent.ON_SUCCESS,this.superPetUILoadOver);
            LoaderList.getInstance().addItem(this.testLoadObj,null,LoaderList.HIGH);
         }
      }
      
      private function superPetUILoadOver(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.testChildMC = evt.getLoader();
         mainMC.addChild(this.testChildMC);
         this.testLoadObj.removeEventListener(MCLoadEvent.ON_SUCCESS,this.superPetUILoadOver);
         this.testLoadObj.clear();
         this.refurbishVipUrlHandler();
      }
      
      private function showNewPetUI() : void
      {
         if(LocalUserInfo.getMapID() == 137)
         {
            return;
         }
      }
      
      private function flushShardObj() : void
      {
         MainManager.getGlobalObject().data.petUINum = petNewNum;
         MainManager.getGlobalObject().flush();
      }
      
      private function refurbishVipUrlHandler(evt:EventTaomee = null) : void
      {
         if(LocalUserInfo.isVIP())
         {
            if(!LocalUserInfo.getSuperPet())
            {
               this.url = "resource/superPetUI/Wizard.swf";
            }
            else
            {
               this.url = "resource/superPetUI/superPull.swf";
            }
         }
         else if(Boolean(LocalUserInfo.getVip() >> 5 & 1))
         {
            this.url = "resource/superPetUI/superPull.swf";
         }
      }
      
      public function initShardObject() : void
      {
         this.flushShardObj();
      }
   }
}

