package com.common.util
{
   import flash.display.DisplayObject;
   import flash.filters.ColorMatrixFilter;
   
   public class ColorUtils
   {
      
      private static const RGB_MAX:uint = 256;
      
      private static const HUE_MAX:uint = 360;
      
      private static const PCT_MAX:uint = 100;
      
      private static const RED:Number = 0.3086;
      
      private static const GREEN:Number = 0.6094;
      
      private static const BLUE:Number = 0.082;
      
      private static const DELTA_INDEX:Array = [0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.2,0.21,0.22,0.24,0.25,0.27,0.28,0.3,0.32,0.34,0.36,0.38,0.4,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.8,0.83,0.86,0.89,0.92,0.95,0.98,1,1.06,1.12,1.18,1.24,1.3,1.36,1.42,1.48,1.54,1.6,1.66,1.72,1.78,1.84,1.9,1.96,2,2.12,2.25,2.37,2.5,2.62,2.75,2.87,3,3.2,3.4,3.6,3.8,4,4.3,4.7,4.9,5,5.5,6,6.5,6.8,7,7.3,7.5,7.8,8,8.4,8.7,9,9.4,9.6,9.8,10];
      
      public function ColorUtils()
      {
         super();
      }
      
      public static function getAlpha(c:uint) : uint
      {
         return c >> 24 & 0xFF;
      }
      
      public static function getRed(c:uint) : uint
      {
         return c >> 16 & 0xFF;
      }
      
      public static function getGreen(c:uint) : uint
      {
         return c >> 8 & 0xFF;
      }
      
      public static function getBlue(c:uint) : uint
      {
         return c & 0xFF;
      }
      
      public static function getColor24(r:uint, g:uint, b:uint) : uint
      {
         return r << 16 | g << 8 | b;
      }
      
      public static function getColor32(a:uint, r:uint, g:uint, b:uint) : uint
      {
         return a << 24 | r << 16 | g << 8 | b;
      }
      
      public static function HueToRGB(min:Number, max:Number, hue:Number) : Object
      {
         var mu:Number = NaN;
         var md:Number = NaN;
         var F:Number = NaN;
         var n:int = 0;
         while(hue < 0)
         {
            hue += HUE_MAX;
         }
         n = int(hue / 60);
         F = (hue - n * 60) / 60;
         n %= 6;
         mu = min + (max - min) * F;
         md = max - (max - min) * F;
         switch(n)
         {
            case 0:
               return {
                  "r":max,
                  "g":mu,
                  "b":min
               };
            case 1:
               return {
                  "r":md,
                  "g":max,
                  "b":min
               };
            case 2:
               return {
                  "r":min,
                  "g":max,
                  "b":mu
               };
            case 3:
               return {
                  "r":min,
                  "g":md,
                  "b":max
               };
            case 4:
               return {
                  "r":mu,
                  "g":min,
                  "b":max
               };
            case 5:
               return {
                  "r":max,
                  "g":min,
                  "b":md
               };
            default:
               return null;
         }
      }
      
      public static function RGBToHue(red:Number, green:Number, blue:Number) : uint
      {
         var f:Number = NaN;
         var min:Number = NaN;
         var mid:Number = NaN;
         var max:Number = NaN;
         var n:Number = NaN;
         max = Math.max(red,Math.max(green,blue));
         min = Math.min(red,Math.min(green,blue));
         if(max - min == 0)
         {
            return 0;
         }
         mid = center(red,green,blue);
         if(red == max)
         {
            if(blue == min)
            {
               n = 0;
            }
            else
            {
               n = 5;
            }
         }
         else if(green == max)
         {
            if(blue == min)
            {
               n = 1;
            }
            else
            {
               n = 2;
            }
         }
         else if(red == min)
         {
            n = 3;
         }
         else
         {
            n = 4;
         }
         if(n % 2 == 0)
         {
            f = mid - min;
         }
         else
         {
            f = max - mid;
         }
         f /= max - min;
         return 60 * (n + f);
      }
      
      public static function RGBtoHSL(red:Number, green:Number, blue:Number) : Object
      {
         var min:Number = NaN;
         var max:Number = NaN;
         var delta:Number = NaN;
         var l:Number = NaN;
         var s:Number = NaN;
         var h:Number = 0;
         max = Math.max(red,Math.max(green,blue));
         min = Math.min(red,Math.min(green,blue));
         l = (min + max) * 0.5;
         if(l == 0)
         {
            return {
               "h":h,
               "l":0,
               "s":1
            };
         }
         delta = (max - min) * 0.5;
         if(l < 0.5)
         {
            s = delta / l;
         }
         else
         {
            s = delta / (1 - l);
         }
         h = RGBToHue(red,green,blue);
         return {
            "h":h,
            "l":l,
            "s":s
         };
      }
      
      public static function HSLtoRGB(hue:Number, luminance:Number, saturation:Number) : Object
      {
         var delta:Number = NaN;
         if(luminance < 0.5)
         {
            delta = saturation * luminance;
         }
         else
         {
            delta = saturation * (1 - luminance);
         }
         return HueToRGB(luminance - delta,luminance + delta,hue);
      }
      
      public static function RGBtoHSV(red:Number, green:Number, blue:Number) : Object
      {
         var min:Number = NaN;
         var max:Number = NaN;
         var s:Number = NaN;
         var v:Number = NaN;
         var h:Number = 0;
         max = Math.max(red,Math.max(green,blue));
         min = Math.min(red,Math.min(green,blue));
         if(max == 0)
         {
            return {
               "h":0,
               "s":0,
               "v":0
            };
         }
         v = max;
         s = (max - min) / max;
         h = RGBToHue(red,green,blue);
         return {
            "h":h,
            "s":s,
            "v":v
         };
      }
      
      public static function HSVtoRGB(hue:Number, saturation:Number, value:Number) : Object
      {
         var min:Number = (1 - saturation) * value;
         return HueToRGB(min,value,hue);
      }
      
      public static function HSVtoHSL(hue:Number, saturation:Number, value:Number) : Object
      {
         var rgbVal:Object = HSVtoRGB(hue,saturation,value);
         return RGBtoHSL(rgbVal.r,rgbVal.g,rgbVal.b);
      }
      
      public static function HSLtoHSV(hue:Number, luminance:Number, saturation:Number) : Object
      {
         var rgbVal:Object = HSLtoRGB(hue,luminance,saturation);
         return RGBtoHSV(rgbVal.r,rgbVal.g,rgbVal.b);
      }
      
      private static function center(a:Number, b:Number, c:Number) : Number
      {
         if(a > b && a > c)
         {
            if(b > c)
            {
               return b;
            }
            return c;
         }
         if(b > a && b > c)
         {
            if(a > c)
            {
               return a;
            }
            return c;
         }
         if(a > b)
         {
            return a;
         }
         return b;
      }
      
      public static function setHue(offset:Number) : ColorMatrixFilter
      {
         offset = cleanValue(offset,180) / 180 * Math.PI;
         if(offset == 0 || isNaN(offset))
         {
            return null;
         }
         var cosVal:Number = Math.cos(offset);
         var sinVal:Number = Math.sin(offset);
         var lumR:Number = 0.213;
         var lumG:Number = 0.715;
         var lumB:Number = 0.072;
         return new ColorMatrixFilter([lumR + cosVal * (1 - lumR) + sinVal * -lumR,lumG + cosVal * -lumG + sinVal * -lumG,lumB + cosVal * -lumB + sinVal * (1 - lumB),0,0,lumR + cosVal * -lumR + sinVal * 0.143,lumG + cosVal * (1 - lumG) + sinVal * 0.14,lumB + cosVal * -lumB + sinVal * -0.283,0,0,lumR + cosVal * -lumR + sinVal * -(1 - lumR),lumG + cosVal * -lumG + sinVal * lumG,lumB + cosVal * (1 - lumB) + sinVal * lumB,0,0,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public static function setBrightness(offset:Number) : ColorMatrixFilter
      {
         offset = cleanValue(offset,100);
         if(offset == 0 || isNaN(offset))
         {
            return null;
         }
         return new ColorMatrixFilter([1,0,0,0,offset,0,1,0,0,offset,0,0,1,0,offset,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public static function setSaturation(offset:Number) : ColorMatrixFilter
      {
         offset = cleanValue(offset,100);
         if(offset == 0 || isNaN(offset))
         {
            return null;
         }
         var x:Number = 1 + (offset > 0 ? 3 * offset / 100 : offset / 100);
         return new ColorMatrixFilter([RED * (1 - x) + x,GREEN * (1 - x),BLUE * (1 - x),0,0,RED * (1 - x),GREEN * (1 - x) + x,BLUE * (1 - x),0,0,RED * (1 - x),GREEN * (1 - x),BLUE * (1 - x) + x,0,0,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public static function setContrast(offset:Number) : ColorMatrixFilter
      {
         var x:Number = NaN;
         offset = cleanValue(offset,100);
         if(offset == 0 || isNaN(offset))
         {
            return null;
         }
         if(offset < 0)
         {
            x = 127 + offset / 100 * 127;
         }
         else
         {
            x = offset % 1;
            if(x == 0)
            {
               x = Number(DELTA_INDEX[offset]);
            }
            else
            {
               x = DELTA_INDEX[offset << 0] * (1 - x) + DELTA_INDEX[(offset << 0) + 1] * x;
            }
            x = x * 127 + 127;
         }
         return new ColorMatrixFilter([x / 127,0,0,0,0.5 * (127 - x),0,x / 127,0,0,0.5 * (127 - x),0,0,x / 127,0,0.5 * (127 - x),0,0,0,1,0,0,0,0,0,1]);
      }
      
      public static function cancelDisplayObjFilter(obj:DisplayObject) : void
      {
         if(Boolean(obj))
         {
            obj.filters = null;
         }
      }
      
      public static function setDisplayObjGrayscale(obj:DisplayObject) : void
      {
         if(Boolean(obj))
         {
            obj.filters = [setGrayscale()];
         }
      }
      
      public static function setGrayscale() : ColorMatrixFilter
      {
         return new ColorMatrixFilter([RED,GREEN,BLUE,0,0,RED,GREEN,BLUE,0,0,RED,GREEN,BLUE,0,0,0,0,0,1,0]);
      }
      
      public static function setInvert() : ColorMatrixFilter
      {
         return new ColorMatrixFilter([-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0]);
      }
      
      private static function cleanValue(p_val:Number, p_limit:Number) : Number
      {
         return Math.min(p_limit,Math.max(-p_limit,p_val));
      }
   }
}

