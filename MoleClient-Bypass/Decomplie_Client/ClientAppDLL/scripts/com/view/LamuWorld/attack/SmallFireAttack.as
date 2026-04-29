package com.view.LamuWorld.attack
{
   import flash.display.MovieClip;
   
   public class SmallFireAttack extends HitAttack
   {
      
      public function SmallFireAttack()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         bossMC.gotoAndPlay("火种冲击波");
         bossMC.direction = int(Math.random() * 12);
      }
      
      override protected function onEnterFrame(e:*) : void
      {
         var i:int = 0;
         var fire:MovieClip = null;
         var content:MovieClip = bossMC.getChildAt(0) as MovieClip;
         var startIndex:int = bossMC.direction < 4 ? 0 : int(bossMC.direction - 3);
         if(bossMC.currentLabel == "火种冲击波")
         {
            if(content.currentFrame > 36)
            {
               for(i = startIndex; i < startIndex + 6; i++)
               {
                  fire = content.getChildByName("fire" + i) as MovieClip;
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

