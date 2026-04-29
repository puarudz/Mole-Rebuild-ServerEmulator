package com.logic.socket.lookBag
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class LookBagReq
   {
      
      public function LookBagReq()
      {
         super();
      }
      
      public static function send(userId:int, Type:int, Flag:int, newType:int = 0) : void
      {
         var lookBagReq:LookBagReq = new LookBagReq();
         lookBagReq.lookBag(userId,Type,Flag,newType);
      }
      
      public function lookBag(userId:int, Type:int, Flag:int, newType:int = 0) : void
      {
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         MsgHead.PkgLen = 27;
         GV.onlineSocket.writeInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeInt(CommandID.lookUpBag);
         GV.onlineSocket.writeInt(MsgHead.UserID);
         GV.onlineSocket.writeInt(MsgHead.Result);
         GV.onlineSocket.writeInt(userId);
         GV.onlineSocket.writeUnsignedInt(Type);
         GV.onlineSocket.writeByte(Flag);
         GV.onlineSocket.writeByte(newType);
         GV.onlineSocket.flush();
      }
   }
}

