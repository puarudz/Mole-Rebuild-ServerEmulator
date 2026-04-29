package com.mole.app.info
{
   public class MoleActionInfo
   {
      
      private var _cmd:String;
      
      private var _param:*;
      
      private var _data:*;
      
      public function MoleActionInfo()
      {
         super();
      }
      
      public function initArr(arr:Array) : void
      {
         this._cmd = arr[0];
         this._param = arr[1];
         this._data = arr[2];
      }
      
      public function initOptionInfo(optionInfo:NPCDialogOptionInfo) : void
      {
         this._cmd = optionInfo.cmd;
         this._param = optionInfo.param;
         this._data = optionInfo.data;
      }
      
      public function initXML(xml:XML) : void
      {
         this._cmd = xml.@Cmd;
         this._param = xml.@Param;
         this._data = String(xml.@Data) == "" ? null : String(xml.@Data);
      }
      
      public function get cmd() : String
      {
         return this._cmd;
      }
      
      public function set cmd(value:String) : void
      {
         this._cmd = value;
      }
      
      public function get param() : *
      {
         return this._param;
      }
      
      public function set param(value:*) : void
      {
         this._param = value;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(value:*) : void
      {
         this._data = value;
      }
   }
}

