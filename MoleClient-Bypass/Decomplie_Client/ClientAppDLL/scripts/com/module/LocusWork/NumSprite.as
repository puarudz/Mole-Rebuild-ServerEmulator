package com.module.LocusWork
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class NumSprite implements IValueMC
   {
      
      private var _value:Number = 0;
      
      private var _content:Sprite;
      
      private var maxNum:Number = -1;
      
      private var _showHeadZero:Boolean;
      
      private var _baseX:Number;
      
      private var _alignToLeft:Boolean;
      
      public var max_live:uint = 20;
      
      public function NumSprite(content:*, val:Number = 0, showHeadZero:Boolean = true, alignToLeft:Boolean = false)
      {
         super();
         this._alignToLeft = alignToLeft;
         this._showHeadZero = showHeadZero;
         this._content = content as Sprite;
         this._baseX = this._content.x;
         for(var i:int = 0; i < this.max_live; i++)
         {
            if(!this._content.getChildByName("num" + i))
            {
               this.max_live = i;
               break;
            }
         }
         this.value = val;
      }
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      private function get MAXNUM() : Number
      {
         if(this.maxNum != -1)
         {
            return this.maxNum;
         }
         var mn:Number = 1;
         for(var i:int = 0; i < this.max_live; i++)
         {
            mn *= 10;
         }
         return mn - 1;
      }
      
      public function set value(val:Number) : void
      {
         var mc:MovieClip = null;
         var endmc:MovieClip = null;
         var showCount:int = 0;
         var j:int = 0;
         var numMC:MovieClip = null;
         var ShowMC:MovieClip = null;
         this.maxNum = this.MAXNUM;
         this._value = Math.min(val,this.maxNum);
         this._value = Math.max(this._value,0);
         var str:String = this._value.toString();
         var tmn:Number = this.maxNum;
         var tmnLength:int = tmn.toString().length;
         while(this._value.toString().length < tmnLength)
         {
            str = "0" + str;
            tmnLength--;
         }
         var _startNotZero:Boolean = false;
         for(var i:int = 0; i < this.max_live; i++)
         {
            mc = this._content.getChildByName("num" + i) as MovieClip;
            mc.gotoAndStop(int(str.charAt(i)) + 1);
            mc.visible = true;
            if(mc.baseX == null)
            {
               mc.baseX = mc.x;
            }
            else
            {
               mc.x = mc.baseX;
            }
            if(int(str.charAt(i)) == 0)
            {
               if(!this._showHeadZero && !_startNotZero)
               {
                  mc.visible = false;
               }
            }
            else
            {
               _startNotZero = true;
            }
         }
         if(int(str) == 0)
         {
            endmc = this._content.getChildByName("num" + (this.max_live - 1)) as MovieClip;
            endmc.visible = true;
         }
         if(this._alignToLeft)
         {
            showCount = 0;
            for(j = 0; j < this.max_live; j++)
            {
               numMC = this._content.getChildByName("num" + j) as MovieClip;
               if(numMC.visible == true)
               {
                  ShowMC = this._content.getChildByName("num" + showCount) as MovieClip;
                  numMC.x = ShowMC.baseX;
                  showCount++;
               }
            }
         }
      }
      
      public function get value() : Number
      {
         return this._value;
      }
   }
}

