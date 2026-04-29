package com.global.staticData.database.MagicSpirit
{
   public class MagicSpiriteAchievementDefintion
   {
      
      private var _id:uint;
      
      private var _type:uint;
      
      private var _cond:String;
      
      private var _finish_num:uint;
      
      private var _reward:String;
      
      private var _name:String;
      
      private var _desc:String;
      
      private var _iconId:uint;
      
      private var _goldfreeId:uint;
      
      public function MagicSpiriteAchievementDefintion(xml:XML)
      {
         super();
         this._id = uint(xml.@id);
         this._type = uint(xml.@type);
         this._cond = xml.@cond;
         this._finish_num = uint(xml.@finish_num);
         this._reward = xml.@reward;
         this._name = xml.@name;
         this._desc = xml.@desc;
         this._goldfreeId = uint(xml.@goldfree_id);
         this._iconId = xml.@iconid;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get cond() : String
      {
         return this._cond;
      }
      
      public function get finishNum() : uint
      {
         return this._finish_num;
      }
      
      public function get reward() : String
      {
         return this._reward;
      }
      
      public function get desc() : String
      {
         return this._desc;
      }
      
      public function get iconId() : uint
      {
         return this._iconId;
      }
      
      public function get goldfreeId() : uint
      {
         return this._goldfreeId;
      }
   }
}

