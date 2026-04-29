package fl.motion
{
   public class AnimatorFactory extends AnimatorFactoryBase
   {
      
      public function AnimatorFactory(motion:MotionBase, motionArray:Array = null)
      {
         super(motion,motionArray);
      }
      
      override protected function getNewAnimator() : AnimatorBase
      {
         return new Animator(null,null);
      }
   }
}

