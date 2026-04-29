package com.taomee.component.layout
{
   import com.taomee.component.Component;
   import com.taomee.component.geom.IntDimension;
   
   public class FlowLayout extends EmptyLayout implements ILayoutManager
   {
      
      private static const TYPE:String = "flowLayout";
      
      public static const CENTER:int = 0;
      
      public static const LEFT:int = 1;
      
      public static const RIGHT:int = 2;
      
      private var align:int;
      
      private var hgap:int;
      
      private var vgap:int;
      
      private var initialHeight:Number;
      
      private var initialWidth:Number;
      
      public function FlowLayout(align:int = 1, hgap:int = 5, vgap:int = 5)
      {
         super();
         this.align = align;
         this.hgap = hgap;
         this.vgap = vgap;
      }
      
      override public function doLayout() : void
      {
         var comp:Component = null;
         var size:IntDimension = null;
         getMargin();
         var groupArray:Array = [];
         var containerW:Number = container.getWidth() - margin * 2;
         var containerH:Number = container.getHeight() - margin * 2;
         var array:Array = container.getCompArray();
         if(array.length == 0)
         {
            return;
         }
         var comps_width:Number = 0;
         var newRow:Boolean = true;
         for(var i:int = 0; i < array.length; i++)
         {
            comp = array[i] as Component;
            size = comp.countPreferredSize();
            comp.setSizeWH(size.width,size.height);
            comps_width += size.width + this.hgap;
            if(comps_width - this.hgap > containerW)
            {
               if(newRow)
               {
                  groupArray.push(i);
               }
               else
               {
                  groupArray.push(i - 1);
                  i -= 1;
               }
               newRow = true;
               comps_width = 0;
            }
            else
            {
               newRow = false;
            }
         }
         if(groupArray.length == 0)
         {
            groupArray.push(array.length - 1);
         }
         else if(groupArray[groupArray.length - 1] < array.length - 1)
         {
            groupArray.push(array.length - 1);
         }
         this.layoutComps(groupArray);
      }
      
      private function layoutComps(groupArray:Array) : void
      {
         var comp:Component = null;
         var size:IntDimension = null;
         var i:int = 0;
         var totalW:int = 0;
         var maxH:Number = NaN;
         var X:Number = NaN;
         var j:int = 0;
         var k:int = 0;
         var prev_comp:Component = null;
         var size2:IntDimension = null;
         var array:Array = container.getCompArray();
         var begin:int = 0;
         var count:int = 0;
         var prev_maxH:Number = 0;
         for each(i in groupArray)
         {
            totalW = 0;
            maxH = 0;
            for(j = begin; j <= i; j++)
            {
               comp = array[j] as Component;
               size = comp.countPreferredSize();
               totalW += size.width + this.hgap;
               maxH = Math.max(maxH,size.height);
            }
            totalW -= this.hgap;
            switch(this.align)
            {
               case LEFT:
                  X = margin;
                  break;
               case RIGHT:
                  X = container.getWidth() - totalW - margin;
                  break;
               case CENTER:
                  X = (container.getWidth() - totalW) / 2;
            }
            for(k = begin; k <= i; k++)
            {
               comp = array[k] as Component;
               size = comp.countPreferredSize();
               if(k == begin)
               {
                  comp.x = X;
               }
               else
               {
                  prev_comp = array[k - 1] as Component;
                  size2 = prev_comp.countPreferredSize();
                  comp.x = prev_comp.x + size2.width + this.hgap;
               }
               if(count == 0)
               {
                  comp.y = (maxH - size.height) / 2 + prev_maxH + margin;
               }
               else
               {
                  comp.y = (maxH - size.height) / 2 + prev_maxH + this.vgap + margin;
               }
            }
            if(count == 0)
            {
               prev_maxH += maxH;
            }
            else
            {
               prev_maxH += maxH + this.vgap;
            }
            begin = i + 1;
            count++;
         }
      }
      
      public function setAlignment(i:int) : void
      {
         if(i == this.align)
         {
            return;
         }
         this.align = i;
         broadcast();
      }
      
      public function setHgap(i:int) : void
      {
         if(i == this.hgap)
         {
            return;
         }
         this.hgap = i;
         broadcast();
      }
      
      public function getHgap() : int
      {
         return this.hgap;
      }
      
      public function setVgap(i:int) : void
      {
         if(i == this.vgap)
         {
            return;
         }
         this.vgap = i;
         broadcast();
      }
      
      public function getVgap() : int
      {
         return this.vgap;
      }
      
      override public function getType() : String
      {
         return TYPE + this.align.toString() + this.hgap.toString() + this.vgap.toString();
      }
   }
}

