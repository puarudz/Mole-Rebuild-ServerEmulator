package com.logic.socket.becomeCorpse
{
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class BecomeCorpseSocket extends BaseOnlineSocketRequest
   {
      
      public static const CORPSE_MOLE_CHAGE:String = "corpseMoleChange";
      
      public static const CORPSE_LAHM_CHAGE:String = "corpseLahmChange";
      
      public static const CORPSE_MOLE_RENEW:String = "corpseMoleRenew";
      
      public static const CORPSE_LAHM_RENEW:String = "corpseLahmRenew";
      
      public function BecomeCorpseSocket()
      {
         super();
      }
      
      public static function change(type:int) : void
      {
         trace("請求變身-------------->",type);
         initAction(CommandID.CORPSE_CHANGE,type);
         flush();
      }
      
      public static function changeResult() : void
      {
         trace("變身的應答");
         var userID:int = int(GV.onlineSocket.readUnsignedInt());
         var flag:int = GV.onlineSocket.readInt();
         var itemID:int = int(GV.onlineSocket.readUnsignedInt());
         var itemObj:Object = new Object();
         itemObj.ItemID = itemID;
         itemObj.OtherID = userID;
         itemObj.UserID = 0;
         itemObj.FlashTag = 0;
         itemObj.ChangeID = 0;
         if(flag == 1)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(BecomeCorpseSocket.CORPSE_LAHM_CHAGE,itemObj));
            GV.onlineSocket.dispatchEvent(new EventTaomee(BecomeCorpseSocket.CORPSE_MOLE_CHAGE,itemObj));
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(BecomeCorpseSocket.CORPSE_MOLE_CHAGE,itemObj));
         }
      }
      
      public static function corpseRenew() : void
      {
         trace("變身恢復");
         var userID:int = int(GV.onlineSocket.readUnsignedInt());
         var flag:int = GV.onlineSocket.readInt();
         var itemID:int = 0;
         var itemObj:Object = new Object();
         itemObj.UserID = userID;
         itemObj.ItemID = itemID;
         if(flag == 1)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(BecomeCorpseSocket.CORPSE_LAHM_RENEW,itemObj));
            GV.onlineSocket.dispatchEvent(new EventTaomee(BecomeCorpseSocket.CORPSE_MOLE_RENEW,itemObj));
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(BecomeCorpseSocket.CORPSE_MOLE_RENEW,itemObj));
         }
      }
   }
}

