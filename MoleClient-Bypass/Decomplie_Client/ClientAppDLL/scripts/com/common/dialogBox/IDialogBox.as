package com.common.dialogBox
{
   public interface IDialogBox
   {
      
      function setPosXY(param1:int, param2:int) : void;
      
      function say(param1:String, param2:int = 3000) : void;
      
      function removeDialogBox() : void;
   }
}

