package com.mole.app.info
{
   import org.taomee.ds.HashMap;
   
   public class SystemTimeXMLInfo
   {
      
      private static var xmlClass:Class = SystemTimeXMLInfo_xmlClass;
      
      private static var _sysTimes:HashMap = new HashMap();
      
      setup();
      
      public function SystemTimeXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var xml:XML = null;
         var sysTimesXML:XML = XML(new xmlClass());
         var timesList:XMLList = sysTimesXML.descendants("systime");
         for each(xml in timesList)
         {
            if(_sysTimes.containsKey(uint(xml.@id)))
            {
               throw new Error("系統時間限制中出現重復ID，請修改。(systime.xml)");
            }
            _sysTimes.add(uint(xml.@id),new SystemTimeInfo(xml));
         }
      }
      
      public static function getSystemTimeInfoById(id:uint) : SystemTimeInfo
      {
         return _sysTimes.getValue(id) as SystemTimeInfo;
      }
   }
}

