package com.module.npc.frame
{
   import com.module.npc.NPCInfo;
   
   public interface I_AdvancedNPC extends I_BaseNPC
   {
      
      function loadNPC(param1:uint) : void;
      
      function FlashMoveToPoint(param1:Number, param2:Number) : void;
      
      function closeAutoMove_And_Stop() : void;
      
      function get npcInfo() : NPCInfo;
   }
}

