package com.core.socketlogic.baseSocket
{
   import com.fcc.MDecrypt;
   import com.fcc.MEncrypt;
   import flash.utils.ByteArray;
   
   public class MessageEncrypt
   {
      
      public function MessageEncrypt()
      {
         super();
      }
      
      public static function encrypt(inData:ByteArray, endian:String) : ByteArray
      {
         inData.position = 0;
         var inLen:int = int(inData.length);
         var outData:ByteArray = new ByteArray();
         if(endian != null && endian != "")
         {
            outData.endian = endian;
         }
         MEncrypt(inData,inLen,outData);
         outData.position = 0;
         return outData;
      }
      
      public static function decrypt(inData:ByteArray) : ByteArray
      {
         inData.position = 0;
         var inLen:int = int(inData.length);
         var outData:ByteArray = new ByteArray();
         MDecrypt(inData,inLen,outData);
         outData.position = 0;
         return outData;
      }
   }
}

