package com.taomee.component.border
{
   import com.taomee.component.Component;
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.JointStyle;
   
   public class EmptyBorder implements IBorder
   {
      
      protected var border:IBorder;
      
      protected var alpha:Number = 0;
      
      protected var thickness:int;
      
      protected var color:int = 0;
      
      protected var round:int = 0;
      
      protected var graphics:Graphics;
      
      public function EmptyBorder(border:IBorder, thickness:int = 1)
      {
         super();
         this.border = border;
         this.thickness = thickness;
      }
      
      public function drawBorder(graphics:Graphics, comp:Component) : void
      {
         this.graphics = graphics;
         graphics.lineStyle(this.thickness,this.color,this.alpha,true,"normal",CapsStyle.ROUND,JointStyle.ROUND);
         graphics.drawRoundRect(this.thickness / 2,this.thickness / 2,comp.getWidth() - this.thickness,comp.getHeight() - this.thickness,this.round);
      }
      
      public function getThickness() : int
      {
         return this.thickness;
      }
      
      public function getRound() : int
      {
         return this.round;
      }
      
      public function getBorderMargin() : int
      {
         var margin:int = 0;
         if(this.thickness >= this.round)
         {
            margin = this.thickness + 5;
         }
         else
         {
            margin = this.round / 3 + this.thickness / 2 + 3;
         }
         return Math.ceil(margin);
      }
      
      public function clear() : void
      {
         if(Boolean(this.graphics))
         {
            this.graphics.lineStyle(0);
         }
      }
   }
}

