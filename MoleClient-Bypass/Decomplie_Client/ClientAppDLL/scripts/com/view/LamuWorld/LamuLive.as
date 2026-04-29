package com.view.LamuWorld
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class LamuLive extends LiveBar
   {
      
      public function LamuLive(ui:Sprite)
      {
         super(ui);
         this.maxLive = 20;
      }
      
      override public function set live(val:int) : void
      {
         var mc:MovieClip = null;
         super.live = val;
         var num:int = val / 4;
         for(var i:int = 0; i < num; i++)
         {
            mc = ui.getChildByName("live" + i) as MovieClip;
            mc.gotoAndStop(1);
         }
         for(i = num; i < 5; i++)
         {
            mc = ui.getChildByName("live" + i) as MovieClip;
            mc.gotoAndStop(15);
         }
         if(num == 5)
         {
            return;
         }
         var num0:int = val % 4;
         mc = ui.getChildByName("live" + int(num)) as MovieClip;
         if(num0 == 0)
         {
            mc.gotoAndStop(5);
         }
         else
         {
            mc.gotoAndStop(5 - num0);
         }
      }
   }
}

