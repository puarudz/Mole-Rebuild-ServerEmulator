package com.mole.info
{
   public class ItemInfo
   {
      
      private var _ID:uint;
      
      private var _name:String;
      
      private var _count:uint = 0;
      
      public function ItemInfo()
      {
         super();
      }
      
      public function get ID() : uint
      {
         return this._ID;
      }
      
      public function set ID(value:uint) : void
      {
         this._ID = value;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function get count() : uint
      {
         return this._count;
      }
      
      public function set count(value:uint) : void
      {
         this._count = value;
      }
   }
}

