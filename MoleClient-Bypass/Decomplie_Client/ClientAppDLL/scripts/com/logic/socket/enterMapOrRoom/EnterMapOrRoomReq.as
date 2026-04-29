package com.logic.socket.enterMapOrRoom
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.CommandID;
   
   public class EnterMapOrRoomReq
   {
      
      public static var OldMapID:uint = 0;
      
      public static var OldMapType:uint = 0;
      
      public static var newGrid:int = 0;
      
      public static var OldGrid:int = 0;
      
      public function EnterMapOrRoomReq()
      {
         super();
      }
      
      public static function enterMapRoom() : void
      {
         MsgHead.PkgLen = 25;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.goInMapOrHome);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(newMapID);
         GV.onlineSocket.writeUnsignedInt(newMapType);
         if(newMapID != 150)
         {
            LocalUserInfo.setMyInfo_Grid(0);
            newGrid = 0;
         }
         GV.onlineSocket.writeUnsignedInt(OldMapID);
         GV.onlineSocket.writeUnsignedInt(OldMapType);
         GV.onlineSocket.writeUnsignedInt(newGrid);
         GV.onlineSocket.writeUnsignedInt(OldGrid);
         GV.onlineSocket.flush();
         OldMapID = newMapID;
         OldMapType = newMapType;
      }
      
      public static function get newMapID() : uint
      {
         return LocalUserInfo.getMapID();
      }
      
      public static function get newMapType() : uint
      {
         return LocalUserInfo.getMapType();
      }
   }
}

