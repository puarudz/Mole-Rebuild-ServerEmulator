package com.core.music
{
   import com.common.soundControl.soundControl;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundLoaderContext;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class MapSound
   {
      
      private static const PLAY_TYPE_ORDER:int = 1;
      
      private static const PLAY_TYPE_RANDOM:int = 2;
      
      private static const MUSIC_PATH:String = "resource/bgSounds/";
      
      private static var _sounds:Dictionary = new Dictionary();
      
      private var _playType:int = 1;
      
      private var _mapId:int;
      
      private var _soundList:Array;
      
      private var _soundIndex:int;
      
      private var _soundControl:soundControl;
      
      private var _playingMusicId:String = "-1";
      
      private var _soundChannel:SoundChannel;
      
      private var _isPlay:Boolean;
      
      public function MapSound(mapInfo:XML, soundContrl:soundControl)
      {
         var item:String = null;
         var obj:Object = null;
         var itemInfo:Array = null;
         super();
         this._mapId = int(mapInfo.@id);
         this._soundControl = soundContrl;
         if(mapInfo.hasOwnProperty("@playType"))
         {
            this._playType = int(mapInfo.@playType);
         }
         var musicInfo:String = mapInfo.@musicId;
         var musicList:Array = musicInfo.split(",");
         this._soundList = new Array();
         for each(item in musicList)
         {
            obj = new Object();
            itemInfo = item.split(":");
            if(Boolean(itemInfo[0]))
            {
               obj.id = itemInfo[0];
               if(Boolean(itemInfo[1]))
               {
                  obj.waitTime = itemInfo[1];
               }
               else
               {
                  obj.waitTime = 0;
               }
               this._soundList.push(obj);
            }
         }
         this._soundIndex = 0;
         if(Boolean(this._soundList[this._soundIndex]))
         {
            this._playingMusicId = this._soundList[this._soundIndex].id;
         }
      }
      
      public static function GetSound(mapId:String) : Sound
      {
         return _sounds[mapId];
      }
      
      public function get mapId() : int
      {
         return this._mapId;
      }
      
      public function get playingMusicId() : String
      {
         return this._playingMusicId;
      }
      
      public function get soundChannel() : SoundChannel
      {
         return this._soundChannel;
      }
      
      public function ContinuePlay(channel:SoundChannel) : void
      {
         this._soundChannel = channel;
         this.ConfigChannelEvent();
      }
      
      public function PlayNewMusic() : void
      {
         var musicSound:Sound = GetSound(this._playingMusicId);
         if(Boolean(musicSound))
         {
            this._soundControl.stopAllSound();
            this._soundChannel = this._soundControl.getSound(musicSound,0,1);
            this.ConfigChannelEvent();
         }
         else
         {
            this._isPlay = true;
            this.LoadMp3(this._playingMusicId);
         }
      }
      
      private function ConfigChannelEvent() : void
      {
         if(Boolean(this._soundChannel))
         {
            BC.addEvent(this,this._soundChannel,Event.SOUND_COMPLETE,this.PlayNext);
         }
      }
      
      private function PlayNext(e:Event) : void
      {
         var soundObj:Object = null;
         BC.removeEvent(this,this._soundChannel,Event.SOUND_COMPLETE,this.PlayNext);
         if(this._playType == PLAY_TYPE_ORDER)
         {
            this._soundIndex = this.GetOrderNextIndex();
         }
         else
         {
            this._soundIndex = this.GetRandomNextIndex();
         }
         soundObj = this._soundList[this._soundIndex];
         this._playingMusicId = soundObj.id;
         var waitTime:int = int(soundObj.waitTime);
         setTimeout(this.PlayNewMusic,waitTime * 1000);
      }
      
      private function GetOrderNextIndex() : int
      {
         var index:int = this._soundIndex;
         index++;
         if(this._soundList[index] == null)
         {
            index = 0;
         }
         return index;
      }
      
      private function GetRandomNextIndex() : int
      {
         var index:int = 0;
         var tempList:Array = null;
         var tempIndex:int = 0;
         var obj:Object = null;
         if(this._soundList.length > 3)
         {
            index = this._soundIndex;
            tempList = this._soundList.slice();
            tempList.splice(index,1);
            tempIndex = Math.random() * 100 % tempList.length;
            obj = tempList[tempIndex];
            return this._soundList.indexOf(obj);
         }
         return this.GetOrderNextIndex();
      }
      
      public function Stop() : void
      {
         this._isPlay = false;
         BC.removeEvent(this);
         this._soundIndex = 0;
         if(Boolean(this._soundList[this._soundIndex]))
         {
            this._playingMusicId = this._soundList[this._soundIndex].id;
         }
      }
      
      private function LoadMp3(id:String) : void
      {
         var currentSound:Sound = null;
         var request:URLRequest = VL.getURLRequest(MUSIC_PATH + id + ".mp3");
         var _temp_4:* = BC;
         var _temp_3:* = currentSound;
         var _temp_2:* = currentSound;
         var _temp_1:* = Event.COMPLETE;
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function okHandler(e:Event):void
            {
               if(_isPlay)
               {
                  BC.removeEvent(currentSound);
                  _sounds[id] = currentSound;
                  PlayNewMusic();
               }
            });
            BC.addEvent(currentSound,currentSound,IOErrorEvent.IO_ERROR,this.ErrorHandler);
            currentSound.load(request);
         }
         
         private function ErrorHandler(e:IOErrorEvent) : void
         {
            var currentSound:Sound = e.target as Sound;
            BC.removeEvent(currentSound);
         }
      }
   }
   
   