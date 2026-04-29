package com.taomee.mole.resource
{
   import flash.system.ApplicationDomain;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   
   public class ResourceManager
   {
      
      private static var _resourceCache:ResourceCache = new ResourceCache();
      
      private static var _resourceMap:HashMap = new HashMap();
      
      private static var _id:int = 0;
      
      private static var _processes:Object = {};
      
      public static const NO_CACHE:int = 0;
      
      public static const TEMP_CACHE:int = 1;
      
      public static const PERM_CACHE:int = 2;
      
      public function ResourceManager()
      {
         super();
      }
      
      public static function loadFile(url:String, complete:Function, progress:Function = null, vars:* = null, lazy:int = 1, skipError:Boolean = false, errorHanlder:Function = null) : void
      {
         var loader:RESLoader = null;
         if(lazy == ResourceManager.TEMP_CACHE)
         {
            _resourceCache.find(url,complete,progress,vars,skipError);
         }
         else
         {
            loader = createLoader(url);
            loader.completeHandler = function(loader:RESLoader):void
            {
               if(progress != null)
               {
                  progress(100);
               }
               if(complete != null)
               {
                  if(lazy == ResourceManager.PERM_CACHE)
                  {
                     _resourceMap.add(url,loader.data);
                  }
                  if(vars != null)
                  {
                     complete(loader.data,vars);
                  }
                  else
                  {
                     complete(loader.data);
                  }
               }
               loader.destroy();
            };
            loader.progressHandler = progress;
            loader.errorHandler = function(loader:RESLoader):void
            {
               if(errorHanlder != null)
               {
                  errorHanlder();
               }
               if(skipError)
               {
                  loader.completeHandler(loader);
               }
               loader.destroy();
            };
            loader.load(url);
         }
      }
      
      public static function loadList(list:Array, complete:Function, progress:Function = null, vars:* = null, lazy:int = 1, skipError:Boolean = false) : void
      {
         var args:Object = null;
         var url:String = null;
         var timeoutId:int = 0;
         var newlist:Array = [];
         if(Boolean(list))
         {
            for each(url in list)
            {
               if(Boolean(url) && !_resourceCache.containsKey(url))
               {
                  newlist.push(url);
               }
            }
         }
         args = {
            "complete":complete,
            "progress":progress,
            "vars":vars,
            "lazy":lazy
         };
         if(newlist.length > 0)
         {
            ++_id;
            _processes[_id] = true;
            loadOne(newlist,0,args,_id,skipError);
         }
         else
         {
            timeoutId = int(setTimeout(function():void
            {
               if(args.progress != null)
               {
                  if(args.progress.length == 1)
                  {
                     args.progress(100);
                  }
                  else if(args.progress.length == 3)
                  {
                     args.progress(1,1,100);
                  }
               }
               if(args.complete != null)
               {
                  if(args.vars != null)
                  {
                     args.complete(args.vars);
                  }
                  else
                  {
                     args.complete();
                  }
               }
               clearTimeout(timeoutId);
            },10));
         }
      }
      
      private static function loadOne(list:Array, index:int, args:Object, id:int = 0, skipError:Boolean = false) : void
      {
         var len:int = 0;
         len = int(list.length);
         var url:String = list[index];
         var loader:RESLoader = createLoader(url);
         loader.completeHandler = function(loader:RESLoader):void
         {
            if(args.lazy == ResourceManager.TEMP_CACHE)
            {
               _resourceCache.put(loader.url,loader.data);
            }
            else if(args.lazy == ResourceManager.PERM_CACHE)
            {
               _resourceMap.add(loader.url,loader.data);
            }
            if(_processes[id] == false)
            {
               delete _processes[id];
               return;
            }
            if(index + 1 >= len)
            {
               delete _processes[id];
               if(args.progress != null)
               {
                  if(args.progress.length == 1)
                  {
                     args.progress(100);
                  }
                  else if(args.progress.length == 3)
                  {
                     args.progress(index + 1,len,100);
                  }
               }
               if(Boolean(args.vars))
               {
                  args.complete(args.vars);
               }
               else
               {
                  args.complete();
               }
            }
            else
            {
               loadOne(list,index + 1,args,id,skipError);
            }
            loader.destroy();
         };
         loader.progressHandler = function(percent:int):void
         {
            if(args.progress != null)
            {
               if(args.progress.length == 1)
               {
                  args.progress((index * 100 + percent) / (len * 100) * 100);
               }
               else if(args.progress.length == 3)
               {
                  args.progress(index,len,percent);
               }
            }
         };
         loader.errorHandler = function(loader:RESLoader):void
         {
            if(skipError)
            {
               loader.completeHandler(loader);
            }
            loader.destroy();
         };
         loader.load(url);
      }
      
      public static function removeResource(url:String) : void
      {
         if(_resourceMap.containsKey(url))
         {
            _resourceMap.remove(url);
         }
      }
      
      public static function removeResources(urls:Array) : void
      {
         var url:String = null;
         for each(url in urls)
         {
            removeResource(url);
         }
      }
      
      public static function createLoader(url:String) : RESLoader
      {
         var symbolpos:int = url.lastIndexOf("/");
         var argpos:int = url.indexOf("?");
         var file:String = url.substring(symbolpos + 1,argpos != -1 ? argpos : int.MAX_VALUE);
         var extension:String = file.substring(file.lastIndexOf(".") + 1).toLowerCase();
         switch(extension)
         {
            case "swf":
            case "png":
            case "jpg":
               return new SWFLoader();
            case "zip":
            case "bin":
               return new DataLoader();
            case "xml":
            case "csv":
               return new TextLoader();
            default:
               throw new Error("未定义的文件类型: " + url);
         }
      }
      
      public static function fetch(url:String) : *
      {
         if(_resourceMap.containsKey(url))
         {
            return _resourceMap.getValue(url);
         }
         return _resourceCache.fetch(url);
      }
      
      public static function has(url:String) : Boolean
      {
         if(!_resourceMap.containsKey(url) && !_resourceCache.containsKey(url))
         {
            return false;
         }
         return true;
      }
      
      public static function getClass(className:String, url:String = "") : Class
      {
         var domain:ApplicationDomain = ApplicationDomain.currentDomain;
         if(Boolean(url) && _resourceMap.containsKey(url))
         {
            domain = _resourceMap.getValue(url).loaderInfo.applicationDomain;
         }
         else if(Boolean(url) && _resourceCache.containsKey(url))
         {
            domain = _resourceCache.fetch(url).loaderInfo.applicationDomain;
         }
         if(domain.hasDefinition(className))
         {
            return domain.getDefinition(className) as Class;
         }
         return null;
      }
      
      public static function getObject(className:String, url:String = "") : Object
      {
         var objectClass:Class = getClass(className,url);
         if(Boolean(objectClass))
         {
            return new objectClass();
         }
         return null;
      }
   }
}

