package com.module.pet
{
   public class petClassLearnStatus
   {
      
      public var hasFinish:Boolean = false;
      
      public var classID:int = 0;
      
      public var classStep:int = 0;
      
      public var LearnFlagArray:Array = new Array(32);
      
      public function petClassLearnStatus(_classID:int, _LearnFlagArray:Array = null, _hasFinish:Boolean = false, _classStep:int = 0)
      {
         super();
         this.classID = _classID;
         this.hasFinish = _hasFinish;
         this.classStep = _classStep;
         if(Boolean(_LearnFlagArray))
         {
            this.LearnFlagArray = _LearnFlagArray;
         }
      }
   }
}

