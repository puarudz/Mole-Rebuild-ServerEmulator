package com.logic.socket.addBlackList
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class AddBlackListRes extends EventDispatcher
   {
      
      public static var ADD_BLACK_LIST:String = "add_black_list";
      
      public static var ADD_BLACK_LIST_FAIL:String = "add_black_list_fail";
      
      public function AddBlackListRes()
      {
         super();
      }
      
      public function addBlackList() : void
      {
         var addBlackListObj:Object = new Object();
         addBlackListObj.friend = "加入黑名單成功！";
         GV.onlineSocket.dispatchEvent(new EventTaomee(ADD_BLACK_LIST,addBlackListObj));
      }
      
      public function addBlcakListFail() : void
      {
         var addBlackListObj:Object = new Object();
         addBlackListObj.friend = "加入黑名單失敗！";
         GV.onlineSocket.dispatchEvent(new EventTaomee(ADD_BLACK_LIST_FAIL,addBlackListObj));
      }
      
      public function beAddBlackList() : void
      {
         var addBlackListObj:Object = new Object();
         addBlackListObj.userID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 10015,addBlackListObj));
      }
   }
}

