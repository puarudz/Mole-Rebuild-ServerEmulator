package com.taomee.component
{
   import com.taomee.component.layout.FlowLayout;
   import com.taomee.component.layout.ILayoutManager;
   
   public class MPanel extends Container
   {
      
      public function MPanel(layout:ILayoutManager = null)
      {
         super();
         if(Boolean(layout))
         {
            layoutManager = layout;
         }
         else
         {
            layoutManager = new FlowLayout();
         }
         setLayout(layoutManager);
      }
   }
}

