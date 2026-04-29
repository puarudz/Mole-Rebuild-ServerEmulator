package com.mole.net.interfaces
{
   import flash.utils.IDataInput;
   
   public interface ISocketProtocol
   {
      
      function decode(param1:IDataInput = null) : void;
   }
}

