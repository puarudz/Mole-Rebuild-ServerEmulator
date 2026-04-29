package com.module.elementKnight.constant
{
   import com.global.staticData.XMLInfo;
   import com.module.elementKnight.info.ElementKnightCardAdvanceInfo;
   import org.taomee.ds.HashMap;
   
   public class ElementKnightCardAdvanceXML
   {
      
      private var _advanceMap:HashMap;
      
      public function ElementKnightCardAdvanceXML()
      {
         super();
      }
      
      public function setup() : void
      {
         var advanceInfo:ElementKnightCardAdvanceInfo = null;
         var tempXml:XML = null;
         var xml:XML = XML(new XMLInfo.elementKnightCardAdvanceCls());
         this._advanceMap = new HashMap();
         for each(tempXml in xml.elements("card"))
         {
            advanceInfo = new ElementKnightCardAdvanceInfo(tempXml);
            this._advanceMap.add(advanceInfo.cardId,advanceInfo);
         }
      }
      
      public function get advanceMap() : HashMap
      {
         return this._advanceMap;
      }
   }
}

