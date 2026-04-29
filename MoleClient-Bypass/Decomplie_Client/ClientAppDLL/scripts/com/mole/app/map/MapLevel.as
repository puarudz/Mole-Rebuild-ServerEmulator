package com.mole.app.map
{
   import flash.display.MovieClip;
   
   public class MapLevel
   {
      
      private var _map_mc:MovieClip;
      
      private var _maskLevel:MovieClip;
      
      private var _debugLevel:MovieClip;
      
      private var _topLevel:MovieClip;
      
      private var _moveLevel:MovieClip;
      
      private var _buttonLevel:MovieClip;
      
      private var _depthLevel:MovieClip;
      
      private var _controlLevel:MovieClip;
      
      private var _bgLevel:MovieClip;
      
      private var _spaceLevel:MovieClip;
      
      public function MapLevel(map_mc:MovieClip)
      {
         super();
         this._map_mc = map_mc;
         this._maskLevel = this._map_mc["mask_mc"];
         this._debugLevel = this._map_mc["test_mc"];
         this._topLevel = this._map_mc["top_mc"];
         this._moveLevel = this._map_mc["type_mc"];
         this._buttonLevel = this._map_mc["buttonLevel"];
         this._depthLevel = this._map_mc["depth_mc"];
         this._controlLevel = this._map_mc["control_mc"];
         this._bgLevel = this._map_mc["bg_mc"];
         this._spaceLevel = this._map_mc["space_mc"];
         if(this._topLevel == null)
         {
            this._topLevel = new MovieClip();
            this._map_mc.addChild(this._topLevel);
         }
         if(Boolean(this._moveLevel))
         {
            this._moveLevel.mouseEnabled = false;
            this._moveLevel.mouseChildren = false;
            this._moveLevel.alpha = 0;
         }
         if(Boolean(this._depthLevel))
         {
            this._depthLevel.mouseChildren = this._depthLevel.mouseEnabled = false;
         }
         if(Boolean(this._bgLevel))
         {
            this._bgLevel.mouseChildren = this._bgLevel.mouseEnabled = false;
         }
         this._depthLevel.mouseEnabled = false;
         GV.MC_mapTop = this._topLevel;
         GV.MC_Depth = this._depthLevel;
         GV.MC_Space = this._bgLevel;
         GV.MC_Type = this._moveLevel;
      }
      
      public function destroy() : void
      {
         if(Boolean(this._map_mc as MapMaterialBase))
         {
            MapMaterialBase(this._map_mc).destroy();
         }
         this._map_mc = null;
         this._maskLevel = null;
         this._debugLevel = null;
         this._topLevel = null;
         this._moveLevel = null;
         this._buttonLevel = null;
         this._depthLevel = null;
         this._controlLevel = null;
         this._bgLevel = null;
         this._spaceLevel = null;
      }
      
      public function get maskLevel() : MovieClip
      {
         return this._maskLevel;
      }
      
      public function get debugLevel() : MovieClip
      {
         return this._debugLevel;
      }
      
      public function get topLevel() : MovieClip
      {
         return this._topLevel;
      }
      
      public function get moveLevel() : MovieClip
      {
         return this._moveLevel;
      }
      
      public function get buttonLevel() : MovieClip
      {
         return this._buttonLevel;
      }
      
      public function get depthLevel() : MovieClip
      {
         return this._depthLevel;
      }
      
      public function get controlLevel() : MovieClip
      {
         return this._controlLevel;
      }
      
      public function get bgLevel() : MovieClip
      {
         return this._bgLevel;
      }
      
      public function get spaceLevel() : MovieClip
      {
         return this._spaceLevel;
      }
      
      public function get map_mc() : MovieClip
      {
         return this._map_mc;
      }
   }
}

