package com.taomee.component
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class MSprite extends Sprite
   {
      
      protected var bgMC:Sprite;
      
      protected var maskMC:Shape;
      
      protected var bgMaskMC:Shape;
      
      protected var fillColor:uint = 16777215;
      
      protected var bgAlpha:Number = 0.5;
      
      protected var containSprite:Sprite;
      
      private var clipMasked:Boolean;
      
      public function MSprite(clipMasked:Boolean = false)
      {
         super();
         this.clipMasked = clipMasked;
         this.maskMC = new Shape();
         this.bgMaskMC = new Shape();
         this.bgMC = new Sprite();
         addChild(this.bgMC);
         addChild(this.maskMC);
         addChild(this.bgMaskMC);
         this.bgMC.tabEnabled = false;
         this.bgMC.mouseEnabled = false;
         this.bgMC.mouseChildren = false;
         this.bgMC.cacheAsBitmap = true;
         this.containSprite = new Sprite();
         this.containSprite.mouseEnabled = false;
         this.containSprite.cacheAsBitmap = true;
         this.addChild(this.containSprite);
         this.cacheAsBitmap = true;
         this.initMask();
      }
      
      public function setMouseEnabled(b:Boolean) : void
      {
         this.mouseEnabled = b;
      }
      
      public function destroy() : void
      {
         while(this.bgMC.numChildren > 0)
         {
            this.bgMC.removeChildAt(0);
         }
         this.bgMC = null;
         this.maskMC = null;
         this.containSprite = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function initMask() : void
      {
         if(this.clipMasked)
         {
            this.maskMC.graphics.beginFill(0,0);
            this.maskMC.graphics.drawRect(0,0,1,1);
            this.maskMC.graphics.endFill();
            this.containSprite.mask = this.maskMC;
            this.bgMaskMC.graphics.beginFill(0,0.5);
            this.bgMaskMC.graphics.drawRect(0,0,1,1);
            this.bgMaskMC.graphics.endFill();
            this.bgMC.mask = this.bgMaskMC;
         }
      }
      
      override public function set width(value:Number) : void
      {
         if(this.clipMasked)
         {
            this.bgMaskMC.width = this.maskMC.width = value;
         }
         else
         {
            this.width = value;
         }
      }
      
      override public function set height(value:Number) : void
      {
         if(this.clipMasked)
         {
            this.bgMaskMC.height = this.maskMC.height = value;
         }
         else
         {
            this.height = value;
         }
      }
      
      override public function get width() : Number
      {
         if(this.clipMasked)
         {
            return this.bgMaskMC.width;
         }
         return this.containSprite.width;
      }
      
      override public function get height() : Number
      {
         if(this.clipMasked)
         {
            return this.bgMaskMC.height;
         }
         return this.containSprite.height;
      }
      
      override public function get numChildren() : int
      {
         return this.containSprite.numChildren;
      }
      
      override public function getChildAt(index:int) : DisplayObject
      {
         return this.containSprite.getChildAt(index);
      }
      
      override public function getChildByName(name:String) : DisplayObject
      {
         return this.containSprite.getChildByName(name);
      }
      
      override public function getChildIndex(child:DisplayObject) : int
      {
         return this.containSprite.getChildIndex(child);
      }
      
      override public function setChildIndex(child:DisplayObject, index:int) : void
      {
         return this.containSprite.setChildIndex(child,index);
      }
   }
}

