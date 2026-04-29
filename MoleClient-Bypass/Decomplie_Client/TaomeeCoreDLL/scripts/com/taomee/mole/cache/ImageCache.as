package com.taomee.mole.cache
{
   import org.taomee.loader.ContentInfo;
   
   internal class ImageCache extends CacheImpl
   {
      
      public function ImageCache()
      {
         super();
      }
      
      override protected function parseOutput(uid:String, type:String, name:String, complete:Function, cacheInfo:CacheInfo, data:* = null) : void
      {
         complete(new ContentInfo(uid,type,cacheInfo.content,cacheInfo.domain,data));
      }
   }
}

