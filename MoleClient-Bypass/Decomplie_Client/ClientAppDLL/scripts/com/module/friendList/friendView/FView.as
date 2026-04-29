package com.module.friendList.friendView
{
   import com.common.scrollBar.ScrollBar;
   import com.common.tip.tip;
   import com.common.util.PinYinUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.objectPool.ObjectPool;
   import com.event.EventTaomee;
   import com.logic.socket.delFrend.DelFrendRes;
   import com.logic.socket.getUserBasicInfo.GetUserBasicInfoRes;
   import com.logic.socket.lookOverFriendOnline.LookOverFriendOnlineReq;
   import com.logic.socket.lookOverFriendOnline.LookOverFriendOnlineRes;
   import com.module.friendList.friendLogic.friendLogic;
   import com.module.friendList.friendView.searchFriend.SearchFriendView;
   import com.module.myselfTalk.selfTalk;
   import com.mole.app.map.MapManager;
   import com.mole.net.MoleSharedObject;
   import com.view.userPanelView.userPanelView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.net.SharedObject;
   
   public class FView extends MovieClip
   {
      
      private static var ARRMC:Array;
      
      private static var FriendsStatusArr:Array;
      
      private static var HomeTimeObj:Object;
      
      private static var MC:MovieClip;
      
      private static var Man:Class;
      
      private static var RootMC:MovieClip;
      
      private static var myScrollBar:ScrollBar;
      
      private static var so:SharedObject;
      
      private static var tempIDArr:Array;
      
      private static var updateNum:Number;
      
      private static var whichList:*;
      
      public static var FriendStatusReq:LookOverFriendOnlineReq;
      
      public static var GTalk:selfTalk;
      
      public static var addEventListener:Function;
      
      public static var arrMC:Array;
      
      public static var dispatchEvent:Function;
      
      public static var friendsList:Array;
      
      public static var removeEventListener:Function;
      
      public static var serverFriendsList:Array;
      
      public static var userIDArray:Array;
      
      public static var _searchFriendView:SearchFriendView;
      
      private static const Base_ManMC_X:int = 75;
      
      private static var barBool:Boolean = false;
      
      private static var oneManNum:uint = 0;
      
      private static var vipNum:uint = 0;
      
      public static var closed:Boolean = false;
      
      public static var firstTime:Boolean = false;
      
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
      
      public static var userInfoObj:Object = {};
      
      public function FView()
      {
         super();
      }
      
      public static function HomeTime() : void
      {
         var i:uint = 0;
         var OneObj:Object = null;
         var soOneObj:Object = null;
         var mc:Object = null;
         var tmparr:Array = null;
         var homeTime:Object = so.data["HomeTime" + LocalUserInfo.getUserID()];
         if(Boolean(homeTime))
         {
            for(i = 0; i < HomeTimeObj.arr.length; i++)
            {
               OneObj = HomeTimeObj.arr[i];
               soOneObj = homeTime[OneObj.ID];
               if(Boolean(soOneObj))
               {
                  if(OneObj.Time > soOneObj.Time)
                  {
                     mc = MC.manMC.getChildByName("mc" + OneObj.ID);
                     if(Boolean(mc))
                     {
                        mc.home_btn.visible = true;
                        tip.tipTailDisPlayObject(mc.home_btn,"小屋家園更新");
                        BC.addEvent(FView,mc.home_btn,MouseEvent.CLICK,gotoHome);
                        mc.HomeUpdateTime = OneObj.Time;
                     }
                  }
               }
            }
         }
         else
         {
            tmparr = new Array();
            for(i = 0; i < HomeTimeObj.arr.length; i++)
            {
               tmparr[HomeTimeObj.arr[i].ID] = HomeTimeObj.arr[i];
            }
            so.data["HomeTime" + LocalUserInfo.getUserID()] = tmparr;
            MoleSharedObject.flush();
         }
      }
      
      public static function Only(arr:Array) : void
      {
         for(var i:uint = 0; i < arr.length - 1; i++)
         {
            if(arr[i].friend == arr[i + 1].friend)
            {
               arr.splice(i,1);
               Only(arr);
               break;
            }
         }
      }
      
      public static function addBG() : void
      {
         var temp:MovieClip = ObjectPool.getObject(Man);
         temp.home_btn.visible = false;
         temp.prev_pet.visible = true;
         temp.prev_mc.visible = true;
         temp.id = 1;
         temp.chat_btn.visible = false;
         temp.del_btn.visible = false;
         temp.userName.text = "";
         temp.prev_mc.visible = false;
         temp.prev_pet.visible = false;
         temp.sortnum = 8;
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      public static function addFriendFail(e:EventTaomee) : void
      {
      }
      
      public static function addFriendSuccess(e:EventTaomee) : void
      {
         uninit();
         refresh();
      }
      
      public static function arrange(arr:Array) : void
      {
         for(var k:uint = 0; k < arr.length; k++)
         {
            arr[k].y = 36 * k;
            arr[k].visible = true;
         }
      }
      
      public static function delFriendFail(e:EventTaomee) : void
      {
      }
      
      public static function delFriendSuccess(e:EventTaomee) : void
      {
         uninit();
         refresh();
      }
      
      public static function getFriendInfo(e:EventTaomee) : void
      {
         var i:uint = 0;
         try
         {
            GView.friendsInfo[e.EventObj.UserID] = e.EventObj;
         }
         catch(e:Error)
         {
         }
         so = MainManager.getGlobalObject();
         serverFriendsList = so.data.ServerFriendsList;
         if(Boolean(friendsList))
         {
            for(i = 0; i < friendsList.length; i++)
            {
               if(friendsList[i].UserID == e.EventObj.UserID)
               {
                  friendsList[i].Action = e.EventObj.Action;
                  friendsList[i].Color = e.EventObj.Color;
                  friendsList[i].Dining_flag = e.EventObj.Dining_flag;
                  friendsList[i].Dining_level = e.EventObj.Dining_level;
                  friendsList[i].MapID = e.EventObj.MapID;
                  friendsList[i].MapType = e.EventObj.MapType;
                  friendsList[i].Nick = e.EventObj.Nick;
                  friendsList[i].Status = e.EventObj.Status;
                  friendsList[i].UserID = e.EventObj.UserID;
                  friendsList[i].Vip = e.EventObj.Vip;
                  try
                  {
                     GView.friendsInfo[e.EventObj.UserID] = e.EventObj;
                  }
                  catch(e:Error)
                  {
                  }
                  try
                  {
                     friendsList[i].time = serverFriendsList[i].time;
                  }
                  catch(e:Error)
                  {
                     friendsList[i].time = -1;
                  }
               }
            }
         }
         so.data.FriendsList = friendsList;
         MoleSharedObject.flush();
         updateMan(e.EventObj);
         ++oneManNum;
         if(oneManNum < arrMC.length)
         {
            updateOneMan();
         }
         else
         {
            BC.removeEvent(FView,GV.onlineSocket,GetUserBasicInfoRes.GET_USER_BASIC_INFO,getFriendInfo);
         }
      }
      
      public static function getFriendStatus(e:EventTaomee) : void
      {
         BC.removeEvent(FView,GV.onlineSocket,LookOverFriendOnlineRes.LOOK_OVER_ONLINE_FRIEND,getFriendStatus);
         FriendsStatusArr = e.EventObj.severFriend;
         BC.addEvent(FView,GV.onlineSocket,LookOverFriendOnlineRes.LOOK_OVER_ONLINE_HOME,getHomeStatus);
         FriendStatusReq.lookOverFriendHome(tempIDArr);
      }
      
      public static function getHomeStatus(e:EventTaomee) : void
      {
         BC.removeEvent(FView,GV.onlineSocket,LookOverFriendOnlineRes.LOOK_OVER_ONLINE_HOME,getHomeStatus);
         HomeTimeObj = e.EventObj;
         HomeTime();
         updateNum = -1;
         getOnlineList();
         oneManNum = 0;
         updateOnlineMan();
         updateOneMan();
      }
      
      public static function getOnlineList() : void
      {
         var j:uint = 0;
         var id:Number = NaN;
         userIDArray = [];
         for(var i:uint = 0; i < FriendsStatusArr.length; i++)
         {
            for(j = 0; j < FriendsStatusArr[i].friendArr.length; j++)
            {
               id = Number(FriendsStatusArr[i].friendArr[j].UserID);
               userIDArray.push(id);
            }
         }
      }
      
      public static function getPrimitiveColors(colorStr:String) : Array
      {
         var tempStr:String = null;
         var A:String = null;
         var B:String = null;
         var a:String = colorStr;
         if(a.indexOf("#") > -1)
         {
            a = a.slice(1);
         }
         while(a.length < 6)
         {
            a = "0" + a;
         }
         a = a.toLocaleLowerCase();
         var tempArray:Array = [];
         for(var i:uint = 0; i < 6; i += 2)
         {
            tempStr = a.substr(i,2);
            A = tempStr.substr(0,1);
            B = tempStr.substr(1,1);
            tempArray.push(myObj[A] * 16 + myObj[B]);
         }
         return tempArray;
      }
      
      public static function getsertime(id:*) : int
      {
         for(var i:uint = 0; i < serverFriendsList.length; i++)
         {
            if(serverFriendsList[i].friend == id)
            {
               return serverFriendsList[i].time;
            }
         }
         return 0;
      }
      
      public static function getsotime(id:*) : int
      {
         var i:uint = 0;
         if(Boolean(friendsList))
         {
            for(i = 0; i < friendsList.length; i++)
            {
               if(friendsList[i].UserID == id)
               {
                  return "Dining_flag" in friendsList[i] ? int(friendsList[i].time) : -1;
               }
            }
         }
         return 0;
      }
      
      public static function hideLoading() : void
      {
         MC.loading.visible = false;
         MC.loading.gotoAndStop(1);
         if(Boolean(myScrollBar))
         {
            myScrollBar.doChange();
         }
      }
      
      public static function init(mc:MovieClip, man:Class) : void
      {
         vipNum = 0;
         closed = false;
         var ed:EventDispatcher = new EventDispatcher();
         dispatchEvent = ed.dispatchEvent;
         addEventListener = ed.addEventListener;
         removeEventListener = ed.removeEventListener;
         GTalk = new selfTalk();
         Man = man;
         MC = mc;
         MC.manMC.y = Base_ManMC_X;
         _searchFriendView = new SearchFriendView(MC.searchMC);
         hideLoading();
         FriendStatusReq = new LookOverFriendOnlineReq();
         refresh();
         if(Boolean(myScrollBar))
         {
            myScrollBar.doChange();
         }
      }
      
      public static function initMan(manInfo:Object, bool:*) : void
      {
         if(manInfo.Nick == null)
         {
            return;
         }
         var temp:MovieClip = ObjectPool.getObject(Man);
         temp.home_btn.visible = false;
         temp.prev_pet.visible = true;
         temp.prev_mc.visible = true;
         temp.visible = false;
         temp.del_btn.visible = false;
         temp.id = manInfo.UserID;
         temp.sortnum = 6;
         temp.vip = isvip(manInfo);
         temp.Color = Number(manInfo.Color);
         temp.name = "mc" + temp.id;
         temp.userName.text = manInfo.Nick;
         temp.nick = manInfo.Nick;
         temp.enNick = PinYinUtil.toPinyin(temp.nick);
         temp.chat_btn.visible = true;
         BC.addEvent(FView,temp.chat_btn,MouseEvent.CLICK,showChatPanel);
         BC.addEvent(FView,temp.head_btn,MouseEvent.CLICK,showFriendPanel);
         BC.addEvent(FView,temp.head_btn,MouseEvent.MOUSE_OVER,goto2);
         BC.addEvent(FView,temp.head_btn,MouseEvent.MOUSE_OUT,goto1);
         temp.prev_mc.pv_color.visible = false;
         temp.prev_pet.pv_color.visible = false;
         if(Boolean(temp.vip))
         {
            temp.prev_mc.visible = false;
            temp.prev_pet.visible = true;
            temp.prev_pet.pv_color.visible = false;
         }
         else
         {
            temp.prev_mc.visible = true;
            temp.prev_mc.pv_color.visible = false;
            temp.prev_pet.visible = false;
         }
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      public static function initmyScrollBar(bool:Boolean = false) : void
      {
         var i:int = 0;
         if(!myScrollBar)
         {
            myScrollBar = new ScrollBar(null,MC.manMC,{
               "length":36 * 6,
               "x":210,
               "y":MC.manMC.y
            },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_VERTICAL,36);
         }
         if(serverFriendsList.length > 6)
         {
            arrange(arrMC);
         }
         else
         {
            for(i = int(arrMC.length); i < 6; i++)
            {
               addBG();
            }
            arrange(arrMC);
         }
         if(Boolean(myScrollBar))
         {
            myScrollBar.doChange();
         }
      }
      
      public static function isvip(info:Object) : Boolean
      {
         return Boolean(info.Vip >> 0 & 1);
      }
      
      public static function isVipbyId(userId:int) : Boolean
      {
         var length:int = 0;
         var i:uint = 0;
         if(userId == LocalUserInfo.getUserID())
         {
            return LocalUserInfo.isVIP();
         }
         var so:SharedObject = MainManager.getGlobalObject();
         var friendList:Array = so.data.FriendsList;
         if(Boolean(friendList))
         {
            length = int(friendList.length);
            for(i = 0; i < length; i++)
            {
               if(friendList[i].UserID == userId)
               {
                  return isvip(friendList[i]);
               }
            }
            return false;
         }
         return false;
      }
      
      public static function refresh() : void
      {
         MC.manMC.y = Base_ManMC_X;
         vipNum = 0;
         serverFriendsList = new Array();
         FriendsStatusArr = new Array();
         arrMC = new Array();
         so = MainManager.getGlobalObject();
         serverFriendsList = so.data.ServerFriendsList;
         friendsList = so.data.FriendsList;
         if(!(friendsList is Array))
         {
            friendsList = new Array();
         }
         showSOFriend();
         showNums();
         BC.addEvent(FView,GV.onlineSocket,userPanelView.ADDFRIEND_SUCCESS,addFriendSuccess);
         BC.addEvent(FView,GV.onlineSocket,userPanelView.ADDFRIEND_FAIL,addFriendFail);
         BC.addEvent(FView,GV.onlineSocket,DelFrendRes.DELETE_FREND,delFriendSuccess);
         BC.addEvent(FView,GV.onlineSocket,DelFrendRes.DELETE_FAIL,delFriendFail);
         start();
      }
      
      public static function removeMan() : void
      {
         var mc:* = undefined;
         for(var i:int = MC.manMC.numChildren - 1; i >= 0; i--)
         {
            mc = MC.manMC.getChildAt(i) as Man;
            ObjectPool.disposeObject(mc,Man,200);
            MC.manMC.removeChild(mc);
         }
      }
      
      public static function reshowMan() : void
      {
         for(var i:uint = 0; i < arrMC.length; i++)
         {
            arrMC[i].y = 36 * i;
         }
      }
      
      public static function sendFriendStatus() : void
      {
         tempIDArr = new Array();
         var len:uint = serverFriendsList.length;
         for(var i:uint = 0; i < len; i++)
         {
            tempIDArr.push(serverFriendsList[i].friend);
         }
         FriendStatusReq.lookOverFriendOnline(0,len,tempIDArr);
      }
      
      public static function showColor(mc:*) : void
      {
         mc.prev_pet.visible = true;
         mc.prev_mc.visible = true;
         mc.prev_mc.pv_color.visible = true;
         mc.prev_pet.pv_color.visible = true;
         var colorObj:Array = getPrimitiveColors(mc.Color.toString(16));
         if(Boolean(mc.vip))
         {
            mc.userName.textColor = 16711680;
            mc.sortnum = 2;
            mc.prev_mc.visible = false;
            mc.prev_pet.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         }
         else
         {
            mc.userName.textColor = 0;
            mc.sortnum = 4;
            mc.prev_pet.visible = false;
            mc.prev_mc.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         }
      }
      
      public static function showNums() : void
      {
         MC.nums.text = "(" + (serverFriendsList.length > LocalUserInfo.friendsLimitNum() ? LocalUserInfo.friendsLimitNum() : serverFriendsList.length) + "/" + LocalUserInfo.friendsLimitNum() + ")";
      }
      
      public static function showSOFriend() : void
      {
         var obj:Object = null;
         var len:uint = friendsList.length;
         var len1:uint = serverFriendsList.length;
         var alreadyArr:Array = [];
         for(var i:uint = 0; i < len; i++)
         {
            if(sohave(i) && alreadyArr.indexOf(friendsList[i].UserID) < 0)
            {
               initMan(friendsList[i],false);
               alreadyArr.push(friendsList[i].UserID);
            }
         }
         alreadyArr = null;
         for(var j:uint = 0; j < serverFriendsList.length; j++)
         {
            if(sonothave(j))
            {
               obj = friendsList[j];
               obj.UserID = serverFriendsList[j].friend;
               obj.Nick = "小摩爾";
               obj.Color = 0;
               obj.time = -1;
               obj.Vip = -1;
               initMan(obj,false);
            }
         }
         MoleSharedObject.flush();
         initmyScrollBar();
      }
      
      public static function sohave(i:uint) : Boolean
      {
         for(var j:uint = 0; j < serverFriendsList.length; j++)
         {
            if(friendsList[i].UserID == serverFriendsList[j].friend)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function sonothave(i:uint) : Boolean
      {
         for(var j:uint = 0; j < friendsList.length; j++)
         {
            if(friendsList[j].UserID == serverFriendsList[i].friend)
            {
               return false;
            }
         }
         return true;
      }
      
      public static function start() : void
      {
         if(!closed)
         {
            if(serverFriendsList.length > 0)
            {
               BC.addEvent(FView,GV.onlineSocket,LookOverFriendOnlineRes.LOOK_OVER_ONLINE_FRIEND,getFriendStatus);
               BC.addEvent(FView,GV.onlineSocket,GetUserBasicInfoRes.GET_USER_BASIC_INFO,getFriendInfo);
               sendFriendStatus();
            }
            else
            {
               updateNum = -1;
               hideLoading();
               initmyScrollBar();
               GV.onlineClass.dispatchEvent(new Event("post_card_fview"));
            }
         }
         MC.manMC.y = Base_ManMC_X;
         if(!myScrollBar)
         {
            myScrollBar = new ScrollBar(null,MC.manMC,{
               "length":36 * 6,
               "x":210,
               "y":MC.manMC.y
            },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_VERTICAL,36);
            myScrollBar.doChange();
         }
      }
      
      public static function un() : void
      {
         barBool = false;
         closed = true;
         uninit();
      }
      
      public static function uninit() : void
      {
         if(Boolean(myScrollBar))
         {
            myScrollBar.clearClass();
         }
         myScrollBar = null;
         BC.removeEvent(FView);
         arrMC = null;
         removeMan();
         vipNum = 0;
      }
      
      public static function updateMan(obj:Object) : void
      {
         var temp:Object = arrMC[oneManNum];
         if(Boolean(temp))
         {
            if(userIDArray.indexOf(obj.UserID) >= 0)
            {
               temp.vip = isvip(obj);
               temp.Color = Number(obj.Color);
               temp.name = "mc" + temp.id;
               temp.userName.text = obj.Nick;
               temp.nick = obj.Nick;
               showColor(temp);
            }
            else
            {
               temp.vip = isvip(obj);
               temp.Color = Number(obj.Color);
               temp.name = "mc" + temp.id;
               temp.userName.text = obj.Nick;
               temp.nick = obj.Nick;
            }
            temp.prev_pet.visible = true;
            temp.prev_mc.visible = true;
            if(Boolean(temp.vip))
            {
               temp.prev_mc.visible = false;
            }
            else
            {
               temp.prev_pet.visible = false;
            }
            temp.enNick = PinYinUtil.toPinyin(temp.nick);
         }
      }
      
      public static function updateOneMan() : void
      {
         if(oneManNum < arrMC.length)
         {
            if(arrMC[oneManNum].id != 1 && arrMC[oneManNum].id != 0)
            {
               friendLogic.sendFriendID(arrMC[oneManNum].id);
            }
         }
      }
      
      public static function updateOnlineMan() : void
      {
         var mc:* = undefined;
         for(var i:uint = 0; i < userIDArray.length; i++)
         {
            mc = MC.manMC.getChildByName("mc" + userIDArray[i]);
            if(Boolean(mc))
            {
               showColor(mc);
               mc.online = true;
            }
         }
         arrMC.sortOn("sortnum",Array.NUMERIC);
         reshowMan();
         GV.onlineClass.dispatchEvent(new Event("post_card_fview"));
      }
      
      public static function ScrollToUser(userId:int) : void
      {
         var man:MovieClip = null;
         for each(man in arrMC)
         {
            if(man.id == userId)
            {
               myScrollBar.ScrollToItem(man);
               return;
            }
         }
      }
      
      public static function FilterUser(arr:Array) : void
      {
         var item:MovieClip = null;
         var manContainer:MovieClip = MC.manMC;
         while(manContainer.numChildren > 0)
         {
            manContainer.removeChildAt(0);
         }
         arrange(arr);
         for each(item in arr)
         {
            manContainer.addChild(item);
            myScrollBar.doChange();
         }
      }
      
      private static function changePlace(a:*, b:*) : void
      {
         var ay:* = a.y;
         a.y = b.y;
         b.y = ay;
         ay = null;
      }
      
      private static function goto1(evt:MouseEvent) : void
      {
         evt.target.parent[evt.target.name + "_mc"].gotoAndStop(1);
         evt.target.parent.bgMC.gotoAndStop(1);
      }
      
      private static function goto2(evt:MouseEvent) : void
      {
         evt.target.parent[evt.target.name + "_mc"].gotoAndStop(2);
         evt.target.parent.bgMC.gotoAndStop(2);
      }
      
      private static function gotoHome(evt:MouseEvent) : void
      {
         var homeTime:Object = so.data["HomeTime" + LocalUserInfo.getUserID()];
         if(Boolean(homeTime))
         {
            homeTime[evt.currentTarget.parent.id].Time = evt.currentTarget.parent.HomeUpdateTime;
         }
         MoleSharedObject.flush();
         var uid:uint = uint(evt.currentTarget.parent.id);
         if(GV.MapInfo_mapID < 1000)
         {
            GV.MyInfo_PrevMap = GV.MapInfo_mapID;
         }
         if(GV.MapInfo_mapID != uid + GV.TwentyBillion)
         {
            GV.Room_DefaultRoomID = uid + GV.TwentyBillion;
            MapManager.enterMap(uid,2);
         }
      }
      
      private static function showChatPanel(evt:MouseEvent) : void
      {
         GTalk.showTalkUImy({
            "UserID":evt.target.parent.id,
            "Nick":evt.target.parent.userName.text,
            "Color":1
         });
      }
      
      private static function showFriendPanel(evt:Event) : void
      {
         var tempSerID:int = 0;
         var i:uint = 0;
         var j:uint = 0;
         var id:Number = NaN;
         var friendBool:Boolean = false;
         if(FriendsStatusArr.length > 0)
         {
            for(i = 0; i < FriendsStatusArr.length; i++)
            {
               for(j = 0; j < FriendsStatusArr[i].friendArr.length; j++)
               {
                  id = Number(FriendsStatusArr[i].friendArr[j].UserID);
                  if(evt.target.parent.id == id)
                  {
                     friendBool = true;
                     tempSerID = int(FriendsStatusArr[i].friendArr[j].serID);
                     break;
                  }
               }
            }
            if(friendBool)
            {
               userPanelView.showUserPanel(evt.target.parent.id,tempSerID);
            }
            else
            {
               userPanelView.showUserPanel(evt.target.parent.id,10000);
            }
         }
         else
         {
            userPanelView.showUserPanel(evt.target.parent.id,10000);
         }
      }
   }
}

