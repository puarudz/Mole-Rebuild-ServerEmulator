package com.taomee.mole.library.physics
{
   import flash.display.Sprite;
   
   public class Vehicle extends Sprite
   {
      
      public static const WRAP:String = "wrap";
      
      public static const BOUNCE:String = "bounce";
      
      public static const NONE:String = "none";
      
      protected var _edgeBehavior:String = "wrap";
      
      protected var _mass:Number = 1;
      
      protected var _maxSpeed:Number = 10;
      
      protected var _position:Vector2D;
      
      protected var _velocity:Vector2D;
      
      public function Vehicle()
      {
         super();
         this._position = new Vector2D();
         this._velocity = new Vector2D();
         this.draw();
      }
      
      protected function draw() : void
      {
         graphics.clear();
         graphics.lineStyle(0);
         graphics.moveTo(10,0);
         graphics.lineTo(-10,5);
         graphics.lineTo(-10,-5);
         graphics.lineTo(10,0);
      }
      
      public function update() : void
      {
         this._velocity.truncate(this._maxSpeed);
         this._position = this._position.add(this._velocity);
         if(this._edgeBehavior == WRAP)
         {
            this.wrap();
         }
         else if(this._edgeBehavior == BOUNCE)
         {
            this.bounce();
         }
         this.x = this._position.x;
         this.y = this._position.y;
         rotation = this._velocity.angle * 180 / Math.PI;
      }
      
      private function bounce() : void
      {
         if(stage != null)
         {
            if(this._position.x > stage.stageWidth)
            {
               this._position.x = stage.stageWidth;
               this._velocity.x *= -1;
            }
            else if(this._position.x < 0)
            {
               this._position.x = 0;
               this._velocity.x *= -1;
            }
            if(this._position.y > stage.stageHeight)
            {
               this._position.y = stage.stageHeight;
               this._velocity.y *= -1;
            }
            else if(this._position.y < 0)
            {
               this._position.y = 0;
               this._velocity.y *= -1;
            }
         }
      }
      
      private function wrap() : void
      {
         if(stage != null)
         {
            if(this._position.x > stage.stageWidth)
            {
               this._position.x = 0;
            }
            if(this._position.x < 0)
            {
               this._position.x = stage.stageWidth;
            }
            if(this._position.y > stage.stageHeight)
            {
               this._position.y = 0;
            }
            if(this._position.y < 0)
            {
               this._position.y = stage.stageHeight;
            }
         }
      }
      
      public function set edgeBehavior(value:String) : void
      {
         this._edgeBehavior = value;
      }
      
      public function get edgeBehavior() : String
      {
         return this._edgeBehavior;
      }
      
      public function set mass(value:Number) : void
      {
         this._mass = value;
      }
      
      public function get mass() : Number
      {
         return this._mass;
      }
      
      public function set maxSpeed(value:Number) : void
      {
         this._maxSpeed = value;
      }
      
      public function get maxSpeed() : Number
      {
         return this._maxSpeed;
      }
      
      public function set position(value:Vector2D) : void
      {
         this._position = value;
         this.x = this._position.x;
         this.y = this._position.y;
      }
      
      public function get position() : Vector2D
      {
         return this._position;
      }
      
      public function set velocity(value:Vector2D) : void
      {
         this._velocity = value;
      }
      
      public function get velocity() : Vector2D
      {
         return this._velocity;
      }
      
      override public function set x(value:Number) : void
      {
         super.x = value;
         this._position.x = x;
      }
      
      override public function set y(value:Number) : void
      {
         super.y = value;
         this._position.y = y;
      }
   }
}

