package com.logic.socket.action
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class ActionReq
   {
      
      public function ActionReq()
      {
         super();
      }
      
      public static function actions1(action:int, dir:int) : void
      {
         new ActionReq().actions(action,dir);
      }
      
      public static function actions2(Action:int) : void
      {
         MsgHead.Command = CommandID.actions2;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Action);
         GF.writeHead(tempByteArray);
      }
      
      public function actions(Action:int, Direction:int) : void
      {
         MsgHead.PkgLen = 22;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.actions);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(Action);
         GV.onlineSocket.writeByte(Direction);
         GV.onlineSocket.flush();
      }
   }
}

