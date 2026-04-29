package com.global.staticData.database.post
{
   public class InfopostListXML
   {
      
      private static var xmlClas:Class = InfopostListXML_xmlClas;
      
      public static const postListXML:XML = XML(new xmlClas());
      
      public function InfopostListXML()
      {
         super();
      }
   }
}

