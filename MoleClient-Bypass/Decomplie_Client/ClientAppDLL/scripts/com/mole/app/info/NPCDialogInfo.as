package com.mole.app.info
{
   import com.core.info.LocalUserInfo;
   import com.mole.app.manager.NPCInfoManager;
   
   public class NPCDialogInfo
   {
      
      private var _npcInfo:NPCInfo;
      
      private var _face:String;
      
      private var _msg:String;
      
      private var _optionList:Array;
      
      private var _isHideClose:Boolean;
      
      private var _isTaskDialog:Boolean;
      
      private var _isExchangeName:Boolean;
      
      private var _exchangeName:String;
      
      public function NPCDialogInfo(id:uint, face:String, msg:String, optionList:Array, isHideClose:Boolean = false, isTaskDialog:Boolean = false, isExchangeName:Boolean = false, exchangeName:String = "")
      {
         super();
         this._npcInfo = NPCInfoManager.getNPCInfo(id);
         this._face = face;
         this._msg = msg;
         this._optionList = optionList;
         this._isHideClose = isHideClose;
         this._isTaskDialog = isTaskDialog;
         this._isExchangeName = isExchangeName;
         this._exchangeName = exchangeName;
      }
      
      public function get id() : uint
      {
         return this._npcInfo.id;
      }
      
      public function get name() : String
      {
         if(this.id == 10197)
         {
            return LocalUserInfo.getNickName();
         }
         if(this._isExchangeName)
         {
            return this._exchangeName;
         }
         return this._npcInfo.name;
      }
      
      public function get msg() : String
      {
         return this._msg;
      }
      
      public function get optionList() : Array
      {
         return this._optionList;
      }
      
      public function set optionList(value:Array) : void
      {
         this._optionList = value;
      }
      
      public function get face() : String
      {
         return this._face;
      }
      
      public function get isHideClose() : Boolean
      {
         return this._isHideClose;
      }
      
      public function get isTaskDialog() : Boolean
      {
         return this._isTaskDialog;
      }
   }
}

