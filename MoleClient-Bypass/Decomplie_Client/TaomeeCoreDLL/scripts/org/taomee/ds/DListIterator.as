package org.taomee.ds
{
   public class DListIterator
   {
      
      public var node:DListNode;
      
      public var list:DLinkedList;
      
      public function DListIterator(list:DLinkedList, node:DListNode = null)
      {
         super();
         this.list = list;
         this.node = node;
      }
      
      public function start() : void
      {
         this.node = this.list.head;
      }
      
      public function end() : void
      {
         this.node = this.list.tail;
      }
      
      public function next() : void
      {
         this.node = this.node.next;
      }
      
      public function prev() : void
      {
         this.node = this.node.prev;
      }
      
      public function hasNext() : Boolean
      {
         return this.node != null;
      }
      
      public function hasPrev() : Boolean
      {
         return this.node != null;
      }
   }
}

