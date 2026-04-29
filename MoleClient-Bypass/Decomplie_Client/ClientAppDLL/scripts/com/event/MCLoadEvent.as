package com.event
{
   import com.core.newloader.BaseMCLoader;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.events.Event;
   
   public class MCLoadEvent extends Event
   {
      
      public static var ON_SUCCESS:String = "onSuccess";
      
      public static var MOLE_LOADING_COUNT:String = "mole_loading_count";
      
      public static var ERROR:String = "error";
      
      private var _parentMC:DisplayObjectContainer;
      
      private var _loader:Loader;
      
      private var content:DisplayObject;
      
      public function MCLoadEvent(type:String, mcloader:BaseMCLoader, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._parentMC = mcloader.getParent();
         this._loader = mcloader.loader;
      }
      
      public function getParent() : DisplayObjectContainer
      {
         return this._parentMC;
      }
      
      public function getLoader() : Loader
      {
         return this._loader;
      }
      
      public function getContent() : DisplayObject
      {
         return this._loader.content;
      }
      
      public function get url() : String
      {
         return this._loader.contentLoaderInfo.url;
      }
   }
}

