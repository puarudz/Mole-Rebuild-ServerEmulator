package com.global.staticData.database
{
   public class InfobgMusicXmlData
   {
      
      private static var xmlClas:Class = InfobgMusicXmlData_xmlClas;
      
      public static const bgMusicXmlData:XML = XML(new xmlClas());
      
      public function InfobgMusicXmlData()
      {
         super();
      }
   }
}

