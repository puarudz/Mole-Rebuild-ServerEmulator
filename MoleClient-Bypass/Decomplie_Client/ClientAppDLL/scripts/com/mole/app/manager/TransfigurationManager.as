package com.mole.app.manager
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.login.LoginShared;
   import com.global.staticData.CommandID;
   import com.mole.net.MoleSharedObject;
   import com.view.PeopleView.ChildPeople.simplePeople;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class TransfigurationManager
   {
      
      public function TransfigurationManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.TRANSFIGURATION_ROLE_NOTICE,transfigurationRole);
      }
      
      private static function transfigurationRole(evt:SocketEvent) : void
      {
         var loginObj:Object = null;
         var recData:ByteArray = evt.data as ByteArray;
         var userId:uint = recData.readUnsignedInt();
         var roleType:uint = recData.readUnsignedInt();
         var userMC:Object = GF.getPeopleByID(userId);
         if(userId == LocalUserInfo.getUserID())
         {
            LocalUserInfo.roleType = roleType;
            simplePeople(GV.MAN_PEOPLE.avatarClass).clothClass.getOffAll();
            loginObj = LoginShared.getUser(LocalUserInfo.getUserID());
            loginObj.roleType = LocalUserInfo.roleType;
            LoginShared.addUser(loginObj);
            MainManager.getGlobalObject().data.clothArray = [];
            MoleSharedObject.flush();
         }
         if(Boolean(userMC))
         {
            userMC.roleType = roleType;
            if(userId != LocalUserInfo.getUserID())
            {
               simplePeople(userMC.avatarClass).clothClass.getOffAll();
            }
            simplePeople(userMC.avatarClass).changeRoleType(roleType);
         }
      }
      
      public static function changeRoleType(roleType:uint) : void
      {
         GF.sendSocket(CommandID.TRANSFIGURATION_ROLE,roleType);
         GV.onlineSocket.addCmdListener(CommandID.TRANSFIGURATION_ROLE,changeRoleTypeBk);
      }
      
      private static function changeRoleTypeBk(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.TRANSFIGURATION_ROLE,changeRoleTypeBk);
         var recData:ByteArray = evt.data as ByteArray;
         var state:uint = recData.readUnsignedInt();
         if(state == 1)
         {
         }
      }
   }
}

