package org.taomee.ds
{
   import flash.geom.Rectangle;
   
   public class QuadTree
   {
      
      public var _topLeft:QuadTree;
      
      public var _topRight:QuadTree;
      
      public var _bottomLeft:QuadTree;
      
      public var _bottomRight:QuadTree;
      
      public var _rect:Rectangle;
      
      public var _depth:int;
      
      public var _maxDepth:int;
      
      public var _hw:int;
      
      public var _hh:int;
      
      public var _midX:int;
      
      public var _midY:int;
      
      public var _children:Array = [];
      
      public function QuadTree(rect:Rectangle, maxDepth:int = 3, currentDepth:int = 0)
      {
         super();
         this._depth = currentDepth;
         this._maxDepth = maxDepth;
         this._rect = rect;
         this._hw = this._rect.width >> 1;
         this._hh = this._rect.height >> 1;
         this._midX = this._rect.x + this._hw;
         this._midY = this._rect.y + this._hh;
      }
      
      public function clear() : void
      {
         this._children = [];
         this._topLeft = this._topRight = this._bottomLeft = this._bottomRight = null;
      }
      
      public function toString() : String
      {
         var s:String = "[QuadTreeNode> ";
         var l:int = int(this._children.length);
         return s + (l > 1 ? l + " children" : l + " child");
      }
      
      public function dump() : String
      {
         var s:String = null;
         s = "";
         this.preorder(this,function(node:QuadTree):void
         {
            var d:int = node._depth;
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
      
      public function preorder(Node:QuadTree, Process:Function) : void
      {
         Process(Node);
         if(Boolean(Node._topLeft))
         {
            this.preorder(Node._topLeft,Process);
         }
         if(Boolean(Node._topRight))
         {
            this.preorder(Node._topRight,Process);
         }
         if(Boolean(Node._bottomLeft))
         {
            this.preorder(Node._bottomLeft,Process);
         }
         if(Boolean(Node._bottomRight))
         {
            this.preorder(Node._bottomRight,Process);
         }
      }
      
      public function retrieve(obj:*) : Array
      {
         var r:Array = [];
         if(!this._topLeft)
         {
            r.push.apply(r,this._children);
            return r;
         }
         if(obj.x <= this._rect.x && obj.y <= this._rect.y && obj.x + obj.width >= this._rect.right && obj.y + obj.height >= this._rect.bottom)
         {
            r.push.apply(r,this._children);
            r.push.apply(r,this._topLeft.retrieve(obj));
            r.push.apply(r,this._topRight.retrieve(obj));
            r.push.apply(r,this._bottomLeft.retrieve(obj));
            r.push.apply(r,this._bottomRight.retrieve(obj));
            return r;
         }
         var objRight:Number = obj.x + obj.width;
         var objBottom:Number = obj.y + obj.height;
         if(obj.x > this._rect.x && objRight < this._midX)
         {
            if(obj.y > this._rect.y && objBottom < this._midY)
            {
               r.push.apply(r,this._topLeft.retrieve(obj));
               return r;
            }
            if(obj.y > this._midY && objBottom < this._rect.bottom)
            {
               r.push.apply(r,this._bottomLeft.retrieve(obj));
               return r;
            }
         }
         if(obj.x > this._midX && objRight < this._rect.right)
         {
            if(obj.y > this._rect.y && objBottom < this._midY)
            {
               r.push.apply(r,this._topRight.retrieve(obj));
               return r;
            }
            if(obj.y > this._midY && objBottom < this._rect.bottom)
            {
               r.push.apply(r,this._bottomRight.retrieve(obj));
               return r;
            }
         }
         if(objBottom > this._rect.y && obj.y < this._midY)
         {
            if(obj.x < this._midX && objRight > this._rect.x)
            {
               r.push.apply(r,this._topLeft.retrieve(obj));
            }
            if(obj.x < this._rect.right && objRight > this._midX)
            {
               r.push.apply(r,this._topRight.retrieve(obj));
            }
         }
         if(objBottom > this._midY && obj.y < this._rect.bottom)
         {
            if(obj.x < this._midX && objRight > this._rect.x)
            {
               r.push.apply(r,this._bottomLeft.retrieve(obj));
            }
            if(obj.x < this._rect.right && objRight > this._midX)
            {
               r.push.apply(r,this._bottomRight.retrieve(obj));
            }
         }
         return r;
      }
      
      public function insert(obj:*) : void
      {
         var i:* = undefined;
         var d:int = 0;
         if(obj is Array)
         {
            for each(i in obj)
            {
               this.insert(i);
            }
            return;
         }
         if(this._depth >= this._maxDepth || obj.x <= this._rect.x && obj.y <= this._rect.y && obj.x + obj.width >= this._rect.right && obj.y + obj.height >= this._rect.bottom)
         {
            this._children.push(obj);
            return;
         }
         if(!this._topLeft)
         {
            d = this._depth + 1;
            this._topLeft = new QuadTree(new Rectangle(this._rect.x,this._rect.y,this._hw,this._hh),this._maxDepth,d);
            this._topRight = new QuadTree(new Rectangle(this._rect.x + this._hw,this._rect.y,this._hw,this._hh),this._maxDepth,d);
            this._bottomLeft = new QuadTree(new Rectangle(this._rect.x,this._rect.y + this._hh,this._hw,this._hh),this._maxDepth,d);
            this._bottomRight = new QuadTree(new Rectangle(this._rect.x + this._hw,this._rect.y + this._hh,this._hw,this._hh),this._maxDepth,d);
         }
         var objRight:Number = obj.x + obj.width;
         var objBottom:Number = obj.y + obj.height;
         if(obj.x > this._rect.x && objRight < this._midX)
         {
            if(obj.y > this._rect.y && objBottom < this._midY)
            {
               this._topLeft.insert(obj);
               return;
            }
            if(obj.y > this._midY && objBottom < this._rect.bottom)
            {
               this._bottomLeft.insert(obj);
               return;
            }
         }
         if(obj.x > this._midX && objRight < this._rect.right)
         {
            if(obj.y > this._rect.y && objBottom < this._midY)
            {
               this._topRight.insert(obj);
               return;
            }
            if(obj.y > this._midY && objBottom < this._rect.bottom)
            {
               this._bottomRight.insert(obj);
               return;
            }
         }
         if(objBottom > this._rect.y && obj.y < this._midY)
         {
            if(obj.x < this._midX && objRight > this._rect.x)
            {
               this._topLeft.insert(obj);
            }
            if(obj.x < this._rect.right && objRight > this._midX)
            {
               this._topRight.insert(obj);
            }
         }
         if(objBottom > this._midY && obj.y < this._rect.bottom)
         {
            if(obj.x < this._midX && objRight > this._rect.x)
            {
               this._bottomLeft.insert(obj);
            }
            if(obj.x < this._rect.right && objRight > this._midX)
            {
               this._bottomRight.insert(obj);
            }
         }
      }
   }
}

