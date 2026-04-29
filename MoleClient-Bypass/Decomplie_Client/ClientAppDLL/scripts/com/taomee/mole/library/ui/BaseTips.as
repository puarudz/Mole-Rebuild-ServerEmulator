package com.taomee.mole.library.ui
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class BaseTips extends Sprite
   {
      
      public var _info:*;
      
      public var mcContainer:DisplayObjectContainer;
      
      public function BaseTips(_info:*)
      {
         super();
         this._info = _info;
      }
      
      public function show() : void
      {
         this.setup();
         if(Boolean(this.mcContainer))
         {
            this.mcContainer.mouseEnabled = false;
            this.mcContainer.mouseChildren = false;
         }
      }
      
      public function setup() : void
      {
      }
      
      public function hide() : void
      {
         if(Boolean(this.mcContainer) && contains(this.mcContainer))
         {
            removeChild(this.mcContainer);
         }
         this.mcContainer = null;
      }
      
      public function detory() : void
      {
         this.hide();
         this._info = null;
      }
   }
}

