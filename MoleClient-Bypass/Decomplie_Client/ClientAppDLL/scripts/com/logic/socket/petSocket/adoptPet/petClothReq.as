package com.logic.socket.petSocket.adoptPet
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class petClothReq extends EventDispatcher
   {
      
      public function petClothReq()
      {
         super();
      }
      
      public static function change_cloth(SpriteID:uint, ItemIDArr:Array) : void
      {
         MsgHead.PkgLen = 17 + 4 + 5 * ItemIDArr.length;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PET_CHANGE_CLOTH);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(SpriteID);
         for(var i:uint = 0; i < ItemIDArr.length; i++)
         {
            trace("換帶衣服：：：：",ItemIDArr[i].ItemID,ItemIDArr[i].Flag);
            GV.onlineSocket.writeUnsignedInt(ItemIDArr[i].ItemID);
            GV.onlineSocket.writeByte(ItemIDArr[i].Flag);
         }
         GV.onlineSocket.flush();
      }
      
      public static function change_honor(SpriteID:uint, ItemIDArr:Array) : void
      {
         MsgHead.PkgLen = 17 + 4 + 5 * ItemIDArr.length;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PET_CHANGE_HONOR);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(SpriteID);
         for(var i:uint = 0; i < ItemIDArr.length; i++)
         {
            trace("換帶榮譽：：：：",ItemIDArr[i].ItemID,ItemIDArr[i].Flag);
            GV.onlineSocket.writeUnsignedInt(ItemIDArr[i].ItemID);
            GV.onlineSocket.writeByte(ItemIDArr[i].Flag);
         }
         GV.onlineSocket.flush();
      }
      
      public static function petItemReq(UserID:uint, SpriteID:uint, Start:uint, End:uint, Flag:uint = 2) : void
      {
         var sendByte:ByteArray = new ByteArray();
         sendByte.writeUnsignedInt(UserID);
         sendByte.writeUnsignedInt(SpriteID);
         sendByte.writeUnsignedInt(Start);
         sendByte.writeUnsignedInt(End);
         sendByte.writeByte(Flag);
         GF.sendSocket(CommandID.PET_ITEM_INFO,sendByte);
      }
      
      public static function buyItem(SpriteID:uint, ItemID:uint, Count:uint) : void
      {
         MsgHead.PkgLen = 29;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PET_ITEM_BUY);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(SpriteID);
         GV.onlineSocket.writeUnsignedInt(ItemID);
         GV.onlineSocket.writeUnsignedInt(Count);
         GV.onlineSocket.flush();
      }
      
      public static function getHonor() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GETPETHONOR);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
      
      public static function getSLCloth() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(1125);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
   }
}

