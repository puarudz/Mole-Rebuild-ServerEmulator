package com.view.mapView
{
   import com.mole.app.map.MapBase;
   import com.view.toolView.toolView;
   
   public class centerNewUserView extends MapBase
   {
      
      public function centerNewUserView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         toolView.setToolBtns(0,0,0,0,0,0,0,0,0,0,0,0,0);
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         super.destroy();
      }
   }
}

