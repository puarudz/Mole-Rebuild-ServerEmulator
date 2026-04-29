package com.core.loading.loadingstyle
{
   import flash.events.IEventDispatcher;
   
   public interface ILoadingStyle extends IEventDispatcher
   {
      
      function changePercent(param1:Number, param2:Number) : void;
      
      function close() : void;
      
      function setTitle(param1:String) : void;
      
      function setIsShowCloseBtn(param1:Boolean) : void;
   }
}

