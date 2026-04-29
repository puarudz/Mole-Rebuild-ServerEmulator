package com.mole.app.info
{
   public class NpcTalkInfo
   {
      
      private var _npcID:String;
      
      private var _que:String;
      
      private var _msg:String;
      
      private var _talkID:uint;
      
      public function NpcTalkInfo(talkID:uint, npcID:String, que:String, msg:String)
      {
         super();
         this._talkID = talkID;
         this._npcID = npcID;
         this._que = que;
         this._msg = msg;
      }
      
      public function get npcID() : String
      {
         return this._npcID;
      }
      
      public function get que() : String
      {
         return this._que;
      }
      
      public function get msg() : String
      {
         return this._msg;
      }
      
      public function get talkID() : uint
      {
         return this._talkID;
      }
   }
}

