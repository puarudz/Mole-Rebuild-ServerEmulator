package com.logic.socket.getSceneUserInfo
{
   import com.common.data.HashMap;
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class GetSceneUserInfoReq
   {
      
      private static var _friends:HashMap = new HashMap();
      
      private static var _needLoadFriendList:Array = new Array();
      
      private static var _isLoadingFriendInfo:Boolean = false;
      
      public function GetSceneUserInfoReq()
      {
         super();
      }
      
      public static function GetFriendInfo(id:int, callBackFun:Function, getNew:Boolean = false) : void
      {
         if(getNew)
         {
            _friends.remove(id);
         }
         if(_friends.containsKey(id))
         {
            if(callBackFun != null)
            {
               try
               {
                  callBackFun(_friends.getValue(id));
               }
               catch(error:Error)
               {
               }
            }
         }
         else
         {
            _needLoadFriendList.push({
               "id":id,
               "fun":callBackFun
            });
            if(_isLoadingFriendInfo == false)
            {
               LoadFriendInfo();
            }
         }
      }
      
      private static function LoadFriendInfo() : void
      {
         var data:Object = null;
         var id:int = 0;
         var callBackFun:Function = null;
         var getNew:Boolean = false;
         var userReq:GetSceneUserInfoReq = null;
         if(_needLoadFriendList.length > 0)
         {
            _isLoadingFriendInfo = true;
            data = _needLoadFriendList[0];
            id = int(data.id);
            callBackFun = data.fun;
            getNew = Boolean(data.getNew);
            if(_friends.containsKey(id))
            {
               if(callBackFun != null)
               {
                  try
                  {
                     callBackFun(_friends.getValue(id));
                  }
                  catch(error:Error)
                  {
                  }
               }
               _needLoadFriendList.shift();
               LoadFriendInfo();
            }
            else
            {
               BC.addEvent(_friends,GV.onlineSocket,GetSceneUserRes.GET_SCENE_INFO,onReadUserInfo);
               userReq = new GetSceneUserInfoReq();
               userReq.getSeceeUserInfo(id);
            }
         }
         else
         {
            _isLoadingFriendInfo = false;
         }
      }
      
      private static function onReadUserInfo(e:EventTaomee) : void
      {
         var userInfo:Object = e.EventObj;
         var data:Object = _needLoadFriendList[0];
         var id:int = int(data.id);
         var callBackFun:Function = data.fun;
         if(userInfo.UserID == id)
         {
            BC.removeEvent(_friends,GV.onlineSocket,GetSceneUserRes.GET_SCENE_INFO,onReadUserInfo);
            _friends.add(id,e.EventObj);
            LoadFriendInfo();
         }
      }
      
      public function getSeceeUserInfo(UserID:int) : void
      {
         if(UserID == 0)
         {
            return;
         }
         MsgHead.PkgLen = 21;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.reachDetailPro);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.flush();
      }
   }
}

