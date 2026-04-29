package com.module.newAngel.info
{
   public class NewAngelBuffInfo
   {
      
      public var id:uint;
      
      public var priority:uint;
      
      public var name:String;
      
      public var isTopShow:Boolean;
      
      public function NewAngelBuffInfo(xml:XML)
      {
         super();
         this.id = uint(xml.@id);
         this.priority = uint(xml.@priority);
         this.name = String(xml.@name);
         this.isTopShow = uint(xml.@isTopShow) == 1;
      }
   }
}

