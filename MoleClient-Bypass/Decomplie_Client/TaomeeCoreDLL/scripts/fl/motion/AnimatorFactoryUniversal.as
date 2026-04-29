package fl.motion
{
   public class AnimatorFactoryUniversal extends AnimatorFactoryBase
   {
      
      public function AnimatorFactoryUniversal(motion:MotionBase, motionArray:Array)
      {
         super(motion,motionArray);
      }
      
      override protected function getNewAnimator() : AnimatorBase
      {
         return new AnimatorUniversal();
      }
   }
}

