package com.core.objectPool
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class ObjectPool
   {
      
      private static var pools:Dictionary = new Dictionary();
      
      private static var typeCount:Dictionary = new Dictionary(true);
      
      public function ObjectPool()
      {
         super();
      }
      
      public static function getPool(object:*) : Array
      {
         var type:Class = null;
         var typeName:String = null;
         if(!(object is Class))
         {
            typeName = getQualifiedClassName(object);
            type = getDefinitionByName(typeName) as Class;
         }
         else
         {
            type = object as Class;
         }
         return type in pools ? pools[type] : (pools[type] = new Array());
      }
      
      public static function getObject(type:Class, ... parameters) : *
      {
         var pool:Array = getPool(type);
         if(pool.length > 0)
         {
            typeCount[type] = pool.length - 1;
            return pool.pop();
         }
         return construct(type,parameters);
      }
      
      public static function getObjectCount(object:*) : uint
      {
         return getPool(object).length;
      }
      
      public static function getObjectsStatus() : void
      {
         var type:String = null;
         for(type in typeCount)
         {
            trace(type,typeCount[type]);
         }
      }
      
      public static function clearObject(object:*) : void
      {
         var tempArray:Array = getPool(object);
         while(Boolean(tempArray.length))
         {
            tempArray.pop();
         }
      }
      
      public static function disposeObject(object:*, type:Class = null, maxLimit:uint = 4294967295) : void
      {
         var typeName:String = null;
         var pool:Array = null;
         if(!object)
         {
            return;
         }
         if(!type)
         {
            typeName = getQualifiedClassName(object);
            type = getDefinitionByName(typeName) as Class;
         }
         if(getPool(type).length < maxLimit)
         {
            if(Boolean(typeCount[type]))
            {
               typeCount[type] = getPool(type).length + 1;
            }
            else
            {
               typeCount[type] = 1;
            }
            pool = getPool(type);
            pool.push(object);
         }
      }
      
      public static function clearObjectPool() : void
      {
         pools = new Dictionary();
         typeCount = new Dictionary(true);
      }
   }
}

