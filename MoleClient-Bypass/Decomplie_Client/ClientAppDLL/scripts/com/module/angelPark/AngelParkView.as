package com.module.angelPark
{
   import com.common.Alert.Alert;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.music.TopicMusicManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import com.global.staticData.XMLInfo;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.socket.angelPark.valueObj.AngelParkVO;
   import com.logic.socket.enterMapOrRoom.EnterMapOrRoomReq;
   import com.logic.socket.getSceneUserInfo.GetSceneUserInfoReq;
   import com.logic.socket.getSceneUserInfo.GetSceneUserRes;
   import com.logic.temp.switchAngle;
   import com.module.angelPark.data.AngelParkDataCtl;
   import com.module.angelPark.viewControl.ParkAuraToolBar;
   import com.module.angelPark.viewControl.ParkEffectCtl;
   import com.module.angelPark.viewControl.ParkLvlToolBar;
   import com.module.angelPark.viewControl.ParkManageToolBar;
   import com.module.angelPark.viewControl.ParkWarehouseToolBar;
   import com.module.changeClothsModule.prevView;
   import com.module.popupMsg.PopupMsgCtl;
   import com.mole.app.map.MapManager;
   import com.view.mapView.activity.creatShareObject;
   import com.view.noticeView.noticeView;
   import com.view.userPanelView.userPanelView;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class AngelParkView
   {
      
      private static var _instance:AngelParkView;
      
      public static var MapInitOk:String = "AngelParkView_MapInitOk";
      
      private static var _canotNew:Boolean = true;
      
      public static var isInMyPark:Boolean = false;
      
      private var _firstIntoPark:Boolean = false;
      
      private var _bgLoader:MCLoader;
      
      private var _parkAuraToolBar:ParkAuraToolBar;
      
      private var _parkDataCtl:AngelParkDataCtl;
      
      private var _parkLiveSourceAreaCtl:ParkLiveSourceAreaCtl;
      
      private var _parkEffectCtl:ParkEffectCtl;
      
      private var _parkLvlToolBar:ParkLvlToolBar;
      
      private var _parkManageToolBar:ParkManageToolBar;
      
      private var _ui:MovieClip;
      
      private var _angelMenuBtn:SimpleButton;
      
      private var _changeAngelBtn:SimpleButton;
      
      private var _backHomeBtn:SimpleButton;
      
      private var _angelSeedBtn:SimpleButton;
      
      private var _pigBtn:SimpleButton;
      
      private var _joinFightBtn:SimpleButton;
      
      private var _showAngelMC:MovieClip;
      
      private var _honerMC:MovieClip;
      
      private var _gotoNewAngelParkBtn:SimpleButton;
      
      private var _headMC:MovieClip;
      
      private var _useNameTxt:TextField;
      
      private var _angelMC:MovieClip;
      
      private var _showTimer:Timer;
      
      private var _getSeedNewMC:MovieClip;
      
      public function AngelParkView()
      {
         super();
         if(_canotNew)
         {
            throw new Error("AngelParkView不能直接new , 用靜態方法 instance()!");
         }
      }
      
      public static function get instance() : AngelParkView
      {
         if(!_instance)
         {
            _canotNew = false;
            _instance = new AngelParkView();
            _canotNew = true;
         }
         return _instance;
      }
      
      public function get parkEffectCtl() : ParkEffectCtl
      {
         return this._parkEffectCtl;
      }
      
      public function get userId() : Number
      {
         return this._parkDataCtl.angelParkVO.userId;
      }
      
      public function Init(ui:MovieClip, data:AngelParkVO) : void
      {
         this._parkEffectCtl = new ParkEffectCtl();
         this._firstIntoPark = true;
         this._ui = ui;
         noticeView.owner.GetUI().visible = false;
         this._parkDataCtl = new AngelParkDataCtl(data);
         isInMyPark = this._parkDataCtl.isMyPark;
         this._parkAuraToolBar = new ParkAuraToolBar(this._ui.UI.top_bar.auraBar_mc);
         this._parkLvlToolBar = new ParkLvlToolBar(this._ui.UI.top_bar.lvlBar_mc);
         this._parkManageToolBar = new ParkManageToolBar(this._ui.UI.manageBar_mc);
         this._headMC = this._ui.UI.top_bar.pic_mc;
         this._useNameTxt = this._ui.UI.top_bar.name_txt;
         if(this._parkDataCtl.isMyPark)
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
         var _temp_4:* = BC;
         var _temp_3:* = this;
         var _temp_2:* = this._parkDataCtl;
         var _temp_1:* = AngelParkDataCtl.CHANGE_BG_EVENT;
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function handler(e:Event):void
            {
               parkManageToolBar.ShowFeatureToolBar();
               parkManageToolBar.featureToolBar.HideWareHouseBar();
               LoadBG(_parkDataCtl.BG_id);
            });
            this.LoadBG(this._parkDataCtl.BG_id);
         }
         
         private function OpenUseInfoPanel(e:MouseEvent) : void
         {
            userPanelView.showUserPanel(this.userId);
         }
         
         private function onReadUserInfo(e:EventTaomee) : void
         {
            BC.removeEvent(this,GV.onlineSocket,GetSceneUserRes.GET_SCENE_INFO,this.onReadUserInfo);
            var userInfo:Object = e.EventObj;
            new prevView(this._headMC.mole,userInfo.Color.toString(16),userInfo.itemArr,userInfo);
            this._useNameTxt.text = userInfo.Nick;
         }
         
         public function LoadBG(bgId:int) : void
         {
            var bgPath:String = "resource/angelPark/items/swf/1353000.swf";
            this._bgLoader = new MCLoader(Links.getUrl(bgPath),MainManager.getAppLevel(),1,"正在加載天使園背景...");
            BC.addEvent(this,this._bgLoader,MCLoadEvent.ON_SUCCESS,this.onBGLoadOver);
            BC.addEvent(this,this._bgLoader,MCLoadEvent.ERROR,this.onBGLoadFail);
            this._bgLoader.load();
            this._parkDataCtl.StopUpdateTimer();
         }
         
         public function get parkAuraToolBar() : ParkAuraToolBar
         {
            return this._parkAuraToolBar;
         }
         
         public function get parkDataCtl() : AngelParkDataCtl
         {
            return this._parkDataCtl;
         }
         
         public function get parkLiveSourceAreaCtl() : ParkLiveSourceAreaCtl
         {
            return this._parkLiveSourceAreaCtl;
         }
         
         public function get parkLvlToolBar() : ParkLvlToolBar
         {
            return this._parkLvlToolBar;
         }
         
         public function get parkManageToolBar() : ParkManageToolBar
         {
            return this._parkManageToolBar;
         }
         
         private function ClearHandler(e:Event) : void
         {
            BC.removeEvent(this);
            this._parkAuraToolBar.Clear();
            this._parkDataCtl.Clear();
            this._parkLiveSourceAreaCtl.Clear();
            this._parkLvlToolBar.Clear();
            this._parkManageToolBar.Clear();
            this._parkEffectCtl.Clear();
            ParkDragCtl.StopDrag();
            isInMyPark = false;
            this._ui = null;
            _instance = null;
         }
         
         private function InitEvent() : void
         {
            BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.ClearHandler);
         }
         
         private function onBGLoadFail(e:MCLoadEvent) : void
         {
            throw new Error("加載天使園背景出錯");
         }
         
         private function onBGLoadOver(e:MCLoadEvent) : void
         {
            var bgMC:MovieClip;
            var app:ApplicationDomain;
            var composeBtn:*;
            var joinFightNewId:int;
            var bgIndex:int = 0;
            BC.removeEvent(this,this._bgLoader);
            bgMC = this._bgLoader.loader.content as MovieClip;
            app = this._bgLoader.loader.contentLoaderInfo.applicationDomain;
            this._bgLoader.clear();
            this._bgLoader = null;
            if(Boolean(this._parkLiveSourceAreaCtl))
            {
               GC.clearChildren(this._ui.bg_mc);
               GC.clearChildren(this._ui.control_mc);
               GC.clearChildren(this._ui.depth_mc);
               GC.clearChildren(this._ui.buttonLevel);
               GC.clearChildren(this._ui.type_mc);
               GC.clearChildren(this._ui.top_mc);
               this._parkLiveSourceAreaCtl.Clear();
               this._parkLiveSourceAreaCtl = null;
               this._angelMenuBtn = null;
               this._angelSeedBtn = null;
               this._pigBtn = null;
               this._changeAngelBtn = null;
               this._backHomeBtn = null;
               this._honerMC = null;
               this._gotoNewAngelParkBtn = null;
            }
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
               this._parkLiveSourceAreaCtl = new ParkLiveSourceAreaCtl(this._ui.buttonLevel);
               this._parkDataCtl.StartUpdateTimer();
               this._angelMenuBtn = this._ui.control_mc.angelMenu_btn;
               this._changeAngelBtn = this._ui.control_mc.changeAngel_btn;
               this._backHomeBtn = this._ui.control_mc.backHome_btn;
               this._angelSeedBtn = this._ui.control_mc.angelSeed_btn;
               this._pigBtn = this._ui.control_mc.pig_btn;
               this._joinFightBtn = this._ui.control_mc.joinFight_btn;
               this._gotoNewAngelParkBtn = this._ui.control_mc.newAngel_btn;
               this._showAngelMC = this._ui.control_mc.showAngel_mc;
               this._honerMC = this._ui.control_mc.honerEffect_mc;
               this._parkEffectCtl.InitHonerBtnEffect(this._honerMC);
               composeBtn = this._ui.buttonLevel.composeBtn;
               tip.tipTailDisPlayObject(composeBtn,"天使強化");
               tip.tipTailDisPlayObject(this._angelMenuBtn,"進入天使聖殿");
               tip.tipTailDisPlayObject(this._changeAngelBtn,"蛻變為天使");
               tip.tipTailDisPlayObject(this._backHomeBtn,"返回家園");
               tip.tipTailDisPlayObject(this._joinFightBtn,"參加天使之戰");
               tip.tipTailDisPlayObject(this._angelSeedBtn,"拯救天使種子");
               tip.tipTailDisPlayObject(this._pigBtn,"去肥肥館");
               tip.tipTailDisPlayObject(this._gotoNewAngelParkBtn,"去新天使園");
               joinFightNewId = int(XMLInfo.WeeklyUpdateXML["angelParkGetSeed"].id);
               if(joinFightNewId != creatShareObject.getInstance().getShareObject().data.angelParkGetSeed)
               {
                  this._getSeedNewMC = GV.Lib_Map.getMovieClip("new_mc") as MovieClip;
                  this._getSeedNewMC.x = this._angelSeedBtn.x;
                  this._getSeedNewMC.y = this._angelSeedBtn.y;
                  this._ui.buttonLevel.addChild(this._getSeedNewMC);
               }
               BC.addEvent(this,this._angelMenuBtn,MouseEvent.CLICK,this.OpenAngelMenuPanel);
               BC.addEvent(this,this._changeAngelBtn,MouseEvent.CLICK,this.StartChangeAngel);
               BC.addEvent(this,this._backHomeBtn,MouseEvent.CLICK,this.BackHomeHandler);
               BC.addEvent(this,this._angelSeedBtn,MouseEvent.CLICK,this.AngelSeedBtnHandler);
               BC.addEvent(this,this._joinFightBtn,MouseEvent.CLICK,this.JoinFightBtnHandler);
               BC.addEvent(this,this._pigBtn,MouseEvent.CLICK,this.GoPigHouse);
               BC.addEvent(this,this._gotoNewAngelParkBtn,MouseEvent.CLICK,this.gotoNewAngelPark);
               this._showAngelMC.buttonMode = true;
               BC.addEvent(this,this._showAngelMC.btn_mc,MouseEvent.MOUSE_OVER,this.OnMouseOver);
               BC.addEvent(this,this._showAngelMC.btn_mc,MouseEvent.MOUSE_OUT,this.OnMouseOut);
               BC.addEvent(this,this._showAngelMC,MouseEvent.CLICK,this.OpenAngelCollectionPanel);
               BC.addEvent(this,this._honerMC,MouseEvent.CLICK,this.OpenHonerPanel);
               BC.addEvent(this,composeBtn,MouseEvent.CLICK,this.onLoaderCompose);
               BC.addEvent(this,GV.onlineSocket,"UpdateShowAngelEvent",this.InitShowAngel);
               this.InitShowAngel();
               BC.addEvent(this,PeopleCountLogic.owner,PeopleCountLogic.onAddChildPeopleOver,this.PeopleInitOver);
               TopicMusicManager.instance.playSound(10001);
            }
            
            private function GoPigHouse(e:MouseEvent) : void
            {
               GF.switchToPigHouse(this.userId);
            }
            
            private function gotoNewAngelPark(e:MouseEvent) : void
            {
               GF.switchMap(LocalUserInfo.getUserID(),false,37);
            }
            
            private function onLoaderCompose(e:MouseEvent) : void
            {
               ParkExtenalModelCtl.OpenCombinePanel();
            }
            
            private function PeopleInitOver(e:Event) : void
            {
               BC.removeEvent(this,PeopleCountLogic.owner,PeopleCountLogic.onAddChildPeopleOver,this.PeopleInitOver);
               this._parkDataCtl.ReSetMolePoint();
               if(this._firstIntoPark)
               {
                  this.InitOver();
                  this._firstIntoPark = false;
               }
               else
               {
                  this.parkManageToolBar.featureToolBar.ShowWareHouseKinds(ParkWarehouseToolBar.KIND_BG);
                  this._parkDataCtl.HidePeople();
               }
               if(this._parkDataCtl.isMyPark)
               {
               }
            }
            
            private function InitOver() : void
            {
               if(this._parkDataCtl.isMyPark)
               {
                  if(this._parkDataCtl.angelParkVO.aura < 100)
                  {
                     PopupMsgCtl.PopupMsg("你的靈氣值過低，天使會停止生長哦！",5000,3000);
                  }
               }
            }
            
            private function InitShowAngel(e:Event = null) : void
            {
               var loader:Loader = null;
               var path:String = null;
               var angelId:int = this._parkDataCtl.angelParkVO.showAngelId;
               GC.clearAllChildren(this._showAngelMC.content_mc);
               tip.delTipTailDisPlayObject(this._showAngelMC);
               if(angelId == 0)
               {
                  tip.tipTailDisPlayObject(this._showAngelMC,"天使收藏家");
                  this._showAngelMC.gotoAndStop(1);
               }
               else
               {
                  loader = new Loader();
                  loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.OnAngelLoadOver);
                  path = "resource/angelPark/items/swf/" + angelId + "_2.swf";
                  loader.load(VL.getURLRequest(path));
                  this._showAngelMC.gotoAndStop(2);
               }
            }
            
            private function OnAngelLoadOver(e:Event) : void
            {
               var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
               loaderInfo.removeEventListener(Event.COMPLETE,this.OnAngelLoadOver);
               this._angelMC = loaderInfo.content as MovieClip;
               this._angelMC.scaleX = this._angelMC.scaleY = 0.6;
               this._showAngelMC.content_mc.addChild(this._angelMC);
            }
            
            private function OnMouseOver(e:MouseEvent) : void
            {
               if(Boolean(this._showTimer))
               {
                  this._showTimer.stop();
               }
               this._showTimer = new Timer(400,1);
               BC.addEvent(this,this._showTimer,TimerEvent.TIMER_COMPLETE,this.OnTimerComplete);
               this._showTimer.start();
            }
            
            private function OnTimerComplete(e:TimerEvent) : void
            {
               if(Boolean(this._showTimer))
               {
                  this._showTimer.stop();
                  this._showTimer = null;
               }
               if(Boolean(this._angelMC))
               {
                  this._angelMC.gotoAndStop(2);
               }
            }
            
            private function OnMouseOut(e:MouseEvent) : void
            {
               if(Boolean(this._showTimer))
               {
                  this._showTimer.stop();
                  this._showTimer = null;
               }
               if(Boolean(this._angelMC))
               {
                  this._angelMC.gotoAndStop(1);
               }
            }
            
            private function JoinFightBtnHandler(e:MouseEvent) : void
            {
               GV.Room_DefaultRoomID = 0;
               EnterMapOrRoomReq.OldMapID = EnterMapOrRoomReq.OldMapType = 0;
               GF.switchMap(179);
            }
            
            private function AngelSeedBtnHandler(e:MouseEvent) : void
            {
               var joinFightNewId:int = 0;
               GV.Room_DefaultRoomID = 0;
               MapManager.enterMap(178);
               if(Boolean(this._getSeedNewMC))
               {
                  joinFightNewId = int(XMLInfo.WeeklyUpdateXML["angelParkGetSeed"].id);
                  creatShareObject.getInstance().getShareObject().data.angelParkGetSeed = joinFightNewId;
                  GC.clearAll(this._getSeedNewMC);
                  this._getSeedNewMC = null;
               }
            }
            
            private function BackHomeHandler(e:MouseEvent) : void
            {
               GV.Room_DefaultRoomID = GV.MyInfo_userID + GV.TwentyBillion;
               GF.switchMap(this._parkDataCtl.angelParkVO.userId + GV.TwentyBillion);
            }
            
            private function StartChangeAngel(e:MouseEvent) : void
            {
               if(this._parkDataCtl.isMyPark)
               {
                  switchAngle.instance.init();
               }
               else
               {
                  Alert.smileAlart("    只能在自己的天使園裡蛻變為天使哦。");
               }
            }
            
            private function OpenAngelMenuPanel(e:MouseEvent) : void
            {
               ParkExtenalModelCtl.OpenAngelParkMenu();
            }
            
            private function OpenAngelCollectionPanel(e:MouseEvent) : void
            {
               ParkExtenalModelCtl.OpenAngelCollectionPanel();
            }
            
            private function OpenHonerPanel(e:MouseEvent) : void
            {
               ParkExtenalModelCtl.OpenHonorPanel();
            }
         }
      }
      
      