package org.taomee.ds
{
   public class GraphNode
   {
      
      public var data:*;
      
      public var arcs:Array;
      
      public var marked:Boolean;
      
      public function GraphNode(obj:*)
      {
         super();
         this.data = obj;
         this.arcs = [];
         this.marked = false;
      }
      
      public function addArc(p_node:GraphNode, p_weight:Number) : void
      {
         this.arcs.push(new GraphArc(p_node,p_weight));
      }
      
      public function removeArc(p_targetNode:GraphNode) : Boolean
      {
         var l:int = int(this.arcs.length);
         for(var i:int = 0; i < l; i++)
         {
            if(this.arcs[i] == p_targetNode)
            {
               this.arcs.splice(i,1);
               return true;
            }
         }
         return false;
      }
      
      public function getArc(p_targetNode:GraphNode) : GraphArc
      {
         var arc:GraphArc = null;
         var l:int = int(this.arcs.length);
         for each(arc in this.arcs)
         {
            if(arc.targetNode == p_targetNode)
            {
               return arc;
            }
         }
         return null;
      }
   }
}

