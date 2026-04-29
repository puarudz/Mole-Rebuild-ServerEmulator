package com.module.pig
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   
   public class PigHouseUI
   {
      
      private static var _instance:PigHouseUI;
      
      public static const Init_OK_Event:String = "PigHouseUI_Init_OK";
      
      private var _app:ApplicationDomain;
      
      public function PigHouseUI()
      {
         super();
      }
      
      public static function get instance() : PigHouseUI
      {
         if(_instance == null)
         {
            _instance = new PigHouseUI();
         }
         return _instance;
      }
      
      public function Init() : void
      {
         var uiUrl:String = null;
         var loader:Loader = null;
         if(this._app == null)
         {
            uiUrl = "module/pig/PigUI.swf";
            loader = new Loader();
            BC.addOnceEvent(this,loader.contentLoaderInfo,Event.COMPLETE,this.LoadOverHandler);
            loader.load(VL.getURLRequest(uiUrl));
         }
         else
         {
            PigEvent.instance.dispatchEvent(new Event(Init_OK_Event));
         }
      }
      
      private function LoadOverHandler(e:Event) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         this._app = loaderInfo.applicationDomain;
         PigEvent.instance.dispatchEvent(new Event(Init_OK_Event));
      }
      
      public function get isInitOK() : Boolean
      {
         return this._app != null;
      }
      
      public function GetMovieClip(name:String) : MovieClip
      {
         var cls:Class = null;
         if(Boolean(this._app))
         {
            cls = this._app.getDefinition(name) as Class;
            if(Boolean(cls))
            {
               return new cls() as MovieClip;
            }
         }
         return null;
      }
      
      public function GetClass(name:String) : Class
      {
         var cls:Class = null;
         if(Boolean(this._app))
         {
            cls = this._app.getDefinition(name) as Class;
            if(Boolean(cls))
            {
               return cls;
            }
         }
         return null;
      }
   }
}

