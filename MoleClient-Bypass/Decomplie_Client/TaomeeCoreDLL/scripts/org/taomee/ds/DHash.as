package org.taomee.ds
{
   import flash.utils.Dictionary;
   
   public class DHash implements ICollection
   {
      
      private var _length:int;
      
      private var _contentKey:Dictionary;
      
      private var _contentValue:Dictionary;
      
      private var _weakKeys:Boolean;
      
      public function DHash(weakKeys:Boolean = false)
      {
         super();
         this._weakKeys = weakKeys;
         this._length = 0;
         this._contentKey = new Dictionary(weakKeys);
         this._contentValue = new Dictionary(weakKeys);
      }
      
      public function get length() : int
      {
         return this._length;
      }
      
      public function isEmpty() : Boolean
      {
         return this._length == 0;
      }
      
      public function getKeys() : Array
      {
         var i:* = undefined;
         var temp:Array = new Array(this._length);
         var index:int = 0;
         for each(i in this._contentValue)
         {
            temp[index] = i;
            index++;
         }
         return temp;
      }
      
      public function getValues() : Array
      {
         var i:* = undefined;
         var temp:Array = new Array(this._length);
         var index:int = 0;
         for each(i in this._contentKey)
         {
            temp[index] = i;
            index++;
         }
         return temp;
      }
      
      public function eachKey(func:Function) : void
      {
         var i:* = undefined;
         for each(i in this._contentValue)
         {
            func(i);
         }
      }
      
      public function eachValue(func:Function) : void
      {
         var i:* = undefined;
         for each(i in this._contentKey)
         {
            func(i);
         }
      }
      
      public function forEach(func:Function) : void
      {
         var i:* = undefined;
         for(i in this._contentKey)
         {
            func(i,this._contentKey[i]);
         }
      }
      
      public function containsValue(value:*) : Boolean
      {
         return value in this._contentValue;
      }
      
      public function containsKey(key:*) : Boolean
      {
         return key in this._contentKey;
      }
      
      public function contains(kv:*) : Boolean
      {
         if(kv in this._contentKey)
         {
            return true;
         }
         if(kv in this._contentValue)
         {
            return true;
         }
         return false;
      }
      
      public function getValue(key:*) : *
      {
         var value:* = this._contentKey[key];
         return value === undefined ? null : value;
      }
      
      public function getKey(value:*) : *
      {
         var key:* = this._contentValue[value];
         return key === undefined ? null : key;
      }
      
      public function addForKey(key:*, value:*) : *
      {
         var oldValue:* = undefined;
         if(key == null)
         {
            throw new ArgumentError("cannot put a value with undefined or null key!");
         }
         if(value === undefined)
         {
            return null;
         }
         if(!(key in this._contentKey))
         {
            ++this._length;
         }
         oldValue = this.getValue(key);
         delete this._contentValue[oldValue];
         this._contentKey[key] = value;
         this._contentValue[value] = key;
         return oldValue;
      }
      
      public function addForValue(value:*, key:*) : *
      {
         var oldKey:* = undefined;
         if(value == null)
         {
            throw new ArgumentError("cannot put a key with undefined or null value!");
         }
         if(key === undefined)
         {
            return null;
         }
         if(!(value in this._contentValue))
         {
            ++this._length;
         }
         oldKey = this.getKey(value);
         delete this._contentKey[oldKey];
         this._contentValue[value] = key;
         this._contentKey[key] = value;
         return oldKey;
      }
      
      public function removeForKey(key:*) : *
      {
         var value:* = undefined;
         if(key in this._contentKey)
         {
            value = this._contentKey[key];
            delete this._contentKey[key];
            delete this._contentValue[value];
            --this._length;
            return value;
         }
         return null;
      }
      
      public function removeForValue(value:*) : *
      {
         var key:* = undefined;
         if(value in this._contentValue)
         {
            key = this._contentValue[value];
            delete this._contentValue[value];
            delete this._contentKey[key];
            --this._length;
            return key;
         }
         return null;
      }
      
      public function clear() : void
      {
         this._length = 0;
         this._contentKey = new Dictionary(this._weakKeys);
         this._contentValue = new Dictionary(this._weakKeys);
      }
      
      public function clone() : DHash
      {
         var i:* = undefined;
         var temp:DHash = new DHash(this._weakKeys);
         for(i in this._contentKey)
         {
            temp.addForKey(i,this._contentKey[i]);
         }
         return temp;
      }
   }
}

