package com.module.lamuPkSys.animalSkill.vo
{
   import com.core.field.animalInfo.AnimalInfo;
   
   public class AnimalSkillData
   {
      
      private var _skillId:int;
      
      private var _userId:int;
      
      private var _animalInfo:AnimalInfo;
      
      private var _itemList:Array;
      
      public function AnimalSkillData()
      {
         super();
      }
      
      public function get itemList() : Array
      {
         return this._itemList;
      }
      
      public function set itemList(value:Array) : void
      {
         this._itemList = value;
      }
      
      public function get skillId() : int
      {
         return this._skillId;
      }
      
      public function set skillId(value:int) : void
      {
         this._skillId = value;
      }
      
      public function get userId() : int
      {
         return this._userId;
      }
      
      public function set userId(value:int) : void
      {
         this._userId = value;
      }
      
      public function get animalInfo() : AnimalInfo
      {
         return this._animalInfo;
      }
      
      public function set animalInfo(value:AnimalInfo) : void
      {
         this._animalInfo = value;
      }
   }
}

