package com.mole.app.module
{
   import flash.events.IEventDispatcher;
   
   public interface IAppModule extends IEventDispatcher
   {
      
      function init(param1:Object = null) : void;
      
      function close() : void;
      
      function destroy() : void;
   }
}

