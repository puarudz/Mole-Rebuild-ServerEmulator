package com.logic.socket.useUserDItem
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class UseUserItemRigReq
   {
      
      public function UseUserItemRigReq()
      {
         super();
      }
      
      public function useUserItemRig(CountArr:Array) : void
      {
         MsgHead.Command = CommandID.useUDProperty;
         var tba:ByteArray = new ByteArray();
         tba.writeUnsignedInt(CountArr.length);
         for(var j:int = 0; j < CountArr.length; j++)
         {
            tba.writeUnsignedInt(CountArr[j].ItemID);
         }
         GF.writeHead(tba);
      }
      
      public function useUserItemRig2(CountArr:Array) : void
      {
         var Count:uint = CountArr.length;
         MsgHead.Result = 0;
         MsgHead.PkgLen = 21 + 5 * Count;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.useUDProperty);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(Count);
         for(var j:int = 0; j < CountArr.length; j++)
         {
            GV.onlineSocket.writeUnsignedInt(CountArr[j]);
         }
         GV.onlineSocket.flush();
      }
   }
}

