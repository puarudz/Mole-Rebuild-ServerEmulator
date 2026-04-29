package com.common.msgHead
{
   import flash.utils.ByteArray;
   
   public final class MsgHead
   {
      
      public static var PkgLen:int;
      
      public static var Command:int;
      
      public static var SessionLen:int;
      
      public static var Version:int = 65;
      
      private static var myUserID:int = 0;
      
      public static var Result:int = 0;
      
      public static var Session:ByteArray = new ByteArray();
      
      public function MsgHead()
      {
         super();
      }
      
      public static function set UserID(_userID:int) : void
      {
         myUserID = _userID;
      }
      
      public static function get UserID() : int
      {
         return myUserID;
      }
   }
}

