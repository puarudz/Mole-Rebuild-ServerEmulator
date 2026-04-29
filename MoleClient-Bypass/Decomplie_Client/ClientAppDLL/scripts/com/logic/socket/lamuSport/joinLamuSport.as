package com.logic.socket.lamuSport
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class joinLamuSport
   {
      
      public static var GET_TEAM_INFO:String = "get_team_info";
      
      public static var GET_SEETEAM_INFO:String = "get_seeteam_info";
      
      public static var GET_ITEMID_INFO:String = "get_itemID_info";
      
      public static var GET_TEAM:String = "get_team";
      
      public static var GET_CONTION:String = "get_contion";
      
      public static var SEE_MEDALS_COUNT:String = "see_medals_count";
      
      public static var SEE_P_CONTION:String = "see_p_count";
      
      public function joinLamuSport()
      {
         super();
      }
      
      public static function GetJoinTeam() : void
      {
         MsgHead.Command = 1151;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetJoinTeam() : void
      {
         var obj:Object = new Object();
         obj.team = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_TEAM_INFO,obj));
      }
      
      public static function seeTeam() : void
      {
         MsgHead.Command = 1152;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_seeTeam() : void
      {
         var obj:Object = new Object();
         obj.team = GV.onlineSocket.readUnsignedInt();
         obj.useMede = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_SEETEAM_INFO,obj));
      }
      
      public static function getJersey() : void
      {
         MsgHead.Command = 1153;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getJersey() : void
      {
         var obj:Object = new Object();
         obj.itemid = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_ITEMID_INFO,obj));
      }
      
      public static function getFireSport(teamID:int) : void
      {
         MsgHead.Command = 1240;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(teamID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getFireSport() : void
      {
         var obj:Object = new Object();
         obj.userID = GV.onlineSocket.readUnsignedInt();
         obj.itemid = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_TEAM,obj));
      }
      
      public static function getContingent() : void
      {
         MsgHead.Command = 1241;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getContingent() : void
      {
         var obj:Object = new Object();
         obj.itemid = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_CONTION,obj));
      }
      
      public static function seeMedalsNum() : void
      {
         MsgHead.Command = 1244;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_seeMedalsNum() : void
      {
         var obj:Object = null;
         var itemCountObj:Object = new Object();
         var output:IDataInput = GV.onlineSocket;
         var mScoreArray:Array = new Array();
         for(var i:int = 0; i < 4; i++)
         {
            obj = {};
            obj.team = output.readUnsignedInt();
            obj.count = output.readUnsignedInt();
            mScoreArray.push(obj);
         }
         itemCountObj.mScoreArray = mScoreArray;
         GV.onlineSocket.dispatchEvent(new EventTaomee(SEE_MEDALS_COUNT,itemCountObj));
      }
      
      public static function seePersonalMedals() : void
      {
         MsgHead.Command = 1245;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_seePersonalMedals() : void
      {
         var obj:Object = new Object();
         obj.team = GV.onlineSocket.readUnsignedInt();
         obj.count = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(SEE_P_CONTION,obj));
      }
   }
}

