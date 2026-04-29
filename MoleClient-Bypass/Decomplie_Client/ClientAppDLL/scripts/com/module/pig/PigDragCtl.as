package com.module.pig
{
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.manager.LevelManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PigDragCtl
   {
      
      private static var _banUI:MovieClip;
      
      private static var _clickFun:Function;
      
      private static var _dragUI:MovieClip;
      
      private static var _stopFun:Function;
      
      public static const Type_Tease:int = 1;
      
      public static const Type_Train:int = 2;
      
      public static const Type_Item:int = 3;
      
      private static var _dragId:int = -1;
      
      private static var _dragType:int = -1;
      
      public function PigDragCtl()
      {
         super();
      }
      
      public static function get isBaned() : Boolean
      {
         return _banUI.visible;
      }
      
      public static function HideBanIcon() : void
      {
         _banUI.visible = false;
      }
      
      public static function ShowBanIcon() : void
      {
         if(Boolean(_banUI))
         {
            _banUI.visible = true;
         }
      }
      
      public static function StarDrag(ui:DisplayObject, dragId:int, type:int, clickFun:Function = null, stopFun:Function = null) : void
      {
         StopDrag();
         _dragType = type;
         _dragId = dragId;
         _clickFun = clickFun;
         _stopFun = stopFun;
         _dragUI = new MovieClip();
         _dragUI.mouseEnabled = false;
         _dragUI.mouseChildren = false;
         _dragUI.addChild(ui);
         _banUI = PigHouseUI.instance.GetMovieClip("Ban_mc");
         _dragUI.addChild(_banUI);
         LevelManager.topLevel.addChild(_dragUI);
         _dragUI.x = _dragUI.stage.mouseX - 25;
         _dragUI.y = _dragUI.stage.mouseY - 25;
         AddEvent();
      }
      
      public static function StopDrag() : void
      {
         if(Boolean(_dragUI))
         {
            BC.removeEvent(_dragUI);
            DisplayUtil.removeForParent(_dragUI);
            _dragUI = null;
            _banUI = null;
         }
         _dragId = -1;
         _dragType = -1;
         _clickFun = null;
         if(_stopFun != null)
         {
            _stopFun();
         }
         _stopFun = null;
      }
      
      public static function get dragId() : int
      {
         return _dragId;
      }
      
      public static function get dragType() : int
      {
         return _dragType;
      }
      
      public static function get dragUI() : MovieClip
      {
         return _dragUI;
      }
      
      private static function AddEvent() : void
      {
         BC.addEvent(_dragUI,MainManager.getStage(),MouseEvent.CLICK,OnMouseDown);
         BC.addEvent(_dragUI,MainManager.getStage(),MouseEvent.MOUSE_MOVE,OnMouseMove);
      }
      
      private static function OnMouseDown(e:MouseEvent) : void
      {
         if(_clickFun != null)
         {
            _clickFun();
         }
         if(Boolean(_banUI) && _banUI.visible)
         {
            StopDrag();
         }
      }
      
      private static function OnClick(e:MouseEvent) : void
      {
         StopDrag();
         e.stopImmediatePropagation();
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

