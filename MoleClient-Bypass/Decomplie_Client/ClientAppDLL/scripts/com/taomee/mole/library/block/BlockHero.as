package com.taomee.mole.library.block
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class BlockHero extends Sprite
   {
      
      private var _xTile:int;
      
      private var _yTile:int;
      
      private var _speed:Number;
      
      private var _hero_mc:MovieClip;
      
      private var _downY:Number;
      
      private var _upY:Number;
      
      private var _leftX:Number;
      
      private var _rightX:Number;
      
      private var _upLeft:Boolean;
      
      private var _downLeft:Boolean;
      
      private var _upRight:Boolean;
      
      private var _downRight:Boolean;
      
      public function BlockHero(hero_mc:MovieClip, speed:Number = 4)
      {
         super();
         this._hero_mc = hero_mc;
         addChild(this._hero_mc);
         this._speed = speed;
      }
      
      public function get xTile() : int
      {
         return this._xTile;
      }
      
      public function set xTile(value:int) : void
      {
         this._xTile = value;
      }
      
      public function get yTile() : int
      {
         return this._yTile;
      }
      
      public function set yTile(value:int) : void
      {
         this._yTile = value;
      }
      
      public function move(dirx:int, diry:int) : Boolean
      {
         return true;
      }
      
      private function getMyCorners() : void
      {
         this._downY = Math.floor((y + height - 1) / BlockGame.tileH);
         this._upY = Math.floor((y - height) / BlockGame.tileH);
         this._leftX = Math.floor((x - width) / BlockGame.tileW);
         this._rightX = Math.floor((x + width - 1) / BlockGame.tileW);
      }
   }
}

