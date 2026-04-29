package com.common.util
{
   import flash.utils.ByteArray;
   
   public class BitArray extends ByteArray
   {
      
      public function BitArray(bytes:ByteArray = null)
      {
         super();
         if(bytes != null)
         {
            this.writeBytes(bytes,0,bytes.length);
         }
      }
      
      public function get bitLength() : uint
      {
         return this.length * 8;
      }
      
      public function getBitAt(index:uint = 0) : Boolean
      {
         index = this.bitLength - index;
         if(index > this.length * 8)
         {
            throw new RangeError("數值不在可接受的範圍內。可接受範圍為：0 到 ByteArray.length*8-1 。");
         }
         var byteIndex:uint = Math.ceil(index / 8) - 1;
         var flag:uint = uint(1 << (this.length * 8 - index) % 8);
         return Boolean(this[byteIndex] & flag);
      }
      
      public function setBitAt(index:uint, value:Boolean) : void
      {
         index = this.bitLength - index;
         var len:uint = Math.ceil(index / 8);
         if(len > this.length)
         {
            this.length = len;
         }
         var byteIndex:uint = Math.ceil(index / 8) - 1;
         var flag:uint = uint(1 << (this.length * 8 - index) % 8);
         if(value)
         {
            this[byteIndex] |= flag;
         }
         else
         {
            this[byteIndex] &= ~flag;
         }
      }
      
      public function getBitAtCoord(lengthX:uint, x:uint, y:uint) : Boolean
      {
         var i:uint = y * lengthX + x;
         return this.getBitAt(i);
      }
      
      public function get bitArr() : Array
      {
         var bit:int = 0;
         var j:int = 0;
         var arr:Array = [];
         for(var i:int = 0; i < this.length; i++)
         {
            bit = int(this[i]);
            for(j = 0; j < 8; j++)
            {
               arr[(i + 1) * 8 - j - 1] = Boolean(bit & 1);
               bit >>= 1;
            }
         }
         arr.reverse();
         return arr;
      }
   }
}

