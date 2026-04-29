package com.view.mapView.activity.mapActivity.elaineParty
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class BasePartyView
   {
      
      protected var _ui:MovieClip;
      
      protected var _closeBtn:SimpleButton;
      
      public function BasePartyView(ui:MovieClip)
      {
         super();
         this._ui = ui;
      }
      
      public function GetUI() : MovieClip
      {
         this.Init();
         return this._ui;
      }
      
      protected function Init() : void
      {
         BC.addEvent(this,this._closeBtn,MouseEvent.CLICK,this.CloseBtnHandler);
      }
      
      protected function CloseBtnHandler(e:MouseEvent = null) : void
      {
         BC.removeEvent(this);
         try
         {
            this._ui.parent.removeChild(this._ui);
         }
         catch(e:Error)
         {
         }
      }
   }
}

