package com.view.mapView
{
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   
   public class BasicMapView extends MapBase
   {
      
      public function BasicMapView()
      {
         super();
      }
      
      public function get target_mc() : MovieClip
      {
         return _mapLevel.controlLevel as MovieClip;
      }
      
      public function get depth_mc() : MovieClip
      {
         return _mapLevel.depthLevel as MovieClip;
      }
      
      public function get botton_mc() : MovieClip
      {
         return _mapLevel.buttonLevel as MovieClip;
      }
      
      public function get top_mc() : MovieClip
      {
         return _mapLevel.topLevel as MovieClip;
      }
   }
}

