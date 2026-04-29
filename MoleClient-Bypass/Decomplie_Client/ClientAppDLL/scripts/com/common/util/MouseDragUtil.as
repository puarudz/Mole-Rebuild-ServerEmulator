package com.common.util
{
   import com.core.manager.LevelManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.DepthUtil;
   
   public class MouseDragUtil extends EventDispatcher
   {
      
      public static const DRAG_STOP:String = "MouseDrag_Stop";
      
      public static const DRAG_MOVE:String = "MouseDrag_Move";
      
      private var _disObj:DisplayObject;
      
      private var _startPos:Point;
      
      private var _oldPos:Point;
      
      public function MouseDragUtil(disObj:DisplayObject)
      {
         super();
         this._disObj = disObj;
         DepthUtil.bringToTop(this._disObj);
         this._oldPos = new Point(this._disObj.x,this._disObj.y);
         this._startPos = new Point(LevelManager.stage.mouseX,LevelManager.stage.mouseY);
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         Tick.instance.addCallback(this.onMove);
      }
      
      private function onMove(delay:Number) : void
      {
         var disPos:Point = new Point(LevelManager.stage.mouseX - this._startPos.x,LevelManager.stage.mouseY - this._startPos.y);
         var endPos:Point = new Point(this._oldPos.x + disPos.x,this._oldPos.y + disPos.y);
         if(LevelManager.stage.mouseX >= 0 && LevelManager.stage.mouseX <= LevelManager.WIDTH)
         {
            this._disObj.x = endPos.x;
         }
         if(LevelManager.stage.mouseY >= 0 && LevelManager.stage.mouseY <= LevelManager.HEIGHT)
         {
            this._disObj.y = endPos.y;
         }
         dispatchEvent(new Event(DRAG_MOVE));
      }
      
      protected function onDragUp(e:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         Tick.instance.removeCallback(this.onMove);
         dispatchEvent(new Event(DRAG_STOP));
      }
      
      public function get disObj() : DisplayObject
      {
         return this._disObj;
      }
   }
}

