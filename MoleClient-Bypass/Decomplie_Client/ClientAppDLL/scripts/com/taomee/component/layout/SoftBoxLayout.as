package com.taomee.component.layout
{
   import com.taomee.component.Component;
   import com.taomee.component.MButton;
   import com.taomee.component.geom.IntDimension;
   
   public class SoftBoxLayout extends EmptyLayout implements ILayoutManager
   {
      
      private static const TYPE:String = "softBoxLayout";
      
      public static const CENTER:int = 0;
      
      public static const LEFT:int = 1;
      
      public static const RIGHT:int = 2;
      
      public static const TOP:int = 3;
      
      public static const BOTTOM:int = 4;
      
      public static const X_AXIS:int = 0;
      
      public static const Y_AXIS:int = 1;
      
      private var axis:int;
      
      private var gap:int;
      
      private var align:int;
      
      public function SoftBoxLayout(axis:int = 0, gap:int = 5, align:int = 0)
      {
         super();
         this.axis = axis;
         this.gap = gap;
         this.align = align;
      }
      
      override public function doLayout() : void
      {
         if(this.axis == X_AXIS)
         {
            this.layoutX();
         }
         else
         {
            this.layoutY();
         }
      }
      
      private function layoutX() : void
      {
         var X:Number = NaN;
         var comp:Component = null;
         var dim:IntDimension = null;
         var c:Component = null;
         var oldComp:Component = null;
         getMargin();
         var compArray:Array = container.getCompArray();
         var num:int = int(compArray.length);
         var totalWidth:Number = 0;
         for(var i:int = 0; i < num; i++)
         {
            comp = compArray[i] as Component;
            dim = comp.countPreferredSize();
            if(comp is MButton)
            {
               comp.setHeight(35.5);
            }
            else
            {
               comp.setWidth(dim.width);
            }
            totalWidth += comp.width;
            comp.setHeight(container.height - margin * 2);
         }
         if(num > 0)
         {
            totalWidth += (num - 1) * this.gap;
         }
         switch(this.align)
         {
            case RIGHT:
               X = container.width - margin * 2 - totalWidth;
               break;
            case BOTTOM:
               X = container.width - margin * 2 - totalWidth;
               break;
            case CENTER:
               X = (container.width - margin * 2 - totalWidth) / 2;
               break;
            default:
               X = 0;
         }
         for(var j:int = 0; j < compArray.length; j++)
         {
            c = compArray[j];
            c.y = margin;
            if(j == 0)
            {
               c.x = X + margin;
            }
            else
            {
               oldComp = compArray[j - 1];
               c.x = oldComp.x + oldComp.width + this.gap;
            }
         }
      }
      
      private function layoutY() : void
      {
         var Y:Number = NaN;
         var comp:Component = null;
         var dim:IntDimension = null;
         var c:Component = null;
         var oldComp:Component = null;
         getMargin();
         var totalHeight:Number = 0;
         var compArray:Array = container.getCompArray();
         var num:int = int(compArray.length);
         for(var i:int = 0; i < num; i++)
         {
            comp = compArray[i] as Component;
            dim = comp.countPreferredSize();
            if(comp is MButton)
            {
               comp.setHeight(35.5);
            }
            else
            {
               comp.setHeight(dim.height);
            }
            totalHeight += comp.height;
            if(comp is MButton)
            {
               comp.x = (container.width - comp.getWidth()) / 2;
            }
            else
            {
               comp.setWidth(container.width - margin * 2);
            }
         }
         if(num > 0)
         {
            totalHeight += (num - 1) * this.gap;
         }
         switch(this.align)
         {
            case RIGHT:
               Y = container.height - margin * 2 - totalHeight;
               break;
            case BOTTOM:
               Y = container.height - margin * 2 - totalHeight;
               break;
            case CENTER:
               Y = (container.height - margin * 2 - totalHeight) / 2;
               break;
            default:
               Y = 0;
         }
         for(var j:int = 0; j < compArray.length; j++)
         {
            c = compArray[j];
            if(j == 0)
            {
               c.y = Y + margin;
            }
            else
            {
               oldComp = compArray[j - 1];
               c.y = oldComp.y + oldComp.height + this.gap;
            }
            c.x = margin;
         }
      }
      
      public function setAxis(i:int) : void
      {
         if(i == this.axis)
         {
            return;
         }
         this.axis = i;
         broadcast();
      }
      
      public function setGap(i:int) : void
      {
         if(i == this.gap)
         {
            return;
         }
         this.gap = i;
         broadcast();
      }
      
      public function getGap() : int
      {
         return this.gap;
      }
      
      public function setAlign(i:int) : void
      {
         if(i == this.align)
         {
            return;
         }
         this.align = i;
         broadcast();
      }
      
      override public function getType() : String
      {
         return TYPE + this.axis.toString() + this.gap.toString() + this.align.toString();
      }
   }
}

