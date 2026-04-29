package com.taomee.mole.library.block
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class BlockGrid extends Sprite
   {
      
      private var _grid_mc:MovieClip;
      
      private var _walkable:Boolean;
      
      private var _frame:uint;
      
      public function BlockGrid(grid_mc:MovieClip)
      {
         super();
         this._grid_mc = grid_mc;
         addChild(this._grid_mc);
      }
      
      public function get walkable() : Boolean
      {
         return this._walkable;
      }
      
      public function set walkable(value:Boolean) : void
      {
         this._walkable = value;
      }
      
      public function get frame() : uint
      {
         return this._frame;
      }
      
      public function set frame(value:uint) : void
      {
         this._frame = value;
         this._grid_mc.gotoAndStop(this._frame);
      }
   }
}

