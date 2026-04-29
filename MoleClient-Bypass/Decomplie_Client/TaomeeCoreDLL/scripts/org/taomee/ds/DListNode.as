package org.taomee.ds
{
   public class DListNode
   {
      
      public var data:*;
      
      public var next:DListNode = null;
      
      public var prev:DListNode = null;
      
      public function DListNode(Data:*)
      {
         super();
         this.data = Data;
      }
   }
}

