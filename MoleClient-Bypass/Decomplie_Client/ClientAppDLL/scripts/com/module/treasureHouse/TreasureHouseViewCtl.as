package com.module.treasureHouse
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import com.logic.socket.getSceneUserInfo.GetSceneUserInfoReq;
   import com.logic.socket.getSceneUserInfo.GetSceneUserRes;
   import com.logic.socket.treasureHouse.TreasureHouseSocket;
   import com.module.changeClothsModule.prevView;
   import com.module.digTreasure.data.DigTreasureData;
   import com.module.treasureHouse.view.TreasureHouseDragCtl;
   import com.module.treasureHouse.view.TreasureHouseToolView;
   import com.module.treasureHouse.view.TreasureHouseTreasurAreaCtl;
   import com.mole.app.map.MapManager;
   import com.view.noticeView.noticeView;
   import com.view.userPanelView.userPanelView;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class TreasureHouseViewCtl
   {
      
      private static var _instance:TreasureHouseViewCtl;
      
      public static var MapInitOk:String = "TreasureHouseViewCtl_MapInitOk";
      
      public static var isInMyHouse:Boolean = false;
      
      private var _bgLoader:MCLoader;
      
      private var _exp:int;
      
      private var _headMC:MovieClip;
      
      private var _level:int;
      
      private var _ui:MovieClip;
      
      private var _useNameTxt:TextField;
      
      private var _userId:Number = LocalUserInfo.getUserID();
      
      private var _data:Object;
      
      private var _boothDatas:Array;
      
      private var _lockedBoothId:int;
      
      private var _edit:Boolean = false;
      
      private var _toolView:TreasureHouseToolView;
      
      private var _treasureAreaCtl:TreasureHouseTreasurAreaCtl;
      
      private var _boothCountOfLevel:Array = [{
         "level":1,
         "count":2
      },{
         "level":4,
         "count":4
      },{
         "level":8,
         "count":8
      },{
         "level":12,
         "count":12
      },{
         "level":16,
         "count":18
      },{
         "level":20,
         "count":24
      },{
         "level":21,
         "count":24
      }];
      
      private var _nextUnLockLevel:int;
      
      private var _nextLevelBoothCount:int;
      
      public function TreasureHouseViewCtl(block:Block)
      {
         super();
      }
      
      public static function get instance() : TreasureHouseViewCtl
      {
         if(!_instance)
         {
            _instance = new TreasureHouseViewCtl(new Block());
         }
         return _instance;
      }
      
      public function get nextLevelBoothCount() : int
      {
         return this._nextLevelBoothCount;
      }
      
      public function get edit() : Boolean
      {
         return this._edit;
      }
      
      public function set edit(value:Boolean) : void
      {
         this._edit = value;
         if(this._edit)
         {
            this._treasureAreaCtl.UpdateBooths();
         }
         else
         {
            TreasureHouseDragCtl.StopDrag();
            TreasureHouseSocket.GetTreasureHouseInfo(this._userId);
         }
      }
      
      public function get boothDatas() : Array
      {
         return this._boothDatas;
      }
      
      public function set boothDatas(value:Array) : void
      {
         this._boothDatas = value;
      }
      
      public function get lockedBoothId() : int
      {
         return this._lockedBoothId;
      }
      
      public function get nextUnLockLevel() : int
      {
         return this._nextUnLockLevel;
      }
      
      public function get userId() : Number
      {
         return this._userId;
      }
      
      public function Init(ui:MovieClip, data:Object) : void
      {
         var levelMC:MovieClip;
         var levelTxt:TextField;
         var nextLevelBoothCountTxt:TextField;
         var i:int;
         var levelPanel:MovieClip = null;
         var levelObj:Object = null;
         this._ui = ui;
         this._data = data;
         this._boothDatas = this._data.booths;
         this._userId = this._data.userId;
         isInMyHouse = LocalUserInfo.getUserID() == this._userId;
         this._exp = this._data.exp;
         this._level = this._data.level;
         this._lockedBoothId = this.CaculateLockedBoothId();
         noticeView.owner.GetUI().visible = false;
         this._headMC = ui.UI.pic_mc;
         this._useNameTxt = ui.UI.name_txt;
         levelMC = ui.UI.level_mc;
         tip.tipTailDisPlayObject(levelMC,"查看詳細資訊");
         levelTxt = levelMC.level_txt;
         levelTxt.text = this._level.toString();
         levelPanel = this._ui.level_panel;
         if(this._level >= DigTreasureData.MAX_LEVEL)
         {
            levelPanel.info_mc.gotoAndStop(2);
         }
         nextLevelBoothCountTxt = levelPanel.num_txt;
         for(i = 0; i < this._boothCountOfLevel.length; i++)
         {
            levelObj = this._boothCountOfLevel[i];
            this._nextLevelBoothCount = levelObj.count;
            nextLevelBoothCountTxt.text = levelObj.count;
            if(this._level < levelObj.level)
            {
               this._nextUnLockLevel = levelObj.level;
               break;
            }
         }
         var _temp_5:* = BC;
         var _temp_4:* = this;
         var _temp_3:* = levelMC;
         var _temp_2:* = MouseEvent.CLICK;
         with({})
         {
            _temp_5.addEvent(_temp_4,_temp_3,_temp_2,function handler(e:MouseEvent):void
            {
               levelPanel.visible = true;
            });
            if(isInMyHouse)
            {
               new prevView(this._headMC.mole,LocalUserInfo.getFamily().toString(16),LocalUserInfo.getClothItem());
               this._useNameTxt.text = LocalUserInfo.getNickName();
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,GetSceneUserRes.GET_SCENE_INFO,this.onReadUserInfo);
               new GetSceneUserInfoReq().getSeceeUserInfo(this.userId);
            }
            this._headMC.buttonMode = true;
            BC.addEvent(this,this._headMC,MouseEvent.CLICK,this.OpenUseInfoPanel);
            this._toolView = new TreasureHouseToolView(this._ui.UI);
            BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.ClearHandler);
            this.LoadBG(data.bgId);
         }
         
         public function LoadBG(bgId:int) : void
         {
            var bgPath:String = "resource/digTreasure/swf/" + bgId + ".swf";
            this._bgLoader = new MCLoader(Links.getUrl(bgPath),MainManager.getAppLevel(),1,"正在加載藏寶閣背景...");
            BC.addEvent(this,this._bgLoader,MCLoadEvent.ON_SUCCESS,this.onBGLoadOver);
            BC.addEvent(this,this._bgLoader,MCLoadEvent.ERROR,this.onBGLoadFail);
            LoaderList.getInstance().addItem(this._bgLoader,null,LoaderList.HIGH);
         }
         
         private function InitOver() : void
         {
            if(isInMyHouse)
            {
            }
         }
         
         private function OpenUseInfoPanel(e:MouseEvent) : void
         {
            userPanelView.showUserPanel(this.userId);
         }
         
         private function onBGLoadFail(e:MCLoadEvent) : void
         {
            throw new Error("加載藏寶閣背景出錯");
         }
         
         private function onBGLoadOver(e:MCLoadEvent) : void
         {
            var bgMC:MovieClip;
            var app:ApplicationDomain;
            var backHomeBtn:SimpleButton;
            var toDigTreasure:SimpleButton;
            var bgIndex:int = 0;
            BC.removeEvent(this,this._bgLoader);
            bgMC = this._bgLoader.loader.content as MovieClip;
            app = this._bgLoader.loader.contentLoaderInfo.applicationDomain;
            this._bgLoader.clear();
            this._bgLoader = null;
            this._ui.addChildAt(bgMC.bg_mc,this._ui.getChildIndex(this._ui.bg_mc));
            this._ui.removeChild(this._ui.bg_mc);
            this._ui.addChildAt(bgMC.control_mc,this._ui.getChildIndex(this._ui.control_mc));
            this._ui.removeChild(this._ui.control_mc);
            this._ui.addChildAt(bgMC.depth_mc,this._ui.getChildIndex(this._ui.depth_mc));
            this._ui.removeChild(this._ui.depth_mc);
            this._ui.addChildAt(bgMC.buttonLevel,this._ui.getChildIndex(this._ui.buttonLevel));
            this._ui.removeChild(this._ui.buttonLevel);
            this._ui.addChildAt(bgMC.type_mc,this._ui.getChildIndex(this._ui.type_mc));
            this._ui.removeChild(this._ui.type_mc);
            this._ui.addChildAt(bgMC.top_mc,this._ui.getChildIndex(this._ui.top_mc));
            this._ui.removeChild(this._ui.top_mc);
            bgIndex = this._ui.getChildIndex(bgMC.bg_mc);
            this._ui.bg_mc = bgMC.bg_mc;
            this._ui.control_mc = bgMC.control_mc;
            this._ui.depth_mc = bgMC.depth_mc;
            this._ui.buttonLevel = bgMC.buttonLevel;
            this._ui.type_mc = bgMC.type_mc;
            this._ui.top_mc = bgMC.top_mc;
            this._ui.type_mc.mouseEnabled = false;
            this._ui.type_mc.mouseChildren = false;
            this._ui.top_mc.mouseEnabled = false;
            this._ui.top_mc.mouseChildren = false;
            this._ui.depth_mc.mouseEnabled = false;
            this._ui.depth_mc.mouseChildren = false;
            with({})
            {
               setTimeout(function handler():void
               {
                  _ui.bg_mc = new MovieClip();
                  _ui.addChildAt(_ui.bg_mc,bgIndex);
               },300);
               backHomeBtn = this._ui.control_mc.backHome_btn;
               var _temp_5:* = BC;
               var _temp_4:* = this;
               var _temp_3:* = backHomeBtn;
               var _temp_2:* = MouseEvent.CLICK;
               with({})
               {
                  _temp_5.addEvent(_temp_4,_temp_3,_temp_2,function backHome(e:MouseEvent):void
                  {
                     GV.Room_DefaultRoomID = GV.MyInfo_userID + GV.TwentyBillion;
                     GF.switchMap(_userId + GV.TwentyBillion);
                  });
                  toDigTreasure = this._ui.control_mc.toDigTreasure_btn;
                  var _temp_9:* = BC;
                  var _temp_8:* = this;
                  var _temp_7:* = toDigTreasure;
                  var _temp_6:* = MouseEvent.CLICK;
                  with({})
                  {
                     _temp_9.addEvent(_temp_8,_temp_7,_temp_6,function toDigTreasure(e:MouseEvent):void
                     {
                        MapManager.enterMap(184);
                     });
                     this._treasureAreaCtl = new TreasureHouseTreasurAreaCtl(this._ui.buttonLevel);
                     this.InitOver();
                  }
                  
                  private function CaculateLockedBoothId() : int
                  {
                     var obj:Object = null;
                     var level:int = this._level;
                     var showCount:int = 2;
                     for each(obj in this._boothCountOfLevel)
                     {
                        if(level < obj.level)
                        {
                           break;
                        }
                        showCount = int(obj.count);
                     }
                     return showCount;
                  }
                  
                  private function onReadUserInfo(e:EventTaomee) : void
                  {
                     BC.removeEvent(this,GV.onlineSocket,GetSceneUserRes.GET_SCENE_INFO,this.onReadUserInfo);
                     var userInfo:Object = e.EventObj;
                     new prevView(this._headMC.mole,userInfo.Color.toString(16),userInfo.itemArr,userInfo);
                     this._useNameTxt.text = userInfo.Nick;
                  }
                  
                  private function ClearHandler(e:Event) : void
                  {
                     BC.removeEvent(this);
                     this._toolView.Clear();
                     isInMyHouse = false;
                     this._ui = null;
                     _instance = null;
                  }
               }
            }
            
            class Block
            {
               
               public function Block()
               {
                  super();
               }
            }
            