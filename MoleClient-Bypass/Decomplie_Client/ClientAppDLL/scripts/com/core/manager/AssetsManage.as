package com.core.manager
{
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   
   public class AssetsManage extends EventDispatcher
   {
      
      private static var libSrc_Dic:Dictionary = new Dictionary(true);
      
      public static var ON_COMPLETE:String = "onComplete";
      
      public static var ON_FAIL:String = "onFail";
      
      public var label:String;
      
      public var src:String;
      
      public var msg:String;
      
      private var addToDic:Boolean;
      
      private var myLoader:Loader;
      
      private var myApplicationDomain:ApplicationDomain;
      
      public function AssetsManage(_addToDic:Boolean = false)
      {
         super();
         this.addToDic = _addToDic;
      }
      
      public static function checkHasLib(_label:String) : *
      {
         return libSrc_Dic[_label];
      }
      
      public function IncludeLib(_label:String, _src:String = "", _msg:String = "", hasLoaderTip:Boolean = true, PRI_Obj:Object = null) : void
      {
         var urlReq:URLRequest = null;
         var infoClass1:Loader = null;
         var infoClass:MCLoader = null;
         this.label = _label;
         if(Boolean(libSrc_Dic[this.label]))
         {
            this.myLoader = libSrc_Dic[this.label];
            this.myApplicationDomain = this.myLoader.contentLoaderInfo.applicationDomain;
            dispatchEvent(new Event(ON_COMPLETE));
         }
         else if(!hasLoaderTip)
         {
            this.src = _src;
            this.msg = _msg;
            urlReq = VL.getURLRequest(this.src);
            infoClass1 = new Loader();
            BC.addEvent(this,infoClass1.contentLoaderInfo,Event.INIT,this.onLoadSuccess2);
            BC.addEvent(this,infoClass1.contentLoaderInfo,IOErrorEvent.IO_ERROR,this.onLoadFailed2);
            infoClass1.load(urlReq);
            this.myLoader = infoClass1;
         }
         else
         {
            this.src = _src;
            this.msg = _msg;
            infoClass = new MCLoader(this.src,GV.MC_AppLever,Loading.TITLE_AND_PERCENT,_msg);
            BC.addEvent(this,infoClass,MCLoadEvent.ON_SUCCESS,this.onLoadSuccess);
            BC.addEvent(this,infoClass,MCLoadEvent.ERROR,this.onLoadFailed);
            infoClass.load();
            this.myLoader = infoClass.getLoader();
         }
      }
      
      private function onLoadSuccess(E:MCLoadEvent) : void
      {
         BC.removeEvent(this);
         this.myLoader = E.getLoader();
         this.myApplicationDomain = this.myLoader.contentLoaderInfo.applicationDomain;
         if(this.addToDic)
         {
            libSrc_Dic[this.label] = this.myLoader;
         }
         dispatchEvent(new Event(ON_COMPLETE));
      }
      
      private function onLoadSuccess2(E:Event) : void
      {
         BC.removeEvent(this);
         this.myLoader = E.currentTarget.loader;
         this.myApplicationDomain = this.myLoader.contentLoaderInfo.applicationDomain;
         if(this.addToDic)
         {
            libSrc_Dic[this.label] = this.myLoader;
         }
         dispatchEvent(new Event(ON_COMPLETE));
      }
      
      private function onLoadFailed(E:MCLoadEvent) : void
      {
         BC.removeEvent(this);
         dispatchEvent(new Event(ON_FAIL));
      }
      
      private function onLoadFailed2(E:IOErrorEvent) : void
      {
         BC.removeEvent(this);
         dispatchEvent(new Event(ON_FAIL));
      }
      
      public function getLoader() : Loader
      {
         if(Boolean(this.myLoader))
         {
            return this.myLoader;
         }
         return null;
      }
      
      public function hasLoaded() : Boolean
      {
         if(Boolean(libSrc_Dic[this.label]))
         {
            return true;
         }
         return false;
      }
      
      public function getClass(_str:String) : Class
      {
         if(Boolean(this.myApplicationDomain))
         {
            return this.myApplicationDomain.getDefinition(_str) as Class;
         }
         throw new Error("資源庫不存在" + this.label + ":" + this.src);
      }
      
      public function getMovieClip(_str:String) : MovieClip
      {
         var tempClass:* = undefined;
         if(Boolean(this.myApplicationDomain))
         {
            tempClass = this.myApplicationDomain.getDefinition(_str);
            return new tempClass() as MovieClip;
         }
         throw new Error("資源庫不存在" + this.label + ":" + _str);
      }
      
      public function getButton(_str:String) : SimpleButton
      {
         var tempClass:* = undefined;
         if(Boolean(this.myApplicationDomain))
         {
            tempClass = this.myApplicationDomain.getDefinition(_str);
            return new tempClass() as SimpleButton;
         }
         throw new Error("資源庫不存在" + this.label + ":" + this.src);
      }
   }
}

