package com.module.pig
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.type.ModuleType;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PigExtenalCtl
   {
      
      public static const PIG_MODULE_PATH:String = "module/pig/";
      
      private static const PATH:String = "module/pig/";
      
      public function PigExtenalCtl()
      {
         super();
      }
      
      public static function OpenBag(e:* = null) : void
      {
         var url:String = "module/pig/PigBag.swf";
         MCLoader.LoadModule(url,"打開背包...",MainManager.getAppLevel());
      }
      
      public static function OpenMachineBag(e:* = null) : void
      {
         var url:String = "module/pig/MachineBag.swf";
         MCLoader.LoadModule(url,"打開背包...",MainManager.getAppLevel());
      }
      
      public static function OpenBeautyBag(e:* = null) : void
      {
         var url:String = "module/pig/BeautyBag.swf";
         MCLoader.LoadModule(url,"打開背包...",MainManager.getAppLevel());
      }
      
      public static function OpenTeam(e:* = null) : void
      {
         var url:String = "module/pig/TeamPanel.swf";
         MCLoader.LoadModule(url,"打開隊列...",MainManager.getAppLevel());
      }
      
      public static function OpenNotice(e:* = null) : void
      {
         var url:String = "module/pig/PigNotice.swf";
         MCLoader.LoadModule(url,"打開公告牌...",MainManager.getAppLevel());
      }
      
      public static function OpenWork(e:Event = null) : void
      {
         ModuleManager.openModule("PigHouseFabricationPlantMain",null,PATH);
      }
      
      public static function OpenShop(type:int = 1, flag:int = 3, node:int = 2) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("get_2011_11_change_Pig_item_3"));
         ModuleManager.openModule("PigHouseShopMain",{
            "type":type,
            "flag":flag,
            "node":node
         },PATH);
      }
      
      public static function OpenTask(e:Event = null) : void
      {
         ModuleManager.openModule("PigHouseTaskMain",null,PATH);
      }
      
      public static function OpenSellPanel(e:Event = null) : void
      {
         ModuleManager.openModule("PigHouseSellMain",null,PATH);
      }
      
      public static function OpenPigInfoPanel(data:Object) : void
      {
         ModuleManager.openModule("PigHouseInfoMain",data,PATH);
      }
      
      public static function OpenBook(e:Event = null) : void
      {
         ModuleManager.openModule("PigHouseIllustratedHandbookMain",null,PATH);
      }
      
      public static function InitToolBar() : void
      {
         var url:String = "module/pig/PigToolBar.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
         MainManager.getAppLevel().addChild(loader);
      }
      
      public static function InitRandomLucky() : void
      {
         var url:String = "module/pig/RandomLucky.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
      }
      
      public static function InitBaoMing() : void
      {
         var loader:Loader = null;
         var tClick2:Function = null;
         var tRemoved2:Function = null;
         var url:String = "module/pig/huahuan.swf";
         loader = new Loader();
         loader.load(VL.getURLRequest(url));
         tip.tipTailDisPlayObject(loader,"肥肥達人秀");
         tClick2 = function(e:MouseEvent):void
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            GF.switchMap(47);
         };
         tRemoved2 = function(e:Event):void
         {
            loader.removeEventListener(MouseEvent.CLICK,tClick2);
            loader.removeEventListener(Event.REMOVED_FROM_STAGE,tRemoved2);
         };
         loader.addEventListener(MouseEvent.CLICK,tClick2);
         loader.addEventListener(Event.REMOVED_FROM_STAGE,tRemoved2);
         MainManager.getAppLevel().addChild(loader);
      }
      
      public static function InitDayExchange() : void
      {
         var loader:Loader = null;
         var tClick2:Function = null;
         var tRemoved2:Function = null;
         var url:String = "module/pig/dayExchange.swf";
         loader = new Loader();
         loader.load(VL.getURLRequest(url));
         tip.tipTailDisPlayObject(loader,"尋找遺失的寶物");
         tClick2 = function(e:MouseEvent):void
         {
            ModuleManager.openModule("FindGifts",null,"module/pig/");
         };
         tRemoved2 = function(e:Event):void
         {
            loader.removeEventListener(MouseEvent.CLICK,tClick2);
            loader.removeEventListener(Event.REMOVED_FROM_STAGE,tRemoved2);
         };
         loader.addEventListener(MouseEvent.CLICK,tClick2);
         loader.addEventListener(Event.REMOVED_FROM_STAGE,tRemoved2);
         MainManager.getAppLevel().addChild(loader);
      }
      
      public static function InitBeautyMatch() : void
      {
         var loader:Loader = null;
         var tClick:Function = null;
         var showHelp:Function = null;
         var onCloseHelp:Function = null;
         var onSucFun:Function = null;
         var url:String = "module/pig/BeautyMatchUI.swf";
         loader = new Loader();
         tClick = function(e:MouseEvent):void
         {
            var ss:String = e.currentTarget.name;
            var index:int = int(ss.slice(3));
            BeautyHouseEntrance.getInstance().onChoosePigToMatch(index);
         };
         showHelp = function(e:MouseEvent):void
         {
            loader.content["mc"].x = 503;
         };
         onCloseHelp = function(e:MouseEvent):void
         {
            loader.content["mc"].x = -496;
         };
         onSucFun = function(event:Event):void
         {
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onSucFun);
            for(var i:int = 1; i <= 3; i++)
            {
               loader.content["btn" + i].addEventListener(MouseEvent.CLICK,tClick);
            }
            loader.content["btn4"].addEventListener(MouseEvent.CLICK,showHelp);
            loader.content["mc"]["close_btn"].addEventListener(MouseEvent.CLICK,onCloseHelp);
         };
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onSucFun);
         loader.load(VL.getURLRequest(url));
         MainManager.getAppLevel().addChild(loader);
      }
      
      public static function InitBeautyHouseToolBar() : void
      {
         var url:String = "module/pig/BeautyHouseToolBar.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
         MainManager.getAppLevel().addChild(loader);
      }
      
      public static function InitMachinistSquareToolBar() : void
      {
         var url:String = "module/pig/MachinistSquareToolBar.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
         MainManager.getAppLevel().addChild(loader);
      }
      
      public static function InitRandomChest() : void
      {
         var url:String = "module/pig/RandomChest.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
      }
      
      public static function InitUplevel() : void
      {
         var url:String = "module/pig/UpLevelCtl.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
      }
      
      public static function InitNpc() : void
      {
         var url:String = "module/pig/PigNpc.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
      }
      
      public static function InitFirstInLead() : void
      {
         var url:String = "module/pig/FirstInLead.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
      }
      
      public static function InitFirstInMachine() : void
      {
         MachineNewHand.inst.openNewHandPanel();
      }
      
      public static function InitBuff() : void
      {
         var url:String = "module/pig/PigBuff.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
      }
      
      public static function OpenTempHouse(e:Event = null) : void
      {
         ModuleManager.openModule(ModuleType.PIG_TEMP_HOUSE,null,PIG_MODULE_PATH);
         StatisticsClass.getInstance().init(67747599);
      }
      
      public static function InitChangePigActivityIcon(e:Event = null) : void
      {
      }
      
      public static function addNewHandBtn() : void
      {
         var url:String = "resource/pig/movie/newHandBtn.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
         MainManager.getAppLevel().addChild(loader);
         tip.tipTailDisPlayObject(loader,"新手教程");
         BC.addEvent(PigHouseEntrance.instance,loader,MouseEvent.CLICK,openNewHandPanel,false,0,true);
      }
      
      private static function openNewHandPanel(e:MouseEvent) : void
      {
         MachineNewHand.inst.openNewHandPanel();
      }
      
      public static function OpenChangePigActivityPanel(e:Event = null) : void
      {
         var url:String = "module/pig/ChangePigGiftActivityPanel.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
      }
      
      public static function OpenHonorMainUI(e:Event = null) : void
      {
         ModuleManager.openModule(ModuleType.PIG_HOUSE_HONOR_UI,null,PIG_MODULE_PATH);
      }
      
      public static function OpenHonorBook(e:Event = null) : void
      {
         ModuleManager.openModule(ModuleType.PIG_HOUSE_HONOR,null,PIG_MODULE_PATH);
      }
      
      public static function SecondToString(time:int, showDay:Boolean = false) : String
      {
         var day:int = 0;
         var hour:int = 0;
         var minute:int = 0;
         var seconds:int = 0;
         var str:String = "";
         if(showDay)
         {
            day = Math.floor(time / (24 * 3600));
            hour = Math.floor(time / 3600) % 24;
            minute = Math.floor(time / 60) % 60;
            seconds = time - hour * 3600 - minute * 60;
            if(day > 0)
            {
               str += day + "天";
            }
            if(hour > 0)
            {
               str += hour + "小時";
            }
            if(minute > 0)
            {
               str += minute + "分鐘";
            }
         }
         else
         {
            hour = Math.floor(time / 3600);
            minute = Math.floor(time / 60) % 60;
            seconds = time - hour * 3600 - minute * 60;
            if(hour > 0)
            {
               str += hour + "小時";
               if(minute > 0)
               {
                  str += minute + "分鐘";
               }
               if(seconds > 0)
               {
                  str += seconds + "秒";
               }
            }
            else if(minute > 0)
            {
               str += minute + "分鐘";
            }
            else
            {
               str = time + "秒";
            }
         }
         return str;
      }
   }
}

