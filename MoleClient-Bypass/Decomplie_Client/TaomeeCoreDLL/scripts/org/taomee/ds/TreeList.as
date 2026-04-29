package org.taomee.ds
{
   public class TreeList implements ITree
   {
      
      private var _root:TreeList;
      
      private var _parent:TreeList;
      
      private var _children:Array;
      
      private var _data:*;
      
      public function TreeList(data:* = null, parent:TreeList = null)
      {
         super();
         this._data = data;
         this._children = [];
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
         var node:TreeList = this._parent;
         while(Boolean(node))
         {
            c += node.numChildren;
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeList Infinite Loop");
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
         var node:TreeList = this._parent;
         var c:int = 0;
         while(Boolean(node))
         {
            c++;
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeList Infinite Loop");
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
      
      public function get root() : TreeList
      {
         return this._root;
      }
      
      public function set parent(parent:TreeList) : void
      {
         var index:int = 0;
         if(Boolean(this._parent))
         {
            index = this._parent.children.indexOf(this);
            if(index != -1)
            {
               this._parent.children.splice(index,1);
            }
         }
         if(parent == this)
         {
            return;
         }
         this._parent = parent;
         if(Boolean(this._parent))
         {
            this._parent.children.push(this);
         }
         this.setRoot();
      }
      
      public function get parent() : TreeList
      {
         return this._parent;
      }
      
      public function get children() : Array
      {
         return this._children;
      }
      
      public function remove() : void
      {
         var child:TreeList = null;
         if(this._parent == null)
         {
            return;
         }
         for each(child in this._children)
         {
            child.parent = this._parent;
         }
      }
      
      public function clear() : void
      {
         this._children = [];
      }
      
      private function setRoot() : void
      {
         if(this._parent == null)
         {
            this._root = this;
            return;
         }
         var node:TreeList = this._parent;
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
               throw new Error("TreeList Infinite Loop");
            }
         }
      }
   }
}

