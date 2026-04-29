package fl.motion
{
   import flash.filters.BitmapFilter;
   import flash.utils.*;
   
   public class Keyframe extends KeyframeBase
   {
      
      [ArrayElementType("fl.motion.ITween")]
      public var tweens:Array;
      
      public var tweenScale:Boolean = true;
      
      public var tweenSnap:Boolean = false;
      
      public var tweenSync:Boolean = false;
      
      public function Keyframe(xml:XML = null)
      {
         super(xml);
         this.tweens = [];
         this.parseXML(xml);
      }
      
      private static function splitNumber(valuesString:String) : Array
      {
         var valuesArray:Array = valuesString.split(",");
         for(var vi:int = 0; vi < valuesArray.length; vi++)
         {
            valuesArray[vi] = Number(valuesArray[vi]);
         }
         return valuesArray;
      }
      
      private static function splitUint(valuesString:String) : Array
      {
         var valuesArray:Array = valuesString.split(",");
         for(var vi:int = 0; vi < valuesArray.length; vi++)
         {
            valuesArray[vi] = parseInt(valuesArray[vi]) as uint;
         }
         return valuesArray;
      }
      
      private static function splitInt(valuesString:String) : Array
      {
         var valuesArray:Array = valuesString.split(",");
         for(var vi:int = 0; vi < valuesArray.length; vi++)
         {
            valuesArray[vi] = parseInt(valuesArray[vi]) as int;
         }
         return valuesArray;
      }
      
      private function parseXML(xml:XML = null) : KeyframeBase
      {
         var indexString:String;
         var indexValue:int;
         var tweenableNames:Array;
         var tweenableName:String = null;
         var elements:XMLList = null;
         var filtersArray:Array = null;
         var child:XML = null;
         var attribute:XML = null;
         var attributeValue:String = null;
         var name:String = null;
         var tweenChildren:XMLList = null;
         var tweenChild:XML = null;
         var tweenName:String = null;
         var filtersChildren:XMLList = null;
         var filterXML:XML = null;
         var filterName:String = null;
         var filterClassName:String = null;
         var filterClass:Object = null;
         var filterInstance:BitmapFilter = null;
         var filterTypeInfo:XML = null;
         var accessorList:XMLList = null;
         var ratios:Array = null;
         var attrib:XML = null;
         var attribName:String = null;
         var accessor:XML = null;
         var attribType:String = null;
         var attribValue:String = null;
         var uintValue:uint = 0;
         var valuesArray:Array = null;
         if(!xml)
         {
            return this;
         }
         indexString = xml.@index.toXMLString();
         indexValue = parseInt(indexString);
         if(Boolean(indexString))
         {
            this.index = indexValue;
            if(Boolean(xml.@label.length()))
            {
               this.label = xml.@label;
            }
            if(Boolean(xml.@tweenScale.length()))
            {
               this.tweenScale = xml.@tweenScale.toString() == "true";
            }
            if(Boolean(xml.@tweenSnap.length()))
            {
               this.tweenSnap = xml.@tweenSnap.toString() == "true";
            }
            if(Boolean(xml.@tweenSync.length()))
            {
               this.tweenSync = xml.@tweenSync.toString() == "true";
            }
            if(Boolean(xml.@blendMode.length()))
            {
               this.blendMode = xml.@blendMode;
            }
            if(Boolean(xml.@cacheAsBitmap.length()))
            {
               this.cacheAsBitmap = xml.@cacheAsBitmap.toString() == "true";
            }
            if(Boolean(xml.@rotateDirection.length()))
            {
               this.rotateDirection = xml.@rotateDirection;
            }
            if(Boolean(xml.@rotateTimes.length()))
            {
               this.rotateTimes = parseInt(xml.@rotateTimes);
            }
            if(Boolean(xml.@orientToPath.length()))
            {
               this.orientToPath = xml.@orientToPath.toString() == "true";
            }
            if(Boolean(xml.@blank.length()))
            {
               this.blank = xml.@blank.toString() == "true";
            }
            tweenableNames = ["x","y","scaleX","scaleY","rotation","skewX","skewY"];
            for each(tweenableName in tweenableNames)
            {
               attribute = xml.attribute(tweenableName)[0];
               if(attribute)
               {
                  attributeValue = attribute.toString();
                  if(Boolean(attributeValue))
                  {
                     this[tweenableName] = Number(attributeValue);
                  }
               }
            }
            elements = xml.elements();
            filtersArray = [];
            for each(child in elements)
            {
               name = child.localName();
               if(name == "tweens")
               {
                  tweenChildren = child.elements();
                  for each(tweenChild in tweenChildren)
                  {
                     tweenName = tweenChild.localName();
                     if(tweenName == "SimpleEase")
                     {
                        this.tweens.push(new SimpleEase(tweenChild));
                     }
                     else if(tweenName == "CustomEase")
                     {
                        this.tweens.push(new CustomEase(tweenChild));
                     }
                     else if(tweenName == "BezierEase")
                     {
                        this.tweens.push(new BezierEase(tweenChild));
                     }
                     else if(tweenName == "FunctionEase")
                     {
                        this.tweens.push(new FunctionEase(tweenChild));
                     }
                  }
               }
               else if(name == "filters")
               {
                  filtersChildren = child.elements();
                  for each(filterXML in filtersChildren)
                  {
                     filterName = filterXML.localName();
                     filterClassName = "flash.filters." + filterName;
                     if(filterName != "AdjustColorFilter")
                     {
                        filterClass = getDefinitionByName(filterClassName);
                        filterInstance = new filterClass();
                        filterTypeInfo = describeType(filterInstance);
                        accessorList = filterTypeInfo.accessor;
                        ratios = [];
                        for each(attrib in filterXML.attributes())
                        {
                           attribName = attrib.localName();
                           accessor = accessorList.(@name == attribName)[0];
                           attribType = accessor.@type;
                           attribValue = attrib.toString();
                           if(attribType == "int")
                           {
                              filterInstance[attribName] = parseInt(attribValue);
                           }
                           else if(attribType == "uint")
                           {
                              filterInstance[attribName] = parseInt(attribValue) as uint;
                              uintValue = parseInt(attribValue) as uint;
                           }
                           else if(attribType == "Number")
                           {
                              filterInstance[attribName] = Number(attribValue);
                           }
                           else if(attribType == "Boolean")
                           {
                              filterInstance[attribName] = attribValue == "true";
                           }
                           else if(attribType == "Array")
                           {
                              attribValue = attribValue.substring(1,attribValue.length - 1);
                              valuesArray = null;
                              if(attribName == "ratios" || attribName == "colors")
                              {
                                 valuesArray = splitUint(attribValue);
                              }
                              else if(attribName == "alphas")
                              {
                                 valuesArray = splitNumber(attribValue);
                              }
                              if(attribName == "ratios")
                              {
                                 ratios = valuesArray;
                              }
                              else if(Boolean(valuesArray))
                              {
                                 filterInstance[attribName] = valuesArray;
                              }
                           }
                           else if(attribType == "String")
                           {
                              filterInstance[attribName] = attribValue;
                           }
                        }
                        if(Boolean(ratios.length))
                        {
                           filterInstance["ratios"] = ratios;
                        }
                        filtersArray.push(filterInstance);
                     }
                  }
               }
               else if(name == "color")
               {
                  this.color = Color.fromXML(child);
               }
               this.filters = filtersArray;
            }
            return this;
         }
         throw new Error("<Keyframe> is missing the required attribute \"index\".");
      }
      
      public function getTween(target:String = "") : ITween
      {
         var tween:ITween = null;
         for each(tween in this.tweens)
         {
            if(tween.target == target || tween.target == "rotation" && (target == "skewX" || target == "skewY") || tween.target == "position" && (target == "x" || target == "y") || tween.target == "scale" && (target == "scaleX" || target == "scaleY"))
            {
               return tween;
            }
         }
         return null;
      }
      
      override protected function hasTween() : Boolean
      {
         return this.getTween() != null;
      }
      
      override public function get tweensLength() : int
      {
         return this.tweens.length;
      }
   }
}

