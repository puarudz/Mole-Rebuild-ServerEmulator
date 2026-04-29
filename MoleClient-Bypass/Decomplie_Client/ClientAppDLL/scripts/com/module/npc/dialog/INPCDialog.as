package com.module.npc.dialog
{
   public interface INPCDialog
   {
      
      function visibleCloseBtn(param1:Boolean) : void;
      
      function say(param1:String = "", param2:String = "") : void;
      
      function chat() : void;
      
      function talkinformally() : void;
      
      function set talkMsg(param1:TalkMessage) : void;
      
      function get talkMsg() : TalkMessage;
      
      function open(param1:* = null) : void;
      
      function close(param1:* = null) : void;
      
      function setAttitudeStatus(param1:int) : void;
      
      function isOpen() : Boolean;
   }
}

