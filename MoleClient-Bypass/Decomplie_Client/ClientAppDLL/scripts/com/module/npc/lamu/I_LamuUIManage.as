package com.module.npc.lamu
{
   import flash.display.Loader;
   
   public interface I_LamuUIManage
   {
      
      function setUILibrary(param1:Loader, param2:LamuInfo) : void;
      
      function refurbish() : void;
      
      function changeBoneDirection() : void;
      
      function set currentDirection(param1:String) : void;
      
      function get currentDirection() : String;
      
      function set isMoveing(param1:Boolean) : void;
      
      function set isDoAction(param1:Boolean) : void;
      
      function get isMoveing() : Boolean;
      
      function get isDoAction() : Boolean;
      
      function set lamuName(param1:String) : void;
      
      function get lamuName() : String;
      
      function get lamuInfo() : LamuInfo;
      
      function showAction(param1:String) : Boolean;
      
      function destroy() : void;
      
      function set scaleX(param1:Number) : void;
      
      function set scaleY(param1:Number) : void;
      
      function get scaleX() : Number;
      
      function get scaleY() : Number;
   }
}

