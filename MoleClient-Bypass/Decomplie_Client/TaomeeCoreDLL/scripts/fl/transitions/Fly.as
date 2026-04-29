package fl.transitions
{
   import flash.display.*;
   import flash.geom.*;
   
   public class Fly extends Transition
   {
      
      public var className:String = "Fly";
      
      protected var _startPoint:Number = 4;
      
      protected var _xFinal:Number;
      
      protected var _yFinal:Number;
      
      protected var _xInitial:Number;
      
      protected var _yInitial:Number;
      
      protected var _stagePoints:Object;
      
      public function Fly(content:MovieClip, transParams:Object, manager:TransitionManager)
      {
         var i:String = null;
         var ib:Rectangle = null;
         super(content,transParams,manager);
         if(Boolean(transParams.startPoint))
         {
            this._startPoint = transParams.startPoint;
         }
         this._xFinal = this.manager.contentAppearance.x;
         this._yFinal = this.manager.contentAppearance.y;
         var stage:Stage = content.stage;
         var oldStageScaleMode:String = stage.scaleMode;
         stage.scaleMode = StageScaleMode.SHOW_ALL;
         var sp:Object = this._stagePoints = {};
         sp[1] = new Point(0,0);
         sp[2] = new Point(0,0);
         sp[3] = new Point(stage.stageWidth,0);
         sp[4] = new Point(0,0);
         sp[5] = new Point(stage.stageWidth / 2,stage.stageHeight / 2);
         sp[6] = new Point(stage.stageWidth,0);
         sp[7] = new Point(0,stage.stageHeight);
         sp[8] = new Point(0,stage.stageHeight);
         sp[9] = new Point(stage.stageWidth,stage.stageHeight);
         for(i in sp)
         {
            this._content.parent.globalToLocal(sp[i]);
         }
         ib = this._innerBounds;
         sp[1].x -= ib.right;
         sp[1].y -= ib.bottom;
         sp[2].x = this.manager.contentAppearance.x;
         sp[2].y -= ib.bottom;
         sp[3].x -= ib.left;
         sp[3].y -= ib.bottom;
         sp[4].x -= ib.right;
         sp[4].y = this.manager.contentAppearance.y;
         sp[5].x -= (ib.right + ib.left) / 2;
         sp[5].y -= (ib.bottom + ib.top) / 2;
         sp[6].x -= ib.left;
         sp[6].y = this.manager.contentAppearance.y;
         sp[7].x -= ib.right;
         sp[7].y -= ib.top;
         sp[8].x = this.manager.contentAppearance.x;
         sp[8].y -= ib.top;
         sp[9].x -= ib.left;
         sp[9].y -= ib.top;
         this._xInitial = this._stagePoints[this._startPoint].x;
         this._yInitial = this._stagePoints[this._startPoint].y;
         stage.scaleMode = oldStageScaleMode;
      }
      
      override public function get type() : Class
      {
         return Fly;
      }
      
      override protected function _render(p:Number) : void
      {
         this._content.x = this._xFinal + (this._xInitial - this._xFinal) * (1 - p);
         this._content.y = this._yFinal + (this._yInitial - this._yFinal) * (1 - p);
      }
   }
}

