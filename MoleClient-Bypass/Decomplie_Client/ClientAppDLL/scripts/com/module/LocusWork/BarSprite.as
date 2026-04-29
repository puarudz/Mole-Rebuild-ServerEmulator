package com.module.LocusWork
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class BarSprite implements IValueMC
   {
      
      public static var max_live:uint = 20;
      
      private var _value:int = 0;
      
      private var _content:Sprite;
      
      public function BarSprite(content:Sprite)
      {
         super();
         this._content = content;
         for(var i:int = 0; i < max_live; i++)
         {
            if(this._content.getChildByName("live" + i) == null)
            {
               max_live = i;
               break;
            }
         }
         this.value = 0;
      }
      
      public function set value(val:Number) : void
      {
         var i:int = 0;
         var brood:MovieClip = null;
         val = int(val);
         this._value = Math.min(val,max_live);
         this._value = Math.max(this._value,0);
         for(i = 0; i < this._value; i++)
         {
            brood = this._content.getChildByName("live" + i) as MovieClip;
            brood.gotoAndStop(2);
         }
         for(i = this._value; i < max_live; i++)
         {
            brood = this._content.getChildByName("live" + i) as MovieClip;
            brood.gotoAndStop(1);
         }
      }
      
      public function get value() : Number
      {
         return this._value;
      }
   }
}

