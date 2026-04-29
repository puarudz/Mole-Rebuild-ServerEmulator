package com.common.soundControl
{
   import com.common.data.HashMap;
   import com.common.data.UILibrary;
   import flash.display.Loader;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.system.ApplicationDomain;
   import flash.utils.getQualifiedClassName;
   
   public class soundControl
   {
      
      private var _playList:HashMap;
      
      private var _soundLibrary:UILibrary;
      
      public var AllSoundTransform:SoundTransform = new SoundTransform();
      
      public function soundControl(library:* = null)
      {
         super();
         this._playList = new HashMap();
         this.setLib(library);
      }
      
      public function setLib(library:*) : void
      {
         this._soundLibrary = new UILibrary(this.checkHasLib(library));
      }
      
      private function checkHasLib(library:*) : ApplicationDomain
      {
         var lib:ApplicationDomain = null;
         if(!library)
         {
            return null;
         }
         if(Boolean(library as ApplicationDomain))
         {
            lib = library;
         }
         else if(Boolean(library as Loader))
         {
            lib = library.contentLoaderInfo.applicationDomain;
         }
         else if(library["loaderInfo"] != null)
         {
            lib = library["loaderInfo"].applicationDomain;
         }
         return lib;
      }
      
      public function getSound(soundObject:*, startTime:Number = 0, count:int = 0, library:* = null) : SoundChannel
      {
         var tmpSound:Sound = null;
         var tmpSoundChannel:SoundChannel = null;
         var SoundCls:Class = null;
         var tmpLibrary:UILibrary = null;
         var soundName:String = String(soundObject);
         if(Boolean(soundObject as Class))
         {
            SoundCls = soundObject as Class;
            if(Boolean(SoundCls))
            {
               tmpSound = new SoundCls();
               soundName = getQualifiedClassName(soundObject);
            }
         }
         else if(Boolean(library))
         {
            tmpLibrary = new UILibrary(this.checkHasLib(library));
            tmpSound = tmpLibrary.getSound(soundObject);
         }
         else if(Boolean(soundObject as String))
         {
            tmpSound = this._soundLibrary.getSound(soundObject);
         }
         else if(Boolean(soundObject as Sound))
         {
            tmpSound = Sound(soundObject);
            soundName = getQualifiedClassName(soundObject);
         }
         if(Boolean(tmpSound))
         {
            tmpSoundChannel = tmpSound.play(startTime,count);
            this.stopSound(soundName);
            this._playList.add(soundName,tmpSoundChannel);
         }
         return tmpSoundChannel;
      }
      
      public function stopSound(name:*) : void
      {
         var soundName:String = "";
         if(Boolean(name as String))
         {
            soundName = String(name);
         }
         else
         {
            soundName = getQualifiedClassName(name);
         }
         var tmpChannel:SoundChannel = this._playList.remove(soundName);
         if(Boolean(tmpChannel))
         {
            tmpChannel.stop();
         }
      }
      
      public function stopAllSound() : void
      {
         var soundChannel:SoundChannel = null;
         for each(soundChannel in this._playList.values)
         {
            if(Boolean(soundChannel))
            {
               soundChannel.stop();
            }
         }
         this._playList.clear();
      }
      
      public function setPan(str:String, volume:Number = 1, pan:Number = 0) : void
      {
         var tempObj:SoundTransform = new SoundTransform();
         tempObj.volume = volume;
         tempObj.pan = pan;
         var tempSoundChannel:SoundChannel = this._playList.getValue(str);
         if(Boolean(tempSoundChannel))
         {
            tempSoundChannel.soundTransform = tempObj;
         }
      }
      
      public function setAllPan(volume:Number = 1, pan:Number = 0, changeConfig:Boolean = false) : void
      {
         var channel:SoundChannel = null;
         var tempObj:SoundTransform = new SoundTransform();
         tempObj.volume = volume;
         tempObj.pan = pan;
         if(changeConfig)
         {
            this.AllSoundTransform.volume = tempObj.volume;
            this.AllSoundTransform.pan = tempObj.pan;
            this.AllSoundTransform.leftToLeft = tempObj.leftToLeft;
            this.AllSoundTransform.leftToRight = tempObj.leftToRight;
            this.AllSoundTransform.rightToLeft = tempObj.rightToLeft;
            this.AllSoundTransform.rightToRight = tempObj.rightToRight;
         }
         for each(channel in this._playList.values)
         {
            if(Boolean(channel))
            {
               channel.soundTransform = tempObj;
            }
         }
      }
      
      public function setPanByObject(Obj:SoundTransform) : void
      {
         var soundID:* = undefined;
         var tempObj:SoundTransform = Obj;
         for each(soundID in this._playList.values)
         {
            soundID.soundTransform = tempObj;
         }
      }
      
      public function destroy() : void
      {
         this.stopAllSound();
      }
   }
}

