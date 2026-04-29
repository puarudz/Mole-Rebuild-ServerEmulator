package com.module.lamuPkSys.animalSkill
{
   public class AnimalSkillTool
   {
      
      public function AnimalSkillTool()
      {
         super();
      }
      
      public static function hasSkill(skillId:int, usingSkill:Array) : int
      {
         var retUsingSkill:int = -1;
         for(var i:int = 0; i < usingSkill.length; i++)
         {
            if(usingSkill[i].skillId == skillId)
            {
               retUsingSkill = int(usingSkill[i].usingCount);
               break;
            }
         }
         return retUsingSkill;
      }
   }
}

