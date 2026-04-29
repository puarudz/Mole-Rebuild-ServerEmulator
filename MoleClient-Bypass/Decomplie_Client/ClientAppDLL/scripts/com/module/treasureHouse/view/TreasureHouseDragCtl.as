package com.module.treasureHouse.view
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.module.treasureHouse.TreasureHouseEvent;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TreasureHouseDragCtl
   {
      
      private static var _banUI:MovieClip;
      
      private static var _dragUI:MovieClip;
      
      private static var _moveBackUI:MovieClip;
      
      private static var _dragId:int = -1;
      
      private static var _dragPos:int = -1;
      
      public function TreasureHouseDragCtl()
      {
         super();
      }
      
      public static function get dragPos() : int
      {
         return _dragPos;
      }
      
      public static function HideBanIcon() : void
      {
         _banUI.visible = false;
      }
      
      public static function ShowBanIcon() : void
      {
         _banUI.visible = true;
      }
      
      public static function HideMoveBackIcon() : void
      {
         _moveBackUI.visible = false;
      }
      
      public static function ShowMoveBackIcon() : void
      {
         _moveBackUI.visible = true;
      }
      
      public static function StarDrag(dragPos:int, dragId:int) : void
      {
         var itemUrl:String;
         var loader:Loader = null;
         StopDrag();
         _dragId = dragId;
         _dragPos = dragPos;
         _dragUI = new MovieClip();
         _dragUI.mouseEnabled = false;
         _dragUI.mouseChildren = false;
         loader = new Loader();
         itemUrl = "resource/digTreasure/swf/" + dragId + ".swf";
         var _temp_4:* = BC;
         var _temp_3:* = _dragUI;
         var _temp_2:* = loader.contentLoaderInfo;
         var _temp_1:* = Event.COMPLETE;
         with({})
         {
            _temp_4.addOnceEvent(_temp_3,_temp_2,_temp_1,function loadOver(e:Event):void
            {
               loader.y = loader.content.height / 2;
            });
            _dragUI.addChild(loader);
            _banUI = GV.Lib_Map.getMovieClip("Ban_mc") as MovieClip;
            _dragUI.addChild(_banUI);
            _moveBackUI = GV.Lib_Map.getMovieClip("moveBack_mc") as MovieClip;
            _dragUI.addChild(_moveBackUI);
            HideMoveBackIcon();
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
               if(_moveBackUI.visible)
               {
                  GV.onlineSocket.dispatchEvent(new EventTaomee(TreasureHouseEvent.MOVE_ITEM_BACK,{
                     "posId":_dragPos,
                     "itemId":_dragId
                  }));
               }
               GV.onlineSocket.dispatchEvent(new EventTaomee(TreasureHouseEvent.STOP_DRAG,{
                  "posId":_dragPos,
                  "itemId":_dragId,
                  "banVisible":_banUI.visible,
                  "moveBackVisible":_moveBackUI.visible
               }));
               GC.clearAll(_dragUI);
               _dragUI = null;
               _banUI = null;
            }
            _dragId = -1;
            _dragPos = -1;
         }
         
         public static function get dragId() : int
         {
            return _dragId;
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
   
   