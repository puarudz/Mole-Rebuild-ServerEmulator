package com.mole.app.utils
{
   import com.common.util.MouseDragUtil;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class MouseDrag extends EventDispatcher
   {
      
      private var _drag:MouseDragUtil;
      
      public function MouseDrag(disObj:DisplayObject)
      {
         super();
         this._drag = new MouseDragUtil(disObj);
         this._drag.addEventListener(DRAG_STOP,this.onDispatchStop);
         this._drag.addEventListener(DRAG_MOVE,this.onDispatchMove);
      }
      
      public static function get DRAG_STOP() : String
      {
         return MouseDragUtil.DRAG_STOP;
      }
      
      public static function get DRAG_MOVE() : String
      {
         return MouseDragUtil.DRAG_MOVE;
      }
      
      private function onDispatchStop(e:Event) : void
      {
         dispatchEvent(e);
      }
      
      private function onDispatchMove(e:Event) : void
      {
         dispatchEvent(e);
      }
      
      public function destroy() : void
      {
         this._drag.removeEventListener(DRAG_STOP,this.onDispatchStop);
         this._drag.removeEventListener(DRAG_MOVE,this.onDispatchMove);
         this._drag.destroy();
      }
      
      public function get disObj() : DisplayObject
      {
         return this._drag.disObj;
      }
   }
}

