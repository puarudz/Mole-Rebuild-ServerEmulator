package com.module.angelFight.valueObject
{
   public class AngelFightSkillVO
   {
      
      private static const Skill_Type_Initiative:int = 0;
      
      private static const Skill_Type_Passive:int = 1;
      
      private var _data:XML;
      
      private var _skillId:int;
      
      private var _level:int;
      
      private var _levelData:XML;
      
      public function AngelFightSkillVO(skillId:int, level:int, data:XML)
      {
         var dataXML:XML = null;
         super();
         this._skillId = skillId;
         this._level = level;
         this._data = data;
         this._levelData = new XML();
         var dataXMLList:XMLList = this._data.children();
         for each(dataXML in dataXMLList)
         {
            if(dataXML.@Skill_lvl == this._level)
            {
               this._levelData = dataXML;
               break;
            }
         }
      }
      
      public function get hasLevel() : Boolean
      {
         return this._levelData != null;
      }
      
      public function get isPassiveSkill() : Boolean
      {
         return this.Skill_type == Skill_Type_Passive;
      }
      
      public function get Skill_type() : int
      {
         return this._data.@Skill_type;
      }
      
      public function get Card_id() : int
      {
         return this._data.@Card_id;
      }
      
      public function get Name() : String
      {
         return this._data.@Name;
      }
      
      public function get AddState() : String
      {
         return this._data.@AddState;
      }
      
      public function get skillId() : int
      {
         return this._skillId;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get Exp_lvl() : int
      {
         return this._levelData.@Exp_lvl;
      }
      
      public function get Card_cnt() : int
      {
         return this._levelData.@Card_cnt;
      }
      
      public function get Money() : int
      {
         return this._levelData.@Money;
      }
      
      public function get Rate() : int
      {
         return this._levelData.@Rate;
      }
      
      public function get UseMp() : int
      {
         return this._levelData.@UseMp;
      }
      
      public function get Hurt() : int
      {
         return this._levelData.@Hurt;
      }
      
      public function get Str() : int
      {
         return this._levelData.@Str;
      }
      
      public function get Int() : int
      {
         return this._levelData.@Int;
      }
      
      public function get Hab() : int
      {
         return this._levelData.@Hab;
      }
      
      public function get Ali() : int
      {
         return this._levelData.@Ali;
      }
      
      public function get Atk() : int
      {
         return this._levelData.@Atk;
      }
      
      public function get Aspd() : int
      {
         return this._levelData.@Aspd;
      }
      
      public function get Evad() : int
      {
         return this._levelData.@Evad;
      }
      
      public function get Block() : int
      {
         return this._levelData.@Block;
      }
      
      public function get Combo() : int
      {
         return this._levelData.@Combo;
      }
      
      public function get Crit() : int
      {
         return this._levelData.@Crit;
      }
      
      public function get Hit() : int
      {
         return this._levelData.@Hit;
      }
      
      public function get Def() : int
      {
         return this._levelData.@Def;
      }
      
      public function get Hp() : int
      {
         return this._levelData.@Hp;
      }
      
      public function get Desc() : String
      {
         return this._levelData.@Desc;
      }
   }
}

