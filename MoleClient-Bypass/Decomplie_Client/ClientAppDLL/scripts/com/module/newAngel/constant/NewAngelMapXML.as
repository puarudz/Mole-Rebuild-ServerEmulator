package com.module.newAngel.constant
{
   import com.global.staticData.XMLInfo;
   import com.module.newAngel.info.NewAngelMapInfo;
   import org.taomee.ds.HashMap;
   
   public class NewAngelMapXML
   {
      
      private static var map:HashMap;
      
      setup();
      
      public function NewAngelMapXML()
      {
         super();
      }
      
      public static function setup() : void
      {
         var tempXml:XML = null;
         var mapInfo:NewAngelMapInfo = null;
         var xml:XML = XML(new XMLInfo.newAngelMapCls());
         map = new HashMap();
         for each(tempXml in xml.descendants("map"))
         {
            mapInfo = new NewAngelMapInfo(tempXml);
            map.add(mapInfo.id,mapInfo);
         }
      }
      
      public static function getAllMaps() : Array
      {
         return map.getValues();
      }
      
      public static function getMapInfoById(mapId:uint) : NewAngelMapInfo
      {
         return map.getValue(mapId);
      }
   }
}

