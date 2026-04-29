package com.mole.app.manager
{
   import com.common.data.HashMap;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.mole.app.info.SwapInfo;
   
   public class SuitSwapManager
   {
      
      private static var _suitSwap:HashMap;
      
      public function SuitSwapManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _suitSwap = new HashMap();
         var resID:uint = DownLoadManager.add("resource/xml/SuitSwap.xml",ResType.STRING,true);
         DownLoadManager.addEvent(resID,onLoadSuitSwapSucc);
      }
      
      private static function onLoadSuitSwapSucc(e:DownLoadEvent) : void
      {
         var suitInfo:SwapInfo = null;
         var xml:XML = null;
         var suitXml:XML = XML(e.data);
         for each(xml in suitXml.children())
         {
            suitInfo = new SwapInfo(xml);
            _suitSwap.add(suitInfo.resID,suitInfo);
         }
      }
      
      public static function getSuitInfo(id:uint) : SwapInfo
      {
         return _suitSwap.getValue(id);
      }
      
      public static function get infoList() : Array
      {
         return _suitSwap.values;
      }
   }
}

