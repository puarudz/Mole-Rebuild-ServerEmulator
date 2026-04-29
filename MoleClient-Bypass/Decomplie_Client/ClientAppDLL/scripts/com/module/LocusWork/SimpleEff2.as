package com.module.LocusWork
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SimpleEff2
   {
      
      public function SimpleEff2(mc:MovieClip)
      {
         super();
         mc.stop();
         mc.buttonMode = true;
         mc.addEventListener(MouseEvent.CLICK,this.onC);
         mc.addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         mc.addFrameScript(1,function():void
         {
            mc.stop();
         });
         mc.addFrameScript(0,function():void
         {
            mc.stop();
         });
         mc.buttonMode = true;
      }
      
      private function removed(e:Event) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc.removeEventListener(MouseEvent.CLICK,this.onC);
         mc.removeEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      private function onC(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(mc.currentFrame == 1)
         {
            mc.gotoAndStop(2);
         }
         else
         {
            mc.gotoAndStop(1);
         }
      }
   }
}

