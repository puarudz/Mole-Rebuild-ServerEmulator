package com.view.mapView.activity.Task83
{
   import com.common.util.StringUtil;
   import com.global.staticData.CommandID;
   import flash.net.URLRequest;
   import flash.net.sendToURL;
   import flash.utils.ByteArray;
   
   public class NewStatisticsClass
   {
      
      public function NewStatisticsClass()
      {
         super();
      }
      
      public static function getInstance() : NewStatisticsClass
      {
         return new NewStatisticsClass();
      }
      
      public function init(mainName:String, partName:String, key:String, staticsKey:String, url:String = null, urlTimes:uint = 0) : void
      {
         var i:uint = 0;
         var mainName2:ByteArray = StringUtil.FillString(mainName,200);
         var partName2:ByteArray = StringUtil.FillString(partName,200);
         var staticsKey2:ByteArray = StringUtil.FillString(staticsKey,200);
         GF.sendSocket(CommandID.NEW_STATICS_PLANT,4,mainName2,partName2,staticsKey2);
         if(Boolean(url))
         {
            for(i = 0; i < urlTimes; i++)
            {
               sendToURL(new URLRequest(url));
            }
         }
      }
      
      private function convertByteArrayToString(bytes:ByteArray) : String
      {
         var str:String = null;
         if(Boolean(bytes))
         {
            bytes.position = 0;
            str = bytes.readUTFBytes(bytes.length);
         }
         return str;
      }
      
      public function destroy() : void
      {
      }
   }
}

