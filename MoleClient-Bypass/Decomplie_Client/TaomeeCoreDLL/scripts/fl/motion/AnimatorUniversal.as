package fl.motion
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class AnimatorUniversal extends Animator3D
   {
      
      public function AnimatorUniversal()
      {
         super(null,null);
         this._isAnimator3D = false;
      }
      
      override protected function setTargetState() : void
      {
         super.setTargetState();
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
         if(thisMotion.is3D)
         {
            return setTime3D(newTime,thisMotion);
         }
         var matrix:Matrix = thisMotion.getMatrix(newTime);
         if(Boolean(matrix))
         {
            if(!motionArray || !_lastMatrixApplied || !Animator.matricesEqual(matrix,_lastMatrixApplied))
            {
               this._target.transform.matrix = matrix;
               _lastMatrixApplied = matrix;
            }
         }
         else
         {
            if(Boolean(motionArray) && thisMotion != _lastMotionUsed)
            {
               this.transformationPoint = Boolean(thisMotion.motion_internal::transformationPoint) ? thisMotion.motion_internal::transformationPoint : new Point(0.5,0.5);
               this.initTransformPointInternal(thisMotion.motion_internal::initialMatrix);
               _lastMotionUsed = thisMotion;
            }
            positionX = thisMotion.getValue(newTime,Tweenables.X);
            positionY = thisMotion.getValue(newTime,Tweenables.Y);
            position = new Point(positionX,positionY);
            if(Boolean(this.positionMatrix))
            {
               position = this.positionMatrix.transformPoint(position);
            }
            position.x += this.targetState.x;
            position.y += this.targetState.y;
            scaleX = thisMotion.getValue(newTime,Tweenables.SCALE_X) * this.targetState.scaleX;
            scaleY = thisMotion.getValue(newTime,Tweenables.SCALE_Y) * this.targetState.scaleY;
            skewX = 0;
            skewY = 0;
            if(this.orientToPath)
            {
               positionX2 = thisMotion.getValue(newTime + 1,Tweenables.X);
               positionY2 = thisMotion.getValue(newTime + 1,Tweenables.Y);
               pathAngle = Math.atan2(positionY2 - positionY,positionX2 - positionX) * (180 / Math.PI);
               if(!isNaN(pathAngle))
               {
                  skewX = pathAngle + this.targetState.skewX;
                  skewY = pathAngle + this.targetState.skewY;
               }
            }
            else
            {
               skewX = thisMotion.getValue(newTime,Tweenables.SKEW_X) + this.targetState.skewX;
               skewY = thisMotion.getValue(newTime,Tweenables.SKEW_Y) + this.targetState.skewY;
            }
            targetMatrix = new Matrix(scaleX * Math.cos(skewY * (Math.PI / 180)),scaleX * Math.sin(skewY * (Math.PI / 180)),-scaleY * Math.sin(skewX * (Math.PI / 180)),scaleY * Math.cos(skewX * (Math.PI / 180)),0,0);
            useRotationConcat = false;
            if(thisMotion.useRotationConcat(newTime))
            {
               rotMat = new Matrix();
               rotConcat = thisMotion.getValue(newTime,Tweenables.ROTATION_CONCAT);
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
            if(!motionArray || !_lastMatrixApplied || !Animator.matricesEqual(targetMatrix,_lastMatrixApplied))
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

