package com.logic.socket.getRoomInfo
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class GetRoomListReq extends BaseOnlineSocketRequest
   {
      
      public static const GET_VIP_HOME_LIST:String = "getVipHomeList";
      
      public function GetRoomListReq()
      {
         super();
      }
      
      public static function sandFun() : void
      {
         MsgHead.PkgLen = 17;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GET_ROOM_LIST);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
      
      public static function requestVipHomeList() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         initAction(CommandID.GET_ROOM_LIST);
         flush();
      }
      
      public static function getVipFun() : void
      {
         var userID:int = 0;
         var userNAME:String = null;
         var isVip:int = 0;
         var userNUM:int = 0;
         var obj:Object = null;
         var pp:uint = 0;
         var vip_array:Array = [];
         var myArr:Array = new Array();
         var lastArr:Array = new Array();
         var lg:int = int(GV.onlineSocket.readUnsignedInt());
         for(var i:uint = 0; i < lg; i++)
         {
            userID = int(GV.onlineSocket.readUnsignedInt());
            userNAME = GV.onlineSocket.readUTFBytes(16);
            isVip = int(GV.onlineSocket.readUnsignedInt());
            userNUM = int(GV.onlineSocket.readUnsignedInt());
            obj = {
               "id":userID,
               "name":userNAME,
               "vip":isVip,
               "num":userNUM
            };
            myArr.push(obj);
            if(isVip == 1)
            {
               vip_array.push(obj);
            }
         }
         var no_arr:Array = new Array();
         var yes_arr:Array = new Array();
         var have_arr:Array = new Array();
         for(var p:uint = 0; p < myArr.length; p++)
         {
            if(myArr[p].num == 0)
            {
               no_arr.push(myArr[p]);
            }
            else if(have_arr.indexOf(myArr[p].num) == -1)
            {
               have_arr.push(myArr[p].num);
            }
         }
         have_arr.sort(Array.NUMERIC);
         for(var ip:uint = 0; ip < have_arr.length; ip++)
         {
            for(pp = 0; pp < myArr.length; pp++)
            {
               if(myArr[pp].num == have_arr[ip])
               {
                  yes_arr.push(myArr[pp]);
               }
            }
         }
         yes_arr.reverse();
         lastArr = yes_arr.concat(no_arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_VIP_HOME_LIST,{
            "arr":lastArr,
            "vipArray":vip_array
         }));
      }
   }
}

