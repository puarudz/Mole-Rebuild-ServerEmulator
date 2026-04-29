package com.logic.socket.delFrend
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class DelFrendReq
   {
      
      public static const DeleteFriendsCmd:int = 612;
      
      public function DelFrendReq()
      {
         super();
      }
      
      public static function DeleteFriends(array:Array) : void
      {
         MsgHead.Command = DeleteFriendsCmd;
         if(array == null)
         {
            return;
         }
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(array.length);
         for(var i:int = 0; i < array.length; i++)
         {
            tempByteArray.writeUnsignedInt(array[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_DeleteFriends() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.state = output.readUnsignedInt();
         obj.canDeleteCount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + DeleteFriendsCmd,obj));
      }
      
      public function delfrend(UserID:int) : void
      {
         MsgHead.PkgLen = 21;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.deleteFrend);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.flush();
      }
   }
}

