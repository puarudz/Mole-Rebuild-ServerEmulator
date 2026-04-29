package com.view.LamuWorld.attack
{
   import flash.display.MovieClip;
   
   public class NormalFire extends HitAttack
   {
      
      public function NormalFire()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         bossMC.gotoAndPlay("扫荡冲击波");
         bossMC.direction = int(Math.random() * 3);
      }
      
      override protected function onEnterFrame(e:*) : void
      {
         var i:int = 0;
         var fire:MovieClip = null;
         var content:MovieClip = bossMC.getChildAt(0) as MovieClip;
         if(bossMC.currentLabel == "扫荡冲击波")
         {
            for(i = 0; i < 3; i++)
            {
               fire = content.getChildByName("fire" + i) as MovieClip;
               if(fire != null && fire.currentFrame > 4)
               {
                  if(hitTest(fire))
                  {
                     hurt();
                     break;
                  }
               }
            }
         }
         else
         {
            end();
         }
      }
   }
}

