package com.view.toolView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.logic.socket.callSuperLamu.CallSuperLamu;
   import com.module.activityModule.superPetLogin;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.newHouse.newHouseView;
   import com.mole.app.manager.ModuleManager;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import com.view.mapView.activity.Task83.SuperPrivilegeCtl;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   
   public class SaveMoney
   {
      
      private static var instance:SaveMoney;
      
      public static const SL_NEW_DISCOVER:String = "sl_new_discover";
      
      private var hlepMC:MovieClip;
      
      public var sign:Boolean;
      
      private var HLEP:Class;
      
      public function SaveMoney()
      {
         super();
      }
      
      public static function getInstance() : SaveMoney
      {
         if(instance == null)
         {
            instance = new SaveMoney();
         }
         return instance;
      }
      
      public function initPanel() : void
      {
         var i:uint;
         with({})
         {
            setTimeout(function timerEndHandler():void
            {
               if(hlepMC != null && hlepMC.hasOwnProperty("tips"))
               {
                  hlepMC["tips"].visible = false;
               }
            },10000);
            if(!MainManager.getAppLevel().getChildByName("hlepMC"))
            {
               this.HLEP = UIManager.getClass("HELP_PANEL");
               this.hlepMC = new this.HLEP();
               this.hlepMC.name = "hlepMC";
               this.hlepMC.x = 723;
               this.hlepMC.y = 307;
               MainManager.getAppLevel().addChild(this.hlepMC);
               this.hlepMC.helpOut.addEventListener(MouseEvent.MOUSE_OVER,this.helpOutHandler);
               for(i = 0; i <= 5; i++)
               {
                  this.hlepMC["mc" + i].addEventListener(MouseEvent.CLICK,this.mcHandler);
               }
            }
         }
         
         private function helpOutHandler(event:MouseEvent = null) : void
         {
            this.hlepMC.helpOut.removeEventListener(MouseEvent.MOUSE_OVER,this.helpOutHandler);
            for(var i:uint = 0; i <= 5; i++)
            {
               this.hlepMC["mc" + i].removeEventListener(MouseEvent.CLICK,this.mcHandler);
            }
            GC.stopAllMC(this.hlepMC);
            MainManager.getAppLevel().removeChild(this.hlepMC);
            this.hlepMC = null;
         }
         
         private function mcHandler(event:MouseEvent) : void
         {
            var num:uint = Number(String(event.currentTarget.name).substr(2));
            switch(num)
            {
               case 0:
                  SuperPrivilegeCtl.getInstance().onOpenSuperLamuGift();
                  break;
               case 1:
                  SuperPrivilegeCtl.getInstance().onOpenSuperPrivilegeBook();
                  break;
               case 2:
                  this.godGiftHandler(event);
                  StatisticsClass.getInstance().init(67679179);
                  break;
               case 3:
                  superPetLogin.gotoPay();
                  break;
               case 4:
                  this.callSuperPet();
                  break;
               case 5:
                  this.moleDoctor();
            }
            this.helpOutHandler();
         }
         
         private function callSuperPet() : void
         {
            if(LocalUserInfo.isVIP())
            {
               if(GV.MAN_PEOPLE.Petlevel == 101)
               {
                  GF.showAlert(GV.MC_AppLever,"    你的超級拉姆就在你身邊哦，不需要召喚它啦！","",100,"iknow",true,false,"E");
               }
               else if(newHouseView.isMyHouse)
               {
                  GF.showAlert(GV.MC_AppLever,"    你的拉姆就在你的小屋中，不需要召喚它啦！","",100,"iknow",true,false,"E");
               }
               else
               {
                  CallSuperLamu.send_callSuperLamu();
               }
            }
            else
            {
               Alert.SLAlart("    只有擁有超能力的超級拉姆才能感應到主人的召喚哦！我們期待你加入。");
            }
         }
         
         public function godGiftHandler(e:MouseEvent) : void
         {
            StatisticsClass.getInstance().init(67744851);
            ModuleManager.openPanel("SuperGoGoPanel");
         }
         
         private function everythingKnownHandler(e:MouseEvent) : void
         {
            var loadGame:LoadGame = new LoadGame("module/external/SLThingMain.swf","正在加載百事通",MainManager.getGameLevel());
            loadGame = null;
         }
         
         private function cardBuy(event:*) : void
         {
            var superPetLogin:* = getDefinitionByName("com.module.activityModule::superPetLogin") as Class;
            superPetLogin.gotoPay();
         }
         
         private function moleDoctor(e:MouseEvent = null) : void
         {
            superPetLogin.loadMoleDoctor();
         }
      }
   }
   
   