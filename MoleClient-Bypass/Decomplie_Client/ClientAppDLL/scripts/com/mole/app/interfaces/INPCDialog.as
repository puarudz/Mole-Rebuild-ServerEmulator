package com.mole.app.interfaces
{
   import com.mole.app.info.NPCDialogInfo;
   import flash.events.IEventDispatcher;
   
   public interface INPCDialog extends IEventDispatcher
   {
      
      function say(param1:NPCDialogInfo) : void;
      
      function get npcID() : uint;
      
      function close() : void;
      
      function destroy() : void;
   }
}

