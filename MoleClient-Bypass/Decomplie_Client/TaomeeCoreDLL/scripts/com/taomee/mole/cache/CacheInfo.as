package com.taomee.mole.cache
{
   import flash.system.ApplicationDomain;
   
   internal class CacheInfo
   {
      
      public var useCount:uint;
      
      public var uid:String;
      
      public var content:*;
      
      public var domain:ApplicationDomain;
      
      public function CacheInfo()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.content = null;
         this.domain = null;
      }
   }
}

