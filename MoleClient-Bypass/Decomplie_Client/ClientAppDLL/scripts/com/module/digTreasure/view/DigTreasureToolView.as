package com.module.digTreasure.view
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.manager.UIManager;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.mapEvent.WordMapLogic_DigTreasure;
   import com.logic.socket.digTreasure.DigTreasureSocket;
   import com.module.changeClothsModule.prevView;
   import com.module.digTreasure.DigTreasureEvent;
   import com.module.digTreasure.data.DigTreasureConfig;
   import com.module.digTreasure.data.DigTreasureData;
   import com.module.friendList.friendView.listView;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.popupMsg.PopupMsgCtl;
   import com.module.present.PresentManager;
   import com.view.baseViewCtl.ProgressbarControler;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class DigTreasureToolView
   {
      
      private static var CheckTreasureCount:int = 0;
      
      private var _ui:MovieClip;
      
      private var _mapBtn:SimpleButton;
      
      private var _bagBtn:SimpleButton;
      
      private var _treasureBtn:SimpleButton;
      
      private var _areaInfoBtn:SimpleButton;
      
      private var _friendBtn:SimpleButton;
      
      private var _shopBtn:SimpleButton;
      
      private var _hpMC:MovieClip;
      
      private var _hpBar:ProgressbarControler;
      
      private var _levelMC:MovieClip;
      
      private var _levelBar:ProgressbarControler;
      
      private var _levelTxt:TextField;
      
      private var _newMapMC:MovieClip;
      
      private var _newTreasureMC:MovieClip;
      
      private var _newMapMCDate:String = "digTreasureNewMap_2011_6_23";
      
      private var _newTreasureMCDate:String = "newTreasureMCDate_2011_6_23";
      
      private var _dataCtl:DigTreasureData;
      
      private var _hpTimeBar:ProgressbarControler;
      
      private var _hpTimeTxt:TextField;
      
      private var _syncHpTimer:Timer;
      
      public function DigTreasureToolView()
      {
         super();
      }
      
      public function Init(dataCtl:DigTreasureData) : void
      {
         this._dataCtl = dataCtl;
         this._ui = DigTreasureConfig.instance.GetMovieClip("toolView_mc");
         new prevView(this._ui.pic_mc.mole,LocalUserInfo.getFamily().toString(16),LocalUserInfo.getClothItem());
         this._ui.name_txt.text = LocalUserInfo.getNickName();
         this._mapBtn = this._ui.map_btn;
         tip.tipTailDisPlayObject(this._mapBtn,"查看地下地圖");
         BC.addEvent(this,this._mapBtn,MouseEvent.CLICK,this.OpenMap);
         this._newMapMC = this._ui.new_mc;
         var so:SharedObject = creatShareObject.getInstance().getShareObject();
         if(so.data.hasOwnProperty(this._newMapMCDate) && so.data[this._newMapMCDate] == true)
         {
            this._newMapMC.visible = false;
         }
         else
         {
            this._newMapMC.visible = true;
         }
         this._bagBtn = this._ui.bag_btn;
         tip.tipTailDisPlayObject(this._bagBtn,"探險背包");
         BC.addEvent(this,this._bagBtn,MouseEvent.CLICK,this.OpenBag);
         this._treasureBtn = this._ui.treasure_btn;
         tip.tipTailDisPlayObject(this._treasureBtn,"我的寶藏");
         BC.addEvent(this,this._treasureBtn,MouseEvent.CLICK,this.OpenTreasurePanel);
         this._newTreasureMC = this._ui.newTreasure_mc;
         so = creatShareObject.getInstance().getShareObject();
         if(so.data.hasOwnProperty(this._newTreasureMCDate) && so.data[this._newTreasureMCDate] == true)
         {
            this._newTreasureMC.visible = false;
         }
         else
         {
            this._newTreasureMC.visible = true;
         }
         this._shopBtn = this._ui.shop_btn;
         tip.tipTailDisPlayObject(this._shopBtn,"購買道具");
         BC.addEvent(this,this._shopBtn,MouseEvent.CLICK,this.OpenShopPanel);
         this._areaInfoBtn = this._ui.areaInfo_btn;
         tip.tipTailDisPlayObject(this._areaInfoBtn,"特色寶藏");
         BC.addEvent(this,this._areaInfoBtn,MouseEvent.CLICK,this.OpenAreaInfoPanel);
         this._friendBtn = this._ui.friend_btn;
         tip.tipTailDisPlayObject(this._friendBtn,"我的好友");
         BC.addEvent(this,this._friendBtn,MouseEvent.CLICK,this.showFriend);
         this._hpMC = this._ui.hp_mc;
         this._hpMC.buttonMode = true;
         tip.tipTailDisPlayObject(this._hpMC,"探險過程會消耗精力哦");
         BC.addEvent(this,this._hpMC,MouseEvent.CLICK,this.OpenHpHelpPanel);
         this._hpMC.bar_mc.gotoAndStop(1);
         this._hpBar = new ProgressbarControler(this._hpMC.bar_mc);
         this._levelMC = this._ui.level_mc;
         this._levelMC.buttonMode = true;
         BC.addEvent(this,this._levelMC,MouseEvent.CLICK,this.OpenLevelHelpPanel);
         this._levelMC.bar_mc.gotoAndStop(1);
         this._levelBar = new ProgressbarControler(this._levelMC.bar_mc);
         this._levelTxt = this._levelMC.level_txt;
         BC.addEvent(this,this._dataCtl,DigTreasureEvent.DigTreasureDataUpdate,this.UpdateDataHandler);
         BC.addEvent(this,this._dataCtl,DigTreasureEvent.DigTreasureLevelUp,this.LevelUpHandler);
         BC.addEvent(this,this._dataCtl,DigTreasureEvent.HPNotEnough,this.HpNotEnoughHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.UseItemCmd,this.UseItemHandler);
         BC.addEvent(this,GV.onlineSocket,"digTreasure_openShop_event",this.OpenShopPanel);
         this._hpTimeBar = new ProgressbarControler(this._ui.hpTime_mc);
         this._hpTimeBar.ui.visible = false;
         this._hpTimeTxt = this._ui.hpTime_txt;
         this._hpTimeTxt.visible = false;
         this.UpdateDataHandler(null);
         this.SyncHp();
         this.CheckHasExchangeTreasure();
      }
      
      private function CheckHasExchangeTreasure() : void
      {
         if(CheckTreasureCount < 3)
         {
            BC.addOnceEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.GetBagCmd,this.GetBagHandler);
            DigTreasureSocket.GetBag();
         }
      }
      
      private function GetBagHandler(e:EventTaomee) : void
      {
         var item:Object = null;
         var exchangeItems:XMLList = null;
         var exchangeItem:XML = null;
         var exitems:XMLList = null;
         var checked:Boolean = false;
         var exitem:XML = null;
         var itemId:int = 0;
         var itemCount:int = 0;
         var lightEffect:MovieClip = null;
         var items:Array = e.EventObj.items;
         var itemDic:Dictionary = new Dictionary();
         for each(item in items)
         {
            itemDic[int(item.id)] = int(item.count);
         }
         exchangeItems = DigTreasureConfig.instance.checkExchangeItems;
         for each(exchangeItem in exchangeItems)
         {
            exitems = exchangeItem.children();
            checked = true;
            for each(exitem in exitems)
            {
               itemId = int(exitem.@id);
               itemCount = int(exitem.@num);
               if(!(Boolean(itemDic[itemId]) && itemDic[itemId] >= itemCount))
               {
                  checked = false;
                  break;
               }
            }
            if(checked)
            {
               lightEffect = DigTreasureConfig.instance.GetMovieClip("light_effect");
               MainManager.getAppLevel().addChild(lightEffect);
               lightEffect.x = this._treasureBtn.x;
               with({})
               {
                  
                  setTimeout(function h():void
                  {
                     lightEffect.visible = false;
                     GC.clearAll(lightEffect);
                  },3000);
                  PopupMsgCtl.PopupMsg("    你有可以兌換的寶藏啦！",3000);
                  ++CheckTreasureCount;
                  break;
               }
            }
         }
         
         private function UseItemHandler(e:EventTaomee) : void
         {
            var effectMC:MovieClip = null;
            if(e.EventObj.hp >= this._dataCtl.maxHP)
            {
               if(Boolean(this._syncHpTimer))
               {
                  this._syncHpTimer.stop();
                  BC.removeEvent(this,this._syncHpTimer);
                  this._syncHpTimer = null;
               }
               this._hpTimeBar.ui.visible = false;
               this._hpTimeTxt.visible = false;
            }
            this._dataCtl.hp = e.EventObj.hp;
            this._hpBar.SetData(this._dataCtl.hp,this._dataCtl.maxHP);
            try
            {
               effectMC = DigTreasureConfig.instance.GetMovieClip("fullHp_effect");
               MainManager.getAppLevel().addChild(effectMC);
               effectMC.x = 221.9;
               effectMC.y = 39.1;
            }
            catch(e:Error)
            {
            }
         }
         
         private function HpNotEnoughHandler(e:Event) : void
         {
            var mc:MovieClip = DigTreasureConfig.instance.GetMovieClip("openShop_panel");
            MainManager.getAppLevel().addChild(mc);
         }
         
         private function OpenLevelHelpPanel(e:MouseEvent) : void
         {
            var mc:MovieClip = DigTreasureConfig.instance.GetMovieClip("exp_panel");
            mc.hp_txt.text = this._dataCtl.GetMaxHPByLevel(this._dataCtl.level + 1);
            MainManager.getAppLevel().addChild(mc);
         }
         
         private function OpenHpHelpPanel(e:MouseEvent) : void
         {
            MainManager.getAppLevel().addChild(DigTreasureConfig.instance.GetMovieClip("hp_panel"));
         }
         
         private function OpenShopPanel(e:Event) : void
         {
            var url:String = "module/external/digTreasure/DigShopPanel.swf";
            var msg:String = "正在打開探險百寶店....";
            var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getAppLevel());
            loadGame = null;
         }
         
         private function OpenAreaInfoPanel(e:MouseEvent) : void
         {
            var url:String = "module/external/digTreasure/DigTreasureMapInfoPanel.swf";
            var msg:String = "正在打開特色寶藏....";
            var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getAppLevel());
            loadGame = null;
         }
         
         private function OpenBag(e:MouseEvent) : void
         {
            var url:String = "module/external/digTreasure/DigBag.swf";
            var msg:String = "正在打開探險背包....";
            var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getAppLevel());
            loadGame = null;
         }
         
         private function OpenTreasurePanel(e:MouseEvent) : void
         {
            this._newTreasureMC.visible = false;
            creatShareObject.getInstance().getShareObject().data[this._newTreasureMCDate] = true;
            var url:String = "module/external/digTreasure/DigExchange.swf";
            var msg:String = "正在打開我的寶藏....";
            var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getAppLevel());
            loadGame = null;
         }
         
         private function OpenMap(e:MouseEvent) : void
         {
            this._newMapMC.visible = false;
            creatShareObject.getInstance().getShareObject().data[this._newMapMCDate] = true;
            creatShareObject.getInstance().getShareObject().flush();
            var mapMC:MovieClip = new MovieClip();
            mapMC.name = "mapMC";
            MainManager.getGameLevel().addChild(mapMC);
            var mcLoader:MCLoader = new MCLoader("resource/worldMap/worldMap_digTreasure.swf",mapMC,Loading.TITLE_AND_PERCENT,"正在打開世界地圖");
            mcLoader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadMapOverHandler);
            LoaderList.getInstance().addItem(mcLoader,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
         }
         
         public function showFriend(e:MouseEvent = null) : void
         {
            var tempMC:Class = null;
            var man:Class = null;
            var friendMC:MovieClip = null;
            var fmc:DisplayObject = null;
            if(!MainManager.getAppLevel().getChildByName("friendMC") && !GV.isChangeMap)
            {
               tempMC = UIManager.getClass("friendListMC");
               man = UIManager.getClass("Man");
               friendMC = new tempMC();
               friendMC.name = "friendMC";
               friendMC.x = 675;
               friendMC.y = 160;
               friendMC.visible = PresentManager.showFriendPanelBool;
               MainManager.getAppLevel().addChild(friendMC);
               new listView(friendMC,man);
            }
            else
            {
               fmc = MainManager.getAppLevel().getChildByName("friendMC");
               if(Boolean(fmc))
               {
                  fmc.visible = true;
               }
            }
         }
         
         public function loadMapOverHandler(evt:MCLoadEvent) : void
         {
            var mainMC:DisplayObjectContainer = evt.getParent();
            var childMC:Loader = evt.getLoader();
            mainMC.addChild(childMC);
            var map:WordMapLogic_DigTreasure = new WordMapLogic_DigTreasure(childMC);
         }
         
         private function LevelUpHandler(e:Event) : void
         {
            var effectMC:MovieClip = null;
            PopupMsgCtl.PopupMsg("恭喜你探險等級提升至" + this._dataCtl.level + "級！");
            if(Boolean(this._syncHpTimer))
            {
               this._syncHpTimer.stop();
               BC.removeEvent(this,this._syncHpTimer);
               this._syncHpTimer = null;
            }
            this._hpTimeBar.ui.visible = false;
            this._hpTimeTxt.visible = false;
            try
            {
               effectMC = DigTreasureConfig.instance.GetMovieClip("fullHp_effect");
               MainManager.getAppLevel().addChild(effectMC);
               effectMC.x = 221.9;
               effectMC.y = 39.1;
            }
            catch(e:Error)
            {
            }
         }
         
         private function UpdateDataHandler(e:Event) : void
         {
            this._levelTxt.text = this._dataCtl.level.toString();
            this._hpBar.SetData(this._dataCtl.hp,this._dataCtl.maxHP);
            this._levelBar.SetData(this._dataCtl.exp,this._dataCtl.maxExp);
            if(this._dataCtl.level > DigTreasureData.MAX_LEVEL)
            {
               tip.tipTailDisPlayObject(this._levelMC,"恭喜你升到頂級啦！");
            }
            else
            {
               tip.tipTailDisPlayObject(this._levelMC,this._dataCtl.maxExp - this._dataCtl.exp + "點經驗後，探險等級提升");
            }
            if(this._syncHpTimer == null && this._dataCtl.hp < this._dataCtl.maxHP)
            {
               this.SyncHp();
            }
         }
         
         public function SyncHp(e:TimerEvent = null) : void
         {
            BC.addOnceEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.SyncHpCmd,this.SyncHpHandler);
            DigTreasureSocket.SyncHp();
         }
         
         private function SyncHpHandler(e:EventTaomee) : void
         {
            var twoMinute:int = 0;
            var nextAddHpTime:int = 0;
            if(Boolean(this._syncHpTimer))
            {
               this._syncHpTimer.stop();
               BC.removeEvent(this,this._syncHpTimer);
               this._syncHpTimer = null;
            }
            if(e.EventObj.hp > this._dataCtl.hp)
            {
               try
               {
               }
               catch(e:Error)
               {
               }
            }
            this._dataCtl.hp = e.EventObj.hp;
            this._hpBar.SetData(this._dataCtl.hp,this._dataCtl.maxHP);
            twoMinute = 120;
            nextAddHpTime = twoMinute - e.EventObj.nextAddHpTime;
            if(this._dataCtl.hp >= this._dataCtl.maxHP)
            {
               this._hpTimeBar.ui.visible = false;
               this._hpTimeTxt.visible = false;
            }
            else
            {
               this._hpTimeBar.ui.visible = true;
               this._hpTimeTxt.visible = true;
               var _temp_6:* = BC;
               var _temp_5:* = this;
               var _temp_4:* = this._syncHpTimer;
               var _temp_3:* = TimerEvent.TIMER;
               with({})
               {
                  
                  var _temp_10:* = BC;
                  var _temp_9:* = this;
                  var _temp_8:* = this._syncHpTimer;
                  var _temp_7:* = TimerEvent.TIMER_COMPLETE;
                  with({})
                  {
                     
                     _temp_10.addEvent(_temp_9,_temp_8,_temp_7,function timerHandler(evt:TimerEvent):void
                     {
                        SyncHp();
                     });
                     this._hpTimeBar.SetData(twoMinute - (nextAddHpTime - this._syncHpTimer.currentCount),twoMinute);
                     this._hpTimeTxt.text = nextAddHpTime - this._syncHpTimer.currentCount + "秒後恢復精力";
                     this._syncHpTimer.start();
                  }
               }
               
               public function get ui() : MovieClip
               {
                  return this._ui;
               }
               
               public function Clear() : void
               {
               }
            }
         }
         
         