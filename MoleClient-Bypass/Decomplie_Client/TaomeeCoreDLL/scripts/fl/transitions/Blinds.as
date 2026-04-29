package fl.transitions
{
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class Blinds extends Transition
   {
      
      protected var _numStrips:uint = 10;
      
      protected var _dimension:uint = 0;
      
      protected var _mask:MovieClip;
      
      protected var _innerMask:MovieClip;
      
      public function Blinds(content:MovieClip, transParams:Object, manager:TransitionManager)
      {
         super(content,transParams,manager);
         this._dimension = Boolean(transParams.dimension) ? 1 : 0;
         if(Boolean(transParams.numStrips))
         {
            this._numStrips = transParams.numStrips;
         }
         this._initMask();
      }
      
      override public function get type() : Class
      {
         return Blinds;
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
         this._innerMask.x = this._innerMask.y = 50;
         if(Boolean(this._dimension))
         {
            this._innerMask.rotation = -90;
         }
         this._innerMask.graphics.beginFill(16711680);
         this.drawBox(this._innerMask,0,0,100,100);
         this._innerMask.graphics.endFill();
         var ib:Rectangle = this._innerBounds;
         this._mask.x = ib.left;
         this._mask.y = ib.top;
         this._mask.width = ib.width;
         this._mask.height = ib.height;
      }
      
      override protected function _render(p:Number) : void
      {
         var h:Number = 100 / this._numStrips;
         var s:Number = p * h;
         var mask:MovieClip = this._innerMask;
         mask.graphics.clear();
         var i:Number = this._numStrips;
         mask.graphics.beginFill(16711680);
         while(Boolean(i--))
         {
            this.drawBox(mask,-50,i * h - 50,100,s);
         }
         mask.graphics.endFill();
      }
   }
}

