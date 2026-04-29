package com.taomee.component.layout
{
   import com.taomee.component.Component;
   
   public class BoxLayout extends EmptyLayout implements ILayoutManager
   {
      
      private static var TYPE:String = "boxLayout";
      
      public static const X_AXIS:int = 0;
      
      public static const Y_AXIS:int = 1;
      
      private var axis:int;
      
      private var gap:int;
      
      public function BoxLayout(axis:int = 0, gap:int = 5)
      {
         super();
         this.axis = axis;
         this.gap = gap;
      }
      
      override public function doLayout() : void
      {
         if(this.axis == Y_AXIS)
         {
            this.layoutY();
         }
         else
         {
            this.layoutX();
         }
      }
      
      public function setAxis(i:int) : void
      {
         if(this.axis == i)
         {
            return;
         }
         this.axis = i;
         broadcast();
      }
      
      public function setGap(i:int) : void
      {
         if(this.gap == i)
         {
            return;
         }
         this.gap = i;
         broadcast();
      }
      
      override public function getType() : String
      {
         return TYPE + this.axis.toString() + this.gap.toString();
      }
      
      private function layoutX() : void
      {
         var comp:Component = null;
         getMargin();
         var containerW:Number = container.getWidth() - margin * 2;
         var containerH:Number = container.getHeight() - margin * 2;
         var array:Array = container.getCompArray();
         var perW:Number = (containerW - this.gap * (array.length - 1)) / array.length;
         for(var i:int = 0; i < array.length; i++)
         {
            comp = array[i] as Component;
            if(i == 0)
            {
               comp.x = margin + perW * i;
            }
            else
            {
               comp.x = margin + perW * i + this.gap * i;
            }
            comp.y = margin;
            comp.setWidth(perW);
            comp.setHeight(containerH);
         }
      }
      
      private function layoutY() : void
      {
         var comp:Component = null;
         getMargin();
         var containerW:Number = container.getWidth() - margin * 2;
         var containerH:Number = container.getHeight() - margin * 2;
         var array:Array = container.getCompArray();
         var perH:Number = (containerH - this.gap * (array.length - 1)) / array.length;
         for(var i:int = 0; i < array.length; i++)
         {
            comp = array[i] as Component;
            if(i == 0)
            {
               comp.y = margin + perH * i;
            }
            else
            {
               comp.y = margin + perH * i + this.gap * i;
            }
            comp.x = margin;
            comp.setHeight(perH);
            comp.setWidth(containerW);
         }
      }
   }
}

