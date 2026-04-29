package com.taomee.component.bgFill
{
   import com.taomee.component.Component;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class BmpFillStyle implements IBgFillStyle
   {
      
      private var image:DisplayObject;
      
      private var bgMC:Sprite;
      
      private var isFitSize:Boolean;
      
      private var matrix:Matrix;
      
      public function BmpFillStyle(content:DisplayObject, isFitSize:Boolean = true, matrix:Matrix = null)
      {
         super();
         this.image = content;
         this.isFitSize = isFitSize;
         this.matrix = matrix;
      }
      
      public function draw(bgMC:Sprite) : void
      {
         this.bgMC = bgMC;
         if(this.isFitSize)
         {
            this.image.width = Component(this.bgMC.parent).getWidth();
            this.image.height = Component(this.bgMC.parent).getHeight();
         }
         if(Boolean(this.matrix))
         {
            this.image.transform.matrix = this.matrix;
         }
         this.bgMC.addChild(this.image);
      }
      
      public function reDraw() : void
      {
         if(this.isFitSize)
         {
            this.image.width = Component(this.bgMC.parent).getWidth();
            this.image.height = Component(this.bgMC.parent).getHeight();
         }
         if(Boolean(this.matrix))
         {
            this.image.transform.matrix = this.matrix;
         }
         this.bgMC.addChild(this.image);
      }
      
      public function clear() : void
      {
         if(this.image != null)
         {
            this.bgMC.removeChild(this.image);
            this.image = null;
         }
         this.bgMC.graphics.clear();
         this.bgMC = null;
      }
   }
}

