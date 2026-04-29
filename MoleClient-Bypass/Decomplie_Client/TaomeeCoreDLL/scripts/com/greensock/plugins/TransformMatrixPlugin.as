package com.greensock.plugins
{
   import com.greensock.*;
   import flash.geom.Matrix;
   import flash.geom.Transform;
   
   public class TransformMatrixPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      private static const _DEG2RAD:Number = Math.PI / 180;
      
      protected var _transform:Transform;
      
      protected var _matrix:Matrix;
      
      protected var _txStart:Number;
      
      protected var _txChange:Number;
      
      protected var _tyStart:Number;
      
      protected var _tyChange:Number;
      
      protected var _aStart:Number;
      
      protected var _aChange:Number;
      
      protected var _bStart:Number;
      
      protected var _bChange:Number;
      
      protected var _cStart:Number;
      
      protected var _cChange:Number;
      
      protected var _dStart:Number;
      
      protected var _dChange:Number;
      
      protected var _angleChange:Number = 0;
      
      public function TransformMatrixPlugin()
      {
         super();
         this.propName = "transformMatrix";
         this.overwriteProps = ["x","y","scaleX","scaleY","rotation","transformMatrix","transformAroundPoint","transformAroundCenter","shortRotation"];
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         var ratioX:Number = NaN;
         var ratioY:Number = NaN;
         var scaleX:Number = NaN;
         var scaleY:Number = NaN;
         var angle:Number = NaN;
         var skewX:Number = NaN;
         var finalAngle:Number = NaN;
         var finalSkewX:Number = NaN;
         var dif:Number = NaN;
         var skewY:Number = NaN;
         this._transform = target.transform as Transform;
         this._matrix = this._transform.matrix;
         var matrix:Matrix = this._matrix.clone();
         this._txStart = matrix.tx;
         this._tyStart = matrix.ty;
         this._aStart = matrix.a;
         this._bStart = matrix.b;
         this._cStart = matrix.c;
         this._dStart = matrix.d;
         if("x" in value)
         {
            this._txChange = typeof value.x == "number" ? value.x - this._txStart : Number(value.x);
         }
         else if("tx" in value)
         {
            this._txChange = value.tx - this._txStart;
         }
         else
         {
            this._txChange = 0;
         }
         if("y" in value)
         {
            this._tyChange = typeof value.y == "number" ? value.y - this._tyStart : Number(value.y);
         }
         else if("ty" in value)
         {
            this._tyChange = value.ty - this._tyStart;
         }
         else
         {
            this._tyChange = 0;
         }
         this._aChange = "a" in value ? value.a - this._aStart : 0;
         this._bChange = "b" in value ? value.b - this._bStart : 0;
         this._cChange = "c" in value ? value.c - this._cStart : 0;
         this._dChange = "d" in value ? value.d - this._dStart : 0;
         if("rotation" in value || "shortRotation" in value || "scale" in value && !(value is Matrix) || "scaleX" in value || "scaleY" in value || "skewX" in value || "skewY" in value || "skewX2" in value || "skewY2" in value)
         {
            scaleX = Math.sqrt(matrix.a * matrix.a + matrix.b * matrix.b);
            if(matrix.a < 0 && matrix.d > 0)
            {
               scaleX = -scaleX;
            }
            scaleY = Math.sqrt(matrix.c * matrix.c + matrix.d * matrix.d);
            if(matrix.d < 0 && matrix.a > 0)
            {
               scaleY = -scaleY;
            }
            angle = Math.atan2(matrix.b,matrix.a);
            if(matrix.a < 0 && matrix.d >= 0)
            {
               angle += angle <= 0 ? Math.PI : -Math.PI;
            }
            skewX = Math.atan2(-this._matrix.c,this._matrix.d) - angle;
            finalAngle = angle;
            if("shortRotation" in value)
            {
               dif = (value.shortRotation * _DEG2RAD - angle) % (Math.PI * 2);
               if(dif > Math.PI)
               {
                  dif -= Math.PI * 2;
               }
               else if(dif < -Math.PI)
               {
                  dif += Math.PI * 2;
               }
               finalAngle += dif;
            }
            else if("rotation" in value)
            {
               finalAngle = typeof value.rotation == "number" ? value.rotation * _DEG2RAD : Number(value.rotation) * _DEG2RAD + angle;
            }
            finalSkewX = "skewX" in value ? (typeof value.skewX == "number" ? Number(value.skewX) * _DEG2RAD : Number(value.skewX) * _DEG2RAD + skewX) : 0;
            if("skewY" in value)
            {
               skewY = typeof value.skewY == "number" ? value.skewY * _DEG2RAD : Number(value.skewY) * _DEG2RAD - skewX;
               finalAngle += skewY + skewX;
               finalSkewX -= skewY;
            }
            if(finalAngle != angle)
            {
               if("rotation" in value || "shortRotation" in value)
               {
                  this._angleChange = finalAngle - angle;
                  finalAngle = angle;
               }
               else
               {
                  matrix.rotate(finalAngle - angle);
               }
            }
            if("scale" in value)
            {
               ratioX = Number(value.scale) / scaleX;
               ratioY = Number(value.scale) / scaleY;
               if(typeof value.scale != "number")
               {
                  ratioX += 1;
                  ratioY += 1;
               }
            }
            else
            {
               if("scaleX" in value)
               {
                  ratioX = Number(value.scaleX) / scaleX;
                  if(typeof value.scaleX != "number")
                  {
                     ratioX += 1;
                  }
               }
               if("scaleY" in value)
               {
                  ratioY = Number(value.scaleY) / scaleY;
                  if(typeof value.scaleY != "number")
                  {
                     ratioY += 1;
                  }
               }
            }
            if(finalSkewX != skewX)
            {
               matrix.c = -scaleY * Math.sin(finalSkewX + finalAngle);
               matrix.d = scaleY * Math.cos(finalSkewX + finalAngle);
            }
            if("skewX2" in value)
            {
               if(typeof value.skewX2 == "number")
               {
                  matrix.c = Math.tan(0 - value.skewX2 * _DEG2RAD);
               }
               else
               {
                  matrix.c += Math.tan(0 - Number(value.skewX2) * _DEG2RAD);
               }
            }
            if("skewY2" in value)
            {
               if(typeof value.skewY2 == "number")
               {
                  matrix.b = Math.tan(value.skewY2 * _DEG2RAD);
               }
               else
               {
                  matrix.b += Math.tan(Number(value.skewY2) * _DEG2RAD);
               }
            }
            if(Boolean(ratioX) || ratioX == 0)
            {
               matrix.a *= ratioX;
               matrix.b *= ratioX;
            }
            if(Boolean(ratioY) || ratioY == 0)
            {
               matrix.c *= ratioY;
               matrix.d *= ratioY;
            }
            this._aChange = matrix.a - this._aStart;
            this._bChange = matrix.b - this._bStart;
            this._cChange = matrix.c - this._cStart;
            this._dChange = matrix.d - this._dStart;
         }
         return true;
      }
      
      override public function set changeFactor(n:Number) : void
      {
         var cos:Number = NaN;
         var sin:Number = NaN;
         var a:Number = NaN;
         var c:Number = NaN;
         this._matrix.a = this._aStart + n * this._aChange;
         this._matrix.b = this._bStart + n * this._bChange;
         this._matrix.c = this._cStart + n * this._cChange;
         this._matrix.d = this._dStart + n * this._dChange;
         if(Boolean(this._angleChange))
         {
            cos = Math.cos(this._angleChange * n);
            sin = Math.sin(this._angleChange * n);
            a = this._matrix.a;
            c = this._matrix.c;
            this._matrix.a = a * cos - this._matrix.b * sin;
            this._matrix.b = a * sin + this._matrix.b * cos;
            this._matrix.c = c * cos - this._matrix.d * sin;
            this._matrix.d = c * sin + this._matrix.d * cos;
         }
         this._matrix.tx = this._txStart + n * this._txChange;
         this._matrix.ty = this._tyStart + n * this._tyChange;
         this._transform.matrix = this._matrix;
      }
   }
}

