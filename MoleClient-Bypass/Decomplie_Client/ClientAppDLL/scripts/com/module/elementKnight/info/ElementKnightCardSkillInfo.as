package com.module.elementKnight.info
{
   public class ElementKnightCardSkillInfo
   {
      
      private var _id:uint;
      
      private var _name:String;
      
      private var _type:uint;
      
      private var _about:String;
      
      public function ElementKnightCardSkillInfo(xml:XML)
      {
         super();
         this._id = uint(xml.@Id);
         this._name = String(xml.@Name);
         this._type = uint(xml.@type);
         this._about = String(xml.@about);
      }
      
      public function get skillId() : uint
      {
         return this._id;
      }
      
      public function get skillName() : String
      {
         return this._name;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get about() : String
      {
         return this._about;
      }
   }
}

