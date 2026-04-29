package com.common.util
{
   import flash.display.DisplayObjectContainer;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MovieClipUtil
   {
      
      public function MovieClipUtil()
      {
         super();
      }
      
      public static function playEndAndRemove(mc:MovieClip) : void
      {
         mc.addFrameScript(mc.totalFrames - 1,function():void
         {
            mc.addFrameScript(mc.totalFrames - 1,null);
            DisplayUtil.removeForParent(mc);
            mc = null;
         });
      }
      
      public static function removePlayEndAndFunc(mc:MovieClip) : void
      {
         mc.addFrameScript(mc.totalFrames - 1,null);
      }
      
      public static function playOneFrameToAnatherFrameAndFunc(mc:MovieClip, a:uint, b:uint, func:Function, funcParam:Array = null) : void
      {
         if(a <= b && a > 0 && b <= mc.totalFrames)
         {
            mc.gotoAndPlay(a);
            mc.addFrameScript(b - 1,function():void
            {
               mc.addFrameScript(b - 1,null);
               mc = null;
               func.apply(null,funcParam);
            });
         }
      }
      
      public static function playEndAndFunc(mc:MovieClip, func:Function, funcParam:Array = null) : void
      {
         mc.addFrameScript(mc.totalFrames - 1,function():void
         {
            mc.addFrameScript(mc.totalFrames - 1,null);
            mc = null;
            func.apply(null,funcParam);
         });
         mc.play();
      }
      
      public static function playAppointFrameToEndAndFun(mc:MovieClip, appointFrame:uint, func:Function, funcParam:Array = null) : void
      {
         mc.gotoAndPlay(appointFrame);
         mc.addFrameScript(mc.totalFrames - 1,function():void
         {
            mc.addFrameScript(mc.totalFrames - 1,null);
            mc = null;
            func.apply(null,funcParam);
         });
      }
      
      public static function playAppointFrameAndFunc(mc:MovieClip, appointFrame:int, func:Function, funcParam:Array = null, isGoto:Boolean = true) : void
      {
         addRegisterFrameEventFunc(mc,appointFrame,func,funcParam);
         if(isGoto)
         {
            mc.gotoAndStop(appointFrame);
         }
      }
      
      public static function addRegisterFrameEventFunc(mc:MovieClip, appointFrame:int, func:Function, funcParam:Array = null) : void
      {
         appointFrame--;
         mc.addFrameScript(appointFrame,function():void
         {
            mc.addFrameScript(appointFrame,null);
            mc = null;
            func.apply(null,funcParam);
         });
      }
      
      public static function labelToFrame(mc:MovieClip, label:Object) : uint
      {
         var frameLabel:FrameLabel = null;
         var tmpLabel:uint = uint(label);
         if(Boolean(tmpLabel))
         {
            return tmpLabel;
         }
         var labelList:Array = mc.currentLabels;
         for each(frameLabel in labelList)
         {
            if(frameLabel.name == label)
            {
               return frameLabel.frame;
            }
         }
         return 0;
      }
      
      public static function isFrameLabel(mc:MovieClip, label:Object) : Boolean
      {
         return Boolean(labelToFrame(mc,label));
      }
      
      public static function childStop(obj:DisplayObjectContainer, frame:Object, level:uint = 0) : void
      {
         var count:int = 0;
         count = 0;
         var num:int = obj.numChildren;
         if(num == 0)
         {
            return;
         }
         if(level >= num)
         {
            level = num - 1;
         }
         obj.addEventListener(Event.ENTER_FRAME,function(e:Event):void
         {
            var mc:MovieClip = obj.getChildAt(level) as MovieClip;
            if(Boolean(mc))
            {
               obj.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               mc.gotoAndStop(frame);
            }
            else if(count > 2)
            {
               obj.removeEventListener(Event.ENTER_FRAME,arguments.callee);
            }
            ++count;
         });
      }
      
      public static function childPlay(obj:DisplayObjectContainer, frame:Object, level:uint = 0) : void
      {
         var count:int = 0;
         count = 0;
         var num:int = obj.numChildren;
         if(num == 0)
         {
            return;
         }
         if(level >= num)
         {
            level = num - 1;
         }
         obj.addEventListener(Event.ENTER_FRAME,function(e:Event):void
         {
            var mc:MovieClip = obj.getChildAt(level) as MovieClip;
            if(Boolean(mc))
            {
               obj.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               mc.gotoAndPlay(frame);
            }
            else if(count > 2)
            {
               obj.removeEventListener(Event.ENTER_FRAME,arguments.callee);
            }
            ++count;
         });
      }
      
      public static function gotoAndStop(mc:MovieClip, frame:Object) : void
      {
         if(Boolean(mc) && Boolean(mc.currentFrame != frame) && mc.currentLabel != frame)
         {
            if(frame is int)
            {
               mc.gotoAndStop(frame);
            }
            else if(isFrameLabel(mc,frame))
            {
               mc.gotoAndStop(frame);
            }
            else
            {
               mc.stop();
            }
         }
      }
      
      public static function gotoAndPlay(mc:MovieClip, frame:Object) : void
      {
         if(Boolean(mc) && Boolean(mc.currentFrame != frame) && mc.currentLabel != frame)
         {
            if(frame is int)
            {
               mc.gotoAndPlay(frame);
            }
            else if(isFrameLabel(mc,frame))
            {
               mc.gotoAndPlay(frame);
            }
         }
      }
      
      public static function setChildValue(obj:DisplayObjectContainer, name:String, count:uint, value:uint, showZero:Boolean = false) : void
      {
         var mc:MovieClip = null;
         var num:int = 0;
         var strValue:String = value.toString();
         var strLen:int = strValue.length;
         var index:int = 0;
         for(var i:int = 0; i < count; i++)
         {
            mc = obj.getChildByName(name + i) as MovieClip;
            if(Boolean(mc))
            {
               if(strLen >= count - i)
               {
                  num = parseInt(strValue.charAt(index++));
                  mc.visible = true;
                  mc.gotoAndStop(num + 1);
               }
               else
               {
                  mc.gotoAndStop(1);
                  mc.visible = showZero;
               }
            }
         }
      }
      
      public static function setChildValueFromFirst(obj:DisplayObjectContainer, name:String, count:uint, value:uint) : void
      {
         var mc:MovieClip = null;
         var num:int = 0;
         var strValue:String = value.toString();
         var strLen:int = strValue.length;
         for(var i:int = 0; i < count; i++)
         {
            mc = obj.getChildByName(name + i) as MovieClip;
            if(Boolean(mc))
            {
               if(strLen > i)
               {
                  num = parseInt(strValue.charAt(i));
                  mc.visible = true;
                  mc.gotoAndStop(num + 1);
               }
               else
               {
                  mc.gotoAndStop(1);
                  mc.visible = false;
               }
            }
         }
      }
   }
}

