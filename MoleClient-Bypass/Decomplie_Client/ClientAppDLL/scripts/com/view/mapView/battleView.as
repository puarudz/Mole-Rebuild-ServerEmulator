package com.view.mapView
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.view.noticeView.noticeView;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.setTimeout;
   
   public class battleView
   {
      
      public var botton_mc:MovieClip;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public function battleView()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         setTimeout(this.init,100);
      }
      
      public function init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         noticeView.owner.GetUI().visible = false;
         var toolBar_mc:MovieClip = MainManager.getToolLevel().getChildByName("tool_mc") as MovieClip;
         if(Boolean(toolBar_mc))
         {
            toolBar_mc.visible = false;
         }
         LocalUserInfo.setIsHideOtherMole(true);
      }
      
      private function switchMap(number:Number) : void
      {
         if(number == 0)
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            GF.switchMap(176,true);
         }
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         this.target_mc = null;
         this.depth_mc = null;
         this.top_mc = null;
         this.botton_mc = null;
         BC.removeEvent(this);
      }
   }
}

