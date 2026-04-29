package org.taomee.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class DepthUtil
   {
      
      private static var _children:Array = [];
      
      public function DepthUtil()
      {
         super();
      }
      
      public static function sort(container:DisplayObjectContainer) : void
      {
         var len:int = container.numChildren;
         _children.length = 0;
         for(var i:int = 0; i < len; i++)
         {
            _children.push(container.getChildAt(i));
         }
         _children.sort(compareDisplayObject);
         for(var j:int = 0; j < len; j++)
         {
            if(container.getChildIndex(_children[j]) != j)
            {
               container.setChildIndex(_children[j],j);
            }
         }
         _children.length = 0;
      }
      
      private static function compareDisplayObject(a:DisplayObject, b:DisplayObject) : int
      {
         if(Math.abs(a.y - b.y) < 2)
         {
            return 0;
         }
         if(a.y > b.y)
         {
            return 1;
         }
         return -1;
      }
      
      public static function bringToBottom(o:DisplayObject) : void
      {
         var parent:DisplayObjectContainer = o.parent;
         if(parent == null)
         {
            return;
         }
         if(parent.getChildIndex(o) != 0)
         {
            parent.setChildIndex(o,0);
         }
      }
      
      public static function bringToTop(o:DisplayObject) : void
      {
         var parent:DisplayObjectContainer = o.parent;
         if(parent == null)
         {
            return;
         }
         parent.addChild(o);
      }
   }
}

