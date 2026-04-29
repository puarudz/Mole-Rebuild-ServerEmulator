package com.module.hulupuModule
{
   import com.core.MainManager;
   import com.core.manager.AssetsManage;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.huluGroup.getGroupBaseInfo;
   import com.module.friendList.friendView.GView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class SelectFriendsBoxView extends EventDispatcher
   {
      
      private static var owner:SelectFriendsBoxView;
      
      private var groupInfo:Object;
      
      private var groupID:uint;
      
      public function SelectFriendsBoxView()
      {
         super();
      }
      
      public static function getInstance() : SelectFriendsBoxView
      {
         if(!owner)
         {
            owner = new SelectFriendsBoxView();
         }
         return owner;
      }
      
      public function getView(_groupID:uint) : void
      {
         this.groupID = _groupID;
         this.groupInfo = null;
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_GETGROUPBASEINFO,this.getGroupBaseInfoFun);
         new getGroupBaseInfo().doAction(this.groupID);
      }
      
      private function loadLibcomplete(E:Event) : void
      {
         BC.removeEvent(this,GView.lib,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
         this.checkOpenGroupBox();
      }
      
      private function getGroupBaseInfoFun(E:EventTaomee) : void
      {
         BC.removeEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_GETGROUPBASEINFO,this.getGroupBaseInfoFun);
         var tempObj:Object = E.EventObj;
         GView.groupInfoObj[tempObj.Groupid] = tempObj;
         this.groupInfo = tempObj;
         this.checkOpenGroupBox();
      }
      
      private function checkOpenGroupBox() : void
      {
         var serverFriendsList:Array = null;
         var friendArray:Array = null;
         var i:uint = 0;
         var groupUserArray:Array = null;
         var tempClass:Class = null;
         var tempSelectFriendsBox:* = undefined;
         if(Boolean(this.groupInfo) && Boolean(GView.lib.getLoader()))
         {
            serverFriendsList = MainManager.getGlobalObject().data.ServerFriendsList;
            friendArray = new Array();
            for(i = 0; i < serverFriendsList.length; i++)
            {
               friendArray.push(serverFriendsList[i].friend);
            }
            groupUserArray = this.groupInfo.UserArray;
            tempClass = GView.lib.getClass("SelectFriendsBox");
            tempSelectFriendsBox = new tempClass();
            tempSelectFriendsBox.init(MainManager.getAppLevel(),this.groupID,friendArray,groupUserArray);
         }
      }
   }
}

