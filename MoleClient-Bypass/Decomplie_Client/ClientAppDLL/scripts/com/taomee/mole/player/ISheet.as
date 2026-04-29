package com.taomee.mole.player
{
   import flash.system.ApplicationDomain;
   import org.taomee.player.IFramePlayer;
   
   public interface ISheet extends IFramePlayer
   {
      
      function setIndex(param1:uint, param2:Boolean = true) : void;
      
      function getIndex() : uint;
      
      function set resourceURL(param1:String) : void;
      
      function get resourceURL() : String;
      
      function setDomain(param1:String, param2:ApplicationDomain) : void;
   }
}

