package com.interfaces
{
   import com.core.car.carInfo.CarInfo;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public interface ICarAction
   {
      
      function get carBody() : MovieClip;
      
      function set carInfo(param1:CarInfo) : void;
      
      function get carInfo() : CarInfo;
      
      function set speed(param1:int) : void;
      
      function get speed() : int;
      
      function driveCar(param1:MovieClip, param2:MovieClip) : void;
      
      function moveTo(param1:int, param2:int) : void;
      
      function say(param1:String) : void;
      
      function sitDown(param1:int = -1) : Boolean;
      
      function scaleXY(param1:Number) : void;
      
      function wave() : Boolean;
      
      function dance() : Boolean;
      
      function scaleBody(param1:Number = 1.5) : void;
      
      function stopAction(param1:String = "") : void;
      
      function throwThing(param1:Object) : void;
      
      function setSkidArea(param1:DisplayObjectContainer, param2:int = 100, param3:int = -1) : void;
      
      function setGhangeSpeedArea(param1:DisplayObjectContainer, param2:int = 100) : void;
      
      function specialAction(param1:XML) : void;
      
      function refreshCar() : void;
   }
}

