package fl.transitions
{
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class PixelDissolve extends Transition
   {
      
      protected var _xSections:Number = 10;
      
      protected var _ySections:Number = 10;
      
      protected var _numSections:uint = 1;
      
      protected var _indices:Array;
      
      protected var _mask:MovieClip;
      
      protected var _innerMask:MovieClip;
      
      public function PixelDissolve(content:MovieClip, transParams:Object, manager:TransitionManager)
      {
         var x:int = 0;
         super(content,transParams,manager);
         if(Boolean(transParams.xSections))
         {
            this._xSections = transParams.xSections;
         }
         if(Boolean(transParams.ySections))
         {
            this._ySections = transParams.ySections;
         }
         this._numSections = this._xSections * this._ySections;
         this._indices = new Array();
         var y:int = this._ySections;
         while(Boolean(y--))
         {
            x = this._xSections;
            while(Boolean(x--))
            {
               this._indices[y * this._xSections + x] = {
                  "x":x,
                  "y":y
               };
            }
         }
         this._shuffleArray(this._indices);
         this._initMask();
      }
      
      override public function get type() : Class
      {
         return PixelDissolve;
      }
      
      override public function start() : void
      {
         this._content.mask = this._mask;
         super.start();
      }
      
      override public function cleanUp() : void
      {
         this._content.removeChild(this._mask);
         this._content.mask = null;
         super.cleanUp();
      }
      
      protected function _initMask() : void
      {
         this._mask = new MovieClip();
         this._mask.visible = false;
         this._content.addChild(this._mask);
         this._innerMask = new MovieClip();
         this._mask.addChild(this._innerMask);
         this._innerMask.graphics.beginFill(16711680);
         this.drawBox(this._innerMask,0,0,100,100);
         this._innerMask.graphics.endFill();
         var ib:Rectangle = this._innerBounds;
         this._mask.x = ib.left;
         this._mask.y = ib.top;
         this._mask.width = ib.right - ib.left;
         this._mask.height = ib.bottom - ib.top;
      }
      
      protected function _shuffleArray(a:Array) : void
      {
         var p:int = 0;
         var tmp:Object = null;
         for(var i:int = a.length - 1; i > 0; i--)
         {
            p = Math.floor(Math.random() * (i + 1));
            if(p != i)
            {
               tmp = a[i];
               a[i] = a[p];
               a[p] = tmp;
            }
         }
      }
      
      override protected function _render(p:Number) : void
      {
         if(p < 0)
         {
            p = 0;
         }
         if(p > 1)
         {
            p = 1;
         }
         var w:Number = 100 / this._xSections;
         var h:Number = 100 / this._ySections;
         var ind:Array = this._indices;
         var mask:MovieClip = this._innerMask;
         mask.graphics.clear();
         mask.graphics.beginFill(16711680);
         var i:Number = Math.floor(p * this._numSections);
         while(Boolean(i--))
         {
            this.drawBox(mask,ind[i].x * w,ind[i].y * h,w,h);
         }
         mask.graphics.endFill();
      }
   }
}

