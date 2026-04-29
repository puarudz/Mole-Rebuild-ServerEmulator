package com.core.manager
{
   import flash.utils.Dictionary;
   
   public class ServerListManager
   {
      
      private static var _listDict:Dictionary;
      
      public function ServerListManager()
      {
         super();
      }
      
      public static function setup(listDict:Dictionary) : void
      {
         _listDict = listDict;
      }
      
      public static function getServerName(id:Object) : String
      {
         return _listDict["ID_" + id];
      }
   }
}

