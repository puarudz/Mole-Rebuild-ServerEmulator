package com.taomee.component.layout
{
   import com.taomee.component.Component;
   import com.taomee.component.Container;
   import flash.events.IEventDispatcher;
   
   public interface ILayoutManager extends IEventDispatcher
   {
      
      function setContainer(param1:Container) : void;
      
      function addLayoutComponent(param1:Component, param2:Object = null) : void;
      
      function removeLayoutComponent(param1:Component) : void;
      
      function doLayout() : void;
      
      function clear() : void;
      
      function getType() : String;
   }
}

