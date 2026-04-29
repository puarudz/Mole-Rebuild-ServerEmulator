package org.taomee.player
{
   import flash.display.Bitmap;
   import flash.events.Event;
   import org.taomee.player.data.FrameInfo;
   
   [Event(name="open",type="flash.events.Event")]
   [Event(name="complete",type="flash.events.Event")]
   public class FramePlayer extends Bitmap implements IFramePlayer
   {
      
      protected var _totalFrames:uint = 0;
      
      protected var _currentFrame:uint = 0;
      
      protected var _isPlaying:Boolean = true;
      
      protected var _sheets:Vector.<FrameInfo>;
      
      private var _frameInfo:FrameInfo;
      
      public function FramePlayer()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.clear();
      }
      
      public function clear() : void
      {
         this._isPlaying = false;
         this._totalFrames = 0;
         this._currentFrame = 0;
         this._sheets = null;
         this._frameInfo = null;
         bitmapData = null;
      }
      
      public function setSheets(value:Vector.<FrameInfo>, isReset:Boolean = true) : void
      {
         if(isReset)
         {
            this._currentFrame = 0;
         }
         if(value == null)
         {
            this.clear();
            return;
         }
         this._sheets = value;
         this._totalFrames = this._sheets.length;
         if(value.length == 0)
         {
            this._isPlaying = false;
            this._currentFrame = 0;
            this._sheets = null;
            this._frameInfo = null;
            bitmapData = null;
         }
         else
         {
            if(this._currentFrame >= this._totalFrames)
            {
               this._currentFrame = this._totalFrames - 1;
            }
            this.updateFrame();
         }
         dispatchEvent(new Event(Event.OPEN));
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function get totalFrames() : uint
      {
         return this._totalFrames;
      }
      
      public function get currentFrame() : uint
      {
         return this._currentFrame;
      }
      
      public function set currentFrame(value:uint) : void
      {
         if(value == this._currentFrame)
         {
            return;
         }
         if(value >= this._totalFrames)
         {
            value = this._totalFrames - 1;
         }
         if(this._totalFrames <= 1)
         {
            this._isPlaying = false;
         }
         this._currentFrame = value;
         this.updateFrame();
      }
      
      public function play() : void
      {
         this.gotoAndPlay(this._currentFrame);
      }
      
      public function stop() : void
      {
         this.gotoAndStop(this._currentFrame);
      }
      
      public function gotoAndPlay(frame:uint) : void
      {
         if(this._totalFrames > 1)
         {
            this._isPlaying = true;
            this.currentFrame = frame;
         }
      }
      
      public function gotoAndStop(frame:uint) : void
      {
         this._isPlaying = false;
         if(this._totalFrames > 1)
         {
            this.currentFrame = frame;
         }
      }
      
      public function nextFrame() : void
      {
         if(this._totalFrames > 1)
         {
            this.updateNextFrame();
            this.updateFrame();
         }
      }
      
      public function prevFrame() : void
      {
         if(this._totalFrames > 1)
         {
            --this._currentFrame;
            if(this._currentFrame < 0)
            {
               dispatchEvent(new Event(Event.COMPLETE));
               this._currentFrame = this._totalFrames - 1;
            }
            this.updateFrame();
         }
      }
      
      public function render() : void
      {
         if(this._isPlaying)
         {
            this.updateNextFrame();
            this.updateFrame();
         }
      }
      
      private function updateNextFrame() : void
      {
         ++this._currentFrame;
         if(this._currentFrame >= this._totalFrames)
         {
            this._currentFrame = 0;
         }
         else if(this._currentFrame >= this._totalFrames - 1)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function updateFrame() : void
      {
         if(this._sheets != null)
         {
            this._frameInfo = this._sheets[this._currentFrame];
            if(this._frameInfo != null)
            {
               if(bitmapData != this._frameInfo.data)
               {
                  bitmapData = this._frameInfo.data;
               }
               x = this._frameInfo.x;
               y = this._frameInfo.y;
            }
         }
      }
   }
}

