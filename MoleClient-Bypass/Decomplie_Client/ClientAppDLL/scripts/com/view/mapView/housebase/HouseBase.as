package com.view.mapView.housebase
{
   import com.mole.app.map.MapBase;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class HouseBase extends MapBase
   {
      
      public var effect_mc:MovieClip;
      
      public function HouseBase()
      {
         super();
         this.effect_mc = GV.MC_mapFrame["effect_mc"];
      }
      
      public function get top_mc() : MovieClip
      {
         return _mapLevel.topLevel as MovieClip;
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
      
      public function get type_mc() : MovieClip
      {
         return _mapLevel.moveLevel as MovieClip;
      }
      
      protected function clearSelf() : void
      {
      }
      
      override public function destroy() : void
      {
         this.effect_mc = null;
         super.destroy();
      }
      
      public function getChildByName(str:String) : DisplayObject
      {
         return GV.MC_mapFrame.getChildByName(str);
      }
   }
}

