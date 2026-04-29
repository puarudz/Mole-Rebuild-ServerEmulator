package
{
   import com.common.data.HashMap;
   import com.core.info.ListenerInfo;
   import flash.utils.getDefinitionByName;
   
   public class BC
   {
      
      private static var _listenerHash:HashMap = new HashMap();
      
      private static var _uid:uint = 0;
      
      public function BC()
      {
         super();
      }
      
      public static function addEvent(key:*, listener:*, eventType:String, backFun:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var listenerInfo:ListenerInfo = null;
         var hash:HashMap = null;
         var DebugM:Class = null;
         if(Boolean(key) && Boolean(listener) && backFun != null)
         {
            listener.addEventListener(eventType,backFun,useCapture,priority,useWeakReference);
            listenerInfo = new ListenerInfo(_uid++,key,listener,eventType,backFun,useCapture,priority,useWeakReference);
            hash = _listenerHash.getValue(key);
            if(hash == null)
            {
               hash = new HashMap();
               _listenerHash.add(key,hash);
            }
            hash.add(listenerInfo.id,listenerInfo);
         }
         else
         {
            DebugM = getDefinitionByName("com.mole.debug.DebugManager") as Class;
            if(Boolean(DebugM))
            {
               DebugM["traceMsg"]();
            }
         }
      }
      
      public static function addOnceEvent(key:*, listener:*, event:String, func:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var onceFun:Function = null;
         onceFun = function handler(e:*):void
         {
            removeEvent(key,listener,event,onceFun,useCapture);
            func(e);
         };
         addEvent(key,listener,event,onceFun,useCapture,priority,useWeakReference);
      }
      
      public static function removeEvent(key:*, listener:* = null, eventType:String = null, backFun:Function = null, useCapture:Boolean = false) : void
      {
         var infoList:Array = null;
         var listenerInfo:ListenerInfo = null;
         var infoHash:HashMap = _listenerHash.getValue(key);
         if(Boolean(infoHash))
         {
            infoList = infoHash.values;
            for each(listenerInfo in infoList)
            {
               if(listener == null || listenerInfo.listener == listener)
               {
                  if(eventType == null || listenerInfo.eventType == eventType)
                  {
                     if(backFun == null || listenerInfo.backFun == backFun)
                     {
                        if(useCapture == listenerInfo.useCapture)
                        {
                           if(listener == null && eventType == null && backFun == null && useCapture == false)
                           {
                              listenerInfo.listener.removeEventListener(listenerInfo.eventType,listenerInfo.backFun,false);
                              listenerInfo.listener.removeEventListener(listenerInfo.eventType,listenerInfo.backFun,true);
                           }
                           else
                           {
                              listenerInfo.listener.removeEventListener(listenerInfo.eventType,listenerInfo.backFun,listenerInfo.useCapture);
                           }
                           infoHash.remove(listenerInfo.id);
                        }
                     }
                  }
               }
            }
            if(infoHash.length == 0)
            {
               _listenerHash.remove(key);
            }
         }
      }
   }
}

