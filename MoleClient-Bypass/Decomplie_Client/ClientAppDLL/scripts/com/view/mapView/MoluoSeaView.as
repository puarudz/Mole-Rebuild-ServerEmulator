package com.view.mapView
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.IndexManager;
   import com.event.EventTaomee;
   import com.logic.JoinGameLogic.JoinGameLogic;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.module.clothBuyModule.clothBuyModule;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class MoluoSeaView extends MapBase
   {
      
      private var top_mc:MovieClip;
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var clothMC:MovieClip;
      
      private var helpMC:MovieClip;
      
      private var noPlayMC:MovieClip;
      
      private var itemArray:Array = [[12189,"大鯊魚頭套",900],[12186,"可愛刺豚魚偽裝頭套",3600],[12190,"小美人魚髮型",1800],[12191,"小美人魚裝",2600],[12188,"小海蟹頭套",800]];
      
      private var tarX:Number;
      
      private var tarY:Number;
      
      private var hitMC:MovieClip;
      
      private var sprite:Sprite;
      
      private var hitBool:Boolean;
      
      private var setTime:Timer;
      
      private var a:int = 0;
      
      public function MoluoSeaView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,GV.PeopleCount,PeopleCountLogic.ONPEOPLEINIT,this.onPeopleInit);
         BC.addEvent(this,GV.PeopleCount,PeopleCountLogic.ONPEOPLEINMAP,this.onPeopleInMap);
         if(!LocalUserInfo.isVIP() && GV.MAN_PEOPLE.Petlevel != 101)
         {
            this.target_mc.mapBtn_2.visible = true;
         }
         BC.addEvent(this,GV.onlineSocket,JoinGameLogic.no_Have_Pet,this.showNohavePetHandler);
         BC.addEvent(this,this.target_mc.clothBtn.btn,MouseEvent.MOUSE_OVER,this.overHandler);
         BC.addEvent(this,this.target_mc.clothBtn.btn,MouseEvent.MOUSE_OUT,this.outHandler);
         BC.addEvent(this,this.target_mc.clothBtn.btn,MouseEvent.CLICK,this.ShowClothHandler);
         BC.addEvent(this,this.target_mc.helpBtn,MouseEvent.CLICK,this.ShowHelpHandler);
      }
      
      private function showNohavePetHandler(evt:Event) : void
      {
         var tempMC:Class = null;
         if(!MainManager.getAppLevel().getChildByName("noPlayMC"))
         {
            tempMC = GV.Lib_Map.getClass("noPlayMC") as Class;
            this.noPlayMC = new tempMC();
            this.noPlayMC.name = "noPlayMC";
            MainManager.getAppLevel().addChild(this.noPlayMC);
            this.noPlayMC.x = (MainManager.getStageWidth() - this.noPlayMC.width) / 2;
            this.noPlayMC.y = (MainManager.getStageHeight() - this.noPlayMC.height) / 2;
            this.noPlayMC.close_btn.addEventListener(MouseEvent.CLICK,this.removenoPlayMCHandler);
         }
      }
      
      private function removenoPlayMCHandler(evt:Event = null) : void
      {
         this.noPlayMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removenoPlayMCHandler);
         GC.clearAllChildren(this.noPlayMC);
         this.noPlayMC.parent.removeChild(this.noPlayMC);
         this.noPlayMC = null;
      }
      
      private function onPeopleInit(evt:EventTaomee) : void
      {
         var p:Object = null;
         var peopleList:Array = PeopleCountLogic.peopleList;
         for each(p in peopleList)
         {
            this.showPaoPao(p.Instance);
         }
      }
      
      private function onPeopleInMap(evt:EventTaomee) : void
      {
         this.showPaoPao(evt.EventObj as PeopleManageView);
      }
      
      private function showPaoPao(mc:PeopleManageView) : void
      {
         var MyMadel:MovieClip = null;
         MyMadel = IndexManager.getInstance().getMovieClip("amulet_mc");
         MyMadel.name = "amulet_mc";
         mc.avatarClass.defaultSpeed = 80;
         mc.avatarClass.speed = mc.avatarClass.defaultSpeed;
         mc.avatarMC.addChild(MyMadel);
      }
      
      private function overHandler(evt:MouseEvent) : void
      {
         evt.target.parent.gotoAndPlay(2);
      }
      
      private function outHandler(evt:MouseEvent) : void
      {
         evt.target.parent.gotoAndPlay(11);
      }
      
      private function ShowClothHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         var i:int = 0;
         if(!MainManager.getAppLevel().getChildByName("clothMC"))
         {
            tempMC = GV.Lib_Map.getClass("clothMC") as Class;
            this.clothMC = new tempMC();
            this.clothMC.name = "clothMC";
            MainManager.getAppLevel().addChild(this.clothMC);
            this.clothMC.x = (MainManager.getStageWidth() - this.clothMC.width) / 2;
            this.clothMC.y = (MainManager.getStageHeight() - this.clothMC.height) / 2;
            this.clothMC.close_btn.addEventListener(MouseEvent.CLICK,this.removeclothMCHandler);
            for(i = 1; i < 6; i++)
            {
               this.clothMC["btn_" + i].addEventListener(MouseEvent.CLICK,this.buyHandler);
               this.clothMC["info_" + i].money_txt.text = String(this.itemArray[i - 1][2]);
            }
         }
      }
      
      private function buyHandler(evt:MouseEvent) : void
      {
         var tempName:String = evt.target.name;
         var num:int = int(tempName.substring(4)) - 1;
         var itemObj:Object = new Object();
         itemObj.id = this.itemArray[num][0];
         itemObj.price = this.itemArray[num][2];
         itemObj.info = this.itemArray[num][1];
         clothBuyModule.buyAction(itemObj);
      }
      
      private function removeclothMCHandler(evt:MouseEvent = null) : void
      {
         this.clothMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removeclothMCHandler);
         GC.clearAllChildren(this.clothMC);
         this.clothMC.parent.removeChild(this.clothMC);
         this.clothMC = null;
      }
      
      private function ShowHelpHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!MainManager.getAppLevel().getChildByName("helpMC"))
         {
            tempMC = GV.Lib_Map.getClass("helpMC") as Class;
            this.helpMC = new tempMC();
            this.helpMC.name = "helpMC";
            MainManager.getAppLevel().addChild(this.helpMC);
            this.helpMC.x = (MainManager.getStageWidth() - this.helpMC.width) / 2;
            this.helpMC.y = (MainManager.getStageHeight() - this.helpMC.height) / 2;
            this.helpMC.close_btn.addEventListener(MouseEvent.CLICK,this.removeHelpMCHandler);
         }
      }
      
      private function removeHelpMCHandler(evt:MouseEvent = null) : void
      {
         this.helpMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removeclothMCHandler);
         GC.clearAllChildren(this.helpMC);
         this.helpMC.parent.removeChild(this.helpMC);
         this.helpMC = null;
      }
      
      override public function destroy() : void
      {
         if(this.clothMC != null)
         {
            this.removeclothMCHandler();
         }
         if(this.helpMC != null)
         {
            this.removeHelpMCHandler();
         }
         if(this.noPlayMC != null)
         {
            this.removenoPlayMCHandler();
         }
         super.destroy();
      }
   }
}

