package com.taomee.component
{
   import com.taomee.component.event.MEvent;
   import flash.events.MouseEvent;
   
   [Event(name="releaseOutside",type="com.taomee.component.event.MEvent")]
   [Event(name="release",type="com.taomee.component.event.MEvent")]
   [Event(name="press",type="com.taomee.component.event.MEvent")]
   [Event(name="onRollOver",type="com.taomee.component.event.MEvent")]
   [Event(name="onRollOut",type="com.taomee.component.event.MEvent")]
   public class AbstractButton extends Component implements IButton
   {
      
      private var isDown:Boolean = false;
      
      public function AbstractButton()
      {
         super();
         this.mouseChildren = false;
         this.initHandler();
      }
      
      public function mouseOut() : void
      {
         dispatchEvent(new MEvent(MEvent.ON_ROLL_OUT));
      }
      
      public function mouseOver() : void
      {
         dispatchEvent(new MEvent(MEvent.ON_ROLL_OVER));
      }
      
      public function press() : void
      {
         dispatchEvent(new MEvent(MEvent.PRESS));
      }
      
      public function release() : void
      {
         dispatchEvent(new MEvent(MEvent.RELEASE));
      }
      
      public function releaseOutside() : void
      {
         dispatchEvent(new MEvent(MEvent.RELEASE_OUTSIDE));
      }
      
      override public function destroy() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
         this.removeEventListener(MouseEvent.MOUSE_UP,this.upHandler);
         MComponentManager.getCompRoot().stage.removeEventListener(MouseEvent.MOUSE_UP,this.stageUpHandler);
         super.destroy();
      }
      
      private function initHandler() : void
      {
         this.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
         this.addEventListener(MouseEvent.MOUSE_UP,this.upHandler);
         MComponentManager.getCompRoot().stage.addEventListener(MouseEvent.MOUSE_UP,this.stageUpHandler);
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         if(this.isDown)
         {
            this.press();
         }
         else
         {
            this.mouseOver();
         }
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         this.mouseOut();
      }
      
      private function downHandler(event:MouseEvent) : void
      {
         this.isDown = true;
         this.press();
      }
      
      private function upHandler(event:MouseEvent) : void
      {
         if(this.isDown)
         {
            this.release();
         }
         this.isDown = false;
      }
      
      private function stageUpHandler(event:MouseEvent) : void
      {
         if(this.isDown)
         {
            this.releaseOutside();
         }
         this.isDown = false;
      }
   }
}

