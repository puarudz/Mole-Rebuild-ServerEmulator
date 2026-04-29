package fl.transitions
{
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class Wipe extends Transition
   {
      
      protected var _mask:MovieClip;
      
      protected var _innerMask:MovieClip;
      
      protected var _startPoint:uint = 4;
      
      protected var _cornerMode:Boolean = false;
      
      public function Wipe(content:MovieClip, transParams:Object, manager:TransitionManager)
      {
         super(content,transParams,manager);
         if(Boolean(transParams.startPoint))
         {
            this._startPoint = transParams.startPoint;
         }
         this._initMask();
      }
      
      override public function get type() : Class
      {
         return Wipe;
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
         this._innerMask.graphics.beginFill(16711680);
         this.drawBox(this._innerMask,-50,-50,100,100);
         this._innerMask.graphics.endFill();
         switch(this._startPoint)
         {
            case 3:
            case 2:
               this._innerMask.rotation = 90;
               break;
            case 1:
            case 4:
            case 5:
               this._innerMask.rotation = 0;
               break;
            case 9:
            case 6:
               this._innerMask.rotation = 180;
               break;
            case 7:
            case 8:
               this._innerMask.rotation = -90;
         }
         if(Boolean(this._startPoint % 2))
         {
            this._cornerMode = true;
         }
         var ib:Rectangle = this._innerBounds;
         this._mask.x = ib.left;
         this._mask.y = ib.top;
         this._mask.width = ib.width;
         this._mask.height = ib.height;
      }
      
      override protected function _render(p:Number) : void
      {
         this._innerMask.graphics.clear();
         this._innerMask.graphics.beginFill(16711680);
         if(this._cornerMode)
         {
            this._drawSlant(this._innerMask,p);
         }
         else
         {
            this.drawBox(this._innerMask,-50,-50,p * 100,100);
         }
         this._innerMask.graphics.endFill();
      }
      
      protected function _drawSlant(mc:MovieClip, p:Number) : void
      {
         mc.graphics.moveTo(-50,-50);
         if(p <= 0.5)
         {
            mc.graphics.lineTo(200 * (p - 0.25),-50);
            mc.graphics.lineTo(-50,200 * (p - 0.25));
         }
         else
         {
            mc.graphics.lineTo(50,-50);
            mc.graphics.lineTo(50,200 * (p - 0.75));
            mc.graphics.lineTo(200 * (p - 0.75),50);
            mc.graphics.lineTo(-50,50);
         }
         mc.graphics.lineTo(-50,-50);
      }
   }
}

