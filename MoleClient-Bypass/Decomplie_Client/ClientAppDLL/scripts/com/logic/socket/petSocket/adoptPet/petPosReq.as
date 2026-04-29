package com.logic.socket.petSocket.adoptPet
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class petPosReq extends EventDispatcher
   {
      
      public function petPosReq()
      {
         super();
      }
      
      public function sendPosReq(count:int, arr:Array) : void
      {
         MsgHead.PkgLen = 21 + 6 * count;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PETPOS);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(count);
         for(var i:uint = 0; i < count; i++)
         {
            GV.onlineSocket.writeUnsignedInt(arr[i].SpriteID);
            GV.onlineSocket.writeByte(arr[i].PosX);
            GV.onlineSocket.writeByte(arr[i].PosY);
         }
         GV.onlineSocket.flush();
      }
   }
}

