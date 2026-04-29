package com.mole.app.manager
{
   import com.common.data.HashMap;
   import com.core.manager.LevelManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   
   public class KeyboardManager
   {
      
      private static var _keyStateHash:HashMap;
      
      private static var _eventDispatcher:EventDispatcher;
      
      public function KeyboardManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _keyStateHash = new HashMap();
         LevelManager.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUpHandler);
         LevelManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
      }
      
      private static function onKeyUpHandler(e:KeyboardEvent) : void
      {
         _keyStateHash.remove(e.keyCode);
         dispatchEvent(e);
      }
      
      private static function onKeyDownHandler(e:KeyboardEvent) : void
      {
         _keyStateHash.add(e.keyCode,true);
         dispatchEvent(e);
      }
      
      public static function getKeyState(keyCode:int) : Boolean
      {
         return Boolean(_keyStateHash.getValue(keyCode));
      }
      
      private static function getEventDispathcer() : EventDispatcher
      {
         if(_eventDispatcher == null)
         {
            _eventDispatcher = new EventDispatcher();
         }
         return _eventDispatcher;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getEventDispathcer().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getEventDispathcer().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         getEventDispathcer().dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getEventDispathcer().hasEventListener(type);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return getEventDispathcer().willTrigger(type);
      }
   }
}

