package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.petSocket.adoptPet.petClothReq;
   import com.logic.socket.petSocket.adoptPet.petClothRes;
   import com.module.helpPanel.HelpPanel;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ModuleType;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class lamuSportsView extends BasicMapView
   {
      
      public static var TeamColor:ColorTransform;
      
      public function lamuSportsView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,buttonLevel.dump_btn,MouseEvent.CLICK,this.loadLamuDumpGame);
         tip.tipTailDisPlayObject(buttonLevel.dump_btn,"拉姆跳高");
      }
      
      private function onOpenShot(e:MouseEvent) : void
      {
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         if(peopleView.Petlevel > 0)
         {
            MapManager.clearMap();
            StatisticsClass.getInstance().init(67748690);
            LevelManager.stage.focus = LevelManager.stage;
            ModuleManager.openGame(ModuleType.SPORTS_SHOT_GAME);
         }
         else
         {
            Alert.smileAlart("    親愛的小摩爾，你要帶著拉姆來這裡哦！");
         }
      }
      
      private function cropBtnHandler(event:MouseEvent) : void
      {
         if(target_mc.cropBtn.jugMC.currentFrame == 1)
         {
            target_mc.cropBtn.jugMC.gotoAndPlay(2);
         }
      }
      
      private function loadLamuDumpGame(evt:MouseEvent) : void
      {
         this.getGameEvent();
      }
      
      private function getGameEvent(evt:Event = null) : void
      {
         var msg:String = null;
         var url:String = null;
         var petID:int = 0;
         if(GV.MAN_PEOPLE.Petlevel == 0)
         {
            msg = "　   親愛的小摩爾，你要帶著拉姆來這裡哦！";
            url = "resource/allJob/icon/marathon.swf";
            Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,petClothRes.PET_GET_ITEM_SUCC,this.startGameEvent);
            petID = int(GV.MAN_PEOPLE.PetID);
            petClothReq.petItemReq(LocalUserInfo.getUserID(),petID,1200001,1200005);
         }
      }
      
      private function startGameEvent(evt:EventTaomee) : void
      {
         var itemID:int = 0;
         BC.removeEvent(this,GV.onlineSocket,petClothRes.PET_GET_ITEM_SUCC,this.startGameEvent);
         if(evt.EventObj.Count > 0)
         {
            itemID = int(evt.EventObj.arr[0].ItemID);
            if(itemID == 1200001)
            {
               TeamColor = new ColorTransform(1,56 / 255,0);
            }
            else if(itemID == 1200002)
            {
               TeamColor = new ColorTransform(1,239 / 255,0);
            }
            else if(itemID == 1200003)
            {
               TeamColor = new ColorTransform(1,105 / 255,1);
            }
            else if(itemID == 1200004)
            {
               TeamColor = new ColorTransform(0,199 / 255,1);
            }
         }
         else
         {
            TeamColor = new ColorTransform(1,56 / 255,0);
         }
         this.gameStartHandler();
      }
      
      private function gameStartHandler() : void
      {
         GameframeLogic.stopMousicHandler();
         if(Boolean(MainManager.getGameLevel().getChildByName("lamuDumpGame")))
         {
            return;
         }
         MoveTo.CanMove = false;
         var tempLoader:Loader = new Loader();
         tempLoader.name = "lamuDumpGame";
         tempLoader.load(VL.getURLRequest("module/game/lamuDump.swf"));
         MainManager.getGameLevel().addChild(tempLoader);
         tempLoader.contentLoaderInfo.addEventListener(Event.CLOSE,this.onCloseDump);
         StatisticsClass.getInstance().init(67748689);
      }
      
      private function throwHander(event:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("THROW_BALL");
      }
      
      private function onCloseDump(e:Event) : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

