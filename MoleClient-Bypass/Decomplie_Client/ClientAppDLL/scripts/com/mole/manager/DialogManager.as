package com.mole.manager
{
   import com.common.data.HashMap;
   import com.core.info.LocalUserInfo;
   
   public class DialogManager
   {
      
      private static var _matchMap:HashMap = new HashMap();
      
      public function DialogManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         addMatch("username",LocalUserInfo.getNickName());
      }
      
      public static function addMatch(key:String, value:*) : void
      {
         _matchMap.add("{$" + key + "}",value);
      }
      
      public static function removeMatch(key:String) : void
      {
         _matchMap.remove("{$" + key + "}");
      }
      
      public static function analysis(msg:String, prefix:String = "    ") : String
      {
         var tmpValue:String = null;
         var keyStr:String = null;
         var tmpKeyList:Array = _matchMap.keys;
         for each(keyStr in tmpKeyList)
         {
            msg = msg.split(keyStr).join(_matchMap.getValue(keyStr));
         }
         return prefix + msg;
      }
   }
}

