package com.global.staticData.database
{
   public class InfosocketXmlData
   {
      
      private static var xmlClas:Class = InfosocketXmlData_xmlClas;
      
      public static const socketXmlData:XML = XML(new xmlClas());
      
      public function InfosocketXmlData()
      {
         super();
      }
   }
}

