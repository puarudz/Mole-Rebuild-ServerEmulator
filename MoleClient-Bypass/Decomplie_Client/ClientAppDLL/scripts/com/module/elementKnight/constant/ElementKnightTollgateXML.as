package com.module.elementKnight.constant
{
   import com.global.staticData.XMLInfo;
   import com.module.elementKnight.info.ElementKnightTollgateInfo;
   import org.taomee.ds.HashMap;
   
   public class ElementKnightTollgateXML
   {
      
      private var _tollgateMap:HashMap;
      
      public function ElementKnightTollgateXML()
      {
         super();
      }
      
      public function setup() : void
      {
         var tollgateInfo:ElementKnightTollgateInfo = null;
         var tempXml:XML = null;
         var xml:XML = XML(new XMLInfo.elementKnightCardPVEStageCls());
         this._tollgateMap = new HashMap();
         for each(tempXml in xml.elements("Stage"))
         {
            tollgateInfo = new ElementKnightTollgateInfo(tempXml);
            this._tollgateMap.add(tollgateInfo.id,tollgateInfo);
         }
      }
      
      public function get tollgateMap() : HashMap
      {
         return this._tollgateMap;
      }
   }
}

