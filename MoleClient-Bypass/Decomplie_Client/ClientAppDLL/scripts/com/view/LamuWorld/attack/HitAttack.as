package com.view.LamuWorld.attack
{
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class HitAttack extends Attack
   {
      
      public function HitAttack()
      {
         super();
      }
      
      protected function hitTest(spr:Sprite, _shapeFlag:Boolean = true) : Boolean
      {
         if(spr == null)
         {
            return false;
         }
         var point:Point = new Point(_target.x,_target.y);
         var flag:Boolean = spr.hitTestPoint(point.x,point.y,_shapeFlag);
         if(flag)
         {
            return true;
         }
         return false;
      }
   }
}

