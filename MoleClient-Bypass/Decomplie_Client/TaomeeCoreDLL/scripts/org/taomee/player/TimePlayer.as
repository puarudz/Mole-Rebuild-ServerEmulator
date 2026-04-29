package org.taomee.player
{
   public class TimePlayer
   {
      
      protected var _repeatCount:uint;
      
      protected var _totalFrames:uint;
      
      protected var _currentFrame:uint;
      
      protected var _time:uint;
      
      protected var _position:Number = 0;
      
      protected var _timeRate:uint = 40;
      
      protected var _duration:uint;
      
      protected var _totalTime:uint;
      
      public function TimePlayer(timeRate:uint = 40)
      {
         super();
         this._timeRate = timeRate;
      }
      
      public function reset() : void
      {
         this._currentFrame = 0;
         this._time = 0;
         this._position = 0;
      }
      
      public function get totalFrames() : uint
      {
         return this._totalFrames;
      }
      
      public function get currentFrame() : uint
      {
         return this._currentFrame;
      }
      
      public function get time() : uint
      {
         return this._time;
      }
      
      public function get position() : Number
      {
         return this._position;
      }
      
      public function get duration() : uint
      {
         return this._duration;
      }
      
      public function get repeatCount() : uint
      {
         return this._repeatCount;
      }
      
      public function get timeRate() : uint
      {
         return this._timeRate;
      }
      
      public function set timeRate(value:uint) : void
      {
         this._timeRate = value;
         this.parseTotalTime();
      }
      
      public function set duration(value:uint) : void
      {
         this._duration = value;
         this.parseTotalTime();
      }
      
      public function set repeatCount(value:uint) : void
      {
         this._repeatCount = value;
         this.parseTotalTime();
      }
      
      public function set currentFrame(value:uint) : void
      {
         if(this._currentFrame == value)
         {
            return;
         }
         this._currentFrame = value;
         if(this._totalFrames > 0)
         {
            if(this._currentFrame >= this._totalFrames)
            {
               this._currentFrame = this._totalFrames - 1;
            }
            this.update();
         }
      }
      
      public function render(interval:uint) : Boolean
      {
         this._time += interval;
         return this.setTime(this._time);
      }
      
      public function setTime(value:uint) : Boolean
      {
         this._time = value;
         if(this._duration > 0)
         {
            if(this._time >= this._duration)
            {
               this._position = 1;
               return true;
            }
            this._position = this._time / this._duration;
         }
         else if(this._totalTime > 0)
         {
            if(this._repeatCount > 0)
            {
               if(this._time >= this._totalTime)
               {
                  this._position = 1;
                  return true;
               }
            }
            this._position = this._time / this._totalTime;
         }
         this.parseCurrentFrame();
         return false;
      }
      
      public function set position(value:Number) : void
      {
         if(value > 1)
         {
            value = 1;
         }
         else if(value < 0)
         {
            value = 0;
         }
         this._position = value;
         if(this._duration > 0)
         {
            this._time = this._position * this._duration;
            this.parseCurrentFrame();
         }
         else if(this._totalTime > 0)
         {
            this._time = this._position * this._totalTime;
            this.parseCurrentFrame();
         }
      }
      
      protected function parseTotalTime() : void
      {
         if(this._duration > 0)
         {
            if(this._repeatCount > 0)
            {
               this._totalTime = this._duration / this._repeatCount;
            }
            else
            {
               this._totalTime = this._totalFrames * this._timeRate;
            }
         }
         else if(this._totalFrames > 0)
         {
            this._totalTime = this._totalFrames * this._timeRate;
         }
      }
      
      protected function parseCurrentFrame() : void
      {
         var frame:uint = 0;
         if(this._totalFrames > 0)
         {
            frame = Math.round(this._time % this._totalTime / this._totalTime * this._totalFrames);
            if(frame >= this._totalFrames)
            {
               frame = this._totalFrames - 1;
            }
            if(this._currentFrame == frame)
            {
               return;
            }
            this._currentFrame = frame;
            this.update();
         }
      }
      
      public function nextFrame() : void
      {
         if(this._totalFrames > 1)
         {
            ++this.currentFrame;
            if(this._currentFrame == this._totalFrames)
            {
               this.currentFrame = 0;
            }
         }
      }
      
      public function prevFrame() : void
      {
         if(this._totalFrames > 1)
         {
            --this.currentFrame;
            if(this._currentFrame < 0)
            {
               this.currentFrame = this._totalFrames - 1;
            }
         }
      }
      
      protected function update() : void
      {
      }
   }
}

