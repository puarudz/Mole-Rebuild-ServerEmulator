package com.module.angelPark
{
   import com.core.MainManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ParkDragCtl
   {
      
      private static var _banUI:MovieClip;
      
      private static var _dragUI:MovieClip;
      
      public static const Type_Angel:int = 3;
      
      public static const Type_Item:int = 2;
      
      public static const Type_Seed:int = 1;
      
      public static const Type_NULL:int = -1;
      
      private static var _dragId:int = -1;
      
      private static var _dragType:int = -1;
      
      public function ParkDragCtl()
      {
         super();
      }
      
      public static function HideBanIcon() : void
      {
         _banUI.visible = false;
      }
      
      public static function ShowBanIcon() : void
      {
         _banUI.visible = true;
      }
      
      public static function StarDrag(ui:DisplayObject, dragId:int, type:int) : void
      {
         StopDrag();
         _dragType = type;
         _dragId = dragId;
         _dragUI = new MovieClip();
         _dragUI.mouseEnabled = false;
         _dragUI.mouseChildren = false;
         _dragUI.addChild(ui);
         _banUI = GV.Lib_Map.getMovieClip("Ban_mc") as MovieClip;
         _dragUI.addChild(_banUI);
         GV.MC_mapTop.addChild(_dragUI);
         _dragUI.x = _dragUI.stage.mouseX - 25;
         _dragUI.y = _dragUI.stage.mouseY - 25;
         AddEvent();
      }
      
      public static function StopDrag() : void
      {
         if(Boolean(_dragUI))
         {
            BC.removeEvent(_dragUI);
            GV.MC_mapTop.removeChild(_dragUI);
            _dragUI = null;
            _banUI = null;
         }
         _dragId = -1;
         _dragType = -1;
      }
      
      public static function get dragId() : int
      {
         return _dragId;
      }
      
      public static function get dragType() : int
      {
         return _dragType;
      }
      
      private static function AddEvent() : void
      {
         BC.addEvent(_dragUI,MainManager.getStage(),MouseEvent.MOUSE_DOWN,OnMouseDown);
         BC.addEvent(_dragUI,MainManager.getStage(),MouseEvent.MOUSE_MOVE,OnMouseMove);
      }
      
      private static function OnMouseDown(e:MouseEvent) : void
      {
         if(Boolean(_banUI) && _banUI.visible)
         {
            StopDrag();
         }
      }
      
      private static function OnMouseMove(e:MouseEvent) : void
      {
         if(Boolean(_dragUI))
         {
            _dragUI.x = _dragUI.stage.mouseX - 25;
            _dragUI.y = _dragUI.stage.mouseY - 25;
         }
      }
   }
}

