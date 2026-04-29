package com.module.angelFight
{
   import com.core.MainManager;
   import com.core.info.MapInfo;
   import com.core.loading.Loading;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.mapEvent.WordMapLogic_HSL;
   import com.logic.mapEvent.WordMapLogic_OldHSL;
   import com.module.angelFight.valueObject.AngelFightSkillVO;
   import com.view.mapView.activity.Task83.TestAngelFight;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   
   public class AngelFightMain extends EventDispatcher
   {
      
      private static var _instance:AngelFightMain;
      
      public static var Default_Bag_Kind_Index:int = 0;
      
      public static var User_Changed_UI_Index:int = 0;
      
      public static var _nickNameDic:Dictionary = new Dictionary();
      
      private var _app:ApplicationDomain;
      
      private var _skillDic:Dictionary;
      
      public var _collectList:Array;
      
      private var _reOpenType:int = 0;
      
      private var _passiveSkills:Array;
      
      private var _collectPieceDir:Dictionary;
      
      private var _toolBar:*;
      
      private var _friendClass:Class;
      
      private var _friendPanel:*;
      
      private var _getCardsPanelClass:Class;
      
      public function AngelFightMain()
      {
         super();
      }
      
      public static function get instance() : AngelFightMain
      {
         if(_instance == null)
         {
            _instance = new AngelFightMain();
         }
         return _instance;
      }
      
      public function Init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"wordMapChang_over",this.OnChangeMap);
         BC.addEvent(this,GV.onlineSocket,AngelFightEvent.End_Fight_Event,this.TryOpenFightMap);
      }
      
      public function set reOpenType(value:int) : void
      {
         this._reOpenType = value;
      }
      
      public function get reOpenType() : int
      {
         return this._reOpenType;
      }
      
      private function TryOpenFightMap(e:Event) : void
      {
         var mapInfo:MapInfo = MapInfo.getMapInfo(GV.MapInfo_mapID);
         var isOldHSL:int = mapInfo.isOldHSL;
         if(isOldHSL != 0)
         {
            try
            {
               if(this._reOpenType == 1)
               {
                  GC.setGTimeout(this.OpenFightMapHandler,1000);
               }
               else if(this._reOpenType == 2)
               {
                  GC.setGTimeout(this.OpenBossHandler,1000);
               }
               else if(this._reOpenType == 3)
               {
                  GC.setGTimeout(this.OpenFightMapWithBossHandler,1000);
               }
               this._reOpenType = 0;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function OnChangeMap(e:EventTaomee) : void
      {
         if(Boolean(this._app) && Boolean(this._skillDic) && Boolean(this._collectList))
         {
            this.InitOk();
         }
         else
         {
            this.LoadUI();
         }
      }
      
      private function InitOk() : void
      {
         var mapInfo:MapInfo = MapInfo.getMapInfo(GV.MapInfo_mapID);
         var isOldHSL:int = mapInfo.isOldHSL;
         if(isOldHSL != 0)
         {
            this.ShowToolBar(isOldHSL);
         }
         else
         {
            this.HideToolBar();
         }
      }
      
      private function LoadUI() : void
      {
         var url:String = null;
         var loader:Loader = null;
         var thisObj:Object = null;
         if(Boolean(this._app))
         {
            this.LoadSkillConfig();
            return;
         }
         url = "module/angelFight/AngelFight.swf";
         loader = new Loader();
         thisObj = this;
         var _temp_4:* = BC;
         var _temp_3:* = thisObj;
         var _temp_2:* = loader.contentLoaderInfo;
         var _temp_1:* = IOErrorEvent.IO_ERROR;
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function IOHandler(e:IOErrorEvent):void
            {
               BC.removeEvent(thisObj,loader.contentLoaderInfo);
               throw Error("素材不存在：" + url);
            });
            loader.load(VL.getURLRequest(url));
         }
         
         private function LoadUIHandler(e:Event) : void
         {
            var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
            BC.removeEvent(this,loaderInfo);
            this._app = loaderInfo.applicationDomain;
            loaderInfo = null;
            this.LoadSkillConfig();
         }
         
         private function LoadSkillConfig() : void
         {
            var url:String = null;
            var loader:URLLoader = null;
            var thisObj:Object = null;
            if(Boolean(this._skillDic))
            {
               this.LoadCollectConfig();
               return;
            }
            url = "resource/xml/angelFight/af_skills.xml";
            loader = new URLLoader();
            thisObj = this;
            var _temp_4:* = BC;
            var _temp_3:* = thisObj;
            var _temp_2:* = loader;
            var _temp_1:* = IOErrorEvent.IO_ERROR;
            with({})
            {
               _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function IOHandler(e:IOErrorEvent):void
               {
                  BC.removeEvent(thisObj,loader);
                  throw Error("配置文件不存在：" + url);
               });
               loader.load(VL.getURLRequest(url));
            }
            
            public function get passiveSkills() : Array
            {
               return this._passiveSkills;
            }
            
            private function LoadSkillConfigHandler(e:Event) : void
            {
               var item:XML = null;
               var skillId:int = 0;
               BC.removeEvent(this,e.currentTarget);
               var data:XMLList = new XML(e.target.data).children();
               this._skillDic = new Dictionary();
               this._passiveSkills = new Array();
               for each(item in data)
               {
                  skillId = int(item.@Skill_id);
                  this._skillDic[skillId] = item;
                  if(int(item.@Skill_type) == 1)
                  {
                     this._passiveSkills.push(skillId);
                  }
               }
               this.LoadCollectConfig();
            }
            
            private function LoadCollectConfig() : void
            {
               var url:String = null;
               var loader:URLLoader = null;
               var thisObj:Object = null;
               if(Boolean(this._collectList))
               {
                  this.InitOk();
                  return;
               }
               url = "resource/xml/angelFight/collectChangel.xml";
               loader = new URLLoader();
               thisObj = this;
               var _temp_4:* = BC;
               var _temp_3:* = thisObj;
               var _temp_2:* = loader;
               var _temp_1:* = IOErrorEvent.IO_ERROR;
               with({})
               {
                  _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function IOHandler(e:IOErrorEvent):void
                  {
                     BC.removeEvent(thisObj,loader);
                     throw Error("配置文件不存在：" + url);
                  });
                  loader.load(VL.getURLRequest(url));
               }
               
               private function LoadCollectConfigHandler(e:Event) : void
               {
                  var item:XML = null;
                  var pieces:XMLList = null;
                  var piece:XML = null;
                  BC.removeEvent(this,e.currentTarget);
                  var data:XMLList = new XML(e.target.data).children();
                  this._collectList = new Array();
                  this._collectPieceDir = new Dictionary();
                  for each(item in data)
                  {
                     this._collectList.push(item);
                     pieces = item.children();
                     for each(piece in pieces)
                     {
                        this._collectPieceDir[int(piece.@id)] = int(item.@id);
                     }
                  }
                  this.InitOk();
               }
               
               public function GetMovieClip(name:String) : MovieClip
               {
                  var cls:Class = null;
                  if(Boolean(this._app))
                  {
                     cls = this._app.getDefinition(name) as Class;
                     if(Boolean(cls))
                     {
                        return new cls() as MovieClip;
                     }
                  }
                  return null;
               }
               
               public function GetClass(name:String) : Class
               {
                  var cls:Class = null;
                  if(Boolean(this._app))
                  {
                     cls = this._app.getDefinition(name) as Class;
                     if(Boolean(cls))
                     {
                        return cls;
                     }
                  }
                  return null;
               }
               
               public function ShowToolBar(type:int) : void
               {
                  var toolBarUrl:String = null;
                  var loader:Loader = null;
                  if(Boolean(this._toolBar))
                  {
                     this._toolBar.visible = true;
                     this._toolBar.InitToolBar(type);
                     MainManager.getToolLevel().addChild(this._toolBar);
                  }
                  else
                  {
                     toolBarUrl = "module/external/angelFight/AngelFightToolBar.swf";
                     var _temp_4:* = BC;
                     var _temp_3:* = this;
                     var _temp_2:* = loader.contentLoaderInfo;
                     var _temp_1:* = Event.COMPLETE;
                     with({})
                     {
                        
                        _temp_4.addOnceEvent(_temp_3,_temp_2,_temp_1,function LoadToolBarOverHandler(e:Event):void
                        {
                           _toolBar = loader.contentLoaderInfo.content as Sprite;
                           ShowToolBar(type);
                        });
                        loader.load(VL.getURLRequest(toolBarUrl));
                     }
                  }
                  
                  public function HideToolBar() : void
                  {
                     if(Boolean(this._toolBar))
                     {
                        this._toolBar.visible = false;
                        try
                        {
                           MainManager.getToolLevel().removeChild(this._toolBar);
                        }
                        catch(e:Error)
                        {
                        }
                     }
                  }
                  
                  public function ShowFriendPanel(userId:Number) : void
                  {
                     var loader:MCLoader = null;
                     if(Boolean(this._friendClass))
                     {
                        if(this._friendPanel == null)
                        {
                           this._friendPanel = new this._friendClass();
                        }
                        this._friendPanel.ShowUser(userId);
                     }
                     else
                     {
                        var _temp_2:* = loader;
                        var _temp_1:* = MCLoadEvent.ON_SUCCESS;
                        with({})
                        {
                           
                           _temp_2.addEventListener(_temp_1,function handler(e:MCLoadEvent):void
                           {
                              var app:ApplicationDomain = e.getLoader().contentLoaderInfo.applicationDomain;
                              _friendClass = app.getDefinition("AngelFightFriendPanel") as Class;
                              ShowFriendPanel(userId);
                              loader.clear();
                           });
                           LoaderList.getInstance().addItem(loader,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
                        }
                     }
                     
                     public function ClearFriendPanel() : void
                     {
                        try
                        {
                           GC.clearAll(this._friendPanel);
                           this._friendPanel = null;
                        }
                        catch(e:Error)
                        {
                        }
                     }
                     
                     public function GetSkillVO(skillId:int, level:int = 1) : AngelFightSkillVO
                     {
                        if(Boolean(this._skillDic) && this._skillDic[skillId] is XML)
                        {
                           return new AngelFightSkillVO(skillId,level,this._skillDic[skillId]);
                        }
                        return null;
                     }
                     
                     public function ShowGetCardsPanel() : void
                     {
                        var getCardsPanel:* = undefined;
                        var loader:MCLoader = null;
                        if(Boolean(this._getCardsPanelClass))
                        {
                           getCardsPanel = new this._getCardsPanelClass();
                           getCardsPanel.Show();
                           this._getCardsPanelClass = null;
                        }
                        else
                        {
                           var _temp_2:* = loader;
                           var _temp_1:* = MCLoadEvent.ON_SUCCESS;
                           with({})
                           {
                              
                              _temp_2.addEventListener(_temp_1,function handler(e:MCLoadEvent):void
                              {
                                 var app:ApplicationDomain = e.getLoader().contentLoaderInfo.applicationDomain;
                                 _getCardsPanelClass = app.getDefinition("AngelFightGetCardPanel") as Class;
                                 ShowGetCardsPanel();
                                 loader.clear();
                              });
                              LoaderList.getInstance().addItem(loader,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
                           }
                        }
                        
                        public function GetCollectIdByPieceId(pieceId:int) : int
                        {
                           if(Boolean(this._collectPieceDir) && Boolean(this._collectPieceDir[pieceId]))
                           {
                              return this._collectPieceDir[pieceId];
                           }
                           return -1;
                        }
                        
                        public function OpenFightMapHandler(mapId:int = 9999) : void
                        {
                           var url:String = "module/external/angelFight/LoadAngelFight.swf?mapID=" + mapId;
                           this.LoadModule(url,"正在打開戰鬥地圖....");
                        }
                        
                        public function OpenFightMapWithBossHandler(mapId:int = 9999) : void
                        {
                           var url:String = "module/external/angelFight/BossLoadAngelFight.swf?mapID=" + mapId;
                           this.LoadModule(url,"正在打開戰鬥地圖....");
                        }
                        
                        public function OpenBuyHandler(e:MouseEvent = null) : void
                        {
                           var url:String = "module/external/angelFight/FightBag.swf";
                           this.LoadModule(url,"正在查看摩摩怪售賣....");
                        }
                        
                        public function OpenTaskHandler(e:MouseEvent = null) : void
                        {
                           var url:String = "module/external/angelFight/AngelFightEveryDayTask.swf";
                           this.LoadModule(url,"正在查看今日任務....");
                        }
                        
                        public function OpenBossHandler(e:MouseEvent = null) : void
                        {
                           TestAngelFight.getInstance().onLoaderBossPanel();
                        }
                        
                        public function OpenCollectHandler(e:MouseEvent = null) : void
                        {
                           var url:String = "module/external/angelFight/AngelFightCollection.swf";
                           this.LoadModule(url,"正在查看我的收集品....");
                        }
                        
                        public function OpenDiscipleMarket(e:MouseEvent = null) : void
                        {
                           var url:String = "module/external/angelFight/AngelfightDiscipleMarket.swf";
                           this.LoadModule(url,"正在查看小小市場....");
                        }
                        
                        public function OpenMasterAndDiscipleInfo(e:MouseEvent = null) : void
                        {
                           var url:String = "module/external/angelFight/AngelFightMasterAndDisciple.swf";
                           this.LoadModule(url,"正在查看大小幫總動員....");
                        }
                        
                        public function OpenSkillsHandler(userId:int) : void
                        {
                           var url:String = "module/external/angelFight/AngelFightSkills.swf?userId=" + userId;
                           this.LoadModule(url,"正在查看我的天賦....");
                        }
                        
                        public function OpenCardsHandler(userId:int) : void
                        {
                           var url:String = "module/external/angelFight/AngelFightCards.swf?userId=" + userId;
                           this.LoadModule(url,"正在打開卡牌冊....");
                        }
                        
                        public function OpenPvpFight(e:MouseEvent) : void
                        {
                           var url:String = "module/external/angelFight/AngelFightPvp.swf";
                           this.LoadModule(url,"正在進入挑戰....");
                        }
                        
                        public function OpenBagHandler(e:MouseEvent = null) : void
                        {
                           var url:String = "module/external/angelFight/AngelFightUserBag.swf";
                           this.LoadModule(url,"正在打開戰鬥行囊....");
                        }
                        
                        public function OpenHotMasterDesc(e:MouseEvent = null) : void
                        {
                           var url:String = "module/external/angelFight/masterDesc.swf";
                           this.LoadModule(url,"正在打開大小活動說明....");
                        }
                        
                        public function OpenFightMsgHandler(e:MouseEvent = null) : void
                        {
                           var url:String = "module/external/angelFight/AngelFightMsg.swf";
                           this.LoadModule(url,"正在查看戰鬥記錄....");
                        }
                        
                        public function OpenDonateHandler(e:MouseEvent = null) : void
                        {
                           var url:String = "module/external/angelFight/AngelFightDonate.swf";
                           this.LoadModule(url,"正在查找捐獻卡牌....");
                        }
                        
                        public function PlayMovie(name:String) : void
                        {
                           var loader:Loader = new Loader();
                           loader.load(VL.getURLRequest("resource/angelFight/movie/" + name + ".swf"));
                           MainManager.getAppLevel().addChild(loader);
                        }
                        
                        private function CheckNewIconForBuyMC(setVisibleMC:MovieClip, key:String, setVisibleToFalse:Boolean = false) : void
                        {
                           if(setVisibleToFalse)
                           {
                              creatShareObject.getInstance().getShareObject().data[key] = false;
                              try
                              {
                                 creatShareObject.getInstance().getShareObject().flush();
                              }
                              catch(e:*)
                              {
                              }
                              setVisibleMC.visible = false;
                           }
                           else
                           {
                              if(!creatShareObject.getInstance().getShareObject().data.hasOwnProperty(key))
                              {
                                 creatShareObject.getInstance().getShareObject().data[key] = true;
                                 try
                                 {
                                    creatShareObject.getInstance().getShareObject().flush();
                                 }
                                 catch(e:*)
                                 {
                                 }
                              }
                              setVisibleMC.visible = creatShareObject.getInstance().getShareObject().data[key];
                           }
                        }
                        
                        public function OpenMapHandler(e:MouseEvent = null) : void
                        {
                           var mapMC:MovieClip = null;
                           var loader:MCLoader = null;
                           if(!MainManager.getGameLevel().getChildByName("mapMC") && !GV.isChangeMap)
                           {
                              mapMC = new MovieClip();
                              mapMC.name = "mapMC";
                              MainManager.getGameLevel().addChild(mapMC);
                              if(GV.MapInfo_mapID == 228)
                              {
                                 loader = new MCLoader("resource/worldMap/worldMap_HSL.swf",mapMC,Loading.TITLE_AND_PERCENT,"正在打開世界地圖");
                                 loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.LoadMapOverHandler_temp);
                                 LoaderList.getInstance().addItem(loader,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
                              }
                              else
                              {
                                 loader = new MCLoader("resource/worldMap/worldMap_OldHSL.swf",mapMC,Loading.TITLE_AND_PERCENT,"正在打開世界地圖");
                                 loader.addEventListener(MCLoadEvent.ON_SUCCESS,this.LoadMapOverHandler);
                                 LoaderList.getInstance().addItem(loader,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
                              }
                           }
                        }
                        
                        private function LoadMapOverHandler(e:MCLoadEvent) : void
                        {
                           var mainMC:DisplayObjectContainer = e.getParent();
                           var childMC:Loader = e.getLoader();
                           mainMC.addChild(childMC);
                           var map:WordMapLogic_OldHSL = new WordMapLogic_OldHSL(childMC);
                        }
                        
                        private function LoadMapOverHandler_temp(e:MCLoadEvent) : void
                        {
                           var mainMC:DisplayObjectContainer = e.getParent();
                           var childMC:Loader = e.getLoader();
                           mainMC.addChild(childMC);
                           var map:WordMapLogic_HSL = new WordMapLogic_HSL(childMC);
                        }
                        
                        private function LoadModule(url:String, msg:String) : void
                        {
                           var mapMC:MovieClip = null;
                           var loader:MCLoader = null;
                           if(!MainManager.getAppLevel().getChildByName(url) && !GV.isChangeMap)
                           {
                              mapMC = new MovieClip();
                              mapMC.name = url;
                              MainManager.getAppLevel().addChild(mapMC);
                              var _temp_3:* = loader;
                              var _temp_2:* = MCLoadEvent.ON_SUCCESS;
                              with({})
                              {
                                 
                                 _temp_3.addEventListener(_temp_2,function h(e:MCLoadEvent):void
                                 {
                                    var mainMC:DisplayObjectContainer = e.getParent();
                                    var childMC:Loader = e.getLoader();
                                    mainMC.addChild(childMC);
                                    loader.clear();
                                    loader = null;
                                 });
                                 LoaderList.getInstance().addItem(loader,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
                              }
                           }
                           
                           public function GetMasterLevelName(outCount:int) : String
                           {
                              if(outCount == 0)
                              {
                                 return "一大大";
                              }
                              if(outCount >= 1 && outCount <= 3)
                              {
                                 return "二大大";
                              }
                              if(outCount >= 4 && outCount <= 9)
                              {
                                 return "三大大";
                              }
                              if(outCount >= 10 && outCount <= 19)
                              {
                                 return "四大大";
                              }
                              return "五大大";
                           }
                        }
                     }
                     
                     