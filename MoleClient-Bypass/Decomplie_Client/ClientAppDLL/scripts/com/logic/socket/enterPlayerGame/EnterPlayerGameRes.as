package com.logic.socket.enterPlayerGame
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class EnterPlayerGameRes extends EventDispatcher
   {
      
      public static var ENTER_GAME_SUCCESS:String = "enter_game_sucess";
      
      public function EnterPlayerGameRes()
      {
         super();
      }
      
      public function enterPlayerGame() : void
      {
         var enterGameUserObj:Object = null;
         var enterGameObj:Object = new Object();
         var enterGameArr:Array = new Array();
         enterGameObj.GameID = GV.GameSocket.readUnsignedInt();
         enterGameObj.GroupID = GV.GameSocket.readUnsignedInt();
         enterGameObj.Count = GV.GameSocket.readUnsignedInt();
         for(var i:int = 0; i < enterGameObj.Count; i++)
         {
            enterGameUserObj = new Object();
            enterGameUserObj.UserID = GV.GameSocket.readUnsignedInt();
            enterGameUserObj.UserName = enterGameUserObj.UserID;
            enterGameUserObj.IsSelf = 0;
            if(enterGameUserObj.UserID == LocalUserInfo.getUserID())
            {
               enterGameUserObj.IsSelf = 1;
            }
            enterGameArr.push(enterGameUserObj);
         }
         enterGameObj.enter = "加入遊戲成功";
         GV.GameSocket.dispatchEvent(new EventTaomee(ENTER_GAME_SUCCESS,{
            "gameInfo":enterGameObj,
            "usersArray":enterGameArr
         }));
      }
   }
}

