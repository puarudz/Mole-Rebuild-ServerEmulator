package org.taomee.ds
{
   public class Graph
   {
      
      public var nodes:Array;
      
      public var count:int;
      
      public function Graph()
      {
         super();
         this.nodes = [];
         this.count = 0;
      }
      
      public function addNode(node:GraphNode, index:int) : Boolean
      {
         if(Boolean(this.nodes[index]))
         {
            return false;
         }
         this.nodes[index] = node;
         return true;
      }
      
      public function removeNode(index:int) : Boolean
      {
         var node:GraphNode = this.nodes[index];
         if(!node)
         {
            return false;
         }
         var l:int = int(this.nodes.length);
         for(var i:int = 0; i < l; i++)
         {
            if(Boolean(this.nodes[i].getArc(node)))
            {
               this.removeArc(i,index);
            }
         }
         this.nodes.splice(index,1);
         return true;
      }
      
      public function getNode(index:int) : GraphNode
      {
         return this.nodes[index];
      }
      
      public function addArc(p_fromIndex:int, p_toIndex:int, p_weight:int = 1) : Boolean
      {
         var from:GraphNode = this.nodes[p_fromIndex];
         var to:GraphNode = this.nodes[p_toIndex];
         if(Boolean(from) && Boolean(to))
         {
            if(Boolean(from.getArc(to)))
            {
               return false;
            }
            from.addArc(to,p_weight);
            return true;
         }
         return false;
      }
      
      public function removeArc(p_fromIndex:int, p_toIndex:int) : Boolean
      {
         var from:GraphNode = this.nodes[p_fromIndex];
         var to:GraphNode = this.nodes[p_toIndex];
         if(Boolean(from) && Boolean(to))
         {
            from.removeArc(to);
            return true;
         }
         return false;
      }
      
      public function getArc(p_fromIndex:int, p_toIndex:int) : GraphArc
      {
         var from:GraphNode = this.nodes[p_fromIndex];
         var to:GraphNode = this.nodes[p_toIndex];
         if(Boolean(from) && Boolean(to))
         {
            return from.getArc(to);
         }
         return null;
      }
      
      public function clearMarks() : void
      {
         var n:GraphNode = null;
         for each(n in this.nodes)
         {
            if(Boolean(n))
            {
               n.marked = false;
            }
         }
      }
      
      public function depthFirst(p_node:GraphNode, p_process:Function) : void
      {
         if(!p_node)
         {
            return;
         }
         p_process(p_node);
         p_node.marked = true;
         var arcs:Array = p_node.arcs;
         var l:int = int(arcs.length);
         for(var i:int = 0; i < l; i++)
         {
            if(!GraphArc(arcs[i]).targetNode.marked)
            {
               this.depthFirst(GraphArc(arcs[i]).targetNode,p_process);
            }
         }
      }
      
      public function breadFirst(p_node:GraphNode, p_process:Function) : void
      {
         var arcs:Array = null;
         var i:int = 0;
         if(!p_node)
         {
            return;
         }
         var queue:DLinkedList = new DLinkedList();
         var itr:DListIterator = queue.getIterator();
         queue.push(p_node);
         p_node.marked = true;
         while(queue.length > 0)
         {
            p_process(queue.head);
            arcs = GraphNode(queue.head.data).arcs;
            for(i = 0; i < arcs.length; i++)
            {
               if(!GraphArc(arcs[i]).targetNode.marked)
               {
                  GraphArc(arcs[i]).targetNode.marked = true;
                  queue.push(GraphArc(arcs[i]).targetNode);
               }
            }
            queue.shift();
         }
      }
   }
}

