package com.view.LamuWorld.attack
{
   import flash.display.Sprite;
   
   public class BigFireAttack extends HitAttack
   {
      
      public function BigFireAttack()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         bossMC.gotoAndPlay("烈焰冲击波");
         bossMC.direction = 0;
      }
      
      override protected function onEnterFrame(e:*) : void
      {
         var matrix:Sprite = null;
         var content:Sprite = bossMC.getChildAt(0) as Sprite;
         if(bossMC.currentLabel == "烈焰冲击波")
         {
            matrix = content.getChildByName("matrix") as Sprite;
            if(hitTest(matrix))
            {
               hurt();
            }
         }
         else
         {
            end();
         }
      }
   }
}

