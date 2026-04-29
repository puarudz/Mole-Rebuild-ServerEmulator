package com.module.friendList.friendView
{
   import com.common.Alert.Alert;
   import com.common.scrollBar.ScrollBar;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.objectPool.ObjectPool;
   import com.event.EventTaomee;
   import com.logic.socket.delBlackList.DelBlackListRes;
   import com.logic.socket.getBlackList.GetBlackListRes;
   import com.logic.socket.getUserBasicInfo.GetUserBasicInfoRes;
   import com.module.friendList.friendLogic.friendLogic;
   import com.module.myselfTalk.selfTalk;
   import com.view.userPanelView.userPanelView;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   
   public class RView extends MovieClip
   {
      
      public static var GTalk:selfTalk;
      
      public static var addEventListener:Function;
      
      public static var blackList:Array;
      
      public static var dispatchEvent:Function;
      
      public static var removeEventListener:Function;
      
      private static var MC:MovieClip;
      
      private static var Man:Class;
      
      private static var RootMC:MovieClip;
      
      private static var arrMC:Array;
      
      private static var blackNum:uint;
      
      private static var delBlackAlert:*;
      
      private static var delBlackID:int;
      
      private static var len:uint;
      
      private static var myScrollBar:ScrollBar;
      
      private static var recentFriendsList:Object;
      
      private static var so:SharedObject;
      
      private static var updateNum:Number;
      
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
      
      public function RView()
      {
         super();
      }
      
      public static function DeleteBlack(e:Event) : void
      {
         friendLogic.delBlack(delBlackID);
         GV.onlineSocket.dispatchEvent(new EventTaomee("return_black_friend",{"id":delBlackID}));
         BC.addEvent(BView,GV.onlineSocket,DelBlackListRes.DEL_BLACK_LIST,getBlackListAgain);
         delBlackAlert = null;
      }
      
      public static function addBG() : void
      {
         var temp:Object = ObjectPool.getObject(Man);
         temp.home_btn.visible = false;
         temp.prev_pet.visible = true;
         temp.prev_mc.visible = true;
         temp.chat_btn.visible = false;
         temp.del_btn.visible = false;
         temp.userName.text = "";
         temp.prev_mc.visible = false;
         temp.prev_pet.visible = false;
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      public static function addBlackFail(e:EventTaomee) : void
      {
      }
      
      public static function addBlackSuccess(e:EventTaomee) : void
      {
         uninit();
         refresh();
      }
      
      public static function arrange(arr:Array) : void
      {
         for(var k:uint = 0; k < arr.length; k++)
         {
            arr[k].y = 32 * k;
            arr[k].visible = true;
         }
      }
      
      public static function delBlackSuccess(e:EventTaomee) : void
      {
         uninit();
         refresh();
      }
      
      public static function getBlackArr(e:EventTaomee) : void
      {
         BC.removeEvent(BView,GV.onlineSocket,GetBlackListRes.GET_BLACKLIST,getBlackArr);
         if(e.EventObj.Count > 0)
         {
            blackList = e.EventObj.countArr;
            len = blackList.length;
            sendBlackInfo();
         }
         else
         {
            len = 0;
            hideLoading();
            initmyScrollBar();
         }
         showNums();
      }
      
      public static function getBlackInfo(e:EventTaomee) : void
      {
         initMan(e.EventObj,false);
         if(blackNum + 1 < len)
         {
            ++blackNum;
            friendLogic.sendBlackID(blackList[blackNum].UserID);
         }
         else
         {
            hideLoading();
            initmyScrollBar();
            BC.removeEvent(BView,GV.onlineSocket,GetUserBasicInfoRes.GET_USER_BASIC_INFO,getBlackInfo);
         }
         if(Boolean(myScrollBar))
         {
            myScrollBar.doChange();
         }
      }
      
      public static function getBlackListAgain(e:Event) : void
      {
         uninit();
         refresh();
      }
      
      public static function getChatBlackList(e:EventTaomee) : void
      {
         BC.removeEvent(BView,GV.onlineSocket,GetBlackListRes.GET_BLACKLIST,getChatBlackList);
         blackList = e.EventObj.countArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("chatBlackListOver"));
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
      
      public static function getblackListArr() : void
      {
         friendLogic.getBlackList();
         BC.addEvent(BView,GV.onlineSocket,GetBlackListRes.GET_BLACKLIST,getBlackArr);
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
         var ed:EventDispatcher = new EventDispatcher();
         dispatchEvent = ed.dispatchEvent;
         addEventListener = ed.addEventListener;
         removeEventListener = ed.removeEventListener;
         GTalk = new selfTalk();
         Man = man;
         MC = mc;
         MC.manMC.y = 64;
         refresh();
      }
      
      public static function initMan(manInfo:Object, bool:Boolean) : void
      {
         var temp:Object = ObjectPool.getObject(Man);
         temp.home_btn.visible = false;
         temp.prev_pet.visible = true;
         temp.prev_mc.visible = true;
         temp.visible = false;
         temp.vip = isvip(manInfo);
         temp.Color = Number(manInfo.Color);
         temp.del_btn.visible = false;
         temp.chat_btn.visible = true;
         temp.prev_pet.visible = true;
         temp.prev_mc.pv_color.visible = false;
         temp.prev_pet.pv_color.visible = false;
         temp.id = manInfo.UserID;
         temp.name = "mc" + temp.id;
         temp.userName.text = manInfo.Nick;
         BC.addEvent(RView,temp.chat_btn,MouseEvent.CLICK,showChatPanel);
         BC.addEvent(RView,temp.head_btn,MouseEvent.CLICK,showFriendPanel);
         BC.addEvent(RView,temp.head_btn,MouseEvent.MOUSE_OVER,goto2);
         BC.addEvent(RView,temp.head_btn,MouseEvent.MOUSE_OUT,goto1);
         if(bool)
         {
            showColor(temp);
         }
         else if(FView.isVipbyId(temp.id))
         {
            temp.prev_mc.visible = false;
         }
         else
         {
            temp.prev_pet.visible = false;
         }
         arrMC.push(temp);
         MC.manMC.addChild(temp);
      }
      
      public static function initmyScrollBar() : void
      {
         var i:uint = 0;
         if(!myScrollBar)
         {
            myScrollBar = new ScrollBar(null,MC.manMC,{
               "length":32 * 7 + 6,
               "x":210,
               "y":MC.manMC.y
            },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_VERTICAL,36);
         }
         if(len > 7)
         {
            arrange(arrMC);
         }
         else
         {
            for(i = len; i < 7; i++)
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
      
      public static function recentViewInit(type:uint = 0) : void
      {
         var i:uint = 0;
         var maninfo:Object = null;
         so = MainManager.getGlobalObject();
         recentFriendsList = so.data.recentFriendsList313;
         var myid:int = LocalUserInfo.getUserID();
         if(Boolean(recentFriendsList))
         {
            if(Boolean(recentFriendsList[myid]))
            {
               len = recentFriendsList[myid].length;
               for(i = 0; i < recentFriendsList[myid].length; i++)
               {
                  maninfo = recentFriendsList[myid][i];
                  if(Boolean(maninfo))
                  {
                     if(FView.userIDArray.indexOf(maninfo.UserID) >= 0)
                     {
                        initMan(maninfo,true);
                     }
                     else
                     {
                        initMan(maninfo,false);
                     }
                  }
               }
            }
         }
         hideLoading();
         initmyScrollBar();
      }
      
      public static function refresh() : void
      {
         MC.manMC.y = 64;
         MC.loading.visible = true;
         MC.loading.gotoAndPlay(2);
         arrMC = new Array();
         start();
         MC.manMC.y = 64;
         if(!myScrollBar)
         {
            myScrollBar = new ScrollBar(null,MC.manMC,{
               "length":32 * 7 + 6,
               "x":210,
               "y":MC.manMC.y
            },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_VERTICAL,36);
         }
         if(Boolean(myScrollBar))
         {
            myScrollBar.doChange();
         }
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
      
      public static function sendBlackInfo() : void
      {
         blackNum = 0;
         friendLogic.sendBlackID(blackList[blackNum].UserID);
         BC.addEvent(BView,GV.onlineSocket,GetUserBasicInfoRes.GET_USER_BASIC_INFO,getBlackInfo);
      }
      
      public static function showAlertPanel(e:Event) : void
      {
         if(delBlackAlert != null)
         {
            Alert.closeAllAlert();
         }
         delBlackID = e.target.parent.id;
         var nick:String = e.target.parent.userName.text;
         delBlackAlert = Alert.showAlert(MainManager.getAppLevel(),"你要把" + nick + "(" + delBlackID + ")\n從黑名單中刪除嗎？","",Alert.ICO_ALERT,"E");
         BC.addEvent(BView,delBlackAlert,Alert.CLICK_ + "1",DeleteBlack);
      }
      
      public static function showColor(mc:Object) : void
      {
         mc.prev_pet.visible = true;
         mc.prev_mc.visible = true;
         mc.prev_mc.pv_color.visible = true;
         mc.prev_pet.pv_color.visible = true;
         var colorObj:Array = getPrimitiveColors(mc.Color.toString(16));
         if(FView.isVipbyId(mc.id))
         {
            mc.sortnum = 2;
            mc.prev_mc.visible = false;
            mc.prev_pet.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         }
         else
         {
            mc.sortnum = 4;
            mc.prev_pet.visible = false;
            mc.prev_mc.pv_color.pv_color.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         }
      }
      
      public static function showNums() : void
      {
         MC.nums.text = "(" + len + ")";
      }
      
      public static function start() : void
      {
         recentViewInit();
         if(Boolean(myScrollBar))
         {
            myScrollBar.doChange();
         }
      }
      
      public static function un() : void
      {
         uninit();
      }
      
      public static function uninit() : void
      {
         if(Boolean(myScrollBar))
         {
            myScrollBar.clearClass();
         }
         myScrollBar = null;
         BC.removeEvent(RView);
         arrMC = null;
         removeMan();
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
      
      private static function showChatPanel(evt:MouseEvent) : void
      {
         GTalk.showTalkUImy({
            "UserID":evt.target.parent.id,
            "Nick":evt.target.parent.userName.text,
            "Color":1
         });
      }
      
      private static function showFriendPanel(evt:MouseEvent) : void
      {
         userPanelView.showUserPanel(evt.target.parent.id);
      }
   }
}

