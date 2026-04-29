package com.module.friendList
{
   import com.core.MainManager;
   
   public class getFriendListData
   {
      
      private static var instance:getFriendListData;
      
      private static var canotNew:Boolean = true;
      
      private var serverFriendsList:Array;
      
      public function getFriendListData()
      {
         super();
         if(canotNew)
         {
            throw new Error("getFriendListData不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : getFriendListData
      {
         if(!instance)
         {
            canotNew = false;
            instance = new getFriendListData();
            canotNew = true;
         }
         return instance;
      }
      
      public function getFriendList() : Array
      {
         var ret:Array = new Array();
         this.serverFriendsList = MainManager.getGlobalObject().data.ServerFriendsList;
         if(Boolean(this.serverFriendsList) && this.serverFriendsList.length > 0)
         {
            ret = this.serverFriendsList;
         }
         return ret;
      }
   }
}

