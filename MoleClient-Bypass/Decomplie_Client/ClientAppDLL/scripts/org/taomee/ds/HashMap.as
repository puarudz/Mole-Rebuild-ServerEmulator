package org.taomee.ds
{
   import flash.utils.Dictionary;
   
   public class HashMap implements ICollection
   {
      
      private var _length:int;
      
      private var _content:Dictionary;
      
      private var _weakKeys:Boolean;
      
      public function HashMap(weakKeys:Boolean = false)
      {
         super();
         this._weakKeys = weakKeys;
         this._length = 0;
         this._content = new Dictionary(weakKeys);
      }
      
      public function get weakKeys() : Boolean
      {
         return this._weakKeys;
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
         for(i in this._content)
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
         for each(i in this._content)
         {
            temp[index] = i;
            index++;
         }
         return temp;
      }
      
      public function eachKey(func:Function) : void
      {
         var i:* = undefined;
         for(i in this._content)
         {
            func(i);
         }
      }
      
      public function eachValue(func:Function) : void
      {
         var i:* = undefined;
         for each(i in this._content)
         {
            func(i);
         }
      }
      
      public function forEach(func:Function) : void
      {
         var i:* = undefined;
         for(i in this._content)
         {
            func(i,this._content[i]);
         }
      }
      
      public function containsValue(value:*) : Boolean
      {
         var i:* = undefined;
         for each(i in this._content)
         {
            if(i === value)
            {
               return true;
            }
         }
         return false;
      }
      
      public function some(func:Function) : Boolean
      {
         var i:* = undefined;
         for(i in this._content)
         {
            if(Boolean(func(i,this._content[i])))
            {
               return true;
            }
         }
         return false;
      }
      
      public function every(func:Function) : Boolean
      {
         var i:* = undefined;
         for(i in this._content)
         {
            if(!func(i,this._content[i]))
            {
               return false;
            }
         }
         return true;
      }
      
      public function filter(func:Function) : Array
      {
         var i:* = undefined;
         var v:* = undefined;
         var arr:Array = [];
         for(i in this._content)
         {
            v = this._content[i];
            if(Boolean(func(i,v)))
            {
               arr.push(v);
            }
         }
         return arr;
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
         return value === undefined ? null : value;
      }
      
      public function getKey(value:*) : *
      {
         var i:* = undefined;
         for(i in this._content)
         {
            if(this._content[i] == value)
            {
               return i;
            }
         }
         return null;
      }
      
      public function add(key:*, value:*) : *
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
         if(!(key in this._content))
         {
            ++this._length;
         }
         oldValue = this.getValue(key);
         this._content[key] = value;
         return oldValue;
      }
      
      public function remove(key:*) : *
      {
         if(!(key in this._content))
         {
            return null;
         }
         var temp:* = this._content[key];
         delete this._content[key];
         --this._length;
         return temp;
      }
      
      public function clear() : void
      {
         this._length = 0;
         this._content = new Dictionary(this._weakKeys);
      }
      
      public function clone() : HashMap
      {
         var i:* = undefined;
         var temp:HashMap = new HashMap(this._weakKeys);
         for(i in this._content)
         {
            temp.add(i,this._content[i]);
         }
         return temp;
      }
      
      public function toString() : String
      {
         var i:int = 0;
         var ks:Array = this.getKeys();
         var vs:Array = this.getValues();
         var len:int = int(ks.length);
         var temp:String = "HashMap Content:\n";
         for(i = 0; i < len; i++)
         {
            temp += ks[i] + " -> " + vs[i] + "\n";
         }
         return temp;
      }
   }
}

