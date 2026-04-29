package com.global.staticData.database.SL
{
   public class InfoSLGoodsXmlData
   {
      
      private static var xmlClas:Class = InfoSLGoodsXmlData_xmlClas;
      
      public static const SLGoodsXmlData:XML = XML(new xmlClas());
      
      public function InfoSLGoodsXmlData()
      {
         super();
      }
   }
}

