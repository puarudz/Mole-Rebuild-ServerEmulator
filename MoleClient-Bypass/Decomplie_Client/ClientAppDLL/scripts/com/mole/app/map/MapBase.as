package com.mole.app.map
{
   import com.common.data.UILibrary;
   import com.mole.app.manager.NPCDialogManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   
   public class MapBase
   {
      
      protected var _mapLevel:MapLevel;
      
      protected var _mapControl:MapControl;
      
      protected var _mapLibrary:UILibrary;
      
      public function MapBase()
      {
         super();
         this._mapLevel = MapManageView.inst.mapLevel;
         if(Boolean(this._mapLevel.map_mc.stage))
         {
            this.onMapAddToStage();
         }
         else
         {
            this._mapLevel.map_mc.addEventListener(Event.ADDED_TO_STAGE,this.onMapAddToStage);
         }
      }
      
      public function setLibrary(appDomain:ApplicationDomain) : void
      {
         this._mapLibrary = new UILibrary(appDomain);
      }
      
      private function onMapAddToStage(e:Event = null) : void
      {
         this.initView();
      }
      
      protected function initView() : void
      {
      }
      
      public function mapSay(id:uint) : void
      {
         NPCDialogManager.say(this._mapControl.getNpcDialogInfo(id));
      }
      
      public function init() : void
      {
         this._mapControl = MapManageView.inst.mapControl;
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         this._mapLevel.destroy();
         this._mapLevel = null;
      }
      
      public function get mapID() : uint
      {
         return this._mapControl.mapID;
      }
      
      public function get maskLevel() : MovieClip
      {
         return this._mapLevel.maskLevel;
      }
      
      public function get debugLevel() : MovieClip
      {
         return this._mapLevel.debugLevel;
      }
      
      public function get topLevel() : MovieClip
      {
         return this._mapLevel.topLevel;
      }
      
      public function get moveLevel() : MovieClip
      {
         return this._mapLevel.moveLevel;
      }
      
      public function get buttonLevel() : MovieClip
      {
         return this._mapLevel.buttonLevel;
      }
      
      public function get depthLevel() : MovieClip
      {
         return this._mapLevel.depthLevel;
      }
      
      public function get controlLevel() : MovieClip
      {
         return this._mapLevel.controlLevel;
      }
      
      public function get bgLevel() : MovieClip
      {
         return this._mapLevel.bgLevel;
      }
      
      public function get spaceLevel() : MovieClip
      {
         return this._mapLevel.spaceLevel;
      }
      
      public function get map_mc() : MovieClip
      {
         return this._mapLevel.map_mc;
      }
   }
}

