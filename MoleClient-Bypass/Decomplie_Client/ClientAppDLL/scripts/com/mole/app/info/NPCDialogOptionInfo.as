package com.mole.app.info
{
   public class NPCDialogOptionInfo
   {
      
      private var _option:String;
      
      private var _cmd:String;
      
      private var _param:*;
      
      private var _data:*;
      
      private var _isClose:Boolean;
      
      public function NPCDialogOptionInfo(option:String, cmd:String, param:* = null, isClose:Boolean = true, data:* = null)
      {
         super();
         this._option = option;
         this._cmd = cmd;
         this._isClose = isClose;
         this._param = param;
         this._data = data;
      }
      
      public function get option() : String
      {
         return this._option;
      }
      
      public function get cmd() : String
      {
         return this._cmd;
      }
      
      public function get param() : *
      {
         return this._param;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function get isClose() : Boolean
      {
         return this._isClose;
      }
   }
}

