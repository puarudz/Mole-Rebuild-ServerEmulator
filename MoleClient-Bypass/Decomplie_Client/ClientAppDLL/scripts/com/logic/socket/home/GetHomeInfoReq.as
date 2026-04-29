package com.logic.socket.home
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class GetHomeInfoReq
   {
      
      public function GetHomeInfoReq()
      {
         super();
      }
      
      public static function getHomeInfo(UserID:int) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GET_HOME_INFO);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.flush();
      }
      
      public static function getHomeDepotInfo() : void
      {
         MsgHead.PkgLen = 22;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GET_HOME_DEPOT_INFO);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
      
      public static function saveHomeUsedGoods(usedArr:Array) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.SAVE_HOME_USED);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(usedArr.length);
         for(var i:uint = 0; i < usedArr.length; i++)
         {
            GV.onlineSocket.writeUnsignedInt(usedArr[i].ID);
            GV.onlineSocket.writeShort(usedArr[i].PosX);
            GV.onlineSocket.writeShort(usedArr[i].PosY);
            GV.onlineSocket.writeByte(usedArr[i].Direction);
            GV.onlineSocket.writeByte(usedArr[i].Visible);
            GV.onlineSocket.writeByte(usedArr[i].Layer);
            GV.onlineSocket.writeByte(usedArr[i].Type);
            GV.onlineSocket.writeUnsignedInt(usedArr[i].Other);
         }
         GV.onlineSocket.flush();
      }
      
      public static function saveHomeInfo(usedArr:Array, nousedArr:Array) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.SAVE_HOME_INFO);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(usedArr.length);
         GV.onlineSocket.writeUnsignedInt(nousedArr.length);
         for(var j:int = 0; j < nousedArr.length; j++)
         {
            GV.onlineSocket.writeUnsignedInt(nousedArr[j].ID);
            GV.onlineSocket.writeUnsignedInt(nousedArr[j].Count);
         }
         var has:Boolean = false;
         for(var i:uint = 0; i < usedArr.length; i++)
         {
            GV.onlineSocket.writeUnsignedInt(usedArr[i].ID);
            GV.onlineSocket.writeShort(usedArr[i].PosX);
            GV.onlineSocket.writeShort(usedArr[i].PosY);
            GV.onlineSocket.writeByte(usedArr[i].Direction);
            GV.onlineSocket.writeByte(usedArr[i].Visible);
            GV.onlineSocket.writeByte(usedArr[i].Layer);
            GV.onlineSocket.writeByte(usedArr[i].Type);
            GV.onlineSocket.writeUnsignedInt(usedArr[i].Other);
            if(usedArr[i].ID == 1220008 || usedArr[i].ID == 1220369 || usedArr[i].ID == 1220367 || usedArr[i].ID == 1220368)
            {
               has = true;
            }
         }
         GV.onlineSocket.flush();
         if(has)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("prop_1220008"));
         }
      }
      
      public static function isUserExist(id:uint) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.USER_EXIST);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(id);
         GV.onlineSocket.flush();
      }
      
      public static function FriendBoxList() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GET_GOOODS_INBOX_LIST);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
      
      public static function HomeGuest(id:uint) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.HOME_GUEST);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(id);
         GV.onlineSocket.flush();
      }
      
      public static function UserFlag(id:uint) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.USER_FLAG);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(id);
         GV.onlineSocket.flush();
      }
      
      public static function getgoodsinbox(Userid:uint, Itemid:uint) : void
      {
         MsgHead.PkgLen = 25;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GET_GOOODS_INBOX);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(Userid);
         GV.onlineSocket.writeUnsignedInt(Itemid);
         GV.onlineSocket.flush();
      }
      
      public static function getFriendHot(arr:Array) : void
      {
         var len:uint = arr.length;
         MsgHead.PkgLen = 21 + len * 4;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GET_FRIENDS_HOT);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(len);
         for(var i:uint = 0; i < len; i++)
         {
            GV.onlineSocket.writeUnsignedInt(arr[i].friend);
         }
         GV.onlineSocket.flush();
      }
   }
}

