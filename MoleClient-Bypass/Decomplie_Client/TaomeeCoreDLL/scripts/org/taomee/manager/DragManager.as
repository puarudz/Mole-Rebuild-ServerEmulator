package org.taomee.manager
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.core.DragSource;
   import org.taomee.events.DragEvent;
   
   public class DragManager
   {
      
      private static var _dropAction:String;
      
      private static var _offset:Point;
      
      private static var _dragInitiator:InteractiveObject;
      
      private static var _dropTarget:InteractiveObject;
      
      private static var _mouseTarget:InteractiveObject;
      
      private static var _dragSource:DragSource;
      
      private static var _dragImage:Bitmap;
      
      public static const NONE:String = "none";
      
      public static const COPY:String = "copy";
      
      public static const MOVE:String = "move";
      
      public static const LINK:String = "link";
      
      private static var _isDragging:Boolean = false;
      
      private static var _allowMove:Boolean = true;
      
      public function DragManager()
      {
         super();
      }
      
      public static function get isDragging() : Boolean
      {
         return _isDragging;
      }
      
      public static function get dragInitiator() : InteractiveObject
      {
         return _dragInitiator;
      }
      
      public static function get dropAction() : String
      {
         return _dropAction;
      }
      
      public static function set dropAction(value:String) : void
      {
         _dropAction = value;
      }
      
      public static function doDrag(dragInitiator:InteractiveObject, dragSource:DragSource, dragImage:BitmapData = null, offset:Point = null, allowMove:Boolean = true) : void
      {
         if(_isDragging)
         {
            return;
         }
         _isDragging = true;
         _dropAction = NONE;
         _offset = new Point();
         _dragInitiator = dragInitiator;
         _dragSource = dragSource;
         if(Boolean(dragImage))
         {
            if(_dragImage == null)
            {
               _dragImage = new Bitmap();
            }
            _dragImage.bitmapData = dragImage;
            if(Boolean(offset))
            {
               _offset = offset;
            }
            TaomeeManager.stage.addChild(_dragImage);
            upDateImageMove();
         }
         _allowMove = allowMove;
         TaomeeManager.stage.addEventListener(MouseEvent.MOUSE_OVER,onStageOver);
         TaomeeManager.stage.addEventListener(MouseEvent.MOUSE_OUT,onStageOut);
         TaomeeManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMove);
         TaomeeManager.stage.addEventListener(MouseEvent.MOUSE_UP,onStageUp);
         _dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_START,_dragInitiator,_dropTarget,_dragSource,_dropAction,_allowMove));
      }
      
      public static function acceptDragDrop(target:InteractiveObject) : void
      {
         _dropTarget = target;
      }
      
      public static function endDrag() : void
      {
         _isDragging = false;
         TaomeeManager.stage.removeEventListener(MouseEvent.MOUSE_OVER,onStageOver);
         TaomeeManager.stage.removeEventListener(MouseEvent.MOUSE_OUT,onStageOut);
         TaomeeManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMove);
         TaomeeManager.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageUp);
         if(Boolean(_dragInitiator))
         {
            _dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_COMPLETE,_dragInitiator,_dropTarget,_dragSource,_dropAction,_allowMove));
         }
         if(Boolean(_dropTarget) && Boolean(_mouseTarget))
         {
            if(_dropTarget == _mouseTarget)
            {
               _dropTarget.dispatchEvent(new DragEvent(DragEvent.DRAG_DROP,_dragInitiator,_dropTarget,_dragSource,_dropAction,_allowMove));
            }
         }
         clear();
      }
      
      private static function clear() : void
      {
         _dragInitiator = null;
         _dropTarget = null;
         _mouseTarget = null;
         _dragSource = null;
         _offset = null;
         _dropAction = NONE;
         if(Boolean(_dragImage))
         {
            if(Boolean(_dragImage.bitmapData))
            {
               _dragImage.bitmapData.dispose();
            }
            if(Boolean(_dragImage.parent))
            {
               _dragImage.parent.removeChild(_dragImage);
            }
            _dragImage = null;
         }
      }
      
      private static function upDateImageMove() : void
      {
         if(Boolean(_dragImage))
         {
            _dragImage.x = TaomeeManager.stage.mouseX - _offset.x;
            _dragImage.y = TaomeeManager.stage.mouseY - _offset.y;
         }
      }
      
      private static function onStageOver(e:MouseEvent) : void
      {
         (e.target as InteractiveObject).dispatchEvent(new DragEvent(DragEvent.DRAG_ENTER,_dragInitiator,_dropTarget,_dragSource,_dropAction,_allowMove));
      }
      
      private static function onStageOut(e:MouseEvent) : void
      {
         (e.target as InteractiveObject).dispatchEvent(new DragEvent(DragEvent.DRAG_EXIT,_dragInitiator,_dropTarget,_dragSource,_dropAction,_allowMove));
      }
      
      private static function onStageMove(e:MouseEvent) : void
      {
         upDateImageMove();
         _dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_UPEATE,_dragInitiator,_dropTarget,_dragSource,_dropAction,_allowMove));
         _mouseTarget = e.target as InteractiveObject;
         _mouseTarget.dispatchEvent(new DragEvent(DragEvent.DRAG_OVER,_dragInitiator,_dropTarget,_dragSource,_dropAction,_allowMove));
      }
      
      private static function onStageUp(e:MouseEvent) : void
      {
         endDrag();
      }
   }
}

