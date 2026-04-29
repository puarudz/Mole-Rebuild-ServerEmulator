package com.module.newAngel.info
{
   public class NewAngelMapInfo
   {
      
      public var id:uint;
      
      public var name:String;
      
      public var tollgates:Vector.<Array>;
      
      public function NewAngelMapInfo(xml:XML)
      {
         var tempXml:XML = null;
         super();
         this.id = uint(xml.@id);
         this.name = String(xml.@name);
         this.tollgates = new Vector.<Array>();
         for each(tempXml in xml.descendants("item"))
         {
            this.tollgates.push([uint(tempXml.@id),tempXml.@monsterId]);
         }
      }
   }
}

