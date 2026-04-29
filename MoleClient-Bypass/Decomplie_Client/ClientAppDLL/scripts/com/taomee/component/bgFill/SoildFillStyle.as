package com.taomee.component.bgFill
{
   import com.taomee.component.Component;
   import flash.display.Sprite;
   
   public class SoildFillStyle implements IBgFillStyle
   {
      
      private var bgMC:Sprite;
      
      private var fillColor:uint = 16777215;
      
      private var bgAlpha:Number;
      
      public function SoildFillStyle(fillColor:uint = 16777215, bgAlpha:Number = 1)
      {
         super();
         this.fillColor = fillColor;
         this.bgAlpha = bgAlpha;
      }
      
      public function draw(bgMC:Sprite) : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         this.bgMC = bgMC;
         this.bgMC.graphics.clear();
         this.bgMC.graphics.beginFill(this.fillColor,this.bgAlpha);
         w = Component(this.bgMC.parent).getWidth();
         h = Component(this.bgMC.parent).getHeight();
         this.bgMC.graphics.drawRect(0,0,w,h);
         this.bgMC.graphics.endFill();
      }
      
      public function reDraw() : void
      {
         this.draw(this.bgMC);
      }
      
      public function clear() : void
      {
         this.bgMC.graphics.clear();
         this.bgMC = null;
      }
   }
}

