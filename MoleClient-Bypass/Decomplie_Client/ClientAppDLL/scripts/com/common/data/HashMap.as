package com.common.data
{
   import flash.utils.Dictionary;
   
   public class HashMap
   {
      
      private var _length:int;
      
      private var _weakKeys:Boolean;
      
      private var _content:Dictionary;
      
      public function HashMap(weakKeys:Boolean = false)
      {
         super();
         this._weakKeys = weakKeys;
         this._length = 0;
         this._content = new Dictionary(weakKeys);
      }
      
      public function containsKey(key:*) : Boolean
      {
         if(key in this._content)
         {
            return true;
         }
         return false;
      }
      
      public function getValue(key:*) : *
      {
         var value:* = this._content[key];
         return value == undefined ? null : value;
      }
      
      public function remove(key:*) : *
      {
         if(!(key in this._content))
         {
            return null;
         }
         var value:* = this._content[key];
         delete this._content[key];
         --this._length;
         return value;
      }
      
      public function get weakKeys() : Boolean
      {
         return this._weakKeys;
      }
      
      public function clear() : void
      {
         this._length = 0;
         this._content = new Dictionary(this._weakKeys);
      }
      
      public function containsValue(value:*) : Boolean
      {
         var value1:* = undefined;
         for each(value1 in this._content)
         {
            if(value1 === value)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get values() : Array
      {
         var value:* = undefined;
         var result:Array = new Array(this._length);
         var key:int = 0;
         for each(value in this._content)
         {
            result[key++] = value;
         }
         return result;
      }
      
      public function clone() : HashMap
      {
         var key:* = undefined;
         var hashMap:HashMap = new HashMap(this._weakKeys);
         for(key in this._content)
         {
            hashMap.add(key,this._content[key]);
         }
         return hashMap;
      }
      
      public function add(key:*, value:*) : *
      {
         var resValue:* = undefined;
         if(key == null)
         {
            throw new ArgumentError("cannot put a value with undefined or null key!");
         }
         if(value == null)
         {
            return null;
         }
         if(!(key in this._content))
         {
            ++this._length;
         }
         resValue = this.getValue(key);
         this._content[key] = value;
         return resValue;
      }
      
      public function isEmpty() : Boolean
      {
         return this._length == 0;
      }
      
      public function get length() : int
      {
         return this._length;
      }
      
      public function getKey(value:*) : *
      {
         var key:* = undefined;
         for(key in this._content)
         {
            if(this._content[key] == value)
            {
               return key;
            }
         }
         return null;
      }
      
      public function get keys() : Array
      {
         var key:* = undefined;
         var resArr:Array = new Array(this._length);
         var idx:int = 0;
         for(key in this._content)
         {
            resArr[idx++] = key;
         }
         return resArr;
      }
      
      public function combine(surData:HashMap) : void
      {
         var tmpKeys:Array = null;
         var tmpKey:* = undefined;
         if(Boolean(surData))
         {
            tmpKeys = surData.keys;
            for each(tmpKey in tmpKeys)
            {
               this.add(tmpKey,surData.getValue(tmpKey));
            }
         }
      }
      
      public function toString() : String
      {
         var idx:int = 0;
         var keyList:Array = this.keys;
         var valueList:Array = this.values;
         var len:uint = keyList.length;
         var str:String = "HashMap-----------------------------------------------------";
         idx = 0;
         while(idx++ < len)
         {
            str += keyList[idx] + " -> " + valueList[idx] + "\n";
         }
         return str + "-----------------------------------------------------";
      }
   }
}

