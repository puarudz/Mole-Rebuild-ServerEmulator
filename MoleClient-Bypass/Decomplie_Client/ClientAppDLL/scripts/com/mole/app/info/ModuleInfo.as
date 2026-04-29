package com.mole.app.info
{
   public class ModuleInfo
   {
      
      private var _id:uint;
      
      private var _name:String;
      
      private var _moduleType:String;
      
      private var _moduleName:String;
      
      private var _score:Number;
      
      public function ModuleInfo()
      {
         super();
      }
      
      public function initXml(xml:XML) : void
      {
         this._id = uint(xml.@ID);
         this._name = xml.@Name;
         this._moduleType = xml.@ModuleType;
         this._moduleName = xml.@ModuleName;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get score() : Number
      {
         return this._score;
      }
      
      public function set score(value:Number) : void
      {
         this._score = value;
      }
      
      public function get moduleName() : String
      {
         return this._moduleName;
      }
      
      public function get moduleType() : String
      {
         return this._moduleType;
      }
   }
}

