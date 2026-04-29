package com.module.pig
{
   import com.common.Alert.Alert;
   import com.common.data.HashMap;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.socket.pig.PigSocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.pig.view.pig.PigData;
   import com.module.popupMsg.PopupMsgCtl;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.utils.PlayMovie;
   import com.view.MapManageView.MapManageView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BeautyHouseEntrance
   {
      
      private static var _instance:BeautyHouseEntrance;
      
      public static var inBeautyHouse:Boolean = false;
      
      private static const PATH:String = "module/pig/";
      
      public static const MAX:int = 5;
      
      private var _userId:int = 0;
      
      private var _data:Array;
      
      private var _pigIDArr:Array;
      
      private var _level:int = 1;
      
      private var _houseLevel:int = 1;
      
      private var _matchType:int;
      
      private var _inShow:Boolean = false;
      
      private var _showCount:int;
      
      private var _pkCount:int;
      
      private var _decorateArr:Array;
      
      private var _timeProp:HashMap;
      
      private var index:int;
      
      private var _choosePigs:Array;
      
      private var _chooseAddPropArr:Array;
      
      private var _chooseReducePropArr:Array;
      
      private var control_mc:MovieClip;
      
      private var ply:PlayMovie;
      
      public function BeautyHouseEntrance()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.OnRemoveMap);
      }
      
      public static function getInstance() : BeautyHouseEntrance
      {
         if(_instance == null)
         {
            _instance = new BeautyHouseEntrance();
         }
         return _instance;
      }
      
      public function get pkCount() : int
      {
         return this._pkCount;
      }
      
      public function get houseLevel() : int
      {
         return this._houseLevel;
      }
      
      public function get decorateArr() : Array
      {
         return this._decorateArr;
      }
      
      public function get timeProp() : HashMap
      {
         return this._timeProp;
      }
      
      public function get chooseReducePropArr() : Array
      {
         return this._chooseReducePropArr;
      }
      
      public function get chooseAddPropArr() : Array
      {
         return this._chooseAddPropArr;
      }
      
      public function get choosePigs() : Array
      {
         return this._choosePigs;
      }
      
      public function get inShow() : Boolean
      {
         return this._inShow;
      }
      
      public function set inShow(value:Boolean) : void
      {
         this._inShow = value;
      }
      
      public function get pigIDArr() : Array
      {
         return this._pigIDArr;
      }
      
      public function get matchType() : int
      {
         return this._matchType;
      }
      
      public function set matchType(value:int) : void
      {
         this._matchType = value;
      }
      
      public function get userId() : int
      {
         return this._userId;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function EnterHouse(userId:int) : void
      {
         this._userId = userId;
         BC.addEvent(this,PigEvent.instance,PigEvent.Beauty_Time_Prop,this.onUseTimeProp);
         BC.addEvent(this,PigEvent.instance,PigEvent.Beauty_Match_Prop,this.onUseMatchProp);
         this.InitStage();
         inBeautyHouse = true;
      }
      
      public function get isMyBeautyHouse() : Boolean
      {
         return this._userId == LocalUserInfo.getUserID();
      }
      
      private function EnterUserHouse(e:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.GetShowStageInfoCmd,this.onResGetShowStageInfo);
         PigSocket.GetShowStageInfo(this._userId);
      }
      
      private function onResGetShowStageInfo(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + PigSocket.GetShowStageInfoCmd,this.onResGetShowStageInfo);
         this._level = event.EventObj.lvl;
         this._pkCount = event.EventObj.showCount / 65536;
         this._showCount = event.EventObj.showCount % 65536;
         this._decorateArr = event.EventObj.arr;
         BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.GetPigHouseInfoCmd,this.GetPigHouseDataHandler);
         PigSocket.GetPigHouseInfo(this._userId);
      }
      
      private function checkDecorate(itemID:int) : Boolean
      {
         var len:int = int(this._decorateArr.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this._decorateArr[i].itemID == itemID)
            {
               return true;
            }
         }
         return false;
      }
      
      private function showDecorate() : void
      {
         this._timeProp = new HashMap();
         if(this._decorateArr.length > 0)
         {
            this.loaderDecorate(this._decorateArr[0].itemID);
         }
      }
      
      private function loaderDecorate(itemID:int, path:String = "resource/pig/swf/prop/") : void
      {
         var loader:Loader = new Loader();
         var url:String = path + itemID + ".swf";
         BC.addEvent(this,loader.contentLoaderInfo,Event.COMPLETE,this.onLoaderSuc);
         loader.load(VL.getURLRequest(url));
      }
      
      private function onLoaderSuc(event:Event) : void
      {
         BC.removeEvent(this,event.currentTarget,Event.COMPLETE,this.onLoaderSuc);
         this.addLoaderChild(MovieClip(event.currentTarget.content));
         MapDepthManageLogic.compositorMapDepth();
         this._decorateArr.splice(0,1);
         if(this._decorateArr.length > 0)
         {
            this.loaderDecorate(this._decorateArr[0].itemID);
         }
      }
      
      private function addLoaderChild(spr:MovieClip) : void
      {
         var mc:MovieClip = null;
         var arr:Array = [];
         while(Boolean(spr.numChildren))
         {
            if(this._decorateArr[0].itemID == 1613297)
            {
               break;
            }
            mc = MovieClip(spr.getChildAt(0));
            MapModelLogic.ManageLever.addChild(mc);
            arr.push(mc);
         }
         this._timeProp.add(this._decorateArr[0].itemID,arr);
      }
      
      private function GetPigHouseDataHandler(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + PigSocket.GetPigHouseInfoCmd,this.GetPigHouseDataHandler);
         var data:HashMap = event.EventObj as HashMap;
         var pigs:HashMap = data.getValue("pigs");
         this._pigIDArr = pigs.keys;
         this._houseLevel = data.getValue("level");
         this.getPigInfo();
      }
      
      private function getPigInfo() : void
      {
         this._data = [];
         if(this._pigIDArr.length > 0)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.GetPigInfoCmd,this.onResGetPigInfo);
            PigSocket.GetPigInfo(this._userId,this._pigIDArr[0]);
         }
         else
         {
            this.addStageEvent();
         }
      }
      
      private function onResGetPigInfo(event:EventTaomee) : void
      {
         var pigData:PigData = new PigData();
         pigData.UpdateData(HashMap(event.EventObj));
         if(pigData.isCanShow())
         {
            this._data.push(pigData);
         }
         var len:int = int(this.pigIDArr.length);
         ++this.index;
         if(this.index < len)
         {
            PigSocket.GetPigInfo(this._userId,this._pigIDArr[this.index]);
         }
         else
         {
            BC.removeEvent(this,GV.onlineSocket,"read_" + PigSocket.GetPigInfoCmd,this.onResGetPigInfo);
            this.addStageEvent();
         }
      }
      
      private function InitStage() : void
      {
         var bgPath:String = "resource/pig/swf/beautyHouse.swf";
         var _bgLoader:MCLoader = new MCLoader(bgPath,MainManager.getAppLevel(),Loading.MAIN_LOAD,"正在進入肥肥館...");
         BC.addEvent(this,_bgLoader,MCLoadEvent.ON_SUCCESS,this.onBGLoadOver);
         LoaderList.getInstance().addItem(_bgLoader,null,LoaderList.HIGH);
      }
      
      private function onBGLoadOver(event:MCLoadEvent) : void
      {
         BC.removeEvent(this,event.currentTarget);
         var pigHouseLoader:Loader = event.currentTarget.getLoader();
         MapManageView.inst.initMap(pigHouseLoader);
         GV.map_ManagerChange.MapManage.initFindPath();
         MovieClip(GV.MC_mapFrame.type_mc).mouseChildren = false;
         MovieClip(GV.MC_mapFrame.type_mc).mouseEnabled = false;
         MovieClip(GV.MC_mapTop).mouseChildren = false;
         MovieClip(GV.MC_mapTop).mouseEnabled = false;
         this.EnterUserHouse();
      }
      
      private function addStageEvent() : void
      {
         BC.addEvent(this,GV.MC_mapFrame.control_mc.door,MouseEvent.CLICK,this.onBackToPigsHouse);
         BC.addEvent(this,GV.MC_mapFrame.control_mc.dress,MouseEvent.CLICK,this.onOpenDressingRoom);
         this.showDecorate();
         PigExtenalCtl.InitBeautyMatch();
         PigExtenalCtl.InitBeautyHouseToolBar();
      }
      
      public function onChoosePigToMatch(type:int) : void
      {
         var obj:Object = null;
         var loadGame:LoadGame = null;
         this._matchType = type;
         if(this.isMyBeautyHouse)
         {
            if(this._showCount >= MAX)
            {
               PopupMsgCtl.PopupMsg("今日表演已經超過" + MAX + "次，不會再獲得獎勵哦。");
            }
            obj = this.checkLevel(type,this._level);
            if(Boolean(obj.result))
            {
               BC.addEvent(this,PigEvent.instance,PigEvent.Beauty_Match_Show,this.onShowMatch);
               loadGame = new LoadGame("module/pig/ChoosePigsAndPropMain.swf","正在加載...",MainManager.getAppLevel());
               loadGame = null;
            }
            else
            {
               Alert.smileAlart(obj.msg);
            }
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.GetShowStageInfoCmd,this.onResGetMyShowStageInfo);
            PigSocket.GetShowStageInfo(LocalUserInfo.getUserID());
         }
      }
      
      private function onResGetMyShowStageInfo(event:EventTaomee) : void
      {
         var loadGame:LoadGame = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + PigSocket.GetShowStageInfoCmd,this.onResGetMyShowStageInfo);
         var myLvl:int = int(event.EventObj.lvl);
         var myPKCount:int = event.EventObj.showCount / 65536;
         var obj:Object = this.checkLevel(this._matchType,myLvl);
         if(Boolean(obj.result))
         {
            if(myPKCount >= MAX)
            {
               PopupMsgCtl.PopupMsg("今日PK已經超過" + MAX + "次，不會再獲得獎勵哦。");
            }
            if(this._data.length < this._matchType)
            {
               Alert.smileAlart("    對方可參賽的豬仔數量不足，無法進行PK！");
               return;
            }
            BC.addEvent(this,PigEvent.instance,PigEvent.Beauty_Match_PK,this.onShowPKMatch);
            loadGame = new LoadGame("module/pig/ChoosePigsAndPropMain.swf","正在加載...",MainManager.getAppLevel());
            loadGame = null;
         }
         else
         {
            Alert.smileAlart(obj.msg);
         }
      }
      
      private function checkLevel(type:int, lvl:int) : Object
      {
         var typeMsg:String = null;
         if(this.isMyBeautyHouse)
         {
            typeMsg = "表演";
         }
         else
         {
            typeMsg = "PK";
         }
         var obj:Object = new Object();
         if(type == 1)
         {
            obj.result = true;
         }
         else if(type == 2)
         {
            if(lvl >= 2)
            {
               obj.result = true;
            }
            else
            {
               obj.result = false;
               obj.msg = "    2人" + typeMsg + "賽，需要升級為中級美美屋！";
            }
         }
         else if(type == 3)
         {
            if(lvl >= 3)
            {
               obj.result = true;
            }
            else
            {
               obj.result = false;
               obj.msg = "    3人" + typeMsg + "賽，需要升級為高級美美屋！";
            }
         }
         return obj;
      }
      
      private function onShowMatch(event:EventTaomee) : void
      {
         BC.removeEvent(this,PigEvent.instance,PigEvent.Beauty_Match_Show,this.onShowMatch);
         this._choosePigs = event.EventObj.pigArr;
         this.loaderShow();
      }
      
      private function onShowPKMatch(event:EventTaomee) : void
      {
         BC.removeEvent(this,PigEvent.instance,PigEvent.Beauty_Match_PK,this.onShowPKMatch);
         this._choosePigs = event.EventObj.pigArr;
         this._chooseAddPropArr = event.EventObj.addPropArr;
         this._chooseReducePropArr = event.EventObj.reducePropArr;
         this.loaderShow();
      }
      
      private function loaderShow() : void
      {
         this.inShow = true;
         var loadGame:LoadGame = new LoadGame("module/pig/PigHouseDanceMatch.swf","正在加載...",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function onBackToPigsHouse(event:MouseEvent) : void
      {
         if(this.inShow)
         {
            PopupMsgCtl.PopupMsg("正在表演，請等待表演結束！");
            return;
         }
         GF.switchToPigHouse(this._userId);
      }
      
      private function onOpenDressingRoom(event:MouseEvent) : void
      {
         ModuleManager.openModule("PigHouseDressingRoomMain",null,PATH);
      }
      
      private function onUseTimeProp(event:EventTaomee) : void
      {
         var propObj:Object = null;
         var obj:Object = event.EventObj;
         if(!this.checkDecorate(obj.itemID))
         {
            propObj = new Object();
            propObj.itemID = obj.itemID;
            this._decorateArr.push(propObj);
            this.loaderDecorate(obj.itemID);
         }
      }
      
      private function onUseMatchProp(event:EventTaomee) : void
      {
         if(Boolean(this.ply))
         {
            this.ply.destroy();
            this.ply = null;
         }
         var url:String = "resource/pig/swf/prop/" + event.EventObj.itemID + ".swf";
         this.ply = PlayMovie.play(url,null,null,this.clearPlayMovie,null);
      }
      
      private function clearPlayMovie() : void
      {
         this.ply.destroy();
         this.ply = null;
      }
      
      private function OnRemoveMap(e:EventTaomee) : void
      {
         BC.removeEvent(this);
         this.clear();
      }
      
      private function clear() : void
      {
         this.index = 0;
         this._userId = 0;
         this._data = null;
         this._pigIDArr = null;
         this._level = 0;
         _instance = null;
         this._matchType = 0;
         inBeautyHouse = false;
      }
   }
}

