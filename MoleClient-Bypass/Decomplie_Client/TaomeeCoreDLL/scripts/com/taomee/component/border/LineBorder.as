package com.taomee.component.border
{
   public class LineBorder extends EmptyBorder implements IBorder
   {
      
      public function LineBorder(border:IBorder, color:uint = 0, thickness:int = 1, round:int = 5)
      {
         super(border,thickness);
         alpha = 1;
         this.color = color;
         this.thickness = thickness <= 20 ? thickness : 20;
         this.round = round <= 40 ? round : 40;
      }
   }
}

