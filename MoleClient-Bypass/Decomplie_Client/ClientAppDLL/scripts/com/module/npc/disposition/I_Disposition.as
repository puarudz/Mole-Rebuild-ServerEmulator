package com.module.npc.disposition
{
   import com.module.npc.NPCInfo;
   
   public interface I_Disposition
   {
      
      function init(param1:NPCInfo) : void;
      
      function isDispositionConditon() : Boolean;
      
      function get name() : String;
      
      function destroy() : void;
   }
}

