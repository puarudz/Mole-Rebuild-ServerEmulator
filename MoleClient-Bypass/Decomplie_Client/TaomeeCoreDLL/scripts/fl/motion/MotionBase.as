package fl.motion
{
   import flash.filters.*;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.*;
   
   use namespace motion_internal;
   
   public class MotionBase
   {
      
      public var keyframes:Array;
      
      private var _spanStart:int;
      
      private var _transformationPoint:Point;
      
      private var _transformationPointZ:int;
      
      private var _initialPosition:Array;
      
      private var _initialMatrix:Matrix;
      
      private var _duration:int = 0;
      
      private var _is3D:Boolean = false;
      
      private var _overrideScale:Boolean;
      
      private var _overrideSkew:Boolean;
      
      private var _overrideRotate:Boolean;
      
      public function MotionBase(xml:XML = null)
      {
         var kf:KeyframeBase = null;
         super();
         this.keyframes = [];
         if(this.duration == 0)
         {
            kf = this.getNewKeyframe();
            kf.index = 0;
            this.addKeyframe(kf);
         }
         this._overrideScale = false;
         this._overrideSkew = false;
         this._overrideRotate = false;
      }
      
      motion_internal function set spanStart(v:int) : void
      {
         this._spanStart = v;
      }
      
      motion_internal function get spanStart() : int
      {
         return this._spanStart;
      }
      
      motion_internal function set transformationPoint(v:Point) : void
      {
         this._transformationPoint = v;
      }
      
      motion_internal function get transformationPoint() : Point
      {
         return this._transformationPoint;
      }
      
      motion_internal function set transformationPointZ(v:int) : void
      {
         this._transformationPointZ = v;
      }
      
      motion_internal function get transformationPointZ() : int
      {
         return this._transformationPointZ;
      }
      
      motion_internal function set initialPosition(v:Array) : void
      {
         this._initialPosition = v;
      }
      
      motion_internal function get initialPosition() : Array
      {
         return this._initialPosition;
      }
      
      motion_internal function set initialMatrix(v:Matrix) : void
      {
         this._initialMatrix = v;
      }
      
      motion_internal function get initialMatrix() : Matrix
      {
         return this._initialMatrix;
      }
      
      public function get duration() : int
      {
         if(this._duration < this.keyframes.length)
         {
            this._duration = this.keyframes.length;
         }
         return this._duration;
      }
      
      public function set duration(value:int) : void
      {
         if(value < this.keyframes.length)
         {
            value = int(this.keyframes.length);
         }
         this._duration = value;
      }
      
      public function get is3D() : Boolean
      {
         return this._is3D;
      }
      
      public function set is3D(enable:Boolean) : void
      {
         this._is3D = enable;
      }
      
      public function overrideTargetTransform(scale:Boolean = true, skew:Boolean = true, rotate:Boolean = true) : void
      {
         this._overrideScale = scale;
         this._overrideSkew = skew;
         this._overrideRotate = rotate;
      }
      
      private function indexOutOfRange(index:int) : Boolean
      {
         return isNaN(index) || index < 0 || index > this.duration - 1;
      }
      
      public function getCurrentKeyframe(index:int, tweenableName:String = "") : KeyframeBase
      {
         var kf:KeyframeBase = null;
         if(isNaN(index) || index < 0 || index > this.duration - 1)
         {
            return null;
         }
         for(var i:int = index; i > 0; i--)
         {
            kf = this.keyframes[i];
            if(Boolean(kf) && kf.affectsTweenable(tweenableName))
            {
               return kf;
            }
         }
         return this.keyframes[0];
      }
      
      public function getNextKeyframe(index:int, tweenableName:String = "") : KeyframeBase
      {
         var kf:KeyframeBase = null;
         if(isNaN(index) || index < 0 || index > this.duration - 1)
         {
            return null;
         }
         for(var i:int = index + 1; i < this.keyframes.length; i++)
         {
            kf = this.keyframes[i];
            if(Boolean(kf) && kf.affectsTweenable(tweenableName))
            {
               return kf;
            }
         }
         return null;
      }
      
      public function setValue(index:int, tweenableName:String, value:Number) : void
      {
         if(index == 0)
         {
            return;
         }
         var kf:KeyframeBase = this.keyframes[index];
         if(!kf)
         {
            kf = this.getNewKeyframe();
            kf.index = index;
            this.addKeyframe(kf);
         }
         kf.setValue(tweenableName,value);
      }
      
      public function getColorTransform(index:int) : ColorTransform
      {
         var result:ColorTransform = null;
         var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index,"color");
         if(!curKeyframe || !curKeyframe.color)
         {
            return null;
         }
         var begin:ColorTransform = curKeyframe.color;
         var timeFromKeyframe:Number = index - curKeyframe.index;
         if(timeFromKeyframe == 0)
         {
            result = begin;
         }
         return result;
      }
      
      public function getMatrix3D(index:int) : Object
      {
         var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index,"matrix3D");
         return Boolean(curKeyframe) ? curKeyframe.matrix3D : null;
      }
      
      public function getMatrix(index:int) : Matrix
      {
         var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index,"matrix");
         return Boolean(curKeyframe) ? curKeyframe.matrix : null;
      }
      
      public function useRotationConcat(index:int) : Boolean
      {
         var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index,"rotationConcat");
         return Boolean(curKeyframe) ? curKeyframe.useRotationConcat : false;
      }
      
      public function getFilters(index:Number) : Array
      {
         var result:Array = null;
         var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index,"filters");
         if(!curKeyframe || Boolean(curKeyframe.filters) && Boolean(!curKeyframe.filters.length))
         {
            return [];
         }
         var begin:Array = curKeyframe.filters;
         var timeFromKeyframe:Number = index - curKeyframe.index;
         if(timeFromKeyframe == 0)
         {
            result = begin;
         }
         return result;
      }
      
      protected function findTweenedValue(index:Number, tweenableName:String, curKeyframeBase:KeyframeBase, timeFromKeyframe:Number, begin:Number) : Number
      {
         return NaN;
      }
      
      public function getValue(index:Number, tweenableName:String) : Number
      {
         var result:Number = NaN;
         var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index,tweenableName);
         if(!curKeyframe || curKeyframe.blank)
         {
            return NaN;
         }
         var begin:Number = curKeyframe.getValue(tweenableName);
         if(isNaN(begin) && curKeyframe.index > 0)
         {
            begin = this.getValue(curKeyframe.index - 1,tweenableName);
         }
         if(isNaN(begin))
         {
            return NaN;
         }
         var timeFromKeyframe:Number = index - curKeyframe.index;
         if(timeFromKeyframe == 0)
         {
            return begin;
         }
         return this.findTweenedValue(index,tweenableName,curKeyframe,timeFromKeyframe,begin);
      }
      
      public function addKeyframe(newKeyframe:KeyframeBase) : void
      {
         this.keyframes[newKeyframe.index] = newKeyframe;
         if(this.duration < this.keyframes.length)
         {
            this.duration = this.keyframes.length;
         }
      }
      
      public function addPropertyArray(name:String, values:Array, startFrame:int = -1, endFrame:int = -1) : void
      {
         var kf:KeyframeBase = null;
         var curValue:* = undefined;
         var valueIndex:int = 0;
         var newValue:* = undefined;
         var numValues:int = int(values.length);
         var lastValue:* = null;
         var useLastValue:Boolean = true;
         var startNumValue:Number = 0;
         if(numValues > 0)
         {
            if(values[0] is Number)
            {
               useLastValue = false;
               if(values[0] is Number)
               {
                  startNumValue = Number(values[0]);
               }
            }
         }
         if(this.duration < numValues)
         {
            this.duration = numValues;
         }
         if(startFrame == -1 || endFrame == -1)
         {
            startFrame = 0;
            endFrame = this.duration;
         }
         for(var i:int = startFrame; i < endFrame; i++)
         {
            kf = KeyframeBase(this.keyframes[i]);
            if(kf == null)
            {
               kf = this.getNewKeyframe();
               kf.index = i;
               this.addKeyframe(kf);
            }
            if(Boolean(kf.filters) && kf.filters.length == 0)
            {
               kf.filters = null;
            }
            curValue = lastValue;
            valueIndex = i - startFrame;
            if(valueIndex < values.length)
            {
               if(Boolean(values[valueIndex]) || !useLastValue)
               {
                  curValue = values[valueIndex];
               }
            }
            switch(name)
            {
               case "blendMode":
               case "matrix3D":
               case "matrix":
                  kf[name] = curValue;
                  break;
               case "rotationConcat":
                  kf.useRotationConcat = true;
                  if(!this._overrideRotate && !useLastValue)
                  {
                     kf.setValue(name,(curValue - startNumValue) * Math.PI / 180);
                  }
                  else
                  {
                     kf.setValue(name,curValue * Math.PI / 180);
                  }
                  break;
               case "brightness":
               case "tintMultiplier":
               case "tintColor":
               case "alphaMultiplier":
               case "alphaOffset":
               case "redMultiplier":
               case "redOffset":
               case "greenMultiplier":
               case "greenOffset":
               case "blueMultiplier":
               case "blueOffset":
                  if(kf.color == null)
                  {
                     kf.color = new Color();
                  }
                  kf.color[name] = curValue;
                  break;
               case "rotationZ":
                  kf.useRotationConcat = true;
                  this._is3D = true;
                  if(!this._overrideRotate && !useLastValue)
                  {
                     kf.setValue("rotationConcat",curValue - startNumValue);
                  }
                  else
                  {
                     kf.setValue("rotationConcat",curValue);
                  }
                  break;
               case "rotationX":
               case "rotationY":
               case "z":
                  this._is3D = true;
                  newValue = curValue;
                  if(!useLastValue)
                  {
                     switch(name)
                     {
                        case "scaleX":
                        case "scaleY":
                           if(!this._overrideScale)
                           {
                              if(startNumValue == 0)
                              {
                                 newValue = curValue + 1;
                              }
                              else
                              {
                                 newValue = curValue / startNumValue;
                              }
                           }
                           break;
                        case "skewX":
                        case "skewY":
                           if(!this._overrideSkew)
                           {
                              newValue = curValue - startNumValue;
                           }
                           break;
                        case "rotationX":
                        case "rotationY":
                           if(!this._overrideRotate)
                           {
                              newValue = curValue - startNumValue;
                           }
                     }
                  }
            }
            kf.setValue(name,newValue);
            lastValue = curValue;
         }
      }
      
      public function initFilters(filterClasses:Array, gradientSubarrayLengths:Array, startFrame:int = -1, endFrame:int = -1) : void
      {
         var filterClass:Class = null;
         var i:int = 0;
         var kf:KeyframeBase = null;
         var filter:BitmapFilter = null;
         var subarrayLength:int = 0;
         if(startFrame == -1 || endFrame == -1)
         {
            startFrame = 0;
            endFrame = this.duration;
         }
         for(var j:int = 0; j < filterClasses.length; j++)
         {
            filterClass = getDefinitionByName(filterClasses[j]) as Class;
            for(i = startFrame; i < endFrame; i++)
            {
               kf = KeyframeBase(this.keyframes[i]);
               if(kf == null)
               {
                  kf = this.getNewKeyframe();
                  kf.index = i;
                  this.addKeyframe(kf);
               }
               if(Boolean(kf) && kf.filters == null)
               {
                  kf.filters = new Array();
               }
               if(Boolean(kf) && Boolean(kf.filters))
               {
                  filter = null;
                  switch(filterClasses[j])
                  {
                     case "flash.filters.GradientBevelFilter":
                     case "flash.filters.GradientGlowFilter":
                        subarrayLength = int(gradientSubarrayLengths[j]);
                        filter = BitmapFilter(new filterClass(4,45,new Array(subarrayLength),new Array(subarrayLength),new Array(subarrayLength)));
                        break;
                     default:
                        filter = BitmapFilter(new filterClass());
                  }
                  if(Boolean(filter))
                  {
                     kf.filters.push(filter);
                  }
               }
            }
         }
      }
      
      public function addFilterPropertyArray(index:int, name:String, values:Array, startFrame:int = -1, endFrame:int = -1) : void
      {
         var kf:KeyframeBase = null;
         var curValue:* = undefined;
         var valueIndex:int = 0;
         var numValues:int = int(values.length);
         var lastValue:* = null;
         var useLastValue:Boolean = true;
         if(numValues > 0)
         {
            if(values[0] is Number)
            {
               useLastValue = false;
            }
         }
         if(this.duration < numValues)
         {
            this.duration = numValues;
         }
         if(startFrame == -1 || endFrame == -1)
         {
            startFrame = 0;
            endFrame = this.duration;
         }
         for(var i:int = startFrame; i < endFrame; i++)
         {
            kf = KeyframeBase(this.keyframes[i]);
            if(kf == null)
            {
               kf = this.getNewKeyframe();
               kf.index = i;
               this.addKeyframe(kf);
            }
            curValue = lastValue;
            valueIndex = i - startFrame;
            if(valueIndex < values.length)
            {
               if(Boolean(values[valueIndex]) || !useLastValue)
               {
                  curValue = values[valueIndex];
               }
            }
            switch(name)
            {
               case "adjustColorBrightness":
               case "adjustColorContrast":
               case "adjustColorSaturation":
               case "adjustColorHue":
                  kf.setAdjustColorProperty(index,name,curValue);
                  break;
               default:
                  if(index < kf.filters.length)
                  {
                     kf.filters[index][name] = curValue;
                  }
            }
            lastValue = curValue;
         }
      }
      
      protected function getNewKeyframe(xml:XML = null) : KeyframeBase
      {
         return new KeyframeBase(xml);
      }
   }
}

