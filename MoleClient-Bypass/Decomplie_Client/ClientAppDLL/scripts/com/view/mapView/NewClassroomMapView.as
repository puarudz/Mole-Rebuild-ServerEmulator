package com.view.mapView
{
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   
   public class NewClassroomMapView extends MapBase
   {
      
      public static var task268Flag:int;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public function NewClassroomMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         task268Flag = 1;
      }
      
      override public function destroy() : void
      {
         this.target_mc = null;
         this.depth_mc = null;
         this.topMC = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

