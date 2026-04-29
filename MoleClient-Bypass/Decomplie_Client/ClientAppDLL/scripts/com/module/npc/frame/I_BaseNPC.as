package com.module.npc.frame
{
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   
   public interface I_BaseNPC
   {
      
      function loadBone(param1:String) : void;
      
      function inSideRangeByPoint(param1:Point, param2:uint) : void;
      
      function inSideRangeByMC(param1:DisplayObjectContainer, param2:uint) : void;
      
      function setMovingRange(param1:DisplayObjectContainer) : void;
      
      function get autoMove() : Boolean;
      
      function set autoMove(param1:Boolean) : void;
      
      function get x() : Number;
      
      function set x(param1:Number) : void;
      
      function get y() : Number;
      
      function set y(param1:Number) : void;
      
      function get Speed() : int;
      
      function set Speed(param1:int) : void;
      
      function MoveTo(param1:int, param2:int) : void;
      
      function hideButton() : void;
      
      function showButton() : void;
      
      function showAction(param1:String) : void;
      
      function say(param1:String, param2:uint = 4000) : void;
      
      function clearClass(param1:* = null) : void;
   }
}

