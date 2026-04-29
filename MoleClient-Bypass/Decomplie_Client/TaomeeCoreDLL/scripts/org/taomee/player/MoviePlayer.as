package org.taomee.player
{
   import flash.display.MovieClip;
   
   public class MoviePlayer extends TimePlayer
   {
      
      private var _mc:MovieClip;
      
      public function MoviePlayer(mc:MovieClip = null, timeRate:uint = 40)
      {
         super(timeRate);
         if(mc != null)
         {
            this.movie = mc;
         }
      }
      
      public function set movie(value:MovieClip) : void
      {
         reset();
         this._mc = value;
         _totalFrames = this._mc.totalFrames;
         parseTotalTime();
         this.update();
      }
      
      public function get movie() : MovieClip
      {
         return this._mc;
      }
      
      public function dispose() : void
      {
         this._mc = null;
      }
      
      override protected function update() : void
      {
         if(Boolean(this._mc))
         {
            this._mc.gotoAndStop(_currentFrame + 1);
         }
      }
   }
}

