package org.taomee.ds
{
   public class GraphArc
   {
      
      public var targetNode:GraphNode;
      
      public var weight:Number;
      
      public function GraphArc(p_target:GraphNode, p_weight:Number)
      {
         super();
         this.targetNode = p_target;
         this.weight = p_weight;
      }
   }
}

