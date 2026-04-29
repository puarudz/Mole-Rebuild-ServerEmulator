package org.taomee.events
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.core.DragSource;
   
   public class DragEvent extends MouseEvent
   {
      
      public static const DRAG_ENTER:String = "dragEnter";
      
      public static const DRAG_EXIT:String = "dragExit";
      
      public static const DRAG_OVER:String = "dragOver";
      
      public static const DRAG_COMPLETE:String = "dragComplete";
      
      public static const DRAG_START:String = "dragStart";
      
      public static const DRAG_UPEATE:String = "dragUpdate";
      
      public static const DRAG_DROP:String = "dragDrop";
      
      public var action:String;
      
      public var dragInitiator:InteractiveObject;
      
      public var dragSource:DragSource;
      
      public var allowMove:Boolean;
      
      public var dropTarget:InteractiveObject;
      
      public function DragEvent(type:String, dragInitiator:InteractiveObject = null, dropTarget:InteractiveObject = null, dragSource:DragSource = null, action:String = null, allowMove:Boolean = true)
      {
         super(type);
         this.dragInitiator = dragInitiator;
         this.dropTarget = dropTarget;
         this.dragSource = dragSource;
         this.action = action;
         this.allowMove = allowMove;
      }
      
      override public function clone() : Event
      {
         var cloneEvent:DragEvent = new DragEvent(type,this.dragInitiator,this.dropTarget,this.dragSource,this.action,this.allowMove);
         cloneEvent.ctrlKey = ctrlKey;
         cloneEvent.altKey = altKey;
         cloneEvent.shiftKey = shiftKey;
         cloneEvent.relatedObject = relatedObject;
         cloneEvent.localX = localX;
         cloneEvent.localY = localY;
         return cloneEvent;
      }
   }
}

