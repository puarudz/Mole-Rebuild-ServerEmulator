package com.logic.socket.delFrend
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class DelFrendRes extends EventDispatcher
   {
      
      public static var DELETE_FREND:String = "delete_frend";
      
      public static var DELETE_FAIL:String = "delete_fail";
      
      public function DelFrendRes()
      {
         super();
      }
      
      public function delFrends() : void
      {
         var obj:Object = new Object();
         obj.msg = "刪除好友成功";
         GV.onlineSocket.dispatchEvent(new EventTaomee(DELETE_FREND,obj));
      }
      
      public function delfriendFail() : void
      {
         var obj:Object = new Object();
         obj.msg = "刪除好友失敗";
         GV.onlineSocket.dispatchEvent(new EventTaomee(DELETE_FAIL,obj));
      }
   }
}

