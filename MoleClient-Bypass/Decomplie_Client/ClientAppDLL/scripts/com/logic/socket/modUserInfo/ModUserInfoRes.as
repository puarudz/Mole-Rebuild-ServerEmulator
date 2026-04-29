package com.logic.socket.modUserInfo
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.mole.manager.DialogManager;
   import flash.events.EventDispatcher;
   
   public class ModUserInfoRes extends EventDispatcher
   {
      
      public static var MOD_USER_INFO:String = "mod_user_info";
      
      public function ModUserInfoRes()
      {
         super();
      }
      
      public function modUserInfo() : void
      {
         var my:* = undefined;
         var getUsersBasicObj:Object = new Object();
         getUsersBasicObj.UserID = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Nick = GV.onlineSocket.readUTFBytes(16);
         getUsersBasicObj.Color = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.restaurantSign = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.restaurantLevel = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Vip = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.MapID = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.MapType = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Status = GV.onlineSocket.readUnsignedByte();
         getUsersBasicObj.Action = GV.onlineSocket.readUnsignedInt();
         if(LocalUserInfo.getUserID() == getUsersBasicObj.UserID)
         {
            GV.MyInfo_nickName = getUsersBasicObj.Nick;
            GV.MAN_PEOPLE.nickName = getUsersBasicObj.Nick;
            LocalUserInfo.setNickName(getUsersBasicObj.Nick);
            DialogManager.addMatch("username",getUsersBasicObj.Nick);
            this.updateSO(getUsersBasicObj);
            GV.onlineSocket.dispatchEvent(new EventTaomee(MOD_USER_INFO,getUsersBasicObj));
         }
         else
         {
            my = GF.getPeopleByID(getUsersBasicObj.UserID);
            if(Boolean(my))
            {
               if(this.checkOtherItem(12619,getUsersBasicObj.UserID))
               {
                  my.avatarMC.nickName_txt.htmlText = "<font color=\'#FF0000\'>" + String(getUsersBasicObj.Nick) + "</font>";
               }
               else
               {
                  my.avatarMC.nickName_txt.text = getUsersBasicObj.Nick;
               }
               GV.onlineSocket.dispatchEvent(new EventTaomee(MOD_USER_INFO,getUsersBasicObj));
               try
               {
                  this.updateSO(getUsersBasicObj);
               }
               catch(E:*)
               {
               }
            }
         }
      }
      
      private function updateSO(obj:Object) : void
      {
         var len:uint = 0;
         var i:uint = 0;
         if(!obj)
         {
            return;
         }
         try
         {
            len = uint(MainManager.getGlobalObject().data.FriendsList.length);
            for(i = 0; i < len; i++)
            {
               if(obj.UserID == MainManager.getGlobalObject().data.FriendsList[i].UserID)
               {
                  MainManager.getGlobalObject().data.FriendsList[i].Nick = obj.Nick;
                  return;
               }
            }
            MainManager.getGlobalObject().data.FriendsList.push(obj);
         }
         catch(E:*)
         {
         }
      }
      
      private function checkOtherItem(tempID:int, userID:int) : Boolean
      {
         var tempMC:* = GF.getPeopleByID(userID);
         var peopleArray:Array = tempMC.clothsArray;
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

