package com.taomee.mole.resource
{
   public class ResourceItem
   {
      
      private var _key:String;
      
      private var _data:*;
      
      public function ResourceItem(key:String, data:*)
      {
         super();
         this._key = key;
         this._data = data;
      }
      
      public function get key() : String
      {
         return this._key;
      }
      
      public function get data() : *
      {
         return this._data;
      }
   }
}

