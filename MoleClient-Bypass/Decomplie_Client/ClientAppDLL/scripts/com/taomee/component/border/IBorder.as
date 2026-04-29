package com.taomee.component.border
{
   import com.taomee.component.Component;
   import flash.display.Graphics;
   
   public interface IBorder
   {
      
      function drawBorder(param1:Graphics, param2:Component) : void;
      
      function getThickness() : int;
      
      function getRound() : int;
      
      function getBorderMargin() : int;
      
      function clear() : void;
   }
}

