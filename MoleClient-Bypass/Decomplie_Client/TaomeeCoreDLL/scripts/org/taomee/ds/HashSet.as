package org.taomee.ds
{
   import flash.utils.Dictionary;
   
   public class HashSet implements ICollection
   {
      
      private var _content:Dictionary;
      
      private var _length:int;
      
      private var _weakKeys:Boolean;
      
      public function HashSet(weakKeys:Boolean = false)
      {
         super();
         this._weakKeys = weakKeys;
         this._content = new Dictionary(weakKeys);
         this._length = 0;
      }
      
      public function get length() : int
      {
         return this._length;
      }
      
      public function add(o:*) : void
      {
         if(o === undefined)
         {
            return;
         }
         if(!(o in this._content))
         {
            ++this._length;
         }
         this._content[o] = o;
      }
      
      public function contains(o:*) : Boolean
      {
         return o in this._content;
      }
      
      public function isEmpty() : Boolean
      {
         return this._length == 0;
      }
      
      public function remove(o:*) : Boolean
      {
         if(o in this._content)
         {
            delete this._content[o];
            --this._length;
            return true;
         }
         return false;
      }
      
      public function clear() : void
      {
         this._content = new Dictionary(this._weakKeys);
         this._length = 0;
      }
      
      public function addAll(arr:Array) : void
      {
         var i:* = undefined;
         for each(i in arr)
         {
            this.add(i);
         }
      }
      
      public function removeAll(arr:Array) : void
      {
         var i:* = undefined;
         for each(i in arr)
         {
            this.remove(i);
         }
      }
      
      public function containsAll(arr:Array) : Boolean
      {
         var i:int = 0;
         var len:int = int(arr.length);
         for(i = 0; i < len; i++)
         {
            if(!(arr[i] in this._content))
            {
               return false;
            }
         }
         return true;
      }
      
      public function forEach(func:Function) : void
      {
         var i:* = undefined;
         for each(i in this._content)
         {
            func(i);
         }
      }
      
      public function some(func:Function) : Boolean
      {
         var i:* = undefined;
         for each(i in this._content)
         {
            if(Boolean(func(i)))
            {
               return true;
            }
         }
         return false;
      }
      
      public function every(func:Function) : Boolean
      {
         var i:* = undefined;
         for each(i in this._content)
         {
            if(!func(i))
            {
               return false;
            }
         }
         return true;
      }
      
      public function toArray() : Array
      {
         var i:* = undefined;
         var arr:Array = new Array(this._length);
         var index:int = 0;
         for each(i in this._content)
         {
            arr[index] = i;
            index++;
         }
         return arr;
      }
      
      public function clone() : HashSet
      {
         var o:* = undefined;
         var csd:HashSet = new HashSet(this._weakKeys);
         for each(o in this._content)
         {
            csd.add(o);
         }
         return csd;
      }
   }
}

