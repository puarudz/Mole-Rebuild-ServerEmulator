package com.mole.app.info
{
   public class SuitCloth
   {
      
      public var name:String;
      
      public var clothList:Vector.<ClothInfo>;
      
      public function SuitCloth(name:String, clothList:Vector.<ClothInfo>)
      {
         super();
         this.name = name;
         this.clothList = clothList;
      }
   }
}

