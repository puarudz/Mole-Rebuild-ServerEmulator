package com.mole.app.manager.moduleTime
{
   public class ModuleTimeInfo
   {
      
      private var _moduleXml:XML;
      
      private var _name:String;
      
      private var _canOpen:uint;
      
      private var _systimeID:uint;
      
      private var _creatYear:uint;
      
      private var _creatMonth:uint;
      
      private var _creatDays:uint;
      
      private var _lastDays:uint;
      
      public function ModuleTimeInfo(moduleTimeXML:XML)
      {
         super();
         this._moduleXml = moduleTimeXML;
         this._name = this._moduleXml.@name;
         this._canOpen = this._moduleXml.@canOpen;
         this._systimeID = this._moduleXml.@systimeID;
         this._creatYear = this._moduleXml.@creatYear;
         this._creatMonth = this._moduleXml.@creatMonth;
         this._creatDays = this._moduleXml.@creatDays;
         this._lastDays = this._moduleXml.@lastDays;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get canOpen() : uint
      {
         return this._canOpen;
      }
      
      public function get systimeID() : uint
      {
         return this._systimeID;
      }
      
      public function get creatYear() : uint
      {
         return this._creatYear;
      }
      
      public function get creatMonth() : uint
      {
         return this._creatMonth;
      }
      
      public function get creatDays() : uint
      {
         return this._creatDays;
      }
      
      public function get lastDays() : uint
      {
         return this._lastDays;
      }
   }
}

