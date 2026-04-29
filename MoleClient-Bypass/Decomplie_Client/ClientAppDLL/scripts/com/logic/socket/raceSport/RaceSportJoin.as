package com.logic.socket.raceSport
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class RaceSportJoin
   {
      
      public function RaceSportJoin()
      {
         super();
      }
      
      public static function joinSport() : void
      {
         MsgHead.Command = 1551;
         GF.writeHead();
      }
      
      public static function res_joinSport() : void
      {
         var obj:Object = new Object();
         obj.Team = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1551,obj));
      }
      
      public static function addRaceScore(track:uint, score:uint, timeNum:uint) : void
      {
         MsgHead.Command = 1552;
         var byteArr:ByteArray = new ByteArray();
         byteArr.writeUnsignedInt(track);
         byteArr.writeUnsignedInt(score);
         byteArr.writeUnsignedInt(timeNum);
         GF.writeHead(byteArr);
      }
      
      public static function res_addRaceScore() : void
      {
         var obj:Object = new Object();
         obj.Flag = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1552,obj));
      }
      
      public static function getOwnScore() : void
      {
         MsgHead.Command = 1553;
         GF.writeHead();
      }
      
      public static function res_getOwnScore() : void
      {
         var obj:Object = new Object();
         obj.Score = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1553,obj));
      }
      
      public static function updateTrackTime(team:uint, track:uint, time:uint) : void
      {
         MsgHead.Command = 1554;
         var byteArr:ByteArray = new ByteArray();
         byteArr.writeUnsignedInt(team);
         byteArr.writeUnsignedInt(track);
         byteArr.writeUnsignedInt(time);
         GF.writeHead(byteArr);
      }
      
      public static function res_updateTrackTime() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1554));
      }
      
      public static function getTrackTime() : void
      {
         MsgHead.Command = 1555;
         GF.writeHead();
      }
      
      public static function res_getTrackTime() : void
      {
         var i:int = 0;
         var teamObj:Object = null;
         var obj:Object = new Object();
         obj.Count = GV.onlineSocket.readUnsignedInt();
         obj.TeamArray = new Array();
         if(obj.Count > 0)
         {
            for(i = 0; i < obj.Count; i++)
            {
               teamObj = new Object();
               teamObj.Team = GV.onlineSocket.readUnsignedInt();
               teamObj.TrackTime1 = GV.onlineSocket.readUnsignedInt();
               teamObj.TrackTime2 = GV.onlineSocket.readUnsignedInt();
               teamObj.TrackTime3 = GV.onlineSocket.readUnsignedInt();
               teamObj.TrackTime4 = GV.onlineSocket.readUnsignedInt();
               obj.TeamArray.push(teamObj);
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1555,obj));
      }
      
      public static function getTeamsScore() : void
      {
         MsgHead.Command = 1556;
         GF.writeHead();
      }
      
      public static function res_getTeamsScore() : void
      {
         var i:int = 0;
         var teamObj:Object = null;
         var obj:Object = new Object();
         obj.Count = GV.onlineSocket.readUnsignedInt();
         obj.TeamArray = new Array();
         if(obj.Count > 0)
         {
            for(i = 0; i < obj.Count; i++)
            {
               teamObj = new Object();
               teamObj.Team = GV.onlineSocket.readUnsignedInt();
               teamObj.Score = GV.onlineSocket.readUnsignedInt();
               teamObj.DayScore = GV.onlineSocket.readUnsignedInt();
               obj.TeamArray.push(teamObj);
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1556,obj));
      }
      
      public static function addPopular(team:uint) : void
      {
         MsgHead.Command = 1557;
         var byteArr:ByteArray = new ByteArray();
         byteArr.writeUnsignedInt(team);
         GF.writeHead(byteArr);
      }
      
      public static function res_addPopular() : void
      {
         var Flag:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1557,{"flag":Flag}));
      }
      
      public static function popularStart() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1560));
      }
      
      public static function popularResult() : void
      {
         var obj:Object = new Object();
         obj.team1 = GV.onlineSocket.readUnsignedInt();
         obj.team2 = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1561,obj));
      }
      
      public static function isAddPopular() : void
      {
         MsgHead.Command = 1562;
         GF.writeHead();
      }
      
      public static function res_isAddPopular() : void
      {
         var obj:Object = new Object();
         obj.flag = GV.onlineSocket.readUnsignedInt();
         obj.Time = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1562,obj));
      }
      
      public static function getTrackNum() : void
      {
         MsgHead.Command = 1558;
         GF.writeHead();
      }
      
      public static function res_getTrackNum() : void
      {
         var obj:Object = new Object();
         obj.Track1Num = GV.onlineSocket.readUnsignedInt();
         obj.Track2Num = GV.onlineSocket.readUnsignedInt();
         obj.Track3Num = GV.onlineSocket.readUnsignedInt();
         obj.Track4Num = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1558,obj));
      }
      
      public static function getDayScore() : void
      {
         MsgHead.Command = 1559;
         GF.writeHead();
      }
      
      public static function res_getDayScore() : void
      {
         var obj:Object = new Object();
         obj.DayScore = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1559,obj));
      }
      
      public static function getDriveCard() : void
      {
         MsgHead.Command = 1699;
         GF.writeHead();
      }
      
      public static function res_getDriveCard() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1699));
      }
      
      public static function getCarItem(itemID:uint) : void
      {
         MsgHead.Command = 1568;
         var byteArr:ByteArray = new ByteArray();
         byteArr.writeUnsignedInt(itemID);
         GF.writeHead(byteArr);
      }
      
      public static function res_getCarItem() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1568));
      }
      
      public static function getIntegralItem() : void
      {
         MsgHead.Command = 1563;
         GF.writeHead();
      }
      
      public static function res_getIntegralItem() : void
      {
         var obj:Object = new Object();
         obj.Itemid = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1563,obj));
      }
      
      public static function IntegralOutcome() : void
      {
         var obj:Object = new Object();
         obj.flag = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1572,obj));
      }
      
      public static function isHaveCar(id:uint) : void
      {
         MsgHead.Command = 1707;
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17 + 4;
         MsgHead.UserID = LocalUserInfo.getUserID();
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Command);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(id);
         GV.onlineSocket.flush();
      }
      
      public static function res_isHaveCar() : void
      {
         var obj:Object = new Object();
         obj.Count = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1707,obj));
      }
   }
}

