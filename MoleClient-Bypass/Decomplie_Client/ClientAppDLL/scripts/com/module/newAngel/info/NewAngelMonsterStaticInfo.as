package com.module.newAngel.info
{
   public class NewAngelMonsterStaticInfo
   {
      
      public var id:uint;
      
      public var icon:uint;
      
      public var nick:String;
      
      public var atk:uint;
      
      public var speed:uint;
      
      public var hp:uint;
      
      public var def:uint;
      
      public var outputEnergy:uint;
      
      public var atkFrame:uint;
      
      public var escapeLife:uint;
      
      public var announce:String;
      
      public var probability:uint;
      
      public function NewAngelMonsterStaticInfo(xml:XML)
      {
         super();
         this.id = uint(xml.@id);
         this.icon = uint(xml.@icon);
         this.nick = String(xml.@name);
         this.atk = uint(xml.@atk);
         this.speed = uint(xml.@speed);
         this.hp = uint(xml.@hp);
         this.def = uint(xml.@def);
         this.outputEnergy = uint(xml.@output_energy);
         this.atkFrame = uint(xml.@atkFrame);
         this.escapeLife = uint(xml.@escape_life);
         this.announce = String(xml.@announce);
         this.probability = uint(xml.@probability);
      }
   }
}

