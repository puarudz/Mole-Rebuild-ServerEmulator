package com.taomee.component.bgFill
{
   import com.taomee.component.Component;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class GradientFillStyle implements IBgFillStyle
   {
      
      private var bgMC:Sprite;
      
      private var type:String;
      
      private var colors:Array;
      
      private var alphas:Array;
      
      private var ratios:Array;
      
      private var matrix:Matrix;
      
      private var spreadMethod:String;
      
      private var interpolationMethod:String;
      
      private var focalPointRatio:Number;
      
      public function GradientFillStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0)
      {
         super();
         this.type = type;
         this.colors = colors;
         this.alphas = alphas;
         this.ratios = ratios;
         this.matrix = matrix;
         this.spreadMethod = spreadMethod;
         this.interpolationMethod = interpolationMethod;
         this.focalPointRatio = focalPointRatio;
      }
      
      public function draw(bgMC:Sprite) : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         this.bgMC = bgMC;
         w = Component(this.bgMC.parent).getWidth();
         h = Component(this.bgMC.parent).getHeight();
         this.bgMC.graphics.beginGradientFill(this.type,this.colors,this.alphas,this.ratios,this.matrix,this.spreadMethod,this.interpolationMethod,this.focalPointRatio);
         this.bgMC.graphics.drawRect(0,0,w,h);
         this.bgMC.graphics.endFill();
      }
      
      public function reDraw() : void
      {
         this.bgMC.graphics.clear();
         this.draw(this.bgMC);
      }
      
      public function clear() : void
      {
         this.bgMC.graphics.clear();
         this.bgMC = null;
      }
   }
}

