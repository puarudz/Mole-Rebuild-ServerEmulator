package com.view.LamuWorld.attack
{
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class IceAttack extends HitAttack
   {
      
      public function IceAttack()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         var random:int = Math.random() * 3;
         if(random == 0)
         {
            bossMC.gotoAndPlay("中间");
         }
         else if(random == 1)
         {
            bossMC.gotoAndPlay("右边");
         }
         else if(random == 1)
         {
            bossMC.gotoAndPlay("左边");
         }
      }
      
      override protected function onEnterFrame(e:*) : void
      {
         var matrix:Sprite = null;
         var content:Sprite = bossMC.getChildAt(0) as Sprite;
         var str:String = bossMC.currentLabel;
         if(str == "中間" || str == "左邊" || str == "右邊")
         {
            matrix = content.getChildByName("matrix") as Sprite;
            if(Boolean(matrix) && this.hitTest(matrix))
            {
               hurt();
            }
         }
         else
         {
            end();
         }
      }
      
      override protected function hitTest(spr:Sprite, _shapeFlag:Boolean = true) : Boolean
      {
         if(spr == null)
         {
            return false;
         }
         var point:Point = new Point(_target.x,_target.y);
         var flag:Boolean = spr.hitTestPoint(point.x,point.y,_shapeFlag);
         flag ||= spr.hitTestPoint(point.x + _target.width / 4,point.y,_shapeFlag);
         flag ||= spr.hitTestPoint(point.x - _target.width / 4,point.y,_shapeFlag);
         if(flag)
         {
            return true;
         }
         return false;
      }
   }
}

