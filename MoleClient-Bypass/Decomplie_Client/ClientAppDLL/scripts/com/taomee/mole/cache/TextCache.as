package com.taomee.mole.cache
{
   import org.taomee.loader.ContentInfo;
   
   internal class TextCache extends CacheImpl
   {
      
      public function TextCache()
      {
         super();
      }
      
      override protected function parseOutput(uid:String, type:String, name:String, complete:Function, cacheInfo:CacheInfo, data:* = null) : void
      {
         complete(new ContentInfo(uid,type,cacheInfo.content,cacheInfo.domain,data));
      }
   }
}

