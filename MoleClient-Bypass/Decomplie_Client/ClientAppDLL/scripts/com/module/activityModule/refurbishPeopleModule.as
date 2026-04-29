package com.module.activityModule
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.net.SharedObject;
   
   public class refurbishPeopleModule
   {
      
      private static var tempItemID:int;
      
      public static var REFURBISH_PEOPLE_SUC:String = "refurbish_people_suc";
      
      public function refurbishPeopleModule()
      {
         super();
      }
      
      public static function doAction(itemID:int) : void
      {
         tempItemID = itemID;
         GF.doAction(5,GV.MAN_PEOPLE.x,GV.MAN_PEOPLE.y);
         GV.onlineSocket.addEventListener("MOLE_SLIDE",getResultHandler);
      }
      
      private static function getResultHandler(evt:EventTaomee) : void
      {
         var mc:* = undefined;
         var i:int = 0;
         var shareObj:SharedObject = null;
         GV.onlineSocket.removeEventListener("MOLE_SLIDE",doAction);
         var userID:int = int(evt.EventObj.UserID);
         var action:int = int(evt.EventObj.Action);
         if(action == 5)
         {
            mc = GF.getPeopleByID(userID);
            for(i = 0; i < mc.clothsArray.length; i++)
            {
               if(mc.clothsArray[i].id == tempItemID)
               {
                  mc.clothsArray.splice(i,1);
                  break;
               }
            }
            if(userID == LocalUserInfo.getUserID())
            {
               LocalUserInfo.setClothItem(mc.clothsArray);
               shareObj = MainManager.getGlobalObject();
               shareObj.data.clothArray = LocalUserInfo.getClothItem();
               GV.onlineSocket.dispatchEvent(new EventTaomee(REFURBISH_PEOPLE_SUC));
            }
         }
      }
   }
}

