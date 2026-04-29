package fl.motion
{
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class Animator extends AnimatorBase
   {
      
      public function Animator(xml:XML = null, target:DisplayObject = null)
      {
         this.motion = new Motion(xml);
         super(xml,target);
      }
      
      public static function fromXMLString(xmlString:String, target:DisplayObject = null) : Animator
      {
         return new Animator(new XML(xmlString),target);
      }
      
      public static function matricesEqual(a:Matrix, b:Matrix) : Boolean
      {
         return a.a == b.a && a.b == b.b && a.c == b.c && a.d == b.d && a.tx == b.tx && a.ty == b.ty;
      }
      
      override public function set motion(value:MotionBase) : void
      {
         super.motion = value;
         var classicMotion:Motion = value as Motion;
         if(Boolean(classicMotion) && Boolean(classicMotion.source) && Boolean(classicMotion.source.transformationPoint))
         {
            this.transformationPoint = classicMotion.source.transformationPoint.clone();
         }
      }
      
      override protected function setTargetState() : void
      {
         this.targetState.scaleX = this._target.scaleX;
         this.targetState.scaleY = this._target.scaleY;
         this.targetState.skewX = MatrixTransformer.getSkewX(this._target.transform.matrix);
         this.targetState.skewY = MatrixTransformer.getSkewY(this._target.transform.matrix);
         this.targetState.bounds = this._target.getBounds(this._target);
         this.initTransformPointInternal(this._target.transform.matrix);
         this.targetState.z = 0;
         this.targetState.rotationX = this.targetState.rotationY = 0;
      }
      
      private function initTransformPointInternal(mat:Matrix) : void
      {
         var transformX:Number = NaN;
         var transformY:Number = NaN;
         var transformPointExternal:Point = null;
         var bounds:Object = this.targetState.bounds;
         if(Boolean(this.transformationPoint))
         {
            transformX = this.transformationPoint.x * bounds.width + bounds.left;
            transformY = this.transformationPoint.y * bounds.height + bounds.top;
            this.targetState.transformPointInternal = new Point(transformX,transformY);
            transformPointExternal = mat.transformPoint(this.targetState.transformPointInternal);
            this.targetState.x = transformPointExternal.x;
            this.targetState.y = transformPointExternal.y;
         }
         else
         {
            this.targetState.transformPointInternal = new Point(0,0);
            this.targetState.x = this._target.x;
            this.targetState.y = this._target.y;
         }
      }
      
      override protected function setTimeClassic(newTime:int, thisMotion:MotionBase, curKeyframe:KeyframeBase) : Boolean
      {
         var positionX:Number = NaN;
         var positionY:Number = NaN;
         var position:Point = null;
         var scaleX:Number = NaN;
         var scaleY:Number = NaN;
         var skewX:Number = NaN;
         var skewY:Number = NaN;
         var targetMatrix:Matrix = null;
         var useRotationConcat:Boolean = false;
         var transformationPointLocation:Point = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var positionX2:Number = NaN;
         var positionY2:Number = NaN;
         var pathAngle:Number = NaN;
         var rotMat:Matrix = null;
         var rotConcat:Number = NaN;
         var thisMotionClassic:Motion = thisMotion as Motion;
         if(!thisMotionClassic)
         {
            return false;
         }
         var matrix:Matrix = thisMotionClassic.getMatrix(newTime);
         if(Boolean(matrix))
         {
            if(!motionArray || !_lastMatrixApplied || !matricesEqual(matrix,_lastMatrixApplied))
            {
               this._target.transform.matrix = matrix;
               _lastMatrixApplied = matrix;
            }
         }
         else
         {
            if(Boolean(motionArray) && thisMotionClassic != _lastMotionUsed)
            {
               this.transformationPoint = Boolean(thisMotionClassic.motion_internal::transformationPoint) ? thisMotionClassic.motion_internal::transformationPoint : new Point(0.5,0.5);
               this.initTransformPointInternal(thisMotionClassic.motion_internal::initialMatrix);
               _lastMotionUsed = thisMotionClassic;
            }
            positionX = thisMotionClassic.getValue(newTime,Tweenables.X);
            positionY = thisMotionClassic.getValue(newTime,Tweenables.Y);
            position = new Point(positionX,positionY);
            if(Boolean(this.positionMatrix))
            {
               position = this.positionMatrix.transformPoint(position);
            }
            position.x += this.targetState.x;
            position.y += this.targetState.y;
            scaleX = thisMotionClassic.getValue(newTime,Tweenables.SCALE_X) * this.targetState.scaleX;
            scaleY = thisMotionClassic.getValue(newTime,Tweenables.SCALE_Y) * this.targetState.scaleY;
            skewX = 0;
            skewY = 0;
            if(this.orientToPath)
            {
               positionX2 = thisMotionClassic.getValue(newTime + 1,Tweenables.X);
               positionY2 = thisMotionClassic.getValue(newTime + 1,Tweenables.Y);
               pathAngle = Math.atan2(positionY2 - positionY,positionX2 - positionX) * (180 / Math.PI);
               if(!isNaN(pathAngle))
               {
                  skewX = pathAngle + this.targetState.skewX;
                  skewY = pathAngle + this.targetState.skewY;
               }
            }
            else
            {
               skewX = thisMotionClassic.getValue(newTime,Tweenables.SKEW_X) + this.targetState.skewX;
               skewY = thisMotionClassic.getValue(newTime,Tweenables.SKEW_Y) + this.targetState.skewY;
            }
            targetMatrix = new Matrix(scaleX * Math.cos(skewY * (Math.PI / 180)),scaleX * Math.sin(skewY * (Math.PI / 180)),-scaleY * Math.sin(skewX * (Math.PI / 180)),scaleY * Math.cos(skewX * (Math.PI / 180)),0,0);
            useRotationConcat = false;
            if(thisMotionClassic.useRotationConcat(newTime))
            {
               rotMat = new Matrix();
               rotConcat = thisMotionClassic.getValue(newTime,Tweenables.ROTATION_CONCAT);
               rotMat.rotate(rotConcat);
               targetMatrix.concat(rotMat);
               useRotationConcat = true;
            }
            targetMatrix.tx = position.x;
            targetMatrix.ty = position.y;
            transformationPointLocation = targetMatrix.transformPoint(this.targetState.transformPointInternal);
            dx = targetMatrix.tx - transformationPointLocation.x;
            dy = targetMatrix.ty - transformationPointLocation.y;
            targetMatrix.tx += dx;
            targetMatrix.ty += dy;
            if(!motionArray || !_lastMatrixApplied || !matricesEqual(targetMatrix,_lastMatrixApplied))
            {
               if(!useRotationConcat)
               {
                  this._target.rotation = skewY;
               }
               this._target.transform.matrix = targetMatrix;
               if(useRotationConcat && this._target.scaleX == 0 && this._target.scaleY == 0)
               {
                  this._target.scaleX = scaleX;
                  this._target.scaleY = scaleY;
               }
               _lastMatrixApplied = targetMatrix;
            }
         }
         if(_lastCacheAsBitmapApplied != curKeyframe.cacheAsBitmap || !_cacheAsBitmapHasBeenApplied)
         {
            this._target.cacheAsBitmap = curKeyframe.cacheAsBitmap;
            _cacheAsBitmapHasBeenApplied = true;
            _lastCacheAsBitmapApplied = curKeyframe.cacheAsBitmap;
         }
         return true;
      }
   }
}

