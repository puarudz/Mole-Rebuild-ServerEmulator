package org.taomee.ds
{
   public class TreeMap implements ITree
   {
      
      private var _root:TreeMap;
      
      private var _parent:TreeMap;
      
      private var _key:*;
      
      private var _children:HashMap;
      
      private var _data:*;
      
      public function TreeMap(key:*, data:* = null, parent:TreeMap = null)
      {
         super();
         this._key = key;
         this._data = data;
         this._children = new HashMap();
         this.parent = parent;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(d:*) : void
      {
         this._data = d;
      }
      
      public function get length() : int
      {
         var c:int = this.numChildren;
         var node:TreeMap = this._parent;
         while(Boolean(node))
         {
            c += node.numChildren;
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeMap Infinite Loop");
            }
         }
         return c;
      }
      
      public function get isRoot() : Boolean
      {
         return this._root == this;
      }
      
      public function get isLeaf() : Boolean
      {
         return this._children.length == 0;
      }
      
      public function get depth() : int
      {
         if(this._parent == null)
         {
            return 0;
         }
         var node:TreeMap = this._parent;
         var c:int = 0;
         while(Boolean(node))
         {
            c++;
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeMap Infinite Loop");
            }
         }
         return c;
      }
      
      public function get numChildren() : int
      {
         return this._children.length;
      }
      
      public function get numSiblings() : int
      {
         if(Boolean(this._parent))
         {
            return this._parent.numChildren;
         }
         return 0;
      }
      
      public function get root() : TreeMap
      {
         return this._root;
      }
      
      public function set parent(parent:TreeMap) : void
      {
         if(Boolean(this._parent))
         {
            this._parent.children.remove(this._key);
         }
         if(parent == this)
         {
            return;
         }
         this._parent = parent;
         if(Boolean(this._parent))
         {
            this._parent.children.add(this._key,this);
         }
         this.setRoot();
      }
      
      public function get parent() : TreeMap
      {
         return this._parent;
      }
      
      public function get children() : HashMap
      {
         return this._children;
      }
      
      public function set key(k:*) : void
      {
         if(Boolean(this._parent))
         {
            this._parent.children.remove(this._key);
            this._parent.children.add(k,this);
         }
         this._key = k;
      }
      
      public function get key() : *
      {
         return this._key;
      }
      
      public function remove() : void
      {
         if(this._parent == null)
         {
            return;
         }
         this._children.eachValue(function(child:TreeMap):void
         {
            child.parent = _parent;
         });
      }
      
      public function clear() : void
      {
         this._children = new HashMap();
      }
      
      private function setRoot() : void
      {
         if(this._parent == null)
         {
            this._root = this;
            return;
         }
         var node:TreeMap = this._parent;
         while(Boolean(node))
         {
            if(node.parent == null)
            {
               this._root = node;
               return;
            }
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeMap Infinite Loop");
            }
         }
      }
   }
}

