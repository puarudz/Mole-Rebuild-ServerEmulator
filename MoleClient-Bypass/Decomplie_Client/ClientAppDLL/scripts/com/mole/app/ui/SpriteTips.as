package com.mole.app.ui
{
   import flash.display.DisplayObject;
   
   public class SpriteTips extends TipsBase
   {
      
      public function SpriteTips(container:DisplayObject, tips:DisplayObject, autoDel:Boolean)
      {
         super(container,autoDel);
         _tipCon.addChild(tips);
      }
   }
}

