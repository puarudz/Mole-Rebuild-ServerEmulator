package com.logic.socket.getBlackList
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class GetBlackListRes extends EventDispatcher
   {
      
      public static var GET_BLACKLIST:String = "get_blacklist";
      
      public function GetBlackListRes()
      {
         super();
      }
      
      public function getBlackList() : void
      {
         var getBlackObj:Object = null;
         var getBlackListObj:Object = new Object();
         var getBlackListArr:Array = new Array();
         getBlackListObj.Count = GV.onlineSocket.readUnsignedInt();
         for(var i:int = 0; i < getBlackListObj.Count; i++)
         {
            getBlackObj = new Object();
            getBlackObj.UserID = GV.onlineSocket.readUnsignedInt();
            getBlackListArr.push(getBlackObj);
         }
         getBlackListObj.countArr = getBlackListArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BLACKLIST,getBlackListObj));
      }
   }
}

