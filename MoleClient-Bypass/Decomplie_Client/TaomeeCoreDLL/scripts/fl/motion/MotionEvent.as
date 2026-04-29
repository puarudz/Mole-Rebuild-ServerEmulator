package fl.motion
{
   import flash.events.Event;
   
   public class MotionEvent extends Event
   {
      
      public static const MOTION_START:String = "motionStart";
      
      public static const MOTION_END:String = "motionEnd";
      
      public static const MOTION_UPDATE:String = "motionUpdate";
      
      public static const TIME_CHANGE:String = "timeChange";
      
      public function MotionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new MotionEvent(this.type,this.bubbles,this.cancelable);
      }
   }
}

