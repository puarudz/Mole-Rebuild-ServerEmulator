package com.module.newAngel.info
{
   public class NewAngelTollgateInfo
   {
      
      public var id:uint;
      
      public var name:String;
      
      public var passToll:uint;
      
      public var minDifficultStep:uint;
      
      public var maxDifficultStep:uint;
      
      public var exp:uint;
      
      public var desc:String;
      
      public var items:Vector.<Array>;
      
      public var hp:uint;
      
      public var wave:uint;
      
      public var strategy:String;
      
      public function NewAngelTollgateInfo(xml:XML)
      {
         var tempXml:XML = null;
         super();
         this.id = uint(xml.@id);
         this.name = String(xml.@name);
         this.passToll = uint(xml.@passToll);
         this.exp = uint(xml.@exp);
         this.minDifficultStep = uint(xml.@minDifficultStep);
         this.maxDifficultStep = uint(xml.@maxDifficultStep);
         this.desc = String(xml.@desc);
         this.items = new Vector.<Array>();
         for each(tempXml in xml.elements("Item"))
         {
            this.items.push([uint(tempXml.@id),uint(tempXml.@num)]);
         }
         this.hp = uint(xml.@life);
         this.wave = uint(xml.@num);
         this.strategy = String(xml.@strategy);
      }
   }
}

