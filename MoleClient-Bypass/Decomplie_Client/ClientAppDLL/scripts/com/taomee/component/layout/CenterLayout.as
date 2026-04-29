package com.taomee.component.layout
{
   import com.taomee.component.Component;
   
   public class CenterLayout extends EmptyLayout implements ILayoutManager
   {
      
      private static const TYPE:String = "centerLayout";
      
      public function CenterLayout()
      {
         super();
      }
      
      override public function doLayout() : void
      {
         var comp:Component = container.getChildAt(0) as Component;
         comp.x = (container.getWidth() - comp.getWidth()) / 2;
         comp.y = (container.getHeight() - comp.getHeight()) / 2;
      }
      
      override public function getType() : String
      {
         return TYPE;
      }
   }
}

