package com.common.Alert
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   
   public interface ICustomAlert
   {
      
      function load() : void;
      
      function getLoader() : Loader;
      
      function getTarget() : DisplayObjectContainer;
   }
}

