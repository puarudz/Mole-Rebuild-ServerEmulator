package com.module.LocusWork
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MCContorl
   {
      
      public function MCContorl()
      {
         super();
      }
      
      public static function getFrame(mc:MovieClip, label:Object) : int
      {
         var oldmcCurrentFrame:int = mc.currentFrame;
         mc.gotoAndStop(label);
         label = mc.currentFrame;
         mc.gotoAndStop(oldmcCurrentFrame);
         return label as int;
      }
      
      public static function playTo(mc:MovieClip, fr:Object, fun:Function = null, funparameters:Object = null) : void
      {
         mc["gotoNext"] = false;
         if(fr is String)
         {
            if(mc.currentLabel == fr)
            {
               if(fun != null)
               {
                  if(funparameters != null)
                  {
                     fun(funparameters);
                  }
                  else
                  {
                     fun();
                  }
                  mc["fun"] = null;
                  mc["funparameters"] = null;
               }
               return;
            }
            fr = getFrame(mc,fr);
         }
         else if(mc.currentFrame == fr)
         {
            if(fun != null)
            {
               if(funparameters != null)
               {
                  fun(funparameters);
               }
               else
               {
                  fun();
               }
               mc["fun"] = null;
               mc["funparameters"] = null;
            }
            return;
         }
         if(fr <= 0)
         {
            fr = mc.totalFrames;
         }
         mc["fr"] = fr;
         mc["fun"] = null;
         mc["funparameters"] = null;
         if(fun != null)
         {
            mc["fun"] = fun;
            mc["funparameters"] = funparameters;
         }
         if(!mc.hasEventListener(Event.ENTER_FRAME))
         {
            mc.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
            mc.addEventListener(Event.ENTER_FRAME,mcEnterFrame);
         }
      }
      
      private static function removeFromStage(e:Event) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         mc["fr"] = null;
         mc.removeEventListener(Event.ENTER_FRAME,mcEnterFrame);
         mc.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
      }
      
      private static function mcEnterFrame(e:Event) : void
      {
         var fun:Function = null;
         var o:Object = null;
         var local:MovieClip = e.currentTarget as MovieClip;
         if(Boolean(local["gotoNext"]))
         {
            local["gotoNext"] = false;
            local.removeEventListener(Event.ENTER_FRAME,mcEnterFrame);
            local["fr"] = null;
            fun = local["fun"];
            o = local["funparameters"];
            local["fun"] = null;
            local["funparameters"] = null;
            if(fun != null)
            {
               if(o != null)
               {
                  fun(o);
               }
               else
               {
                  fun();
               }
            }
            return;
         }
         if(local.currentFrame > local["fr"])
         {
            local.prevFrame();
         }
         else if(local.currentFrame < local["fr"])
         {
            local.nextFrame();
         }
         if(local.currentFrame == local["fr"])
         {
            local.stop();
            local["gotoNext"] = true;
         }
      }
      
      public static function stopTo(mc:MovieClip, fr:Object, fun:Function = null, funparameters:Object = null) : void
      {
         mc["gotoNext"] = false;
         if(fr is String)
         {
            mc.gotoAndStop(fr);
            fr = mc.currentFrame;
            mc["fr"] = fr;
         }
         else
         {
            mc["fr"] = fr;
            mc.gotoAndStop(fr);
         }
         mc["fun"] = null;
         mc["funparameters"] = null;
         if(fun != null)
         {
            mc["fun"] = fun;
            mc["funparameters"] = funparameters;
         }
         if(!mc.hasEventListener(Event.ENTER_FRAME))
         {
            mc.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
            mc.addEventListener(Event.ENTER_FRAME,mcEnterFrame);
         }
      }
      
      public static function stopAllMC(mc:*) : void
      {
         var temp:* = undefined;
         try
         {
            mc.stop();
         }
         catch(e:*)
         {
         }
         var num:uint = uint(mc.numChildren);
         for(var j:int = num - 1; j >= 0; j--)
         {
            temp = mc.getChildAt(j);
            if(temp is MovieClip)
            {
               stopAllMC(temp);
            }
         }
      }
      
      public static function playAllMC(mc:*) : void
      {
         var temp:* = undefined;
         try
         {
            mc.play();
         }
         catch(e:*)
         {
         }
         var num:uint = uint(mc.numChildren);
         for(var j:int = num - 1; j >= 0; j--)
         {
            temp = mc.getChildAt(j);
            if(temp is MovieClip)
            {
               playAllMC(temp);
            }
         }
      }
   }
}

