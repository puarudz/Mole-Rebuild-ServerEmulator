package fl.motion
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class Animator3D extends AnimatorBase
   {
      
      private static var IDENTITY_MATRIX:Matrix = new Matrix();
      
      protected static const EPSILON:Number = 1e-8;
      
      private var _initialPosition:Vector3D;
      
      private var _initialMatrixOfTarget:Matrix3D;
      
      public function Animator3D(xml:XML = null, target:DisplayObject = null)
      {
         super(xml,target);
         this.transformationPoint = new Point(0,0);
         this._initialPosition = null;
         this._initialMatrixOfTarget = null;
         this._isAnimator3D = true;
      }
      
      protected static function getSign(n:Number) : int
      {
         return n < -EPSILON ? -1 : (n > EPSILON ? 1 : 0);
      }
      
      protected static function convertMatrixToMatrix3D(mat2D:Matrix) : Matrix3D
      {
         var vec3D:Vector.<Number> = new Vector.<Number>(16);
         vec3D[0] = mat2D.a;
         vec3D[1] = mat2D.b;
         vec3D[2] = 0;
         vec3D[3] = 0;
         vec3D[4] = mat2D.c;
         vec3D[5] = mat2D.d;
         vec3D[6] = 0;
         vec3D[7] = 0;
         vec3D[8] = 0;
         vec3D[9] = 0;
         vec3D[10] = 1;
         vec3D[11] = 0;
         vec3D[12] = mat2D.tx;
         vec3D[13] = mat2D.ty;
         vec3D[14] = 0;
         vec3D[15] = 1;
         return new Matrix3D(vec3D);
      }
      
      protected static function matrices3DEqual(a:Matrix3D, b:Matrix3D) : Boolean
      {
         var aRaw:Vector.<Number> = a.rawData;
         var bRaw:Vector.<Number> = b.rawData;
         if(aRaw == null || aRaw.length != 16 || bRaw == null || bRaw.length != 16)
         {
            return false;
         }
         for(var i:int = 0; i < 16; i++)
         {
            if(aRaw[i] != bRaw[i])
            {
               return false;
            }
         }
         return true;
      }
      
      override public function set initialPosition(initPos:Array) : void
      {
         if(initPos.length == 3)
         {
            this._initialPosition = new Vector3D();
            this._initialPosition.x = initPos[0];
            this._initialPosition.y = initPos[1];
            this._initialPosition.z = initPos[2];
         }
      }
      
      override protected function setTargetState() : void
      {
         if(!motionArray && this._target.transform.matrix != null)
         {
            this._initialMatrixOfTarget = convertMatrixToMatrix3D(this._target.transform.matrix);
         }
      }
      
      override protected function setTime3D(newTime:int, thisMotion:MotionBase) : Boolean
      {
         var newMat3D:Matrix3D = null;
         var frameMat3D:Matrix3D = null;
         var rotX:Number = NaN;
         var rotY:Number = NaN;
         var rotZ:Number = NaN;
         var transX:Number = NaN;
         var transY:Number = NaN;
         var transZ:Number = NaN;
         var scaleSkewMat2D:Matrix = null;
         var scaleSkewMat:Matrix3D = null;
         var matrix3D:Matrix3D = thisMotion.getMatrix3D(newTime) as Matrix3D;
         if(Boolean(motionArray) && thisMotion != _lastMotionUsed)
         {
            this.transformationPoint = Boolean(thisMotion.motion_internal::transformationPoint) ? thisMotion.motion_internal::transformationPoint : new Point(0,0);
            if(Boolean(thisMotion.motion_internal::initialPosition))
            {
               this.initialPosition = thisMotion.motion_internal::initialPosition;
            }
            else
            {
               this._initialPosition = null;
            }
            _lastMotionUsed = thisMotion;
         }
         if(Boolean(matrix3D))
         {
            if(!motionArray || !_lastMatrix3DApplied || !matrices3DEqual(matrix3D,Matrix3D(_lastMatrix3DApplied)))
            {
               newMat3D = matrix3D.clone();
               if(Boolean(this._initialMatrixOfTarget))
               {
                  newMat3D.append(this._initialMatrixOfTarget);
               }
               this._target.transform.matrix3D = newMat3D;
               _lastMatrix3DApplied = matrix3D;
            }
            return true;
         }
         if(thisMotion.is3D)
         {
            frameMat3D = new Matrix3D();
            rotX = thisMotion.getValue(newTime,Tweenables.ROTATION_X) * Math.PI / 180;
            rotY = thisMotion.getValue(newTime,Tweenables.ROTATION_Y) * Math.PI / 180;
            rotZ = thisMotion.getValue(newTime,Tweenables.ROTATION_CONCAT) * Math.PI / 180;
            frameMat3D.prepend(MatrixTransformer3D.rotateAboutAxis(rotZ,MatrixTransformer3D.AXIS_Z));
            frameMat3D.prepend(MatrixTransformer3D.rotateAboutAxis(rotY,MatrixTransformer3D.AXIS_Y));
            frameMat3D.prepend(MatrixTransformer3D.rotateAboutAxis(rotX,MatrixTransformer3D.AXIS_X));
            transX = thisMotion.getValue(newTime,Tweenables.X);
            transY = thisMotion.getValue(newTime,Tweenables.Y);
            transZ = thisMotion.getValue(newTime,Tweenables.Z);
            if(getSign(transX) != 0 || getSign(transY) != 0 || getSign(transZ) != 0)
            {
               frameMat3D.appendTranslation(transX,transY,transZ);
            }
            frameMat3D.prependTranslation(-this.transformationPoint.x,-this.transformationPoint.y,-this.transformationPointZ);
            if(Boolean(this._initialPosition))
            {
               frameMat3D.appendTranslation(this._initialPosition.x,this._initialPosition.y,this._initialPosition.z);
            }
            scaleSkewMat2D = this.getScaleSkewMatrix(thisMotion,newTime,this.transformationPoint.x,this.transformationPoint.y);
            scaleSkewMat = convertMatrixToMatrix3D(scaleSkewMat2D);
            frameMat3D.prepend(scaleSkewMat);
            if(Boolean(this._initialMatrixOfTarget))
            {
               frameMat3D.append(this._initialMatrixOfTarget);
            }
            if(!motionArray || !_lastMatrix3DApplied || !matrices3DEqual(frameMat3D,Matrix3D(_lastMatrix3DApplied)))
            {
               this._target.transform.matrix3D = frameMat3D;
               _lastMatrix3DApplied = frameMat3D;
            }
         }
         return false;
      }
      
      override protected function removeChildTarget(parent:MovieClip, child:DisplayObject, childName:String) : void
      {
         super.removeChildTarget(parent,child,childName);
         if(child.transform.matrix3D != null)
         {
            child.transform.matrix = IDENTITY_MATRIX;
         }
      }
      
      private function getScaleSkewMatrix(thisMotion:MotionBase, newTime:int, positionX:Number, positionY:Number) : Matrix
      {
         var scaleX:Number = thisMotion.getValue(newTime,Tweenables.SCALE_X);
         var scaleY:Number = thisMotion.getValue(newTime,Tweenables.SCALE_Y);
         var skewX:Number = thisMotion.getValue(newTime,Tweenables.SKEW_X);
         var skewY:Number = thisMotion.getValue(newTime,Tweenables.SKEW_Y);
         var targetMatrix:Matrix = new Matrix();
         targetMatrix.translate(-positionX,-positionY);
         var scaleMat:Matrix = new Matrix();
         scaleMat.scale(scaleX,scaleY);
         targetMatrix.concat(scaleMat);
         var skewMat:Matrix = new Matrix();
         skewMat.a = Math.cos(skewY * (Math.PI / 180));
         skewMat.b = Math.sin(skewY * (Math.PI / 180));
         skewMat.c = -Math.sin(skewX * (Math.PI / 180));
         skewMat.d = Math.cos(skewX * (Math.PI / 180));
         targetMatrix.concat(skewMat);
         targetMatrix.translate(positionX,positionY);
         return targetMatrix;
      }
   }
}

