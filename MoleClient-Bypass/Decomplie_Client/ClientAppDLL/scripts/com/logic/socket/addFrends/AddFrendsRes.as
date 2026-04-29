package com.logic.socket.addFrends
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class AddFrendsRes extends EventDispatcher
   {
      
      public static var ADD_FREND:String = "add_frend";
      
      public static var ADD_FRIEND_FAIL:String = "add_friend_fail";
      
      public function AddFrendsRes()
      {
         super();
      }
      
      public function addfrend() : void
      {
         var obj:Object = new Object();
         obj.msg = "加為好友成功";
         GV.onlineSocket.dispatchEvent(new EventTaomee(ADD_FREND,obj));
      }
      
      public function addfrendFail() : void
      {
         var obj:Object = new Object();
         obj.msg = "加為好友失敗";
         GV.onlineSocket.dispatchEvent(new EventTaomee(ADD_FRIEND_FAIL,obj));
      }
   }
}

