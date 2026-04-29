package org.taomee.ds
{
   public class TreeIterator
   {
      
      public var node:Tree = null;
      
      private var _childItr:DListIterator;
      
      public function TreeIterator(Node:Tree)
      {
         super();
         this.node = Node;
         this.resetChildren();
      }
      
      public function appendChild(obj:*) : void
      {
         new Tree(obj,this.node);
         if(this.node.children.length == 1)
         {
            this._childItr.start();
         }
      }
      
      public function prependChild(obj:*) : void
      {
         var childNode:Tree = new Tree(obj,null);
         childNode.parent = this.node;
         this.node.children.unshift(childNode);
         if(this.node.children.length == 1)
         {
            this._childItr.start();
         }
      }
      
      public function root() : void
      {
         if(Boolean(this.node))
         {
            while(Boolean(this.node.parent))
            {
               this.node = this.node.parent;
            }
            this.resetChildren();
         }
      }
      
      public function up() : void
      {
         if(Boolean(this.node))
         {
            this.node = this.node.parent;
         }
         this.resetChildren();
      }
      
      public function down() : void
      {
         if(this._childItr.hasNext())
         {
            this.node = this._childItr.node.data;
            this.resetChildren();
         }
      }
      
      public function nextChild() : void
      {
         this._childItr.next();
      }
      
      public function prevChild() : void
      {
         this._childItr.prev();
      }
      
      public function childStart() : void
      {
         this._childItr.start();
      }
      
      public function childEnd() : void
      {
         this._childItr.end();
      }
      
      private function resetChildren() : void
      {
         if(Boolean(this.node))
         {
            this._childItr = this.node.children.getIterator();
         }
         else
         {
            this._childItr = null;
         }
      }
   }
}

