package com.global.staticData.database.cloths
{
   public class InfoSuit
   {
      
      private static var xmlClas:Class = InfoSuit_xmlClas;
      
      public static const SuitXmlData:XML = XML(new xmlClas());
      
      public function InfoSuit()
      {
         super();
      }
   }
}

