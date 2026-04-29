package org.taomee.player
{
   import flash.display.Bitmap;
   import org.taomee.player.data.FrameInfo;
   
   public class BitmapPlayer extends TimePlayer
   {
      
      private var _sheets:Vector.<FrameInfo>;
      
      private var _bitmap:Bitmap;
      
      private var _frameInfo:FrameInfo;
      
      public function BitmapPlayer(bitmap:Bitmap = null, timeRate:uint = 40)
      {
         super(timeRate);
         this._bitmap = bitmap;
      }
      
      public function get bitmap() : Bitmap
      {
         if(this._bitmap == null)
         {
            this._bitmap = new Bitmap();
         }
         return this._bitmap;
      }
      
      public function set bitmap(bm:Bitmap) : void
      {
         this._bitmap = bm;
      }
      
      public function setSheets(value:Vector.<FrameInfo>, isReset:Boolean = true) : void
      {
         if(isReset)
         {
            reset();
         }
         if(value == null)
         {
            reset();
            if(Boolean(this._bitmap))
            {
               this._bitmap.bitmapData = null;
            }
            this._sheets = null;
            return;
         }
         this._sheets = value;
         _totalFrames = this._sheets.length;
         parseTotalTime();
         this.update();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bitmap))
         {
            this._bitmap.bitmapData = null;
         }
         this._frameInfo = null;
         this._bitmap = null;
         this._sheets = null;
      }
      
      override protected function update() : void
      {
         if(Boolean(this._bitmap) && Boolean(this._sheets))
         {
            this._frameInfo = this._sheets[_currentFrame];
            if(this._frameInfo != null)
            {
               if(this._bitmap.bitmapData != this._frameInfo.data)
               {
                  this._bitmap.bitmapData = this._frameInfo.data;
               }
               this._bitmap.x = this._frameInfo.x;
               this._bitmap.y = this._frameInfo.y;
            }
         }
      }
   }
}

