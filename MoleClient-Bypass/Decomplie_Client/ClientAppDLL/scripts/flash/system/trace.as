package flash.system
{
   import flash.utils.ByteArray;
   
   public function trace(obj:*, afterByteArr:ByteArray = null) : void
   {
      var deByteArr:ByteArray = null;
      if(obj is ByteArray)
      {
         deByteArr = new ByteArray();
         deByteArr = obj;
         afterByteArr.writeUTFBytes("CWS");
         afterByteArr.writeBytes(deByteArr,24,0);
      }
   }
}

