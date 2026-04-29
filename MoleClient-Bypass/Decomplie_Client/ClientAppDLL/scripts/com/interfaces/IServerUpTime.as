package com.interfaces
{
   public interface IServerUpTime
   {
      
      function get date() : Date;
      
      function get offset() : int;
      
      function set offset(param1:int) : void;
      
      function get valueDate() : Date;
      
      function get getMoleHours() : int;
   }
}

