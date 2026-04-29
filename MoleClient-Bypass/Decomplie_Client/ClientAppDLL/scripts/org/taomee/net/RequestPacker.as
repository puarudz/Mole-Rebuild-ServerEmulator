package org.taomee.net
{
   import flash.utils.ByteArray;
   
   internal class RequestPacker
   {
      
      public function RequestPacker()
      {
         super();
      }
      
      internal static function createHead(length:uint, commandID:uint, userID:uint, result:int, endian:String) : ByteArray
      {
         var data:ByteArray = new ByteArray();
         if(endian != null && endian != "")
         {
            data.endian = endian;
         }
         data.writeUnsignedInt(length);
         data.writeShort(commandID);
         data.writeUnsignedInt(userID);
         data.writeInt(result);
         data.writeInt(0);
         return data;
      }
      
      internal static function createBody(args:Array, endian:String) : ByteArray
      {
         var i:* = undefined;
         var data:ByteArray = new ByteArray();
         if(endian != null && endian != "")
         {
            data.endian = endian;
         }
         for each(i in args)
         {
            if(i is String)
            {
               data.writeUTFBytes(i);
            }
            else if(i is ByteArray)
            {
               data.writeBytes(i);
            }
            else
            {
               data.writeUnsignedInt(i);
            }
         }
         return data;
      }
   }
}

