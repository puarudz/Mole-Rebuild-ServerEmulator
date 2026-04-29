package com.module.activityModule
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import flash.net.SharedObject;
   
   public class checkCloth
   {
      
      public function checkCloth()
      {
         super();
      }
      
      public static function doAction(itemID:int) : Boolean
      {
         var peopleArray:Array = null;
         var tempID:int = itemID;
         peopleArray = LocalUserInfo.getClothItem();
         var bool:Boolean = false;
         for(var i:int = 0; i < peopleArray.length; i++)
         {
            if(tempID == peopleArray[i].id)
            {
               bool = true;
               break;
            }
         }
         return bool;
      }
      
      public static function PeopleHaveItem(userid:int, itemID:int) : Boolean
      {
         var peopleArray:Array = null;
         if(userid == LocalUserInfo.getUserID())
         {
            peopleArray = LocalUserInfo.getClothItem();
         }
         else
         {
            peopleArray = GF.getPeopleByID(userid).clothsArray;
         }
         for(var i:int = 0; i < peopleArray.length; i++)
         {
            if(itemID == peopleArray[i].id)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function PeopleHaveItemSO(itemID:int) : Boolean
      {
         var so:SharedObject = MainManager.getGlobalObject();
         var peopleArray:Array = so.data.clothArray;
         for(var i:int = 0; i < peopleArray.length; i++)
         {
            if(itemID == peopleArray[i].id)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function checkOtherItem(tempID:int, userID:int) : Boolean
      {
         var peopleArray:Array = null;
         if(userID == LocalUserInfo.getUserID())
         {
            peopleArray = LocalUserInfo.getClothItem();
         }
         else
         {
            peopleArray = GF.getPeopleByID(userID).clothsArray;
         }
         var bool:Boolean = false;
         for(var i:int = 0; i < peopleArray.length; i++)
         {
            if(tempID == peopleArray[i].id)
            {
               bool = true;
               break;
            }
         }
         return bool;
      }
   }
}

