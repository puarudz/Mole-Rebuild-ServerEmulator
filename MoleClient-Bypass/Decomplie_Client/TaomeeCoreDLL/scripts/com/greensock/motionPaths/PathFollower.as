package com.greensock.motionPaths
{
   public class PathFollower
   {
      
      public var target:Object;
      
      public var cachedProgress:Number;
      
      public var cachedRawProgress:Number;
      
      public var cachedNext:PathFollower;
      
      public var cachedPrev:PathFollower;
      
      public var path:MotionPath;
      
      public var autoRotate:Boolean;
      
      public var rotationOffset:Number;
      
      public function PathFollower(target:Object, autoRotate:Boolean = false, rotationOffset:Number = 0)
      {
         super();
         this.target = target;
         this.autoRotate = autoRotate;
         this.rotationOffset = rotationOffset;
         this.cachedProgress = this.cachedRawProgress = 0;
      }
      
      public function get rawProgress() : Number
      {
         return this.cachedRawProgress;
      }
      
      public function set rawProgress(value:Number) : void
      {
         this.progress = value;
      }
      
      public function get progress() : Number
      {
         return this.cachedProgress;
      }
      
      public function set progress(value:Number) : void
      {
         if(value > 1)
         {
            this.cachedRawProgress = value;
            this.cachedProgress = value - int(value);
            if(this.cachedProgress == 0)
            {
               this.cachedProgress = 1;
            }
         }
         else if(value < 0)
         {
            this.cachedRawProgress = value;
            this.cachedProgress = value - (int(value) - 1);
         }
         else
         {
            this.cachedRawProgress = int(this.cachedRawProgress) + value;
            this.cachedProgress = value;
         }
         if(Boolean(this.path))
         {
            this.path.renderObjectAt(this.target,this.cachedProgress,this.autoRotate,this.rotationOffset);
         }
      }
   }
}

