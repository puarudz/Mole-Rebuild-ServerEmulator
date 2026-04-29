package com.module.newAngel.constant
{
   import com.global.staticData.XMLInfo;
   import org.taomee.ds.HashMap;
   
   public class NewAngelIntrXML
   {
      
      private static var intrMap:HashMap;
      
      private static var sourceMap:HashMap;
      
      setup();
      
      public function NewAngelIntrXML()
      {
         super();
      }
      
      public static function setup() : void
      {
         var tempXml:XML = null;
         var xml:XML = XML(new XMLInfo._angelIntrCls());
         intrMap = new HashMap();
         sourceMap = new HashMap();
         for each(tempXml in xml.elements("Item"))
         {
            intrMap.add(uint(tempXml.@ID),String(tempXml.@About));
            sourceMap.add(uint(tempXml.@ID),String(tempXml.@source));
         }
      }
      
      public static function getNewAngelIntr(angelId:uint) : String
      {
         return intrMap.getValue(angelId);
      }
      
      public static function getNewAngelSource(angelId:uint) : String
      {
         return sourceMap.getValue(angelId);
      }
      
      public static function getAllAngelId() : Array
      {
         return intrMap.getKeys();
      }
   }
}

