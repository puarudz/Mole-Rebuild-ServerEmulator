package com.module.elementKnight.info
{
   public class ElementKnightTalnetInfo
   {
      
      public var id:uint;
      
      public var type:uint;
      
      public var name:String;
      
      public var time:uint;
      
      public var about:String;
      
      public function ElementKnightTalnetInfo(xml:XML)
      {
         super();
         this.id = uint(xml.@No);
         this.type = uint(xml.@Attribute);
         this.name = String(xml.@Name);
         this.time = uint(xml.@time);
         this.about = String(xml.@about);
      }
   }
}

