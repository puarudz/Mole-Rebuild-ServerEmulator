package com.view.mapView.activity.mapActivity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.module.LocusWork.NumSprite;
   import com.view.mapView.activity.mapActivity.elaineParty.CharityMessageView;
   import com.view.mapView.activity.mapActivity.elaineParty.DonateItemView;
   import com.view.mapView.activity.mapActivity.elaineParty.DonateView;
   import com.view.mapView.activity.mapActivity.elaineParty.GuessPartyInfoView;
   import com.view.mapView.activity.mapActivity.elaineParty.GuessPartyView;
   import com.view.mapView.activity.mapActivity.elaineParty.PartyCommonControler;
   import com.view.mapView.activity.mapActivity.elaineParty.PartyInfoView;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class ElaineCharityPartyActivity
   {
      
      private static var _instance:ElaineCharityPartyActivity;
      
      public static const ELAINE_CHARITY_PARTY_INIT_OK:String = "ELAINE_CHARITY_PARTY_INIT_OK";
      
      public var _app:ApplicationDomain;
      
      private var _ui:MovieClip;
      
      private var _donateView:DonateView;
      
      private var _donateItemView:DonateItemView;
      
      private var _charityMsgView:CharityMessageView;
      
      private var _guessPartyInfoView:GuessPartyInfoView;
      
      private var _guessPartyView:GuessPartyView;
      
      private var _partyInfoView:PartyInfoView;
      
      private var _sceneUI:MovieClip;
      
      private var _partyInfoMC:SimpleButton;
      
      private var _donateMC:SimpleButton;
      
      private var _sendMsgMC:SimpleButton;
      
      private var _guessInfoMC:SimpleButton;
      
      private var _guessTimeMC:NumSprite;
      
      private var _guessItemMC:MovieClip;
      
      public function ElaineCharityPartyActivity()
      {
         super();
      }
      
      public static function get instance() : ElaineCharityPartyActivity
      {
         if(_instance == null)
         {
            _instance = new ElaineCharityPartyActivity();
         }
         return _instance;
      }
      
      public function get charityMsgView() : CharityMessageView
      {
         return this._charityMsgView;
      }
      
      public function Init(sceneUI:MovieClip) : void
      {
         PartyCommonControler.instance.Init();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this._sceneUI = sceneUI;
         this._donateMC = this._sceneUI["donate_mc"];
         tip.tipTailDisPlayObject(this._donateMC,"為慈善基金捐款");
         BC.addEvent(this,this._donateMC,MouseEvent.CLICK,this.OpenDonateViewHandler);
         this.InitObserver();
         this.InitUI();
      }
      
      public function InitUI() : void
      {
         var uiUrl:String = null;
         var loader:Loader = null;
         if(this._ui == null)
         {
            uiUrl = "resource/task/ElaineParty.swf";
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.LoadUIComplete);
            loader.load(new URLRequest(uiUrl));
         }
         else
         {
            this.InitOK();
         }
      }
      
      private function LoadUIComplete(e:Event) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         loaderInfo.removeEventListener(Event.COMPLETE,this.LoadUIComplete);
         this._app = loaderInfo.applicationDomain;
         this._ui = loaderInfo.content as MovieClip;
         this._donateView = new DonateView(this._ui["donate_mc"]);
         this._donateItemView = new DonateItemView(this._ui["donateItem_mc"]);
         this._guessPartyInfoView = new GuessPartyInfoView(this._ui["guessInfo_mc"]);
         this._guessPartyView = new GuessPartyView(this._ui["guess_mc"]);
         this._partyInfoView = new PartyInfoView(this._ui["partyInfo_mc"]);
         this._charityMsgView = new CharityMessageView(this._ui["msg_mc"]);
         this.InitOK();
      }
      
      private function InitOK() : void
      {
         BC.addEvent(this,GV.onlineSocket,"move_for_game",this.MoveToGameEnded);
         GV.onlineSocket.dispatchEvent(new Event(ELAINE_CHARITY_PARTY_INIT_OK));
      }
      
      private function MoveToGameEnded(e:Event) : void
      {
         var elaineMCUrl:String = null;
         var msg:String = null;
         if(PartyCommonControler.instance.guessGameState == PartyCommonControler.GUESS_GAME_STSTE_RUNING)
         {
            MainManager.getAppLevel().addChild(this._guessPartyView.GetUI());
         }
         else
         {
            elaineMCUrl = "resource/allJob/AlertPic/elaine.swf";
            if(PartyCommonControler.instance.guessGameState == PartyCommonControler.GUESS_GAME_STSTE_NOT_OPEN)
            {
               msg = "     親愛的小摩爾，這裡是莊園第一屆慈善競猜會！不過，競猜會現在還沒開始哦，等到晚上6點-8點再過來看看吧！";
            }
            else if(PartyCommonControler.instance.guessGameState == PartyCommonControler.GUESS_GAME_STSTE_END)
            {
               msg = "     親愛的小摩爾，這裡是莊園第一屆慈善競猜會！上一輪競猜已經結束，請耐心等待下一輪競猜開始。";
            }
            Alert.showAlert(MainManager.getAppLevel(),elaineMCUrl,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
         }
      }
      
      private function OpenDonateViewHandler(e:MouseEvent) : void
      {
         MainManager.getAppLevel().addChild(this._donateView.GetUI());
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this);
         this.ClearObserver();
         PartyCommonControler.instance.Clear();
      }
      
      private function InitObserver() : void
      {
         PartyCommonControler.instance.RegisterGuessStateObserver(this.GuessGameStateObserver);
         PartyCommonControler.instance.RegisterGuessTimerObserver(this.GuessTimerObserver);
      }
      
      private function ClearObserver() : void
      {
         PartyCommonControler.instance.UnRegisterGuessStateObserver(this.GuessGameStateObserver);
         PartyCommonControler.instance.UnRegisterGuessTimerObserver(this.GuessTimerObserver);
      }
      
      private function GuessTimerObserver(value:int) : void
      {
         this._guessTimeMC.value = value;
      }
      
      private function GuessGameStateObserver(state:int, item:int, count:int) : void
      {
         var loader:Loader = null;
         var path:String = null;
         var name:String = null;
         if(state == PartyCommonControler.GUESS_GAME_STSTE_RUNING)
         {
            try
            {
               this._guessItemMC.removeChildAt(0);
            }
            catch(e:Error)
            {
            }
            this._guessTimeMC.content.visible = true;
            loader = new Loader();
            path = GoodsInfo.GetFullURLByItemId(item);
            name = GoodsInfo.getItemNameByID(item);
            tip.tipTailDisPlayObject(loader,name + ": " + count + "個");
            loader.load(new URLRequest(path));
            this._guessItemMC.addChild(loader);
         }
         else if(state == PartyCommonControler.GUESS_GAME_STSTE_NOT_OPEN || state == PartyCommonControler.GUESS_GAME_STSTE_END)
         {
            try
            {
               this._guessItemMC.removeChildAt(0);
            }
            catch(e:Error)
            {
            }
            this._guessTimeMC.content.visible = false;
         }
      }
   }
}

