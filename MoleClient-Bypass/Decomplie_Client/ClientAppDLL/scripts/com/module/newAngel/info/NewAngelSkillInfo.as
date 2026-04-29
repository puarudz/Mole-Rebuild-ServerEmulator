package com.module.newAngel.info
{
   public class NewAngelSkillInfo
   {
      
      public var id:uint;
      
      public var name:String;
      
      public var hp:uint;
      
      public var atk:uint;
      
      public var def:uint;
      
      public var cd:uint;
      
      public var atkScope:uint;
      
      public var applyScope:uint;
      
      public var bufferId:uint;
      
      public var bufferProbability:uint;
      
      public var buffValue:uint;
      
      public var runTime:Number;
      
      public var about:String;
      
      public function NewAngelSkillInfo(xml:XML)
      {
         super();
         this.id = uint(xml.@id);
         this.name = String(xml.@name);
         this.hp = uint(xml.@hp);
         this.atk = uint(xml.@atk);
         this.def = uint(xml.@def);
         this.cd = uint(xml.@cd);
         this.atkScope = uint(xml.@atkScope);
         this.applyScope = uint(xml.@applyScope);
         this.bufferId = uint(xml.@bufferId);
         this.bufferProbability = uint(xml.@bufferProbability);
         this.buffValue = uint(xml.@buffValue);
         this.runTime = Number(xml.@runTime);
         this.about = String(xml.@about);
      }
   }
}

