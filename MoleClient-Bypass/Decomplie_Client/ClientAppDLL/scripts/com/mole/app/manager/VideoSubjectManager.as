package com.mole.app.manager
{
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class VideoSubjectManager
   {
      
      private static var _inst:VideoSubjectManager;
      
      private var _subjectPanel:AppModuleControl;
      
      public function VideoSubjectManager()
      {
         super();
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("openVSubject",this.openVSubject);
            ExternalInterface.addCallback("closeVSubject",this.closeVSubject);
         }
      }
      
      public static function setup() : void
      {
         if(ExternalInterface.available)
         {
            inst;
         }
      }
      
      public static function get inst() : VideoSubjectManager
      {
         if(_inst == null)
         {
            _inst = new VideoSubjectManager();
         }
         return _inst;
      }
      
      public function openVSubject(msg:String = null) : void
      {
         if(ExternalInterface.available)
         {
            this._subjectPanel = ModuleManager.openPanel("VideoSubjectPanel");
            this._subjectPanel.addEventListener(ModuleEvent.DESTROY,this.onSubjectPanelDestroy);
         }
      }
      
      private function onSubjectPanelDestroy(e:ModuleEvent) : void
      {
         this._subjectPanel.addEventListener(ModuleEvent.DESTROY,this.onSubjectPanelDestroy);
         this._subjectPanel = null;
      }
      
      public function openVideo() : void
      {
         var comleteHandle:Function = null;
         comleteHandle = function(e:Event):void
         {
            var swf_loader:MovieClip = e.target.content as MovieClip;
            LevelManager.topLevel.addChild(swf_loader);
            swf_loader.play();
         };
         var loader:Loader = new Loader();
         var url:URLRequest = new URLRequest("mole.swf");
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,comleteHandle);
         loader.load(url);
      }
      
      private function onGetGameSID(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 426,this.onGetGameSID);
         var byte:ByteArray = ByteArray(e.EventObj);
         byte.position = 0;
         ExternalInterface.call("openInnerFrame","http://www.youtube.com/watch?v=A4wFXeDclCM",400,270,38,290);
         SoundManager.stopAll();
      }
      
      public function closeVSubject(msg:String = null) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("closeInnerFrame");
         }
         SoundManager.openAll();
         if(Boolean(this._subjectPanel))
         {
            this._subjectPanel.close();
         }
      }
   }
}

