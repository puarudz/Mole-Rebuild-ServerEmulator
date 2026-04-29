package com.taomee.mole.library.ui
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BookUI
   {
      
      private var _close_btn:SimpleButton;
      
      private var _prev_btn:SimpleButton;
      
      private var _next_btn:SimpleButton;
      
      private var _ui:Sprite;
      
      public function BookUI(ui:Sprite)
      {
         super();
         this._ui = ui;
         this.initUI();
      }
      
      private function initUI() : void
      {
         if(Boolean(this._ui.getChildByName("next_btn")))
         {
            BC.addEvent(this,this._ui["next_btn"],MouseEvent.CLICK,this.onClickNext);
         }
         if(Boolean(this._ui.getChildByName("prev_btn")))
         {
            BC.addEvent(this,this._ui["prev_btn"],MouseEvent.CLICK,this.onClickPrev);
         }
         if(Boolean(this._ui.getChildByName("close_btn")))
         {
            BC.addEvent(this,this._ui["close_btn"],MouseEvent.CLICK,this.clearAll);
         }
         if(Boolean(this._ui.getChildByName("prevclose_btn")))
         {
            BC.addEvent(this,this._ui["prevclose_btn"],MouseEvent.CLICK,this.onClickPrevPrev);
         }
         if(Boolean(this._ui.getChildByName("overclose_btn")))
         {
            BC.addEvent(this,this._ui["overclose_btn"],MouseEvent.CLICK,this.onClickNextNext);
         }
      }
      
      private function onClickPrevPrev(e:Event) : void
      {
         this._ui.visible = false;
         GV.onlineSocket.dispatchEvent(new Event("guandiao"));
      }
      
      private function onClickNextNext(e:Event) : void
      {
         this._ui.visible = false;
         GV.onlineSocket.dispatchEvent(new Event("guandiao"));
      }
      
      private function clearAll(e:Event) : void
      {
         this._ui.parent.removeChild(this._ui);
      }
      
      private function onClickNext(e:Event) : void
      {
         BC.removeEvent(this,this._ui["next_btn"],MouseEvent.CLICK,this.onClickNext);
         (this._ui as MovieClip).nextFrame();
         this.initUI();
      }
      
      private function onClickPrev(e:Event) : void
      {
         BC.removeEvent(this,this._ui["prev_btn"],MouseEvent.CLICK,this.onClickPrev);
         (this._ui as MovieClip).prevFrame();
         this.initUI();
      }
   }
}

