package org.taomee.ds
{
   public class DLinkedList
   {
      
      public var head:DListNode = null;
      
      public var tail:DListNode = null;
      
      private var _length:uint = 0;
      
      public function DLinkedList(... args)
      {
         var i:uint = 0;
         super();
         var len:uint = uint(args.length);
         if(len > 0)
         {
            this.head = this.tail = new DListNode(args[0]);
            if(len > 1)
            {
               for(i = 1; i < len; i++)
               {
                  this.tail.next = new DListNode(args[i]);
                  this.tail.next.prev = this.tail;
                  this.tail = this.tail.next;
               }
            }
            ++this._length;
         }
      }
      
      public function get(index:uint) : *
      {
         if(this._length <= 0 || index < 0 || index > this._length - 1)
         {
            return null;
         }
         var n:DListNode = this.head;
         var i:uint = 0;
         while(i < index)
         {
            i++;
            n = n.next;
         }
         return n.data;
      }
      
      public function push(obj:*) : *
      {
         if(this._length > 0)
         {
            this.tail.next = new DListNode(obj);
            this.tail.next.prev = this.tail;
            this.tail = this.tail.next;
         }
         else
         {
            this.head = this.tail = new DListNode(obj);
         }
         ++this._length;
         return this.tail.data;
      }
      
      public function pop() : *
      {
         var d:* = undefined;
         if(this._length > 0)
         {
            d = this.tail.data;
            if(this._length == 1)
            {
               this.head = this.tail = null;
            }
            else
            {
               this.tail = this.tail.prev;
               this.tail.next = null;
            }
            --this._length;
            return d;
         }
      }
      
      public function shift() : *
      {
         var d:* = undefined;
         if(this._length > 0)
         {
            d = this.head.data;
            if(this._length == 1)
            {
               this.head = this.tail = null;
            }
            else
            {
               this.head = this.head.next;
               this.head.prev = null;
            }
            --this._length;
            return d;
         }
      }
      
      public function unshift(obj:*) : *
      {
         if(this._length > 0)
         {
            this.head.prev = new DListNode(obj);
            this.head.prev.next = this.head;
            this.head = this.head.prev;
         }
         else
         {
            this.head = this.tail = new DListNode(obj);
         }
         ++this._length;
         return this.head.data;
      }
      
      public function get length() : uint
      {
         return this._length;
      }
      
      public function getIterator() : DListIterator
      {
         return new DListIterator(this,this.head);
      }
      
      public function insert(Iterator:DListIterator, obj:*) : void
      {
         var n:DListNode = null;
         if(Iterator.list != this)
         {
            return;
         }
         if(Boolean(Iterator.node))
         {
            n = new DListNode(obj);
            n.prev = Iterator.node;
            n.next = Iterator.node.next;
            if(Boolean(Iterator.node.next))
            {
               Iterator.node.next.prev = n;
            }
            else
            {
               this.tail = n;
            }
            Iterator.node.next = n;
            ++this._length;
         }
         else
         {
            this.push(obj);
         }
      }
      
      public function remove(Iterator:DListIterator) : *
      {
         if(Iterator.list != this)
         {
            return;
         }
         var n:DListNode = Iterator.node;
         if(Boolean(n))
         {
            if(n == this.head)
            {
               this.head = n.next;
            }
            else if(n == this.tail)
            {
               this.tail = this.tail.prev;
            }
            if(Boolean(n.prev))
            {
               n.prev.next = n.next;
            }
            if(Boolean(n.next))
            {
               n.next.prev = n.prev;
               Iterator.node = n.next;
            }
            else
            {
               Iterator.node = this.head;
            }
            n.prev = n.next = null;
            --this._length;
         }
      }
      
      public function toString() : String
      {
         var str:String = "[";
         var n:DListNode = this.head;
         while(Boolean(n))
         {
            str += n.data.toString();
            if(n != this.tail)
            {
               str += ",";
            }
            n = n.next;
         }
         return str + "]";
      }
   }
}

