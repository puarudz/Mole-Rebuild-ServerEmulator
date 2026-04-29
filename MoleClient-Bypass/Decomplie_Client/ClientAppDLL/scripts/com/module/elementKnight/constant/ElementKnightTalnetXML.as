package com.module.elementKnight.constant
{
   import com.global.staticData.XMLInfo;
   import com.module.elementKnight.info.ElementKnightTalnetInfo;
   import org.taomee.ds.HashMap;
   
   public class ElementKnightTalnetXML
   {
      
      private static var talnetMap:HashMap;
      
      public function ElementKnightTalnetXML()
      {
         super();
      }
      
      public static function setup() : void
      {
         var talnetInfo:ElementKnightTalnetInfo = null;
         var tempXml:XML = null;
         var xml:XML = XML(new XMLInfo.elementKnightTalnetCls());
         talnetMap = new HashMap();
         for each(tempXml in xml.descendants("Gift"))
         {
            talnetInfo = new ElementKnightTalnetInfo(tempXml);
            talnetMap.add(talnetInfo.id + "_" + talnetInfo.type,talnetInfo);
         }
      }
      
      public static function getTalnetInfo(id:uint, type:uint) : ElementKnightTalnetInfo
      {
         return talnetMap.getValue(id + "_" + type);
      }
   }
}

