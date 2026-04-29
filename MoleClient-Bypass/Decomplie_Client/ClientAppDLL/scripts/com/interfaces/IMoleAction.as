package com.interfaces
{
   public interface IMoleAction
   {
      
      function moveTo(param1:int, param2:int) : Boolean;
      
      function say(param1:String) : void;
      
      function sitDown(param1:int = -1) : Boolean;
      
      function scaleXY(param1:Number) : void;
      
      function wave() : Boolean;
      
      function dance() : Boolean;
      
      function openBook(param1:* = null) : void;
      
      function closeBook(param1:* = null) : void;
      
      function scaleBody(param1:Number = 1.5) : void;
      
      function stopAction(param1:String = "") : void;
      
      function throwThing(param1:Object) : void;
      
      function touchdown() : Boolean;
      
      function fly(param1:String) : Boolean;
      
      function ChangeCloths() : void;
      
      function showWordBoxMSG(param1:*) : void;
   }
}

