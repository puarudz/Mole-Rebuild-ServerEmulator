package com.module.newAngel.constant
{
   import com.global.staticData.XMLInfo;
   import com.module.newAngel.info.NewAngelTollgateInfo;
   import org.taomee.ds.HashMap;
   
   public class NewAngelTollgateXML
   {
      
      private static var tollgateMap:HashMap;
      
      setup();
      
      public function NewAngelTollgateXML()
      {
         super();
      }
      
      public static function setup() : void
      {
         var tollgateInfo:NewAngelTollgateInfo = null;
         var tempXml:XML = null;
         var xml:XML = XML(new XMLInfo.newAngelTollgateCls());
         tollgateMap = new HashMap();
         for each(tempXml in xml.elements("tollgate"))
         {
            tollgateInfo = new NewAngelTollgateInfo(tempXml);
            tollgateMap.add(tollgateInfo.id,tollgateInfo);
         }
      }
      
      public static function getAngelTollgateInfo(tollgateId:uint) : NewAngelTollgateInfo
      {
         return tollgateMap.getValue(tollgateId);
      }
   }
}

