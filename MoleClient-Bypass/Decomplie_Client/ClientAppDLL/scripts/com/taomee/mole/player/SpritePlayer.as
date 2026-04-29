package com.taomee.mole.player
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import org.taomee.player.FramePlayer;
   
   public class SpritePlayer extends Sprite implements ISheet
   {
      
      private var _player:SheetPlayer;
      
      public function SpritePlayer()
      {
         super();
         this._player = new SheetPlayer();
         addChild(this._player);
      }
      
      public function dispose() : void
      {
         this._player.dispose();
         this._player = null;
      }
      
      public function clear() : void
      {
         this._player.clear();
      }
      
      public function set resourceURL(url:String) : void
      {
         this._player.resourceURL = url;
      }
      
      public function get resourceURL() : String
      {
         return this._player.resourceURL;
      }
      
      public function setDomain(uid:String, domain:ApplicationDomain) : void
      {
         this._player.setDomain(uid,domain);
      }
      
      public function set sheetsList(value:Dictionary) : void
      {
         this._player.sheetsList = value;
      }
      
      public function setIndex(index:uint, isReset:Boolean = true) : void
      {
         this._player.setIndex(index,isReset);
      }
      
      public function getIndex() : uint
      {
         return this._player.getIndex();
      }
      
      public function addFrameCompleteEvent(completeHandler:Function) : void
      {
         this._player.addEventListener(Event.COMPLETE,completeHandler);
      }
      
      public function removeFrameCompleteEvent(completeHandler:Function) : void
      {
         this._player.removeEventListener(Event.COMPLETE,completeHandler);
      }
      
      public function render() : void
      {
         this._player.render();
      }
      
      public function stop() : void
      {
         this._player.stop();
      }
      
      public function play() : void
      {
         this._player.play();
      }
      
      public function get currentFrame() : uint
      {
         return this._player.currentFrame;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._player.isPlaying;
      }
      
      public function get totalFrames() : uint
      {
         return this._player.totalFrames;
      }
      
      public function gotoAndPlay(frame:uint) : void
      {
         this._player.gotoAndPlay(frame);
      }
      
      public function gotoAndStop(frame:uint) : void
      {
         this._player.gotoAndStop(frame);
      }
      
      public function nextFrame() : void
      {
         this._player.nextFrame();
      }
      
      public function prevFrame() : void
      {
         this._player.prevFrame();
      }
      
      public function get isGeting() : Boolean
      {
         return this._player.isGeting;
      }
      
      public function get player() : FramePlayer
      {
         return this._player;
      }
   }
}

