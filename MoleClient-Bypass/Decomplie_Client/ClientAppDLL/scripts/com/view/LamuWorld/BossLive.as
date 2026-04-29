package com.view.LamuWorld
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class BossLive extends LiveBar
   {
      
      public var mode:int = 0;
      
      public function BossLive(ui:Sprite)
      {
         super(ui);
      }
      
      public function subLive() : void
      {
         --live;
      }
      
      override public function set live(val:int) : void
      {
         var i:int = 0;
         var life:MovieClip = null;
         super.live = val;
         if(Boolean(this.mode))
         {
            (ui as MovieClip).gotoAndStop(val + 1);
         }
         else
         {
            for(i = 0; i < 10; i++)
            {
               life = ui.getChildByName("life" + i) as MovieClip;
               if(life == null)
               {
                  break;
               }
               if(i >= live)
               {
                  if(life.currentFrame == 1)
                  {
                     life.gotoAndStop(2);
                  }
               }
               else if(life.currentFrame == 2)
               {
                  life.gotoAndStop(3);
               }
            }
         }
      }
   }
}

