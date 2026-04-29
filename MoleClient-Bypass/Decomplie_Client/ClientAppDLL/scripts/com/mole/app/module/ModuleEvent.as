package com.mole.app.module
{
   import flash.events.Event;
   
   public class ModuleEvent extends Event
   {
      
      public static const LOAD_PRECOMPLETE:String = "ModuleEvent_PreloadComplete";
      
      public static const LOAD_COMPLETE:String = "ModuleEvent_LoadComplete";
      
      public static const DESTROY:String = "ModuleEvent_Destroy";
      
      private var _id:Object;
      
      private var _data:Object;
      
      public function ModuleEvent(type:String, id:Object, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._id = id;
         this._data = data;
      }
      
      public function get id() : Object
      {
         return this._id;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

