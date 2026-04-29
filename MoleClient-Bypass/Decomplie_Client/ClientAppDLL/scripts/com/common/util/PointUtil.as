package com.common.util
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class PointUtil
   {
      
      public function PointUtil()
      {
         super();
      }
      
      public static function P2P(mc1:DisplayObject, mc1Point:Point, mc2:DisplayObject) : Point
      {
         var temp1Point:Point = null;
         temp1Point = mc1.localToGlobal(mc1Point);
         return mc2.globalToLocal(temp1Point);
      }
   }
}

