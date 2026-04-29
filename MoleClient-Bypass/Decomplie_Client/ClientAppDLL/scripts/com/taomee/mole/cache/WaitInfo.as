package com.taomee.mole.cache
{
   public class WaitInfo
   {
      
      public var uid:String;
      
      public var name:String;
      
      public var completeHandler:Function;
      
      public var errorHandler:Function;
      
      public var data:*;
      
      public function WaitInfo()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.completeHandler = null;
         this.errorHandler = null;
         this.data = null;
      }
   }
}

