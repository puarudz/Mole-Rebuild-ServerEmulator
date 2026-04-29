package com.view.mapView.activity.mapActivity.elaineParty
{
   import com.logic.socket.elaineParty.ElainePartySocket;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class PartyInfoView extends BasePartyView
   {
      
      private var _moleCount:TextField;
      
      private var _itemCount:TextField;
      
      private var _moneyCount:TextField;
      
      public function PartyInfoView(ui:MovieClip)
      {
         super(ui);
         this._closeBtn = this._ui["close_btn"];
         this._moleCount = this._ui["moleCount_txt"];
         this._itemCount = this._ui["itemCount_txt"];
         this._moneyCount = this._ui["moneyCount_txt"];
      }
      
      override protected function Init() : void
      {
         super.Init();
         PartyCommonControler.instance.RegisterPartyInfoObserver(this.PartyInfoUpdate);
         ElainePartySocket.CharityDonateInfo();
      }
      
      override protected function CloseBtnHandler(e:MouseEvent = null) : void
      {
         PartyCommonControler.instance.UnRegisterPartyInfoObserver(this.PartyInfoUpdate);
         super.CloseBtnHandler(e);
      }
      
      private function PartyInfoUpdate(userCount:int, moneyCount:int, itemCount:int) : void
      {
         this._moleCount.text = userCount.toString();
         this._itemCount.text = itemCount.toString();
         this._moneyCount.text = moneyCount.toString() + " 萬";
      }
   }
}

