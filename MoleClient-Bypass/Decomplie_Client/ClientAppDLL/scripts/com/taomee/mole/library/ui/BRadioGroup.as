package com.taomee.mole.library.ui
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class BRadioGroup extends EventDispatcher
   {
      
      public static const RADIO_SELECT:String = "BRadioGroup_Select";
      
      private var _radioList:Array;
      
      private var _curValue:int = -1;
      
      public function BRadioGroup(radioList:Array)
      {
         var radio_mc:MovieClip = null;
         super();
         this._radioList = radioList;
         for each(radio_mc in this._radioList)
         {
            radio_mc.gotoAndStop(1);
            radio_mc.buttonMode = true;
            radio_mc.addEventListener(MouseEvent.CLICK,this.onSelectRadio);
         }
      }
      
      private function onSelectRadio(e:MouseEvent) : void
      {
         var radio_mc:MovieClip = e.currentTarget as MovieClip;
         this._curValue = this._radioList.indexOf(radio_mc);
         this.resetRadio();
         radio_mc.gotoAndStop(2);
         dispatchEvent(new Event(RADIO_SELECT));
      }
      
      private function resetRadio() : void
      {
         var radio_mc:MovieClip = null;
         for each(radio_mc in this._radioList)
         {
            radio_mc.gotoAndStop(1);
         }
      }
      
      public function get curValue() : int
      {
         return this._curValue;
      }
      
      public function set curValue(value:int) : void
      {
         this._curValue = value;
         this.resetRadio();
         var radio_mc:MovieClip = this._radioList[this._curValue];
         if(Boolean(radio_mc))
         {
            radio_mc.gotoAndStop(2);
         }
      }
      
      public function set enabled(value:Boolean) : void
      {
         var radio_mc:MovieClip = null;
         for each(radio_mc in this._radioList)
         {
            radio_mc.mouseChildren = radio_mc.mouseEnabled = value;
         }
      }
      
      public function destroy() : void
      {
         var radio_mc:MovieClip = null;
         for each(radio_mc in this._radioList)
         {
            radio_mc.removeEventListener(MouseEvent.CLICK,this.onSelectRadio);
         }
         this._radioList = null;
      }
   }
}

