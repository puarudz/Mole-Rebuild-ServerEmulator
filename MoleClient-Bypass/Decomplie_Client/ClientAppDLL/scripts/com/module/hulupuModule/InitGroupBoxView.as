package com.module.hulupuModule
{
   import com.core.MainManager;
   import com.core.manager.AssetsManage;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.huluGroup.getGroupBaseInfo;
   import com.module.friendList.friendView.GView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class InitGroupBoxView extends EventDispatcher
   {
      
      private static var owner:InitGroupBoxView;
      
      private var groupInfo:Object;
      
      public function InitGroupBoxView()
      {
         super();
      }
      
      public static function getInstance() : InitGroupBoxView
      {
         if(!owner)
         {
            owner = new InitGroupBoxView();
         }
         return owner;
      }
      
      public function getView(groupID:uint) : void
      {
         trace("groupID",groupID);
         var groupView:MovieClip = MainManager.getAppLevel().getChildByName("group_" + groupID) as MovieClip;
         if(!groupView)
         {
            this.groupInfo = null;
            BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_GETGROUPBASEINFO,this.getGroupBaseInfoFun);
            new getGroupBaseInfo().doAction(groupID);
            if(!GView.lib.getLoader())
            {
               BC.addEvent(this,GView.lib,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
               GView.getLib();
            }
         }
         else
         {
            groupView.parent.setChildIndex(groupView,groupView.parent.numChildren - 1);
         }
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
         var tempClass:Class = null;
         var tempSelectFriendsBox:* = undefined;
         if(Boolean(this.groupInfo) && Boolean(GView.lib.getLoader()))
         {
            tempClass = GView.lib.getClass("GroupTalkBox");
            tempSelectFriendsBox = new tempClass();
            tempSelectFriendsBox.init(MainManager.getAppLevel(),this.groupInfo);
         }
      }
   }
}

