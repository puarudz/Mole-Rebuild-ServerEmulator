package com.common.util
{
   public class MathUtil
   {
      
      public function MathUtil()
      {
         super();
      }
      
      public static function randomRegion(start:Number, end:Number) : Number
      {
         return start + Math.random() * (end - start);
      }
      
      public static function randomHalve(v:Number) : Number
      {
         return v - Math.random() * (v / 2);
      }
      
      public static function randomHalfAdd(v:Number) : Number
      {
         return v + Math.random() * (v / 2);
      }
      
      public static function clamp(value:Number, min:Number, max:Number) : Number
      {
         return Math.min(Math.max(value,min),max);
      }
   }
}

