package com.common.data.socketDataHandler.decString
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   
   public class DealData
   {
      
      private static var txt:TextField;
      
      private static var tetFormat:TextFormat;
      
      public function DealData()
      {
         super();
         txt = new TextField();
         tetFormat = new TextFormat();
         tetFormat.color = 16777215;
         tetFormat.size = 20;
         tetFormat.font = "Times New Roman";
      }
      
      public static function dealStr(str:String) : ByteArray
      {
         var len:int = 0;
         var i:int = 0;
         var byte:ByteArray = new ByteArray();
         var zero:int = 0;
         byte.writeUTFBytes(str);
         len = int(byte.length);
         if(len < 16)
         {
            for(i = len; i < 16; i++)
            {
               byte.writeByte(zero);
            }
            return byte;
         }
         return byte;
      }
      
      public static function dealEmail(email:String) : ByteArray
      {
         var len:int = 0;
         var i:int = 0;
         var byte:ByteArray = new ByteArray();
         var zero:int = 0;
         byte.writeUTFBytes(email);
         len = int(byte.length);
         if(len < 64)
         {
            for(i = len; i < 64; i++)
            {
               byte.writeByte(zero);
            }
            return byte;
         }
         return byte;
      }
      
      public static function dealNikeName(str:String) : ByteArray
      {
         var len:int = 0;
         var i:int = 0;
         var byte:ByteArray = new ByteArray();
         var zero:int = 0;
         byte.writeUTFBytes(str);
         len = int(byte.length);
         if(len < 16)
         {
            for(i = len; i < 16; i++)
            {
               byte.writeByte(zero);
            }
            return byte;
         }
         return byte;
      }
      
      public static function dealString(str:String, len:uint) : ByteArray
      {
         var byte:ByteArray = new ByteArray();
         byte.writeUTFBytes(str);
         byte.length = len;
         return byte;
      }
   }
}

