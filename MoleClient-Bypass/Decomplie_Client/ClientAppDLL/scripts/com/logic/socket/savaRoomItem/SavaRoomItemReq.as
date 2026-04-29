package com.logic.socket.savaRoomItem
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class SavaRoomItemReq
   {
      
      public function SavaRoomItemReq()
      {
         super();
      }
      
      public static function saveRoomBG(bgid:uint) : void
      {
         MsgHead.Command = 415;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(bgid);
         tempByteArray.writeShort(0);
         tempByteArray.writeShort(0);
         tempByteArray.writeByte(0);
         tempByteArray.writeByte(0);
         tempByteArray.writeByte(6);
         tempByteArray.writeByte(3);
         tempByteArray.writeUnsignedInt(0);
         GF.writeHead(tempByteArray);
      }
      
      public function savaRoomItem(Used_CountArr:Array) : void
      {
         Used_CountArr.shift();
         MsgHead.Result = 0;
         var usedCount:int = int(Used_CountArr.length);
         MsgHead.PkgLen = 25 + usedCount * 16;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.SAVE_ROOM_ITEM);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         var maptype:int = LocalUserInfo.getMapType();
         if(maptype == 0)
         {
            maptype = 1;
         }
         else if(maptype == 11)
         {
            maptype = 2;
         }
         else if(maptype == 12)
         {
            maptype = 3;
         }
         GV.onlineSocket.writeUnsignedInt(maptype);
         GV.onlineSocket.writeUnsignedInt(usedCount);
         var buf:ByteArray = new ByteArray();
         for(var h:uint = 0; h < 3; h++)
         {
            buf[h] = 0;
         }
         for(var j:int = 0; j < Used_CountArr.length; j++)
         {
            try
            {
               GV.onlineSocket.writeUnsignedInt(Used_CountArr[j].ID);
               GV.onlineSocket.writeShort(Used_CountArr[j].PosX);
               GV.onlineSocket.writeShort(Used_CountArr[j].PosY);
               GV.onlineSocket.writeByte(Used_CountArr[j].Direction);
               GV.onlineSocket.writeByte(Used_CountArr[j].Visible);
               GV.onlineSocket.writeByte(Used_CountArr[j].Layer);
               GV.onlineSocket.writeByte(Used_CountArr[j].Type);
               GV.onlineSocket.writeByte(0);
               GV.onlineSocket.writeBytes(buf);
            }
            catch(e:Error)
            {
            }
         }
         GV.onlineSocket.flush();
      }
   }
}

