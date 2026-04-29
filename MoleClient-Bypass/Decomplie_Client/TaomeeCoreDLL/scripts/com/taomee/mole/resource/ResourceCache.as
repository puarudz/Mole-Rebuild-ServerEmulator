package com.taomee.mole.resource
{
   public class ResourceCache
   {
      
      private var _max_size:uint;
      
      private var _resourceMap:Array;
      
      public function ResourceCache(size:int = 100)
      {
         super();
         this._resourceMap = [];
         this._max_size = size;
      }
      
      public function get max_size() : uint
      {
         return this._max_size;
      }
      
      public function set max_size(value:uint) : void
      {
         this._max_size = value;
      }
      
      private function update(key:String) : void
      {
         var item:ResourceItem = null;
         var index:int = this.getItemIndex(key);
         if(index >= 0)
         {
            item = this._resourceMap[index];
            this._resourceMap.splice(index,1);
            this._resourceMap.push(item);
         }
      }
      
      private function getItem(key:String) : ResourceItem
      {
         var item:ResourceItem = null;
         for each(item in this._resourceMap)
         {
            if(item.key == key)
            {
               return item;
            }
         }
         return null;
      }
      
      private function getItemIndex(key:String) : int
      {
         var item:ResourceItem = null;
         for(var i:int = 0; i < this._resourceMap.length; i++)
         {
            item = this._resourceMap[i];
            if(item.key == key)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function find(key:String, complete:Function, progress:Function = null, vars:* = null, skipError:Boolean = false) : void
      {
         var item:ResourceItem = this.getItem(key);
         if(Boolean(item))
         {
            this.update(key);
            if(progress != null)
            {
               progress(1);
            }
            if(complete != null)
            {
               if(vars != null)
               {
                  complete(item.data,vars);
               }
               else
               {
                  complete(item.data);
               }
            }
         }
         else
         {
            this.load(key,complete,progress,vars,skipError);
         }
      }
      
      public function load(key:String, complete:Function, progress:Function = null, vars:* = null, skipError:Boolean = false) : void
      {
         var loader:RESLoader = ResourceManager.createLoader(key);
         loader.completeHandler = function(loader:RESLoader):void
         {
            if(progress != null)
            {
               progress(100);
            }
            if(complete != null)
            {
               put(key,loader.data);
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
            if(skipError)
            {
               loader.completeHandler(loader);
            }
            loader.destroy();
         };
         loader.load(key);
      }
      
      public function put(key:String, data:*) : void
      {
         var item:ResourceItem = null;
         if(this._resourceMap.length > this.max_size)
         {
            item = this._resourceMap.shift() as ResourceItem;
         }
         this._resourceMap.push(new ResourceItem(key,data));
      }
      
      public function remove(key:String) : void
      {
         var index:int = this.getItemIndex(key);
         if(index >= 0)
         {
            this._resourceMap.splice(index,1);
         }
      }
      
      public function containsKey(key:String) : Boolean
      {
         return this.getItem(key) != null;
      }
      
      public function fetch(key:String) : *
      {
         var item:ResourceItem = this.getItem(key);
         if(Boolean(item))
         {
            this.update(key);
            return item.data;
         }
         return null;
      }
   }
}

