package com.mole.debug
{
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.mole.net.interfaces.IDebugCommand;
   import flash.display.DisplayObject;
   
   public class DebugManager
   {
      
      private static var _cmd:IDebugCommand;
      
      private static var _DEBUG:Boolean = false;
      
      private static var _outMsg:String = "";
      
      public function DebugManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         DEBUG = VL.debug;
      }
      
      public static function get DEBUG() : Boolean
      {
         return _DEBUG;
      }
      
      public static function set DEBUG(value:Boolean) : void
      {
         var resID:uint = 0;
         if(value && _DEBUG == false)
         {
            resID = DownLoadManager.add("resource/movie/DebugPanel.swf",ResType.DISPLAY_OBJECT,true);
            DownLoadManager.addEvent(resID,onLoadDebugComplete);
         }
         else if(value == false && _DEBUG)
         {
            if(Boolean(_cmd))
            {
               _cmd.destroy();
               _cmd = null;
            }
         }
         _DEBUG = value;
      }
      
      private static function onLoadDebugComplete(e:DownLoadEvent) : void
      {
         _cmd = e.data;
         _cmd.init(_outMsg);
         MainManager.debugLevel.addChildAt(_cmd as DisplayObject,0);
      }
      
      public static function execute(cmdArr:Array) : Boolean
      {
         if(DEBUG && Boolean(_cmd))
         {
            return _cmd.execute(cmdArr);
         }
         return false;
      }
      
      public static function input(cmdStr:String) : void
      {
         if(DEBUG && Boolean(_cmd))
         {
            _cmd.input(cmdStr);
         }
      }
      
      public static function outMsg(msg:String) : void
      {
         _outMsg += msg + "\n";
         if(DEBUG && Boolean(_cmd))
         {
            _cmd.outMsg(msg);
         }
         trace(msg);
      }
      
      public static function traceMsg(msg:String = "", isTraceErrorPath:Boolean = true, err:Error = null) : void
      {
         var errPath:String = "";
         if(isTraceErrorPath)
         {
            try
            {
               throw new Error(msg);
            }
            catch(e:Error)
            {
               errPath = e.getStackTrace();
            }
         }
         if(DEBUG)
         {
            if(Boolean(err))
            {
               msg += "\n" + err.message;
            }
            msg += "\n" + errPath;
            if(Boolean(_cmd))
            {
               _cmd.popMsg(msg);
            }
         }
         outMsg(msg);
      }
   }
}

