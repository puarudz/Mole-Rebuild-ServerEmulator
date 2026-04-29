package com.module.npc
{
   public class NPCInfo
   {
      
      private var _usebigpan:Boolean = false;
      
      private var _birthday:String;
      
      private var _id:int;
      
      private var _name:String;
      
      private var _race:String;
      
      private var _sex:String;
      
      private var _work:String;
      
      private var _movespeed:uint;
      
      private var _en_name:String;
      
      private var _mapID:uint;
      
      public function NPCInfo(info:Object)
      {
         super();
         this._usebigpan = info.usebigpan;
         this._birthday = info.birthday;
         this._id = info.id;
         this._name = info.name;
         this._race = info.race;
         this._sex = info.sex;
         this._work = info.work;
         this._movespeed = info.movespeed;
         this._en_name = info.en_name;
         this._mapID = info.mapID;
      }
      
      public function get usebigpan() : Boolean
      {
         return this._usebigpan;
      }
      
      public function get birthday() : String
      {
         return this._birthday;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get race() : String
      {
         return this._race;
      }
      
      public function get sex() : String
      {
         return this._sex;
      }
      
      public function get work() : String
      {
         return this._work;
      }
      
      public function get movespeed() : uint
      {
         return this._movespeed;
      }
      
      public function get en_name() : String
      {
         return this._en_name;
      }
      
      public function get mapID() : uint
      {
         return this._mapID;
      }
   }
}

