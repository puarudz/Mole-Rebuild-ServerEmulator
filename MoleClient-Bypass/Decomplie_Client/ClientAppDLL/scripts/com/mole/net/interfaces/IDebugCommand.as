package com.mole.net.interfaces
{
   public interface IDebugCommand
   {
      
      function init(param1:String) : void;
      
      function execute(param1:Array) : Boolean;
      
      function input(param1:String) : void;
      
      function outMsg(param1:String) : void;
      
      function popMsg(param1:String) : void;
      
      function destroy() : void;
   }
}

