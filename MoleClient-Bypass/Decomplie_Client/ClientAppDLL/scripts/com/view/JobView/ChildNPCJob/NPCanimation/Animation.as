package com.view.JobView.ChildNPCJob.NPCanimation
{
   import com.event.EventTaomee;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class Animation extends Sprite
   {
      
      private var target_mc:MovieClip;
      
      private var botton_mc:*;
      
      private var IsCloseNpcTip:Boolean = false;
      
      public function Animation(mc:MovieClip, btn:*)
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"wordMapChang_over",this.removeAll);
         this.target_mc = mc;
         this.botton_mc = btn;
         BC.addEvent(this,this.botton_mc,MouseEvent.MOUSE_OVER,this.OVERFun);
         BC.addEvent(this,this.botton_mc,MouseEvent.MOUSE_OUT,this.OUTFun);
      }
      
      private function OVERFun(evt:MouseEvent) : void
      {
         if(!this.IsCloseNpcTip)
         {
            this.cartoonFun();
         }
      }
      
      private function OUTFun(evt:MouseEvent) : void
      {
         if(!this.IsCloseNpcTip)
         {
            this.cartoonFun(1);
         }
      }
      
      private function cartoonFun(type:int = 0) : void
      {
         if(type == 0)
         {
            this.IsCloseNpcTip = true;
            if(this.target_mc.currentFrame == 1)
            {
               this.target_mc.gotoAndPlay(2);
            }
         }
         else
         {
            this.IsCloseNpcTip = false;
            this.target_mc.gotoAndStop(1);
         }
      }
      
      private function removeAll(event:EventTaomee) : void
      {
         BC.removeEvent(this);
         this.botton_mc = null;
         this.target_mc = null;
         this.IsCloseNpcTip = false;
      }
   }
}

