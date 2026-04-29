package com.taomee.component.bgFill
{
   import flash.display.Sprite;
   
   public interface IBgFillStyle
   {
      
      function draw(param1:Sprite) : void;
      
      function reDraw() : void;
      
      function clear() : void;
   }
}

