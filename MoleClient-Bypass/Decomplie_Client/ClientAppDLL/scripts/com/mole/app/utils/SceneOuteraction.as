package com.mole.app.utils
{
   import com.common.util.MovieClipUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class SceneOuteraction
   {
      
      private var _mc:MovieClip;
      
      private var _isLoop:Boolean;
      
      public function SceneOuteraction(mc:MovieClip, isLoop:Boolean = true)
      {
         super();
         this._mc = mc;
         this._isLoop = isLoop;
         this._mc.buttonMode = true;
         this._mc.addEventListener(MouseEvent.CLICK,this.onNext);
      }
      
      private function onNext(e:MouseEvent) : void
      {
         if(this._mc.currentFrame == 1)
         {
            this._mc.gotoAndPlay(2);
            MovieClipUtil.playEndAndFunc(this._mc,function():void
            {
               _mc.gotoAndStop(1);
            });
         }
      }
      
      public function destroy() : void
      {
         this._mc.removeEventListener(MouseEvent.CLICK,this.onNext);
      }
   }
}

