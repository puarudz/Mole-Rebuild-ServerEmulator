package com.mole.app.utils
{
   import com.common.util.MovieClipUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class SceneInteraction
   {
      
      private var _mc:MovieClip;
      
      private var _isLoop:Boolean;
      
      public function SceneInteraction(mc:MovieClip, isLoop:Boolean = true)
      {
         super();
         this._mc = mc;
         this._isLoop = isLoop;
         this._mc.buttonMode = true;
         if(this._mc.numChildren > 1)
         {
            this._mc.mouseChildren = false;
         }
         this._mc.addEventListener(MouseEvent.CLICK,this.onNext);
      }
      
      private function onNext(e:MouseEvent) : void
      {
         var tarFrame:int = 0;
         tarFrame = this._mc.currentFrame + 1;
         MovieClipUtil.playAppointFrameAndFunc(this._mc,tarFrame,function():void
         {
            var i:uint;
            var sub_mc:MovieClip = null;
            for(i = 0; i < _mc.numChildren; i++)
            {
               sub_mc = _mc.getChildAt(i) as MovieClip;
               if(Boolean(sub_mc))
               {
                  MovieClipUtil.playEndAndFunc(sub_mc,function():void
                  {
                     if(tarFrame == _mc.totalFrames)
                     {
                        if(_isLoop)
                        {
                           _mc.gotoAndStop(1);
                        }
                        else
                        {
                           _mc.mouseChildren = _mc.mouseEnabled = false;
                           sub_mc.stop();
                        }
                     }
                  });
                  break;
               }
            }
         });
      }
      
      public function destroy() : void
      {
         this._mc.removeEventListener(MouseEvent.CLICK,this.onNext);
      }
   }
}

