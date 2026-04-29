package fl.motion
{
   import flash.filters.*;
   import flash.geom.ColorTransform;
   import flash.utils.*;
   
   [DefaultProperty("keyframesCompact")]
   public class Motion extends MotionBase
   {
      
      private static var typeCache:Object = {};
      
      public var source:Source;
      
      private var _keyframesCompact:Array;
      
      public function Motion(xml:XML = null)
      {
         var kf:Keyframe = null;
         super();
         this.keyframes = [];
         this.parseXML(xml);
         if(!this.source)
         {
            this.source = new Source();
         }
         if(this.duration == 0)
         {
            kf = this.getNewKeyframe() as Keyframe;
            kf.index = 0;
            this.addKeyframe(kf);
         }
      }
      
      public static function fromXMLString(xmlString:String) : Motion
      {
         var xml:XML = new XML(xmlString);
         return new Motion(xml);
      }
      
      public static function interpolateFilters(fromFilters:Array, toFilters:Array, progress:Number) : Array
      {
         var fromFilter:BitmapFilter = null;
         var toFilter:BitmapFilter = null;
         var resultFilter:BitmapFilter = null;
         if(fromFilters.length != toFilters.length)
         {
            return null;
         }
         var resultFilters:Array = [];
         for(var i:int = 0; i < fromFilters.length; i++)
         {
            fromFilter = fromFilters[i];
            toFilter = toFilters[i];
            resultFilter = interpolateFilter(fromFilter,toFilter,progress);
            if(Boolean(resultFilter))
            {
               resultFilters.push(resultFilter);
            }
         }
         return resultFilters;
      }
      
      public static function interpolateFilter(fromFilter:BitmapFilter, toFilter:BitmapFilter, progress:Number) : BitmapFilter
      {
         var accessor:XML = null;
         var accessorName:String = null;
         var attribType:String = null;
         var color1:uint = 0;
         var color2:uint = 0;
         var colorBlended:uint = 0;
         var resultRatios:Array = null;
         var resultColors:Array = null;
         var resultAlphas:Array = null;
         var fromLength:int = 0;
         var toLength:int = 0;
         var maxLength:int = 0;
         var i:int = 0;
         var fromIndex:int = 0;
         var fromRatio:Number = NaN;
         var fromColor:uint = 0;
         var fromAlpha:Number = NaN;
         var toIndex:int = 0;
         var toRatio:Number = NaN;
         var toColor:uint = 0;
         var toAlpha:Number = NaN;
         var resultRatio:int = 0;
         var resultColor:uint = 0;
         var resultAlpha:Number = NaN;
         if(!toFilter || fromFilter["constructor"] != toFilter["constructor"])
         {
            return fromFilter;
         }
         if(progress > 1)
         {
            progress = 1;
         }
         else if(progress < 0)
         {
            progress = 0;
         }
         var q:Number = 1 - progress;
         var resultFilter:BitmapFilter = fromFilter.clone();
         var filterTypeInfo:XML = getTypeInfo(fromFilter);
         var accessorList:XMLList = filterTypeInfo.accessor;
         for each(accessor in accessorList)
         {
            accessorName = accessor.@name.toString();
            attribType = accessor.@type;
            if(attribType == "Number" || attribType == "int")
            {
               resultFilter[accessorName] = fromFilter[accessorName] * q + toFilter[accessorName] * progress;
               continue;
            }
            if(attribType != "uint")
            {
               continue;
            }
            switch(accessorName)
            {
               case "color":
               case "highlightColor":
               case "shadowColor":
                  color1 = uint(fromFilter[accessorName]);
                  color2 = uint(toFilter[accessorName]);
                  colorBlended = Color.interpolateColor(color1,color2,progress);
                  resultFilter[accessorName] = colorBlended;
                  break;
               default:
                  resultFilter[accessorName] = fromFilter[accessorName] * q + toFilter[accessorName] * progress;
            }
         }
         if(fromFilter is GradientGlowFilter || fromFilter is GradientBevelFilter)
         {
            resultRatios = [];
            resultColors = [];
            resultAlphas = [];
            fromLength = int(fromFilter["ratios"].length);
            toLength = int(toFilter["ratios"].length);
            maxLength = Math.max(fromLength,toLength);
            for(i = 0; i < maxLength; i++)
            {
               fromIndex = Math.min(i,fromLength - 1);
               fromRatio = Number(fromFilter["ratios"][fromIndex]);
               fromColor = uint(fromFilter["colors"][fromIndex]);
               fromAlpha = Number(fromFilter["alphas"][fromIndex]);
               toIndex = Math.min(i,toLength - 1);
               toRatio = Number(toFilter["ratios"][toIndex]);
               toColor = uint(toFilter["colors"][toIndex]);
               toAlpha = Number(toFilter["alphas"][toIndex]);
               resultRatio = fromRatio * q + toRatio * progress;
               resultColor = Color.interpolateColor(fromColor,toColor,progress);
               resultAlpha = fromAlpha * q + toAlpha * progress;
               resultRatios[i] = resultRatio;
               resultColors[i] = resultColor;
               resultAlphas[i] = resultAlpha;
            }
            resultFilter["colors"] = resultColors;
            resultFilter["alphas"] = resultAlphas;
            resultFilter["ratios"] = resultRatios;
         }
         return resultFilter;
      }
      
      private static function getTypeInfo(o:*) : XML
      {
         var className:String = "";
         if(o is String)
         {
            className = o;
         }
         else
         {
            className = getQualifiedClassName(o);
         }
         if(className in typeCache)
         {
            return typeCache[className];
         }
         if(o is String)
         {
            o = getDefinitionByName(o);
         }
         return typeCache[className] = describeType(o);
      }
      
      public function get keyframesCompact() : Array
      {
         var kf:KeyframeBase = null;
         this._keyframesCompact = [];
         for each(kf in this.keyframes)
         {
            if(Boolean(kf))
            {
               this._keyframesCompact.push(kf);
            }
         }
         return this._keyframesCompact;
      }
      
      [ArrayElementType("fl.motion.Keyframe")]
      public function set keyframesCompact(compactArray:Array) : void
      {
         var kf:KeyframeBase = null;
         this._keyframesCompact = compactArray.concat();
         this.keyframes = [];
         for each(kf in this._keyframesCompact)
         {
            this.addKeyframe(kf);
         }
      }
      
      override public function getColorTransform(index:int) : ColorTransform
      {
         var nextKeyframe:Keyframe = null;
         var nextColor:ColorTransform = null;
         var keyframeDuration:Number = NaN;
         var easedTime:Number = NaN;
         var result:ColorTransform = null;
         var curKeyframe:Keyframe = this.getCurrentKeyframe(index,"color") as Keyframe;
         if(!curKeyframe || !curKeyframe.color)
         {
            return null;
         }
         var begin:ColorTransform = curKeyframe.color;
         var timeFromKeyframe:Number = index - curKeyframe.index;
         var tween:ITween = curKeyframe.getTween("color") || curKeyframe.getTween("alpha") || curKeyframe.getTween();
         if(timeFromKeyframe == 0 || !tween)
         {
            result = begin;
         }
         else if(Boolean(tween))
         {
            nextKeyframe = this.getNextKeyframe(index,"color") as Keyframe;
            if(!nextKeyframe || !nextKeyframe.color)
            {
               result = begin;
            }
            else
            {
               nextColor = nextKeyframe.color;
               keyframeDuration = nextKeyframe.index - curKeyframe.index;
               easedTime = tween.getValue(timeFromKeyframe,0,1,keyframeDuration);
               result = Color.interpolateTransform(begin,nextColor,easedTime);
            }
         }
         return result;
      }
      
      override public function getFilters(index:Number) : Array
      {
         var nextKeyframe:Keyframe = null;
         var nextFilters:Array = null;
         var keyframeDuration:Number = NaN;
         var easedTime:Number = NaN;
         var result:Array = null;
         var curKeyframe:Keyframe = this.getCurrentKeyframe(index,"filters") as Keyframe;
         if(!curKeyframe || Boolean(curKeyframe.filters) && Boolean(!curKeyframe.filters.length))
         {
            return [];
         }
         var begin:Array = curKeyframe.filters;
         var timeFromKeyframe:Number = index - curKeyframe.index;
         var tween:ITween = curKeyframe.getTween("filters") || curKeyframe.getTween();
         if(timeFromKeyframe == 0 || !tween)
         {
            result = begin;
         }
         else if(Boolean(tween))
         {
            nextKeyframe = this.getNextKeyframe(index,"filters") as Keyframe;
            if(!nextKeyframe || !nextKeyframe.filters.length)
            {
               result = begin;
            }
            else
            {
               nextFilters = nextKeyframe.filters;
               keyframeDuration = nextKeyframe.index - curKeyframe.index;
               easedTime = tween.getValue(timeFromKeyframe,0,1,keyframeDuration);
               result = interpolateFilters(begin,nextFilters,easedTime);
            }
         }
         return result;
      }
      
      override protected function findTweenedValue(index:Number, tweenableName:String, curKeyframeBase:KeyframeBase, timeFromKeyframe:Number, begin:Number) : Number
      {
         var nextValue:Number = NaN;
         var change:Number = NaN;
         var keyframeDuration:Number = NaN;
         var curKeyframe:Keyframe = curKeyframeBase as Keyframe;
         if(!curKeyframe)
         {
            return NaN;
         }
         var tween:ITween = curKeyframe.getTween(tweenableName) || curKeyframe.getTween();
         if(!tween || !curKeyframe.tweenScale && (tweenableName == Tweenables.SCALE_X || tweenableName == Tweenables.SCALE_Y) || curKeyframe.rotateDirection == RotateDirection.NONE && (tweenableName == Tweenables.ROTATION || tweenableName == Tweenables.SKEW_X || tweenableName == Tweenables.SKEW_Y))
         {
            return begin;
         }
         var nextKeyframeTweenableName:String = tweenableName;
         if(tween.target == "")
         {
            nextKeyframeTweenableName = "";
         }
         var nextKeyframe:Keyframe = this.getNextKeyframe(index,nextKeyframeTweenableName) as Keyframe;
         if(!nextKeyframe || nextKeyframe.blank)
         {
            return begin;
         }
         nextValue = nextKeyframe.getValue(tweenableName);
         if(isNaN(nextValue))
         {
            nextValue = begin;
         }
         change = nextValue - begin;
         if(tweenableName == Tweenables.SKEW_X || tweenableName == Tweenables.SKEW_Y || tweenableName == Tweenables.ROTATION)
         {
            if(curKeyframe.rotateDirection == RotateDirection.AUTO)
            {
               change %= 360;
               if(change > 180)
               {
                  change -= 360;
               }
               else if(change < -180)
               {
                  change += 360;
               }
            }
            else if(curKeyframe.rotateDirection == RotateDirection.CW)
            {
               if(change < 0)
               {
                  change = change % 360 + 360;
               }
               change += curKeyframe.rotateTimes * 360;
            }
            else
            {
               if(change > 0)
               {
                  change = change % 360 - 360;
               }
               change -= curKeyframe.rotateTimes * 360;
            }
         }
         keyframeDuration = nextKeyframe.index - curKeyframe.index;
         return tween.getValue(timeFromKeyframe,begin,change,keyframeDuration);
      }
      
      private function parseXML(xml:XML) : Motion
      {
         var child:XML = null;
         var sourceChild:XML = null;
         if(!xml)
         {
            return this;
         }
         if(Boolean(xml.@duration.length()))
         {
            this.duration = parseInt(xml.@duration);
         }
         var elements:XMLList = xml.elements();
         for(var i:Number = 0; i < elements.length(); i++)
         {
            child = elements[i];
            if(child.localName() == "source")
            {
               sourceChild = child.children()[0];
               this.source = new Source(sourceChild);
            }
            else if(child.localName() == "Keyframe")
            {
               this.addKeyframe(this.getNewKeyframe(child));
            }
         }
         return this;
      }
      
      override protected function getNewKeyframe(xml:XML = null) : KeyframeBase
      {
         return new Keyframe(xml);
      }
   }
}

