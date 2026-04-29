package org.taomee.ds
{
   public class Tree
   {
      
      public var node:Tree;
      
      public var children:DLinkedList;
      
      public var parent:Tree;
      
      public var data:*;
      
      public function Tree(Obj:*, Parent:Tree = null)
      {
         super();
         this.data = Obj;
         this.children = new DLinkedList();
         this.parent = Parent;
         if(Boolean(this.parent))
         {
            this.parent = Parent;
            this.parent.children.push(this);
         }
      }
      
      public function isRoot() : Boolean
      {
         return this.parent == null;
      }
      
      public function isLeaf() : Boolean
      {
         return this.children.length == 0;
      }
      
      public function get depth() : int
      {
         if(!this.parent)
         {
            return 0;
         }
         var node:Tree = this;
         var c:int = 0;
         while(Boolean(node.parent))
         {
            c++;
            node = node.parent;
         }
         return c;
      }
      
      public function get length() : uint
      {
         var c:uint = 1;
         var itr:DListIterator = this.children.getIterator();
         while(itr.hasNext())
         {
            c += Tree(itr.node.data).length;
            itr.next();
         }
         return c;
      }
      
      public function preorder(Node:Tree, Process:Function) : void
      {
         Process(Node);
         var itr:DListIterator = Node.children.getIterator();
         while(itr.hasNext())
         {
            this.preorder(Tree(itr.node.data),Process);
            itr.next();
         }
      }
      
      public function preorder2(Node:Tree, Process:Function) : void
      {
         var t:Tree = null;
         var itr:DListIterator = null;
         var stack:Array = [Node];
         while(stack.length > 0)
         {
            t = stack.pop();
            Process(t);
            itr = t.children.getIterator();
            itr.end();
            while(itr.hasPrev())
            {
               stack.push(Tree(itr.node.data));
               itr.prev();
            }
         }
      }
      
      public function postorder(Node:Tree, Process:Function) : void
      {
         var itr:DListIterator = Node.children.getIterator();
         while(itr.hasNext())
         {
            this.postorder(Tree(itr.node.data),Process);
         }
         Process(Node);
      }
      
      public function toString() : String
      {
         var s:String = "[TreeNode >" + (this.parent == null ? "(root)" : "");
         if(this.children.length == 0)
         {
            s += "(leaf)";
         }
         else
         {
            s += " has " + this.children.length + " child node" + (this.length > 1 || this.length == 0 ? "s" : "");
         }
         return s + (", data=" + this.data + "]");
      }
      
      public function toXML(Node:Tree) : XML
      {
         var t:* = undefined;
         var itr:DListIterator = null;
         var xmlStack:Array = [];
         var stack:Array = [Node];
         var s:String = "";
         while(stack.length > 0)
         {
            t = stack.pop();
            if(t is String)
            {
               s += t;
            }
            else
            {
               t = Tree(t);
               s += "<node label=\'" + t.data + "\'>";
               if(t.children.length > 0)
               {
                  stack.push("</node>");
               }
               else
               {
                  s += "</node>";
               }
               itr = t.children.getIterator();
               itr.end();
               while(itr.hasPrev())
               {
                  stack.push(Tree(itr.node.data));
                  itr.prev();
               }
            }
         }
         return new XML(s);
      }
      
      public function dump() : String
      {
         var s:String = null;
         s = "";
         this.preorder(this,function(node:Tree):void
         {
            var d:int = node.depth;
            for(var i:int = 0; i < d; i++)
            {
               if(i == d - 1)
               {
                  s += "+---";
               }
               else
               {
                  s += "|    ";
               }
            }
            s += node + "\n";
         });
         return s;
      }
      
      public function getIterator() : TreeIterator
      {
         return new TreeIterator(this);
      }
   }
}

