package com.module.lamuPkSys.animalSkill.vo
{
   public class SkillInfo
   {
      
      public static const Type_Day:int = 1;
      
      public static const Type_Forever:int = 2;
      
      public var _id:int = -1;
      
      public var _name:String = "";
      
      public var _type:int = -1;
      
      public var _maxTime:int = 0;
      
      public var _readColdTime:int = 0;
      
      public var _configColdTime:int = -1;
      
      public var _usedCount:int = 0;
      
      public function SkillInfo()
      {
         super();
      }
   }
}

