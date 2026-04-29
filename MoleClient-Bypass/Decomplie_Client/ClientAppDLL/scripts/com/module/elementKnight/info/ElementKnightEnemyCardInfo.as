package com.module.elementKnight.info
{
   public class ElementKnightEnemyCardInfo
   {
      
      public var staticId:uint;
      
      public var name:String;
      
      public var attribute:uint;
      
      public var star:uint;
      
      public var minAtk:uint;
      
      public var maxAtk:uint;
      
      public var minDef:uint;
      
      public var maxDef:uint;
      
      public var skill:uint;
      
      public function ElementKnightEnemyCardInfo(xml:XML)
      {
         super();
         this.staticId = uint(xml.@id);
         this.name = String(xml.@name);
         this.star = uint(xml.@star);
         this.attribute = uint(xml.@Attribute);
         this.minAtk = uint(xml.@Act_min);
         this.maxAtk = uint(xml.@Act_max);
         this.minDef = uint(xml.@Def_min);
         this.maxDef = uint(xml.@Def_max);
         this.skill = uint(xml.@skill);
      }
   }
}

