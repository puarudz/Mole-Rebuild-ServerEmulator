package com.common.util
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import org.taomee.utils.Delegate;
   
   public class DisplayUtil
   {
      
      private static const MOUSE_EVENT_LIST:Array = [MouseEvent.CLICK,MouseEvent.DOUBLE_CLICK,MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_MOVE,MouseEvent.MOUSE_OUT,MouseEvent.MOUSE_OVER,MouseEvent.MOUSE_UP,MouseEvent.MOUSE_WHEEL,MouseEvent.ROLL_OUT,MouseEvent.ROLL_OVER];
      
      public function DisplayUtil()
      {
         super();
      }
      
      public static function stopAllMovieClip(dis:DisplayObjectContainer, frame:uint = 0) : void
      {
         var mc:MovieClip = null;
         var child:DisplayObjectContainer = null;
         var len:uint = 0;
         var i:uint = 0;
         if(Boolean(dis) && !(dis is Loader))
         {
            mc = dis as MovieClip;
            if(Boolean(mc))
            {
               if(frame > 0)
               {
                  mc.gotoAndStop(frame);
               }
               else
               {
                  mc.stop();
               }
            }
            len = uint(dis.numChildren);
            for(i = 0; i < len; i++)
            {
               child = dis.getChildAt(i) as DisplayObjectContainer;
               if(child != null)
               {
                  stopAllMovieClip(child,frame);
               }
            }
         }
      }
      
      public static function playAllMovieClip(dis:DisplayObjectContainer) : void
      {
         var mc:MovieClip = null;
         var num:int = 0;
         var child:DisplayObjectContainer = null;
         var i:int = 0;
         if(Boolean(dis) && !(dis is Loader))
         {
            mc = dis as MovieClip;
            if(mc != null)
            {
               mc.gotoAndPlay(1);
               mc = null;
            }
            num = dis.numChildren - 1;
            if(num < 0)
            {
               return;
            }
            for(i = num; i >= 0; i--)
            {
               child = dis.getChildAt(i) as DisplayObjectContainer;
               if(child != null)
               {
                  playAllMovieClip(child);
               }
            }
         }
      }
      
      public static function startAllMovieClip(dis:DisplayObjectContainer) : void
      {
         var num:int = 0;
         var child:DisplayObjectContainer = null;
         var i:int = 0;
         var mc:MovieClip = dis as MovieClip;
         if(mc != null)
         {
            mc.play();
            mc = null;
            num = dis.numChildren - 1;
            if(num < 0)
            {
               return;
            }
            for(i = num; i >= 0; i--)
            {
               child = dis.getChildAt(i) as DisplayObjectContainer;
               if(child != null)
               {
                  startAllMovieClip(child);
               }
            }
         }
      }
      
      public static function bringToTop(obj:DisplayObject) : void
      {
         var parent:DisplayObjectContainer = obj.parent;
         if(parent != null)
         {
            parent.setChildIndex(obj,parent.numChildren - 1);
         }
      }
      
      public static function removeAllChild(dis:DisplayObjectContainer) : void
      {
         var child:DisplayObjectContainer = null;
         if(Boolean(dis) && !(dis is Loader))
         {
            while(dis.numChildren > 0)
            {
               child = dis.removeChildAt(0) as DisplayObjectContainer;
               if(child != null)
               {
                  stopAllMovieClip(child);
                  child = null;
               }
            }
         }
      }
      
      public static function removeFromParent(obj:DisplayObject) : void
      {
         if(Boolean(obj) && obj.parent != null)
         {
            obj.parent.removeChild(obj);
         }
      }
      
      public static function removeForParent(dis:DisplayObject, gc:Boolean = true) : void
      {
         var disc:DisplayObjectContainer = null;
         if(dis == null)
         {
            return;
         }
         if(gc)
         {
            disc = dis as DisplayObjectContainer;
            if(Boolean(disc))
            {
               stopAllMovieClip(disc);
               disc = null;
            }
         }
         if(!(dis.parent is Loader) && dis.parent != null)
         {
            try
            {
               dis.parent.removeChild(dis);
            }
            catch(e:Error)
            {
               trace(e.getStackTrace());
            }
         }
      }
      
      public static function hasParent(target:DisplayObject) : Boolean
      {
         if(target.parent == null)
         {
            return false;
         }
         return target.parent.contains(target);
      }
      
      public static function localToLocal(from:DisplayObject, _to:DisplayObject, p:Point = null) : Point
      {
         if(p == null)
         {
            p = new Point(0,0);
         }
         p = from.localToGlobal(p);
         return _to.globalToLocal(p);
      }
      
      public static function align(target:DisplayObject, bounds:Rectangle = null, align:int = 0, offset:Point = null) : void
      {
         var rect:Rectangle = null;
         if(bounds == null)
         {
            if(!Boolean(target.stage))
            {
               target.addEventListener(Event.ADDED_TO_STAGE,Delegate.create(onAddStage,align,offset),false,0,true);
               return;
            }
            rect = new Rectangle(0,0,target.stage.stageWidth,target.stage.stageHeight);
         }
         else
         {
            rect = bounds.clone();
         }
         align2(target,rect,align,offset);
      }
      
      private static function onAddStage(event:Event, align:int, offset:Point) : void
      {
         var target:DisplayObject = event.currentTarget as DisplayObject;
         target.removeEventListener(Event.ADDED_TO_STAGE,arguments.callee);
         align2(target,new Rectangle(0,0,target.stage.stageWidth,target.stage.stageHeight),align,offset);
      }
      
      private static function align2(target:DisplayObject, bounds:Rectangle, align:int, offset:Point) : void
      {
         if(Boolean(offset))
         {
            bounds.offsetPoint(offset);
         }
         var targetRect:Rectangle = target.getRect(target);
         var _hd:Number = bounds.width - target.width;
         var _vd:Number = bounds.height - target.height;
         switch(align)
         {
            case AlignType.TOP_LEFT:
               target.x = bounds.x;
               target.y = bounds.y;
               break;
            case AlignType.TOP_CENTER:
               target.x = bounds.x + _hd / 2 - targetRect.x;
               target.y = bounds.y;
               break;
            case AlignType.TOP_RIGHT:
               target.x = bounds.x + _hd - targetRect.x;
               target.y = bounds.y;
               break;
            case AlignType.MIDDLE_LEFT:
               target.x = bounds.x;
               target.y = bounds.y + _vd / 2 - targetRect.x;
               break;
            case AlignType.MIDDLE_CENTER:
               target.x = bounds.x + _hd / 2 - targetRect.x;
               target.y = bounds.y + _vd / 2 - targetRect.y;
               break;
            case AlignType.MIDDLE_RIGHT:
               target.x = bounds.x + _hd - targetRect.x;
               target.y = bounds.y + _vd / 2 - targetRect.y;
               break;
            case AlignType.BOTTOM_LEFT:
               target.x = bounds.x;
               target.y = bounds.y + _vd - targetRect.y;
               break;
            case AlignType.BOTTOM_CENTER:
               target.x = bounds.x + _hd / 2 - targetRect.x;
               target.y = bounds.y + _vd - targetRect.y;
               break;
            case AlignType.BOTTOM_RIGHT:
               target.x = bounds.x + _hd - targetRect.x;
               target.y = bounds.y + _vd - targetRect.y;
         }
      }
      
      public static function FillColor(target:DisplayObject, c:uint) : void
      {
         var ctf:ColorTransform = new ColorTransform();
         ctf.color = c;
         target.transform.colorTransform = ctf;
      }
      
      public static function getColor(target:DisplayObject, x:uint = 0, y:uint = 0, getAlpha:Boolean = false) : uint
      {
         var bmp:BitmapData = new BitmapData(target.width,target.height);
         bmp.draw(target);
         var color:uint = !getAlpha ? bmp.getPixel(int(x),int(y)) : bmp.getPixel32(int(x),int(y));
         bmp.dispose();
         return color;
      }
      
      public static function uniformScale(target:DisplayObject, num:Number) : void
      {
         if(target.width >= target.height)
         {
            target.width = num;
            target.scaleY = target.scaleX;
         }
         else
         {
            target.height = num;
            target.scaleX = target.scaleY;
         }
      }
      
      public static function copyDisplayAsBmp(dis:DisplayObject, smoothing:Boolean = true) : Bitmap
      {
         var oldX:Number = NaN;
         var oldY:Number = NaN;
         var bmp:Bitmap = null;
         oldY = dis.scaleY;
         oldX = dis.scaleX;
         var bmpdata:BitmapData = new BitmapData(dis.width,dis.height,true,16777215);
         var rect:Rectangle = dis.getRect(dis);
         var matrix:Matrix = new Matrix();
         if(oldX < 0)
         {
            dis.scaleX = -dis.scaleX;
         }
         if(oldY < 0)
         {
            dis.scaleY = -dis.scaleY;
         }
         matrix.createBox(dis.scaleX,dis.scaleY,0,-rect.x * dis.scaleX,-rect.y * dis.scaleY);
         bmpdata.draw(dis,matrix);
         dis.scaleX = oldX;
         dis.scaleY = oldY;
         bmp = new Bitmap(bmpdata,PixelSnapping.AUTO,smoothing);
         if(oldX < 0)
         {
            bmp.scaleX = -1;
         }
         if(oldY < 0)
         {
            bmp.scaleY = -1;
         }
         bmp.x = rect.x * dis.scaleX;
         bmp.y = rect.y * dis.scaleY;
         return bmp;
      }
      
      public static function mouseEnabledAll(target:InteractiveObject, isAll:Boolean = false) : void
      {
         var container:DisplayObjectContainer;
         var i:int = 0;
         var child:InteractiveObject = null;
         var b:Boolean = MOUSE_EVENT_LIST.some(function(item:String, index:int, array:Array):Boolean
         {
            if(target.hasEventListener(item))
            {
               return true;
            }
            return false;
         });
         if(!b)
         {
            if(target.name.indexOf("instance") != -1)
            {
               target.mouseEnabled = false;
            }
         }
         container = target as DisplayObjectContainer;
         if(Boolean(container))
         {
            for(i = container.numChildren - 1; i >= 0; )
            {
               child = container.getChildAt(i) as InteractiveObject;
               if(Boolean(child))
               {
                  mouseEnabledAll(child);
               }
               i--;
            }
         }
      }
      
      public static function removeDescTxt(mc:DisplayObjectContainer) : void
      {
         var desc_txt:TextField = null;
         var num:uint = uint(mc.numChildren);
         for(var i:uint = 0; i < num; i++)
         {
            desc_txt = mc.getChildAt(i) as TextField;
            if(Boolean(desc_txt) && desc_txt.name == "desc_txt")
            {
               mc.removeChild(desc_txt);
               break;
            }
         }
      }
      
      public static function depthSort(disObj:DisplayObjectContainer) : void
      {
         var i:uint = 0;
         var obj:DisplayObject = null;
         var arr:Array = new Array();
         var len:uint = uint(disObj.numChildren);
         for(i = 0; i < len; i++)
         {
            arr.push(disObj.getChildAt(i));
         }
         arr.sortOn("y");
         for(i = 0; i < len; i++)
         {
            obj = arr[i];
            if(obj != disObj.getChildAt(i))
            {
               disObj.setChildIndex(obj,i);
            }
         }
      }
      
      public static function enableInteractiveObject(obj:InteractiveObject, enabled:Boolean) : void
      {
         obj.filters = enabled ? null : [ColorUtils.setSaturation(-100)];
         obj.mouseEnabled = enabled;
         if(obj is DisplayObjectContainer)
         {
            (obj as DisplayObjectContainer).mouseChildren = enabled;
         }
      }
   }
}

