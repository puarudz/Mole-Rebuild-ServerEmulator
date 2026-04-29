package com.module.pig
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.music.TopicMusicManager;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.ballot.NpcBallotSocket;
   import com.module.pig.data.PigHouseData;
   import com.module.pig.view.PigHouseStageView;
   import com.module.pig.view.PigsCtl;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class PigHouseEntrance
   {
      
      private static var _instance:PigHouseEntrance;
      
      private var _isEditing:Boolean = false;
      
      private var _nick:String;
      
      private var _userId:int = 0;
      
      public function PigHouseEntrance()
      {
         super();
      }
      
      public static function get instance() : PigHouseEntrance
      {
         if(_instance == null)
         {
            _instance = new PigHouseEntrance();
         }
         return _instance;
      }
      
      public function get isEditing() : Boolean
      {
         return this._isEditing;
      }
      
      public function set isEditing(value:Boolean) : void
      {
         this._isEditing = value;
      }
      
      public function get userId() : int
      {
         return this._userId;
      }
      
      public function set userNick(value:String) : void
      {
         this._nick = value;
      }
      
      public function get userNick() : String
      {
         return this._nick;
      }
      
      private function get isInitOk() : Boolean
      {
         return PigHouseUI.instance.isInitOK && PigConfig.instance.isInitOK;
      }
      
      public function get isMyPigHouse() : Boolean
      {
         return this._userId == LocalUserInfo.getUserID();
      }
      
      public function EnterHouse(userId:int) : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"removeMapEvent",this.OnRemoveMap);
         this._userId = userId;
         if(this.isInitOk)
         {
            this.EnterUserHouse();
         }
         else
         {
            this.InitUI();
         }
      }
      
      public function LeaveHouse() : void
      {
      }
      
      private function InitUI(e:Event = null) : void
      {
         if(PigHouseUI.instance.isInitOK)
         {
            this.InitConfig();
         }
         else
         {
            BC.addOnceEvent(this,PigEvent.instance,PigHouseUI.Init_OK_Event,this.InitConfig);
            PigHouseUI.instance.Init();
         }
      }
      
      private function InitConfig(e:Event = null) : void
      {
         if(PigConfig.instance.isInitOK)
         {
            this.EnterUserHouse();
         }
         else
         {
            BC.addOnceEvent(this,PigEvent.instance,PigConfig.Init_OK_Event,this.EnterUserHouse);
            PigConfig.instance.Init();
         }
      }
      
      private function EnterUserHouse(e:Event = null) : void
      {
         BC.addOnceEvent(this,PigEvent.instance,PigEvent.Get_PigHouse_Data_OK,this.GetUserDataOk);
         PigHouseData.instance.GetPigHouseData();
      }
      
      private function GetUserDataOk(e:Event) : void
      {
         BC.addOnceEvent(this,PigEvent.instance,PigHouseStageView.Init_Map_Ok_Event,this.PigHouseStageInitHandler);
         PigHouseStageView.instance.Init();
      }
      
      private function PigHouseStageInitHandler(e:Event = null) : void
      {
         this._isEditing = false;
         PigsCtl.instance.Init();
         if(this.isMyPigHouse)
         {
            PigExtenalCtl.InitRandomLucky();
            PigExtenalCtl.InitUplevel();
            PigExtenalCtl.InitNpc();
         }
         PigExtenalCtl.InitRandomChest();
         PigExtenalCtl.InitBuff();
         PigExtenalCtl.InitToolBar();
         if(this.isMyPigHouse)
         {
            PigExtenalCtl.InitChangePigActivityIcon();
            if(PigHouseData.instance.isFristIn == false)
            {
               BC.addOnceEvent(this,GV.onlineSocket,"read_2008",this.CheckGetedGiftHandler);
               NpcBallotSocket.NpcBallotReq();
            }
         }
      }
      
      private function CheckGetedGiftHandler(e:EventTaomee) : void
      {
         var uiUrl:String = null;
         var loader:Loader = null;
         var bit:int = 172;
         if(!GF.getBitBool(int(e.EventObj.arr[5]),int(bit - 32)))
         {
            uiUrl = "resource/pig/movie/npcGift.swf";
            loader = new Loader();
            loader.load(VL.getURLRequest(uiUrl));
            MainManager.getAppLevel().addChild(loader);
            BC.addEvent(this,GV.onlineSocket,"2011_11_24_pig_npc_get_gift",this.GetGift);
         }
         else if(creatShareObject.getInstance().getShareObject().data.hasOwnProperty("pigHouseIsBeautyArrow") == false)
         {
            uiUrl = "resource/pig/movie/beautyArrow.swf";
            loader = new Loader();
            BC.addOnceEvent(this,loader.contentLoaderInfo,Event.COMPLETE,this.LoadOverHandler);
            loader.load(VL.getURLRequest(uiUrl));
            MainManager.getAppLevel().addChild(loader);
         }
         else if(creatShareObject.getInstance().getShareObject().data.hasOwnProperty("pigHouseIsMachineArrow") == false)
         {
            uiUrl = "resource/pig/movie/machineArrow.swf";
            loader = new Loader();
            BC.addOnceEvent(this,loader.contentLoaderInfo,Event.COMPLETE,this.LoadOverHandler2);
            loader.load(VL.getURLRequest(uiUrl));
            MainManager.getAppLevel().addChild(loader);
         }
      }
      
      private function GetGift(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"2011_11_24_pig_npc_get_gift",this.GetGift);
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.GetGiftHandler);
         exchange.exchange_goods(911);
      }
      
      private function GetGiftHandler(e:EventTaomee) : void
      {
         if(e.EventObj.type == 911)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.GetGiftHandler);
            Alert.smileAlart("    恭喜你獲得臭臭贈送的禮品，快打開肥肥館背包看看吧！");
         }
      }
      
      private function LoadOverHandler(e:Event) : void
      {
         PigEvent.instance.dispatchEvent(new Event(PigEvent.Hide_Toolbar));
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         var mc:MovieClip = loaderInfo.content as MovieClip;
         mc.gotoAndStop("m_" + PigHouseData.instance.bgId);
         creatShareObject.getInstance().getShareObject().data.pigHouseIsBeautyArrow = 1;
      }
      
      private function LoadOverHandler2(e:Event) : void
      {
         PigEvent.instance.dispatchEvent(new Event(PigEvent.Hide_Toolbar));
         creatShareObject.getInstance().getShareObject().data.pigHouseIsMachineArrow = 1;
      }
      
      private function OnRemoveMap(e:EventTaomee) : void
      {
         BC.removeEvent(this);
         PigsCtl.instance.Clear();
         PigHouseStageView.instance.Clear();
         PigHouseData.instance.Clear();
         PigDragCtl.StopDrag();
         PigEffectCtl.Clear();
         TopicMusicManager.instance.stopSound();
         _instance = null;
      }
   }
}

