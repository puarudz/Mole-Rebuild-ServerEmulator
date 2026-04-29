package com.view.mapView
{
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class chessRoomView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public function chessRoomView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.target_mc.room_btn.buttonMode = true;
         this.target_mc.room_btn.addEventListener(MouseEvent.MOUSE_OUT,this.roomOutHandler);
         this.target_mc.room_btn.addEventListener(MouseEvent.MOUSE_OUT,this.roomOutHandler);
      }
      
      private function roomOverHandler(evt:MouseEvent) : void
      {
         this.target_mc.room_2.gotoAndStop(2);
      }
      
      private function roomOutHandler(evt:MouseEvent) : void
      {
         this.target_mc.room_2.gotoAndStop(1);
      }
      
      override public function destroy() : void
      {
         this.target_mc.room_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.roomOutHandler);
         this.target_mc.room_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.roomOutHandler);
         this.target_mc = null;
         this.depth_mc = null;
         super.destroy();
      }
   }
}

