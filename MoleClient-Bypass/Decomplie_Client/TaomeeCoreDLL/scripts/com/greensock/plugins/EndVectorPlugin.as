package com.greensock.plugins
{
   import com.greensock.*;
   
   public class EndVectorPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected var _v:Vector.<Number>;
      
      protected var _info:Vector.<VectorInfo> = new Vector.<VectorInfo>();
      
      public function EndVectorPlugin()
      {
         super();
         this.propName = "endVector";
         this.overwriteProps = ["endVector"];
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         if(!(target is Vector.<Number>) || !(value is Vector.<Number>))
         {
            return false;
         }
         this.init(target as Vector.<Number>,value as Vector.<Number>);
         return true;
      }
      
      public function init(start:Vector.<Number>, end:Vector.<Number>) : void
      {
         this._v = start;
         var i:int = int(end.length);
         var cnt:uint = 0;
         while(Boolean(i--))
         {
            if(this._v[i] != end[i])
            {
               this._info[cnt++] = new VectorInfo(i,this._v[i],end[i] - this._v[i]);
            }
         }
      }
      
      override public function set changeFactor(n:Number) : void
      {
         var vi:VectorInfo = null;
         var val:Number = NaN;
         var i:int = int(this._info.length);
         if(this.round)
         {
            while(Boolean(i--))
            {
               vi = this._info[i];
               val = vi.start + vi.change * n;
               if(val > 0)
               {
                  this._v[vi.index] = val + 0.5 >> 0;
               }
               else
               {
                  this._v[vi.index] = val - 0.5 >> 0;
               }
            }
         }
         else
         {
            while(Boolean(i--))
            {
               vi = this._info[i];
               this._v[vi.index] = vi.start + vi.change * n;
            }
         }
      }
   }
}

class VectorInfo
{
   
   public var index:uint;
   
   public var start:Number;
   
   public var change:Number;
   
   public function VectorInfo(index:uint, start:Number, change:Number)
   {
      super();
      this.index = index;
      this.start = start;
      this.change = change;
   }
}
