package com.taomee.mole.cache
{
   import com.taomee.mole.resource.ResourceManager;
   import flash.display.MovieClip;
   import org.taomee.loader.ContentInfo;
   import org.taomee.loader.LoadType;
   import org.taomee.utils.DisplayUtil;
   
   public class FastCacheManager
   {
      
      public function FastCacheManager()
      {
         super();
      }
      
      public static function getPhasorContent(uid:String, name:String, complete:Function, error:Function = null, data:* = null) : void
      {
         var completeHandler:Function = null;
         var errorHandler:Function = null;
         completeHandler = function(mc:MovieClip, data:* = null):void
         {
            DisplayUtil.stopAllMovieClip(mc);
            DisplayUtil.removeAllChildren(mc);
            if(complete != null)
            {
               complete(new ContentInfo(uid,LoadType.DOMAIN,getObject(mc,name),mc.loaderInfo.applicationDomain,data));
            }
         };
         errorHandler = function():void
         {
            if(error != null)
            {
               error(new ContentInfo(uid,LoadType.DOMAIN,null,null,data));
            }
         };
         ResourceManager.loadFile(uid,completeHandler,null,data,ResourceManager.TEMP_CACHE,false,errorHandler);
      }
      
      public static function getClass(mc:MovieClip, name:String) : Class
      {
         if(mc.loaderInfo.applicationDomain.hasDefinition(name))
         {
            return mc.loaderInfo.applicationDomain.getDefinition(name) as Class;
         }
         return null;
      }
      
      public static function getObject(mc:MovieClip, name:String) : Object
      {
         var objectClass:Class = getClass(mc,name);
         if(Boolean(objectClass))
         {
            return new objectClass();
         }
         return null;
      }
   }
}

