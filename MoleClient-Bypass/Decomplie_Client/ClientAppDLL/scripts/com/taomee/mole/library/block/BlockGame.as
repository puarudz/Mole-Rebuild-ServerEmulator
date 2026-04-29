package com.taomee.mole.library.block
{
   import com.common.data.HashMap;
   import com.common.util.DisplayUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class BlockGame extends Sprite
   {
      
      public static var tileW:Number;
      
      public static var tileH:Number;
      
      private static var _inst:BlockGame;
      
      protected var _hero:BlockHero;
      
      private var _data:Array;
      
      private var _gridList:Array;
      
      private var _mapCon:Sprite;
      
      private var _keyMap:HashMap;
      
      public function BlockGame()
      {
         super();
         _inst = this;
         this._mapCon = new Sprite();
         addChild(this._mapCon);
         this._keyMap = new HashMap();
         addEventListener(Event.ENTER_FRAME,this.onDetectKeys);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHd);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHd);
      }
      
      public static function get inst() : BlockGame
      {
         return _inst;
      }
      
      private function onKeyDownHd(e:KeyboardEvent) : void
      {
         this._keyMap.add(e.keyCode,true);
      }
      
      private function onKeyUpHd(e:KeyboardEvent) : void
      {
         this._keyMap.add(e.keyCode,false);
      }
      
      private function onDetectKeys(e:Event) : void
      {
         var keyPressed:Boolean = false;
         if(Boolean(this._keyMap.getValue(Keyboard.LEFT)))
         {
            keyPressed = this._hero.move(-1,0);
         }
         else if(Boolean(this._keyMap.getValue(Keyboard.RIGHT)))
         {
            keyPressed = this._hero.move(1,0);
         }
         else if(Boolean(this._keyMap.getValue(Keyboard.UP)))
         {
            keyPressed = this._hero.move(0,-1);
         }
         else if(Boolean(this._keyMap.getValue(Keyboard.DOWN)))
         {
            keyPressed = this._hero.move(0,1);
         }
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(value:Array) : void
      {
         var grid:BlockGrid = null;
         var i:uint = 0;
         var lineList:Array = null;
         var j:uint = 0;
         this._data = value;
         DisplayUtil.removeAllChild(this._mapCon);
         this._gridList = new Array();
         for(i = 0; i < this._data.length; i++)
         {
            lineList = this._data[i];
            for(j = 0; j < lineList.length; j++)
            {
               grid = new BlockGrid(this.getGrid(lineList[j]));
               grid.x = j * tileW;
               grid.y = i * tileH;
               grid.frame = lineList[j];
               this._mapCon.addChild(grid);
               this._gridList[i][j] = grid;
            }
         }
      }
      
      protected function getGrid(type:uint) : MovieClip
      {
         var grid_mc:MovieClip = new MovieClip();
         grid_mc.graphics.beginFill(16711680);
         grid_mc.graphics.drawRect(0,0,tileW,tileH);
         grid_mc.graphics.endFill();
         return grid_mc;
      }
      
      public function destroy() : void
      {
         _inst = null;
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHd);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHd);
         removeEventListener(Event.ENTER_FRAME,this.onDetectKeys);
      }
   }
}

