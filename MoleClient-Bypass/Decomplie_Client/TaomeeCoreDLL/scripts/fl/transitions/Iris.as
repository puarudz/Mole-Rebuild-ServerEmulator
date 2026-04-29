package fl.transitions
{
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class Iris extends Transition
   {
      
      public static const SQUARE:String = "SQUARE";
      
      public static const CIRCLE:String = "CIRCLE";
      
      protected var _mask:MovieClip;
      
      protected var _startPoint:uint = 5;
      
      protected var _cornerMode:Boolean = false;
      
      protected var _shape:String = "SQUARE";
      
      protected var _maxDimension:Number = NaN;
      
      protected var _minDimension:Number = NaN;
      
      protected var _renderFunction:Function;
      
      public function Iris(content:MovieClip, transParams:Object, manager:TransitionManager)
      {
         super(content,transParams,manager);
         if(Boolean(transParams.startPoint))
         {
            this._startPoint = transParams.startPoint;
         }
         if(Boolean(transParams.shape))
         {
            this._shape = transParams.shape;
         }
         this._maxDimension = Math.max(this._width,this._height);
         this._minDimension = Math.min(this._width,this._height);
         if(Boolean(this._startPoint % 2))
         {
            this._cornerMode = true;
         }
         if(this._shape == SQUARE)
         {
            if(this._cornerMode)
            {
               this._renderFunction = this._renderSquareCorner;
            }
            else
            {
               this._renderFunction = this._renderSquareEdge;
            }
         }
         else if(this._shape == CIRCLE)
         {
            this._renderFunction = this._renderCircle;
         }
         this._initMask();
      }
      
      override public function get type() : Class
      {
         return Iris;
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
         var mask:MovieClip = null;
         mask = this._mask = new MovieClip();
         mask.visible = false;
         this._content.addChild(mask);
         var ib:Rectangle = this._innerBounds;
         switch(this._startPoint)
         {
            case 1:
               mask.x = ib.left;
               mask.y = ib.top;
               break;
            case 4:
               mask.x = ib.left;
               mask.y = (ib.top + ib.bottom) * 0.5;
               break;
            case 3:
               mask.rotation = 90;
               mask.x = ib.right;
               mask.y = ib.top;
               break;
            case 2:
               mask.rotation = 90;
               mask.x = (ib.left + ib.right) * 0.5;
               mask.y = ib.top;
               break;
            case 9:
               mask.rotation = 180;
               mask.x = ib.right;
               mask.y = ib.bottom;
               break;
            case 6:
               mask.rotation = 180;
               mask.x = ib.right;
               mask.y = (ib.top + ib.bottom) * 0.5;
               break;
            case 7:
               mask.rotation = -90;
               mask.x = ib.left;
               mask.y = ib.bottom;
               break;
            case 8:
               mask.rotation = -90;
               mask.x = (ib.left + ib.right) * 0.5;
               mask.y = ib.bottom;
               break;
            case 5:
               mask.x = (ib.left + ib.right) * 0.5;
               mask.y = (ib.top + ib.bottom) * 0.5;
         }
      }
      
      override protected function _render(p:Number) : void
      {
         this._renderFunction(p);
      }
      
      protected function _renderCircle(p:Number) : void
      {
         var mask:MovieClip = this._mask;
         mask.graphics.clear();
         mask.graphics.beginFill(16711680);
         var maxRadius:Number = 0;
         if(this._startPoint == 5)
         {
            maxRadius = 0.5 * Math.sqrt(this._width * this._width + this._height * this._height);
            this.drawCircle(mask,0,0,p * maxRadius);
         }
         else if(this._cornerMode)
         {
            maxRadius = Math.sqrt(this._width * this._width + this._height * this._height);
            this._drawQuarterCircle(mask,p * maxRadius);
         }
         else
         {
            if(this._startPoint == 4 || this._startPoint == 6)
            {
               maxRadius = Math.sqrt(this._width * this._width + 0.25 * this._height * this._height);
            }
            else if(this._startPoint == 2 || this._startPoint == 8)
            {
               maxRadius = Math.sqrt(0.25 * this._width * this._width + this._height * this._height);
            }
            this._drawHalfCircle(mask,p * maxRadius);
         }
         mask.graphics.endFill();
      }
      
      protected function _drawQuarterCircle(mc:MovieClip, r:Number) : void
      {
         var x:Number = 0;
         var y:Number = 0;
         mc.graphics.lineTo(r,0);
         mc.graphics.curveTo(r + x,Math.tan(Math.PI / 8) * r + y,Math.sin(Math.PI / 4) * r + x,Math.sin(Math.PI / 4) * r + y);
         mc.graphics.curveTo(Math.tan(Math.PI / 8) * r + x,r + y,x,r + y);
      }
      
      protected function _drawHalfCircle(mc:MovieClip, r:Number) : void
      {
         var x:Number = 0;
         var y:Number = 0;
         mc.graphics.lineTo(0,-r);
         mc.graphics.curveTo(Math.tan(Math.PI / 8) * r + x,-r + y,Math.sin(Math.PI / 4) * r + x,-Math.sin(Math.PI / 4) * r + y);
         mc.graphics.curveTo(r + x,-Math.tan(Math.PI / 8) * r + y,r + x,y);
         mc.graphics.curveTo(r + x,Math.tan(Math.PI / 8) * r + y,Math.sin(Math.PI / 4) * r + x,Math.sin(Math.PI / 4) * r + y);
         mc.graphics.curveTo(Math.tan(Math.PI / 8) * r + x,r + y,x,r + y);
         mc.graphics.lineTo(0,0);
      }
      
      protected function _renderSquareEdge(p:Number) : void
      {
         var mask:MovieClip = this._mask;
         mask.graphics.clear();
         mask.graphics.beginFill(16711680);
         var s:uint = this._startPoint;
         var w:Number = p * this._width;
         var h:Number = p * this._height;
         var z:Number = p * this._maxDimension;
         if(s == 4 || s == 6)
         {
            this.drawBox(mask,0,-0.5 * h,w,h);
         }
         else if(this._height < this._width)
         {
            this.drawBox(mask,0,-0.5 * z,h,w);
         }
         else
         {
            this.drawBox(mask,0,-0.5 * z,z,z);
         }
         mask.graphics.endFill();
      }
      
      protected function _renderSquareCorner(p:Number) : void
      {
         var mask:MovieClip = this._mask;
         mask.graphics.clear();
         mask.graphics.beginFill(16711680);
         var s:uint = this._startPoint;
         var w:Number = p * this._width;
         var h:Number = p * this._height;
         if(s == 5)
         {
            this.drawBox(mask,-0.5 * w,-0.5 * h,w,h);
         }
         else if(s == 3 || s == 7)
         {
            this.drawBox(mask,0,0,h,w);
         }
         else
         {
            this.drawBox(mask,0,0,w,h);
         }
         mask.graphics.endFill();
      }
   }
}

