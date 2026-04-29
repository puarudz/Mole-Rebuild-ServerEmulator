package com.taomee.mole.library.physics
{
   import flash.display.Sprite;
   
   public class SteeredBarrier extends Sprite
   {
      
      private var _radius:Number;
      
      private var _color:uint;
      
      public function SteeredBarrier(radius:Number, color:uint)
      {
         super();
         this._radius = radius;
         this._color = color;
         graphics.lineStyle(0,this._color);
         graphics.drawCircle(0,0,this._radius);
      }
      
      public function get radius() : Number
      {
         return this._radius;
      }
      
      public function get position() : Vector2D
      {
         return new Vector2D(x,y);
      }
   }
}

