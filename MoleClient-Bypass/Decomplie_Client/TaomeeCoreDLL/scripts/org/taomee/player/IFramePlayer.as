package org.taomee.player
{
   import flash.events.IEventDispatcher;
   
   public interface IFramePlayer extends IEventDispatcher
   {
      
      function get totalFrames() : uint;
      
      function get currentFrame() : uint;
      
      function get isPlaying() : Boolean;
      
      function play() : void;
      
      function stop() : void;
      
      function gotoAndPlay(param1:uint) : void;
      
      function gotoAndStop(param1:uint) : void;
      
      function nextFrame() : void;
      
      function prevFrame() : void;
      
      function clear() : void;
      
      function render() : void;
      
      function dispose() : void;
   }
}

