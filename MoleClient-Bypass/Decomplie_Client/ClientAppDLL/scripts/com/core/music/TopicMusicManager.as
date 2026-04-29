package com.core.music
{
   import com.common.soundControl.soundControl;
   import com.global.staticData.XMLInfo;
   import flash.media.SoundChannel;
   import flash.utils.Dictionary;
   
   public class TopicMusicManager
   {
      
      private static var _instance:TopicMusicManager;
      
      private var _bgSoundCon:soundControl;
      
      private var _preMapSound:MapSound;
      
      private var _mapDict:Dictionary;
      
      private var _isOpen:Boolean = true;
      
      private var _extenalSoundChannel:SoundChannel;
      
      public function TopicMusicManager()
      {
         super();
      }
      
      public static function get instance() : TopicMusicManager
      {
         if(!_instance)
         {
            _instance = new TopicMusicManager();
            _instance.Init();
         }
         return _instance;
      }
      
      public static function get mute() : Boolean
      {
         return TopicMusicManager.instance.isOpen() == false;
      }
      
      public static function set mute(value:Boolean) : void
      {
         if(value)
         {
            TopicMusicManager.instance.close();
         }
         else
         {
            TopicMusicManager.instance.open();
         }
      }
      
      public function isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function Init() : void
      {
         var map:XML = null;
         var mapSound:MapSound = null;
         this._mapDict = new Dictionary();
         this._bgSoundCon = new soundControl();
         for each(map in XMLInfo.bgMusicXml.children())
         {
            mapSound = new MapSound(map,this._bgSoundCon);
            this._mapDict[mapSound.mapId] = mapSound;
         }
      }
      
      public function playSound(mapID:int) : void
      {
         var channel:SoundChannel = null;
         if(!this._isOpen)
         {
            return;
         }
         var mapSound:MapSound = this._mapDict[mapID];
         if(mapSound == null)
         {
            this.stopSound();
            this._preMapSound = null;
         }
         else if(this._preMapSound != mapSound)
         {
            if(Boolean(this._preMapSound) && this._preMapSound.playingMusicId == mapSound.playingMusicId)
            {
               channel = this._preMapSound.soundChannel;
               this.stopSound(false,false);
               mapSound.ContinuePlay(channel);
            }
            else
            {
               this.stopSound();
               mapSound.PlayNewMusic();
            }
            this._preMapSound = mapSound;
         }
      }
      
      public function PlayExtenalBgSound(sound:*, count:int = 9999) : void
      {
         if(!this._isOpen)
         {
            return;
         }
         this.stopSound();
         this._extenalSoundChannel = this._bgSoundCon.getSound(sound,0,count);
      }
      
      public function PlayMusic(sound:*, count:int = 9999) : void
      {
         this._bgSoundCon.getSound(sound,0,count);
      }
      
      public function stopSound(changeConfig:Boolean = false, stopBg:Boolean = true) : void
      {
         if(stopBg && Boolean(this._bgSoundCon))
         {
            this._bgSoundCon.stopAllSound();
         }
         if(Boolean(this._extenalSoundChannel))
         {
            this._extenalSoundChannel.stop();
         }
         if(Boolean(this._preMapSound))
         {
            this._preMapSound.Stop();
         }
         this._preMapSound = null;
      }
      
      public function open() : void
      {
         this._isOpen = true;
      }
      
      public function close() : void
      {
         this._isOpen = false;
      }
      
      public function changeSoundVolume(v:Number) : void
      {
         GV.soundCon.setAllPan(v,0,true);
         this._bgSoundCon.setAllPan(v,0,true);
      }
   }
}

