package com.module.activityModule
{
   import com.core.music.TopicMusicManager;
   import com.event.EventTaomee;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   
   public class SoundControlModule
   {
      
      private static var instance:SoundControlModule;
      
      private var danceMusic:Sound;
      
      private var musicHand:SoundChannel;
      
      public function SoundControlModule()
      {
         super();
      }
      
      public static function getInstance() : SoundControlModule
      {
         if(instance == null)
         {
            instance = new SoundControlModule();
         }
         return instance;
      }
      
      public function initSound() : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         if(TopicMusicManager.instance.isOpen())
         {
            this.getSoundFun();
         }
      }
      
      public function getSoundFun() : void
      {
         var tempMusic:Class = GV.Lib_Map.getClass("bgSound") as Class;
         if(tempMusic == null)
         {
            return;
         }
         this.danceMusic = new tempMusic();
         this.musicHand = GV.soundCon.getSound(this.danceMusic,0,999999);
      }
      
      public function stopSund() : void
      {
         if(this.musicHand != null)
         {
            this.musicHand.stop();
         }
      }
      
      public function playSund() : void
      {
         if(this.musicHand != null)
         {
            this.getSoundFun();
         }
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this);
         this.stopSund();
         this.musicHand = null;
         this.danceMusic = null;
      }
   }
}

