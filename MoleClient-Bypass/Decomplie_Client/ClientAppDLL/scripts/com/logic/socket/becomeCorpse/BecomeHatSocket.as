package com.logic.socket.becomeCorpse
{
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class BecomeHatSocket extends BaseOnlineSocketRequest
   {
      
      public static const HAT_LAHM_CHANGE:String = "hatLahmChange";
      
      public static const HAT_LAHM_RENEW:String = "hatLahmRenew";
      
      public function BecomeHatSocket()
      {
         super();
      }
      
      public static function changeLahmHatReq() : void
      {
         initAction(CommandID.LAHM_HAT_CHANGE);
         flush();
      }
      
      public static function ChangeHat() : void
      {
         var userID:int = int(GV.onlineSocket.readUnsignedInt());
         var itemObj:Object = new Object();
         itemObj.UserID = userID;
         GV.onlineSocket.dispatchEvent(new EventTaomee(HAT_LAHM_CHANGE,itemObj));
      }
      
      public static function ChangeLahm() : void
      {
         var userID:int = int(GV.onlineSocket.readUnsignedInt());
         var itemObj:Object = new Object();
         itemObj.UserID = userID;
         GV.onlineSocket.dispatchEvent(new EventTaomee(HAT_LAHM_RENEW,itemObj));
      }
   }
}

