package com.core.info
{
   public class ListenerInfo
   {
      
      private var _id:uint;
      
      private var _key:*;
      
      private var _listener:*;
      
      private var _eventType:String;
      
      private var _backFun:Function;
      
      private var _useCapture:Boolean;
      
      private var _priority:int;
      
      private var _useWeakReference:Boolean;
      
      public function ListenerInfo(id:uint, key:*, listener:*, eventType:String, backFun:Function, useCapture:Boolean, priority:int, useWeakReference:Boolean)
      {
         super();
         this._id = id;
         this._key = key;
         this._listener = listener;
         this._eventType = eventType;
         this._backFun = backFun;
         this._useCapture = useCapture;
         this._priority = priority;
         this._useWeakReference = useWeakReference;
      }
      
      public function get key() : *
      {
         return this._key;
      }
      
      public function get listener() : *
      {
         return this._listener;
      }
      
      public function get eventType() : String
      {
         return this._eventType;
      }
      
      public function get backFun() : Function
      {
         return this._backFun;
      }
      
      public function get useCapture() : Boolean
      {
         return this._useCapture;
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function get useWeakReference() : Boolean
      {
         return this._useWeakReference;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
   }
}

