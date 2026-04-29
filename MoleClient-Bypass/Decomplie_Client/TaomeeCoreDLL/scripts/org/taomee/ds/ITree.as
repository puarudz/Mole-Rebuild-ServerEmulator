package org.taomee.ds
{
   public interface ITree
   {
      
      function get data() : *;
      
      function set data(param1:*) : void;
      
      function get length() : int;
      
      function get isRoot() : Boolean;
      
      function get isLeaf() : Boolean;
      
      function get depth() : int;
      
      function get numChildren() : int;
      
      function get numSiblings() : int;
      
      function remove() : void;
      
      function clear() : void;
   }
}

