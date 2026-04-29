package com.view.mapView.activity.Task83
{
   import com.core.music.TopicMusicManager;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.module.activityModule.SoundControlModule;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.net.URLRequest;
   
   public class SoundManager
   {
      
      private static var soundFactory:Sound;
      
      private static var _Sl:SoundChannel;
      
      public static const Sound_Load_Ok_Event:String = "Sound_Load_Ok_Event";
      
      public static var playEnable:Boolean = true;
      
      private static var _loopPlay:Boolean = false;
      
      public function SoundManager()
      {
         super();
      }
      
      public static function play(url:String, loopPlay:Boolean = false) : Boolean
      {
         var request:URLRequest = null;
         var flag:Boolean = false;
         _loopPlay = loopPlay;
         if(playEnable)
         {
            if(Boolean(_Sl))
            {
               _Sl.stop();
               _Sl.removeEventListener(Event.SOUND_COMPLETE,playCompleteFun);
            }
            request = VL.getURLRequest(url);
            soundFactory = new Sound();
            soundFactory.addEventListener(IOErrorEvent.IO_ERROR,error);
            soundFactory.addEventListener(Event.COMPLETE,MusicLoadComplete);
            soundFactory.load(request);
         }
         return flag;
      }
      
      public static function Stop() : void
      {
         _loopPlay = false;
         if(playEnable)
         {
            if(Boolean(_Sl))
            {
               _Sl.stop();
               _Sl.removeEventListener(Event.SOUND_COMPLETE,playCompleteFun);
               _Sl = null;
            }
         }
      }
      
      private static function MusicLoadComplete(e:Event = null) : void
      {
         if(Boolean(soundFactory))
         {
            GV.onlineSocket.dispatchEvent(new Event(Sound_Load_Ok_Event));
            _Sl = soundFactory.play();
         }
         if(Boolean(_Sl))
         {
            _Sl.addEventListener(Event.SOUND_COMPLETE,playCompleteFun);
         }
      }
      
      private static function playCompleteFun(evt:Event) : void
      {
         _Sl.removeEventListener(Event.SOUND_COMPLETE,playCompleteFun);
         _Sl.stop();
         if(_loopPlay)
         {
            _Sl = soundFactory.play();
            _Sl.addEventListener(Event.SOUND_COMPLETE,playCompleteFun);
         }
         else
         {
            _Sl = null;
         }
      }
      
      public static function Clear() : void
      {
      }
      
      private static function error(e:IOErrorEvent) : void
      {
         soundFactory.removeEventListener(IOErrorEvent.IO_ERROR,error);
         trace("加載聲音文件失敗----：" + e);
      }
      
      public static function stopAll(isAll:Boolean = true) : void
      {
         TopicMusicManager.instance.stopSound();
         SoundControlModule.getInstance().stopSund();
         if(isAll)
         {
            SoundMixer.stopAll();
         }
      }
      
      public static function openAll() : void
      {
         if(TopicMusicManager.instance.isOpen())
         {
            SoundMixer.stopAll();
            GameframeLogic.playMousicHandler();
            SoundControlModule.getInstance().playSund();
         }
      }
      
      public static function get mute() : Boolean
      {
         return TopicMusicManager.mute;
      }
      
      public static function set mute(value:Boolean) : void
      {
         TopicMusicManager.mute = value;
         if(value)
         {
            stopAll();
         }
         else
         {
            openAll();
         }
      }
   }
}

