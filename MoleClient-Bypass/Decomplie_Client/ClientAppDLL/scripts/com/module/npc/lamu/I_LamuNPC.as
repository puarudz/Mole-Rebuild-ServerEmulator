package com.module.npc.lamu
{
   import com.module.npc.frame.I_AdvancedNPC;
   import flash.display.DisplayObjectContainer;
   
   public interface I_LamuNPC extends I_AdvancedNPC
   {
      
      function get saying() : Boolean;
      
      function get boneManaage() : I_LamuUIManage;
      
      function setMasterID(param1:uint, param2:LamuInfo) : void;
      
      function geocaching(param1:DisplayObjectContainer, param2:Function = null, param3:Function = null, param4:Function = null) : void;
      
      function useLamuSkill(param1:int, param2:int = 1) : void;
      
      function delLamuSkill() : void;
      
      function learningSkill(param1:uint, param2:uint) : void;
      
      function showSkillLevelUP(param1:int) : void;
      
      function checkCanGetItem(param1:int, param2:Boolean = true) : Boolean;
   }
}

