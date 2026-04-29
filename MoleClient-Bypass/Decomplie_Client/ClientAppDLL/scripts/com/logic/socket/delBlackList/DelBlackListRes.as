package com.logic.socket.delBlackList
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class DelBlackListRes extends EventDispatcher
   {
      
      public static var DEL_BLACK_LIST:String = "del_black_list";
      
      public static var DEL_BLACK_LIST_FAIL:String = "del_black_list_fail";
      
      public function DelBlackListRes()
      {
         super();
      }
      
      public function delBlackList() : void
      {
         var delBlackListObj:Object = new Object();
         delBlackListObj.friend = "刪除黑名單成功！";
         GV.onlineSocket.dispatchEvent(new EventTaomee(DEL_BLACK_LIST,delBlackListObj));
      }
      
      public function delBlackListfail() : void
      {
         var delBlackListObj:Object = new Object();
         delBlackListObj.friend = "刪除黑名單失敗！";
         GV.onlineSocket.dispatchEvent(new EventTaomee(DEL_BLACK_LIST_FAIL,delBlackListObj));
      }
   }
}

