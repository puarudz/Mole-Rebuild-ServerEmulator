package com.logic.socket.PKsocket
{
   import com.common.msgHead.MsgHead;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   
   public class GameKingSocket
   {
      
      public static const ANIMAL_UP_DATA:String = "Animal_UpData";
      
      public function GameKingSocket()
      {
         super();
      }
      
      public static function friendgamelist(gameid:uint, friendid:uint = 0) : void
      {
         var so:SharedObject = null;
         var serverFriendsList:Array = null;
         var i:uint = 0;
         MsgHead.Command = 1461;
         var tempByteArray:ByteArray = new ByteArray();
         if(friendid == 0)
         {
            tempByteArray.writeUnsignedInt(gameid);
            so = MainManager.getGlobalObject();
            serverFriendsList = so.data.ServerFriendsList;
            tempByteArray.writeUnsignedInt(serverFriendsList.length);
            for(i = 0; i < serverFriendsList.length; i++)
            {
               tempByteArray.writeUnsignedInt(serverFriendsList[i].friend);
            }
         }
         else
         {
            tempByteArray.writeUnsignedInt(gameid);
            tempByteArray.writeUnsignedInt(1);
            tempByteArray.writeUnsignedInt(friendid);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_friendgamelist() : void
      {
         var gameobj:Object = null;
         var obj:Object = new Object();
         obj.arr = new Array();
         obj.count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.count; i++)
         {
            gameobj = new Object();
            gameobj.UserID = GV.onlineSocket.readUnsignedInt();
            gameobj.GameScore = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(gameobj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1461,obj));
      }
      
      public static function usergamelist(uid:uint) : void
      {
         MsgHead.Command = 1462;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(uid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_usergamelist() : void
      {
         var gameobj:Object = null;
         var obj:Object = new Object();
         obj.arr = new Array();
         obj.count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.count; i++)
         {
            gameobj = new Object();
            gameobj.GameID = GV.onlineSocket.readUnsignedInt();
            gameobj.GameScore = GV.onlineSocket.readUnsignedInt();
            gameobj.GameFlag = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(gameobj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1462,obj));
      }
      
      public static function SubmitScorePK(pkuserid:uint, gameid:uint, score:uint) : void
      {
         MsgHead.Command = 1463;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(pkuserid);
         tempByteArray.writeUnsignedInt(gameid);
         tempByteArray.writeUnsignedInt(score);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_SubmitScorePK() : void
      {
         var gameobj:Object = new Object();
         gameobj.GameID = GV.onlineSocket.readUnsignedInt();
         gameobj.MyID = GV.onlineSocket.readUnsignedInt();
         gameobj.PKUserID = GV.onlineSocket.readUnsignedInt();
         gameobj.MyScore = GV.onlineSocket.readUnsignedInt();
         gameobj.PKUserScore = GV.onlineSocket.readUnsignedInt();
         gameobj.HLB = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1463,gameobj));
      }
      
      public static function HistoryPK() : void
      {
         MsgHead.Command = 1464;
         GF.writeHead();
      }
      
      public static function res_HistoryPK() : void
      {
         var gameobj:Object = null;
         var obj:Object = new Object();
         obj.arr = new Array();
         obj.count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.count; i++)
         {
            gameobj = new Object();
            gameobj.UserID = GV.onlineSocket.readUnsignedInt();
            gameobj.UserName = GV.onlineSocket.readUTFBytes(16);
            gameobj.GameID = GV.onlineSocket.readUnsignedInt();
            gameobj.GameTime = GV.onlineSocket.readUnsignedInt();
            gameobj.Hescore = GV.onlineSocket.readUnsignedInt();
            gameobj.Myscore = GV.onlineSocket.readUnsignedInt();
            gameobj.GameFlag = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(gameobj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1464,obj));
      }
      
      public static function UserWineRsult(userid:uint) : void
      {
         MsgHead.Command = 1465;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UserWineRsult() : void
      {
         var obj:Object = new Object();
         obj.win = GV.onlineSocket.readUnsignedInt();
         obj.lose = GV.onlineSocket.readUnsignedInt();
         obj.score = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1465,obj));
      }
   }
}

