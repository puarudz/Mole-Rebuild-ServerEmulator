package org.taomee.ds
{
   public class Heap
   {
      
      private var _heap:Array;
      
      private var _compare:Function;
      
      public function Heap(compare:Function = null)
      {
         super();
         this._heap = [];
         if(compare == null)
         {
            this._compare = function(a:int, b:int):int
            {
               return a - b;
            };
         }
         else
         {
            this._compare = compare;
         }
      }
      
      public function get length() : uint
      {
         return this._heap.length;
      }
      
      public function modify(obj:*, newObj:*) : Boolean
      {
         var objIndex:int = this._heap.indexOf(obj);
         if(objIndex < 0)
         {
            return false;
         }
         this._heap[objIndex] = newObj;
         var parentIndex:int = objIndex - 1 >> 1;
         var temp:* = this._heap[objIndex];
         while(objIndex > 0)
         {
            if(this._compare(temp,this._heap[parentIndex]) <= 0)
            {
               break;
            }
            this._heap[objIndex] = this._heap[parentIndex];
            objIndex = parentIndex;
            parentIndex = parentIndex - 1 >> 1;
         }
         this._heap[objIndex] = temp;
         return true;
      }
      
      public function enqueue(obj:*) : void
      {
         this._heap.push(obj);
         var parentIndex:int = this._heap.length - 2 >> 1;
         var objIndex:int = this._heap.length - 1;
         var temp:* = this._heap[objIndex];
         while(objIndex > 0)
         {
            if(this._compare(temp,this._heap[parentIndex]) <= 0)
            {
               break;
            }
            this._heap[objIndex] = this._heap[parentIndex];
            objIndex = parentIndex;
            parentIndex = parentIndex - 1 >> 1;
         }
         this._heap[objIndex] = temp;
      }
      
      public function dequeue() : *
      {
         var r:* = undefined;
         var parentIndex:int = 0;
         var childIndex:int = 0;
         var temp:* = undefined;
         if(this._heap.length > 1)
         {
            r = this._heap[0];
            this._heap[0] = this._heap.pop();
            parentIndex = 0;
            childIndex = 1;
            temp = this._heap[parentIndex];
            while(childIndex <= this._heap.length - 1)
            {
               if(Boolean(this._heap[childIndex + 1]) && this._compare(this._heap[childIndex],this._heap[childIndex + 1]) < 0)
               {
                  childIndex++;
               }
               if(this._compare(temp,this._heap[childIndex]) >= 0)
               {
                  break;
               }
               this._heap[parentIndex] = this._heap[childIndex];
               parentIndex = childIndex;
               childIndex = (childIndex << 1) + 1;
            }
            this._heap[parentIndex] = temp;
            return r;
         }
         return this._heap.pop();
      }
      
      public function toString() : String
      {
         return this._heap.toString();
      }
      
      public function get heap() : Array
      {
         return this._heap;
      }
   }
}

