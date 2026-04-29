package com.mole.app.utils
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MovieClipFromButton
   {
      
      private var _btn:DisplayObject;
      
      private var _mc:MovieClip;
      
      public function MovieClipFromButton(btn:DisplayObject, mc:MovieClip)
      {
         super();
         this._btn = btn;
         if(this._btn.hasOwnProperty("mouseChildren"))
         {
            this._btn["mouseChildren"] = false;
         }
         this._mc = mc;
         this._mc.gotoAndStop(1);
         this._btn.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this._btn.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      private function onOver(e:MouseEvent) : void
      {
         this._mc.gotoAndStop(2);
      }
      
      private function onOut(e:MouseEvent) : void
      {
         this._mc.gotoAndStop(1);
      }
      
      public function destroy() : void
      {
         this._btn.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this._btn.removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
   }
}

