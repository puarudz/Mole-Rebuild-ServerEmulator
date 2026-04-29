package fl.motion
{
   public class AnimatorFactory3D extends AnimatorFactoryBase
   {
      
      public function AnimatorFactory3D(motion:MotionBase, motionArray:Array = null)
      {
         super(motion,motionArray);
         this._is3D = true;
      }
      
      override protected function getNewAnimator() : AnimatorBase
      {
         return new Animator3D(null,null);
      }
   }
}

