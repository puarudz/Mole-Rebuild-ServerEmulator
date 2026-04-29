package com.logic.socket.birthday
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class getBirthdayCloth
   {
      
      public function getBirthdayCloth()
      {
         super();
      }
      
      public function doAction() : void
      {
         MsgHead.Command = CommandID.GET_BIRTHDAY_CLOTH;
         GF.writeHead();
      }
      
      public function ActionRes() : void
      {
         var Userid:uint = GV.onlineSocket.readUnsignedInt();
         var Itemid:uint = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("CMD_" + CommandID.GET_BIRTHDAY_CLOTH,{
            "OtherID":Userid,
            "UserID":0,
            "ItemID":Itemid
         }));
      }
   }
}

