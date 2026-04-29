package com.module.friendList.friendView
{
   import com.common.Alert.Alert;
   import com.common.scrollBar.ScrollBar;
   import com.core.MainManager;
   import com.core.manager.AssetsManage;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.huluGroup.breakMyGroup;
   import com.logic.socket.huluGroup.getGroupBaseInfo;
   import com.logic.socket.huluGroup.getGroupList;
   import com.logic.socket.huluGroup.outGroup;
   import com.logic.socket.modUserInfo.ModUserInfoRes;
   import com.module.hulupuModule.InitGroupBoxView;
   import com.module.hulupuModule.SelectFriendsBoxView;
   import com.module.hulupuModule.createGroupView;
   import com.module.hulupuModule.seachGroupView;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   
   public class GView extends MovieClip
   {
      
      public static var dispatchEvent:Function;
      
      public static var addEventListener:Function;
      
      public static var removeEventListener:Function;
      
      private static var RootMC:MovieClip;
      
      private static var arrMC:Array;
      
      private static var mySo:SharedObject;
      
      public static var groupList:Array;
      
      private static var updateNum:Number;
      
      private static var MC:MovieClip;
      
      private static var myScrollBar:ScrollBar;
      
      private static var Man:Class;
      
      private static var len:uint;
      
      private static var blackNum:uint;
      
      private static var delBlackID:int;
      
      private static var delBlackAlert:*;
      
      public static var lib:AssetsManage = new AssetsManage(true);
      
      public static var friendsInfo:Object = {};
      
      public static var gourpItemMC:Object = {};
      
      public static var groupInfoObj:Object = {};
      
      public static var screenFlagObj:Object = {};
      
      public static var myObj:Object = {
         0:0,
         1:1,
         2:2,
         3:3,
         4:4,
         5:5,
         6:6,
         7:7,
         8:8,
         9:9,
         "a":10,
         "b":11,
         "c":12,
         "d":13,
         "e":14,
         "f":15
      };
      
      public function GView()
      {
         super();
      }
      
      public static function init(mc:MovieClip, man:Class) : void
      {
         var ed:EventDispatcher = new EventDispatcher();
         dispatchEvent = ed.dispatchEvent;
         addEventListener = ed.addEventListener;
         removeEventListener = ed.removeEventListener;
         Man = UIManager.getClass("Group_bord_mc");
         MC = mc;
         MC.manMC.y = 64;
         BC.addEvent(GView,MC.seach_mc,MouseEvent.CLICK,seachGroupFun);
         BC.addEvent(GView,MC.create_mc,MouseEvent.CLICK,createGroupFun);
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + ModUserInfoRes.MOD_USER_INFO,modUserInfoFun);
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_GETGROUPBASEINFO,getGroupBaseInfoFun);
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_BREAKMYGROUP,breakMyGroupOK);
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_OUTGROUP,outGroupOK);
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_INVITEFRIEND_TO_MYGROUP,inviteFriendSure);
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_MODMYGROUPINFO,modMyGroup);
         myScrollBar = new ScrollBar(null,MC.manMC,{
            "length":32 * 7 + 6,
            "x":210,
            "y":MC.manMC.y
         },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_VERTICAL,36);
         mySo = SharedObject.getLocal("hulupuGroupList");
         refresh();
      }
      
      public static function uninit() : void
      {
         arrMC = null;
         if(Boolean(myScrollBar))
         {
            myScrollBar.clearClass();
         }
         myScrollBar = null;
         BC.removeEvent(GView);
      }
      
      public static function unDataForGroup() : void
      {
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_GETGROUPLIST,updataGroupList);
         new getGroupList().doAction();
      }
      
      private static function updataGroupList(E:EventTaomee) : void
      {
         var groupListObj:Object = E.EventObj;
         var Count:int = int(groupListObj.Count);
         groupList = groupListObj.groupList;
         for(var i:uint = 0; i < Count; i++)
         {
            screenFlagObj[groupList[i]] = groupListObj.flagList[i];
         }
         BC.removeEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_GETGROUPLIST,updataGroupList);
      }
      
      public static function getLib() : void
      {
         GView.lib.IncludeLib("hulupu_Lib","module/hulupuGroup/hulupuGroup.swf","正在加載咕嚕噗...");
         BC.addEvent(GView,GView.lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
      }
      
      private static function loadLibcomplete(E:Event) : void
      {
         BC.removeEvent(GView,GView.lib,AssetsManage.ON_COMPLETE,loadLibcomplete);
      }
      
      public static function seachGroupFun(E:MouseEvent) : void
      {
         var tempClass:seachGroupView = seachGroupView.getInstance();
         if(!seachGroupView.inStage())
         {
            MainManager.getAppLevel().addChild(tempClass.targetMC);
         }
      }
      
      public static function createGroupFun(E:MouseEvent) : void
      {
         var tempClass:createGroupView = createGroupView.getInstance();
         BC.addEvent(GView,tempClass,Event.COMPLETE,createCroupSuccess);
      }
      
      private static function createCroupSuccess(E:Event) : void
      {
         BC.removeEvent(GView,null,Event.COMPLETE,createCroupSuccess);
         trace("groupID",E.target.groupID);
         var groupID:String = E.target.groupID;
         var groupName:String = E.target.groupName;
         mySo.data[groupID] = {
            "name":groupName,
            "num":1,
            "Ownerid":GV.MyInfo_userID
         };
         try
         {
            mySo.flush();
         }
         catch(e:Error)
         {
         }
         refresh();
         SelectFriendsBoxView.getInstance().getView(uint(groupID));
      }
      
      public static function refresh() : void
      {
         if(!MC)
         {
            return;
         }
         arrMC = new Array();
         groupList = new Array();
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_GETGROUPLIST,getGroupListHandel);
         MC.manMC.y = 64;
         MC.loading.visible = true;
         MC.loading.gotoAndPlay(2);
         new getGroupList().doAction();
      }
      
      public static function getGroupListHandel(E:EventTaomee = null) : void
      {
         if(!MC)
         {
            return;
         }
         while(Boolean(MC.manMC.numChildren))
         {
            MC.manMC.removeChildAt(0);
         }
         arrMC = [];
         var groupListObj:Object = E.EventObj;
         var Count:int = int(groupListObj.Count);
         Count = Count < 7 ? 7 : Count;
         groupList = groupListObj.groupList;
         for(var i:uint = 0; i < Count; i++)
         {
            if(i < groupList.length)
            {
               screenFlagObj[groupList[i]] = groupListObj.flagList[i];
               addGroupItem(groupList[i],i);
            }
            else
            {
               addEnptyGroupItem(0,i);
            }
         }
         changeScrollBar();
         MC.loading.visible = false;
         MC.loading.gotoAndStop(1);
      }
      
      public static function getGroupBaseInfoFun(E:EventTaomee) : void
      {
         if(!MC)
         {
            return;
         }
         var tempObj:Object = E.EventObj;
         GView.groupInfoObj[tempObj.Groupid] = tempObj;
         mySo.data[tempObj.Groupid] = {
            "name":tempObj.GroupName,
            "num":1,
            "Ownerid":tempObj.Ownerid
         };
         try
         {
            mySo.flush();
         }
         catch(e:Error)
         {
         }
         setGroupName(E.EventObj);
      }
      
      public static function modUserInfoFun(E:EventTaomee) : void
      {
         GView.friendsInfo[E.EventObj.UserID] = E.EventObj;
      }
      
      public static function addGroupItem(groupID:int, i:uint) : void
      {
         var groupInfo:Object = null;
         if(!MC)
         {
            return;
         }
         var groupName:String = "";
         var item:MovieClip = new Man();
         item.groupID = groupID;
         BC.addEvent(GView,item.hit_btn,MouseEvent.MOUSE_OVER,goto2);
         BC.addEvent(GView,item.hit_btn,MouseEvent.MOUSE_OUT,goto1);
         gourpItemMC[String(groupID)] = item;
         if(Boolean(mySo.data[groupID]) && Boolean(mySo.data[groupID].name) && Boolean(mySo.data[groupID].Ownerid))
         {
            groupName = mySo.data[groupID].name;
            groupInfo = {};
            groupInfo.Groupid = groupID;
            groupInfo.Ownerid = mySo.data[groupID].Ownerid;
            groupInfo.GroupName = groupName;
            setGroupName(groupInfo);
         }
         else
         {
            new getGroupBaseInfo().doAction(groupID);
         }
         item.y = 32 * i;
         item.group_txt.text = groupName + "(" + groupID + ")";
         arrMC.push(item);
         MC.manMC.addChild(item);
      }
      
      public static function addEnptyGroupItem(groupID:int, i:uint) : void
      {
         if(!MC)
         {
            return;
         }
         var groupName:String = "";
         var item:MovieClip = new Man();
         item.y = 32 * i;
         item.ico_mc.visible = false;
         item.delete_out_mc.visible = false;
         MC.manMC.addChild(item);
      }
      
      public static function setGroupName(Obj:Object) : void
      {
         if(!MC)
         {
            return;
         }
         if(!Obj)
         {
            return;
         }
         var item:MovieClip = gourpItemMC[String(Obj.Groupid)];
         if(Boolean(item))
         {
            if(Obj.Ownerid != GV.MyInfo_userID)
            {
               item.ico_mc.gotoAndStop(2);
               item.delete_out_mc.gotoAndStop(2);
               BC.addEvent(GView,item.delete_out_mc,MouseEvent.CLICK,outGroupFun);
            }
            else
            {
               BC.addEvent(GView,item.delete_out_mc,MouseEvent.CLICK,breakMyGroupFun);
            }
            BC.addEvent(GView,item.hit_btn,MouseEvent.CLICK,getGroupBoxHandel);
         }
      }
      
      private static function getGroupBoxHandel(E:MouseEvent) : void
      {
         var groupID:uint = uint(E.currentTarget.parent.groupID);
         getGroup(groupID);
      }
      
      public static function getGroup(groupID:uint) : void
      {
         var tempClass:InitGroupBoxView = InitGroupBoxView.getInstance();
         tempClass.getView(groupID);
      }
      
      private static function outGroupFun(E:MouseEvent) : void
      {
         var groupID:uint = 0;
         var outAlert:* = undefined;
         var groupItem:MovieClip = E.currentTarget.parent as MovieClip;
         groupID = uint(groupItem.groupID);
         var Content:String = "　　你確定要退出" + groupItem.group_txt.text + "咕嚕噗麼？退出以後就看不到這個咕嚕噗了哦！";
         outAlert = Alert.showAlert(MainManager.getAppLevel(),Content,"",Alert.CHANG_ALERT,"sure,cancel",true,false,"D");
         BC.addEvent(GView,outAlert,"CLICK" + 1,function(E:Event):void
         {
            new outGroup().doAction(groupID);
            BC.removeEvent(GView,outAlert);
         });
         BC.addEvent(GView,outAlert,"CLICK" + 2,function(E:Event):void
         {
            BC.removeEvent(GView,outAlert);
         });
      }
      
      private static function outGroupOK(E:EventTaomee) : void
      {
         GView.groupInfoObj[E.EventObj.Groupid] = null;
         refresh();
      }
      
      private static function inviteFriendSure(E:EventTaomee) : void
      {
         var addUserObj:Object = E.EventObj;
         if(!groupInfoObj[addUserObj.Groupid])
         {
            refresh();
         }
      }
      
      private static function modMyGroup(E:EventTaomee) : void
      {
         GC.setGTimeout(refresh,1000);
      }
      
      private static function breakMyGroupFun(E:MouseEvent) : void
      {
         var groupID:uint = 0;
         var outAlert:* = undefined;
         var groupItem:MovieClip = E.currentTarget.parent as MovieClip;
         groupID = uint(groupItem.groupID);
         var Content:String = "　　你確定要解散" + groupItem.group_txt.text + "咕嚕噗麼？解散以後這個咕嚕噗就沒有了哦！";
         outAlert = Alert.showAlert(MainManager.getAppLevel(),Content,"",Alert.CHANG_ALERT,"sure,cancel",true,false,"D");
         BC.addEvent(GView,outAlert,"CLICK" + 1,function(E:Event):void
         {
            new breakMyGroup().doAction(groupID);
            BC.removeEvent(GView,outAlert);
         });
         BC.addEvent(GView,outAlert,"CLICK" + 2,function(E:Event):void
         {
            BC.removeEvent(GView,outAlert);
         });
      }
      
      private static function breakMyGroupOK(E:EventTaomee) : void
      {
         var groupView:MovieClip = MainManager.getAppLevel().getChildByName("group_" + E.EventObj) as MovieClip;
         if(Boolean(groupView))
         {
            groupView.parent.removeChild(groupView);
         }
         refresh();
      }
      
      private static function changeScrollBar() : void
      {
         try
         {
            myScrollBar.doChange();
         }
         catch(E:*)
         {
         }
      }
      
      private static function goto1(evt:MouseEvent) : void
      {
         evt.currentTarget.parent.bg_mc.gotoAndStop(1);
      }
      
      private static function goto2(evt:MouseEvent) : void
      {
         evt.currentTarget.parent.bg_mc.gotoAndStop(2);
      }
   }
}

