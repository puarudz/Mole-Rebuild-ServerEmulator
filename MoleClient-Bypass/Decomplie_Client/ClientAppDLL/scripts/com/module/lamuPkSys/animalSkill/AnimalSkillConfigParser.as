package com.module.lamuPkSys.animalSkill
{
   import com.global.staticData.XMLInfo;
   import com.module.lamuPkSys.animalSkill.vo.SkillInfo;
   
   public class AnimalSkillConfigParser
   {
      
      private static var _skillConfig:XML = new XML(new XMLInfo._animalSkillConfig());
      
      public function AnimalSkillConfigParser()
      {
         super();
      }
      
      private static function GetAnimalInfo(animalId:int) : XML
      {
         var animal:XML = null;
         for each(animal in _skillConfig.children())
         {
            if(animal.@animal_id == animalId)
            {
               return animal;
            }
         }
         return null;
      }
      
      private static function GetAnimalInfoWithStar(animalId:int, starId:int) : XML
      {
         var star:XML = null;
         var animal:XML = GetAnimalInfo(animalId);
         if(Boolean(animal))
         {
            for each(star in animal.children())
            {
               if(star.@star_id == starId)
               {
                  return star;
               }
            }
         }
         return null;
      }
      
      public static function GetAnimalInfoWithStarLvl(animalId:int, starId:int, lvlId:int) : XML
      {
         var lvl:XML = null;
         var star:XML = GetAnimalInfoWithStar(animalId,starId);
         if(Boolean(star))
         {
            for each(lvl in star.children())
            {
               if(lvl.@level_id == lvlId)
               {
                  return lvl;
               }
            }
         }
         return null;
      }
      
      public static function GetSkillInfo(animalId:int, starId:int, lvlId:int, skillId:int) : XML
      {
         var skill:XML = null;
         var lvl:XML = GetAnimalInfoWithStarLvl(animalId,starId,lvlId);
         if(Boolean(lvl))
         {
            for each(skill in lvl.children())
            {
               if(skill.@skill_id == skillId)
               {
                  return skill;
               }
            }
         }
         return null;
      }
      
      public static function GetSkillInfoObjList(animalId:int, starId:int, lvlId:int) : Array
      {
         var arr:Array = null;
         var skill:XML = null;
         var skillObj:SkillInfo = null;
         var lvl:XML = GetAnimalInfoWithStarLvl(animalId,starId,lvlId);
         if(Boolean(lvl))
         {
            arr = new Array();
            for each(skill in lvl.children())
            {
               skillObj = SkillXmlToObj(skill);
               if(Boolean(skillObj))
               {
                  skillObj._readColdTime = skillObj._configColdTime;
                  arr.push(skillObj);
               }
            }
            return arr;
         }
         return null;
      }
      
      public static function GetSkillInfoObj(animalId:int, starId:int, lvlId:int, skillId:int) : SkillInfo
      {
         var skill:XML = GetSkillInfo(animalId,starId,lvlId,skillId);
         if(Boolean(skill))
         {
            return SkillXmlToObj(skill);
         }
         return null;
      }
      
      private static function SkillXmlToObj(xml:XML) : SkillInfo
      {
         var skillInfo:SkillInfo = null;
         if(Boolean(xml))
         {
            skillInfo = new SkillInfo();
            skillInfo._id = xml.@skill_id;
            skillInfo._name = xml.@name;
            skillInfo._type = xml.@type;
            skillInfo._maxTime = xml.@max_time;
            skillInfo._configColdTime = xml.@cold_time;
            return skillInfo;
         }
         return null;
      }
   }
}

