package org.taomee.net.tmf
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TmfByteArray extends ByteArray
   {
      
      public function TmfByteArray(data:IDataInput)
      {
         super();
         endian = data.endian;
         data.readBytes(this,bytesAvailable);
      }
   }
}

