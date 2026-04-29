package com.module.pig.view.pig
{
   import com.common.Tween.TweenLite;
   import com.common.data.HashMap;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapModelLogic;
   import fl.motion.easing.Linear;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class PigMoveCtl
   {
      
      private static const Default_Speed:int = 15;
      
      private var _breakMoveFuns:HashMap;
      
      private var _changeDirFuns:HashMap;
      
      private var _gridSize:uint;
      
      private var _isMoveing:Boolean = false;
      
      private var _path:Array;
      
      private var _speed:uint = 15;
      
      private var _startMoveFuns:HashMap;
      
      private var _stopMoveFuns:HashMap;
      
      private var _targetMC:*;
      
      private var _tween:TweenLite;
      
      private var _startP:Point;
      
      private var _endP:Point;
      
      private var _setDepthTimer:Timer;
      
      public function PigMoveCtl(targetMC:*)
      {
         super();
         this._gridSize = MapModelLogic.GridSize;
         this._targetMC = targetMC;
         this._changeDirFuns = new HashMap();
         this._startMoveFuns = new HashMap();
         this._stopMoveFuns = new HashMap();
         this._breakMoveFuns = new HashMap();
         this._startP = new Point();
         this._endP = new Point();
      }
      
      public function get breakMoveFuns() : HashMap
      {
         return this._breakMoveFuns;
      }
      
      public function get changeDirFuns() : HashMap
      {
         return this._changeDirFuns;
      }
      
      public function get isMoveing() : Boolean
      {
         return this._isMoveing;
      }
      
      public function get speed() : uint
      {
         return this._speed;
      }
      
      public function set speed(speed:uint) : void
      {
         this._speed = speed;
      }
      
      public function ResetSpeed() : void
      {
         this._speed = Default_Speed;
      }
      
      public function get startMoveFuns() : HashMap
      {
         return this._startMoveFuns;
      }
      
      public function get stopMoveFuns() : HashMap
      {
         return this._stopMoveFuns;
      }
      
      public function get startP() : Point
      {
         return this._startP;
      }
      
      public function get endP() : Point
      {
         return this._endP;
      }
      
      public function MoveTo(sx:int, sy:int, ex:int, ey:int) : void
      {
         var step:Object = null;
         if(!this._targetMC)
         {
            return;
         }
         var path:Array = GV.FindPath.getPath(sx,sy,ex,ey);
         this._path = new Array();
         for each(step in path)
         {
            this._path.push(new Point(step.X * this._gridSize,step.Y * this._gridSize));
         }
         this.StartMove();
      }
      
      private function StartMove() : void
      {
         if(!this._targetMC)
         {
            return;
         }
         if(this._path == null)
         {
            this._isMoveing = false;
         }
         else if(this._path.length > 0)
         {
            this._isMoveing = true;
            this.CallBackFuns(this._startMoveFuns);
            this._setDepthTimer = GC.setGInterval(this.SetDepth,500);
            this.MoveToNextStep();
         }
         else
         {
            GC.clearGInterval(this._setDepthTimer);
            this.SetDepth();
         }
      }
      
      private function MoveToNextStep() : void
      {
         if(this._speed == 0)
         {
            this._isMoveing = false;
            return;
         }
         if(Boolean(this._path) && this._path.length > 1)
         {
            this._startP = Point(this._path[0]).clone();
            this._endP = Point(this._path[1]).clone();
            this._path.shift();
            this.DoMove();
         }
         else
         {
            if(Boolean(this._tween))
            {
               TweenLite.removeTween(this._tween);
            }
            this._path = null;
            this._tween = null;
            this._isMoveing = false;
            GC.clearGInterval(this._setDepthTimer);
            this.CallBackFuns(this._stopMoveFuns);
         }
      }
      
      private function DoMove() : void
      {
         this.CallBackFuns(this._changeDirFuns);
         var moveTime:Number = this.getMoveTimer(this._startP,this._endP);
         if(moveTime == 0.1)
         {
            this.MoveToNextStep();
         }
         else
         {
            if(Boolean(this._tween))
            {
               TweenLite.removeTween(this._tween);
               this._tween = null;
            }
            this._tween = TweenLite.to(this._targetMC,moveTime,{
               "x":this._endP.x,
               "y":this._endP.y,
               "ease":Linear.easeNone,
               "onComplete":this.MoveToNextStep
            });
         }
      }
      
      private function getMoveTimer(startP:Point, endP:Point) : Number
      {
         var distance:Number = Point.distance(startP,endP);
         var time:Number = distance / this._speed;
         return time < 0.1 ? 0.1 : time;
      }
      
      private function SetDepth(e:* = null) : void
      {
         if(Boolean(this._targetMC.stage))
         {
            MapDepthManageLogic.setPeopleDepth(this._targetMC);
         }
      }
      
      public function stopToHere() : void
      {
         if(Boolean(this._tween))
         {
            TweenLite.removeTween(this._tween);
         }
         this._path = null;
         this._tween = null;
         this._isMoveing = false;
         GC.clearGInterval(this._setDepthTimer);
         this.SetDepth();
         this.CallBackFuns(this._breakMoveFuns);
      }
      
      private function CallBackFuns(funs:HashMap) : void
      {
         var key:Function = null;
         var keys:Array = funs.keys;
         for each(key in keys)
         {
            if(funs.getValue(key) is Boolean && funs.getValue(key) == true)
            {
               key(this);
            }
         }
      }
   }
}

