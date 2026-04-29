package fl.motion
{
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.utils.*;
   
   public class KeyframeBase
   {
      
      private var _index:int = -1;
      
      public var x:Number = NaN;
      
      public var y:Number = NaN;
      
      public var scaleX:Number = NaN;
      
      public var scaleY:Number = NaN;
      
      public var skewX:Number = NaN;
      
      public var skewY:Number = NaN;
      
      public var rotationConcat:Number = NaN;
      
      public var useRotationConcat:Boolean = false;
      
      [ArrayElementType("flash.filters.BitmapFilter")]
      public var filters:Array;
      
      public var color:Color;
      
      public var label:String = "";
      
      public var loop:String;
      
      public var firstFrame:String;
      
      public var cacheAsBitmap:Boolean = false;
      
      public var blendMode:String = "normal";
      
      public var rotateDirection:String = "auto";
      
      public var rotateTimes:uint = 0;
      
      public var orientToPath:Boolean = false;
      
      public var blank:Boolean = false;
      
      public var matrix3D:Object = null;
      
      public var matrix:Matrix = null;
      
      public var z:Number = NaN;
      
      public var rotationX:Number = NaN;
      
      public var rotationY:Number = NaN;
      
      public var adjustColorObjects:Dictionary = null;
      
      public function KeyframeBase(xml:XML = null)
      {
         super();
         this.filters = [];
         this.adjustColorObjects = new Dictionary();
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(value:int) : void
      {
         this._index = value < 0 ? 0 : value;
         if(this._index == 0)
         {
            this.setDefaults();
         }
      }
      
      public function get rotation() : Number
      {
         return this.skewY;
      }
      
      public function set rotation(value:Number) : void
      {
         if(isNaN(this.skewX) || isNaN(this.skewY))
         {
            this.skewX = value;
         }
         else
         {
            this.skewX += value - this.skewY;
         }
         this.skewY = value;
      }
      
      private function setDefaults() : void
      {
         if(isNaN(this.x))
         {
            this.x = 0;
         }
         if(isNaN(this.y))
         {
            this.y = 0;
         }
         if(isNaN(this.z))
         {
            this.z = 0;
         }
         if(isNaN(this.scaleX))
         {
            this.scaleX = 1;
         }
         if(isNaN(this.scaleY))
         {
            this.scaleY = 1;
         }
         if(isNaN(this.skewX))
         {
            this.skewX = 0;
         }
         if(isNaN(this.skewY))
         {
            this.skewY = 0;
         }
         if(isNaN(this.rotationConcat))
         {
            this.rotationConcat = 0;
         }
         if(!this.color)
         {
            this.color = new Color();
         }
      }
      
      public function getValue(tweenableName:String) : Number
      {
         return Number(this[tweenableName]);
      }
      
      public function setValue(tweenableName:String, newValue:Number) : void
      {
         this[tweenableName] = newValue;
      }
      
      protected function hasTween() : Boolean
      {
         return false;
      }
      
      public function affectsTweenable(tweenableName:String = "") : Boolean
      {
         return !tweenableName || !isNaN(this[tweenableName]) || tweenableName == "color" && this.color || tweenableName == "filters" && this.filters.length || tweenableName == "matrix3D" && this.matrix3D || tweenableName == "matrix" && this.matrix || this.blank || this.hasTween();
      }
      
      public function setAdjustColorProperty(filterIndex:int, propertyName:String, value:*) : void
      {
         var filter:ColorMatrixFilter = null;
         var flatArray:Array = null;
         if(filterIndex >= this.filters.length)
         {
            return;
         }
         var adjustColorObj:AdjustColor = this.adjustColorObjects[filterIndex];
         if(adjustColorObj == null)
         {
            adjustColorObj = new AdjustColor();
            this.adjustColorObjects[filterIndex] = adjustColorObj;
         }
         switch(propertyName)
         {
            case "adjustColorBrightness":
               adjustColorObj.brightness = value;
               break;
            case "adjustColorContrast":
               adjustColorObj.contrast = value;
               break;
            case "adjustColorSaturation":
               adjustColorObj.saturation = value;
               break;
            case "adjustColorHue":
               adjustColorObj.hue = value;
         }
         if(adjustColorObj.AllValuesAreSet())
         {
            filter = this.filters[filterIndex] as ColorMatrixFilter;
            if(Boolean(filter))
            {
               flatArray = adjustColorObj.CalculateFinalFlatArray();
               if(Boolean(flatArray))
               {
                  filter.matrix = flatArray;
               }
            }
         }
      }
      
      public function get tweensLength() : int
      {
         return 0;
      }
   }
}

