package com.module.myselfTalk
{
   import com.common.Alert.Alert;
   import com.common.view.MCScrollBar.ScrollBar;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.ServerListManager;
   import com.core.manager.UIManager;
   import com.core.newloader.MCLoader;
   import com.core.stringPop.Pop;
   import com.event.EventTaomee;
   import com.logic.expressionLogic.expSelfTalkLogic;
   import com.logic.socket.getSceneUserInfo.*;
   import com.logic.socket.home.homeSocket;
   import com.logic.socket.lookOverFriendOnline.LookOverFriendOnlineReq;
   import com.logic.socket.lookOverFriendOnline.LookOverFriendOnlineRes;
   import com.module.changeClothsModule.*;
   import com.module.cutMapModule.SaveCutMap;
   import com.view.userPanelView.userPanelView;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TextEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.net.*;
   import flash.system.Security;
   import flash.system.System;
   import flash.text.*;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class selfTalk extends MovieClip
   {
      
      public static var UIArray:Array = new Array();
      
      private static var talkRecords:Dictionary = new Dictionary();
      
      private var tempCla:*;
      
      private var NoticeMC:*;
      
      private var curentCutMapArray:Array;
      
      private var curentCutMapObj:Object;
      
      private var curentCutMapStr:String;
      
      private var curentCutMapTxt:TextField;
      
      private var pp:*;
      
      private var ID:int;
      
      private var isKeyCtrl:Boolean = false;
      
      private var isKeyEnterNum:int = 0;
      
      public var nowMC:MovieClip;
      
      private var scroll_Bar:ScrollBar;
      
      private var expressionClass:expSelfTalkLogic = null;
      
      private var downloadURL:URLRequest;
      
      private var fileName:String;
      
      private var file:FileReference;
      
      private var showTipTimer:Timer;
      
      private var myPetMC:MovieClip;
      
      private var otherPetMC:MovieClip;
      
      private var otherUserInfo:Object;
      
      private var getSceneUserInfoReq:GetSceneUserInfoReq;
      
      private var FriendStatusReq:LookOverFriendOnlineReq = new LookOverFriendOnlineReq();
      
      public function selfTalk()
      {
         super();
         try
         {
            this.tempCla = UIManager.getClass("talk_notice");
         }
         catch(e:Error)
         {
         }
         this.getSceneUserInfoReq = new GetSceneUserInfoReq();
      }
      
      public function showTalkUImy(arr:*) : void
      {
         var talkNoticeMC:* = undefined;
         var sss:ScrollBar = null;
         if(UIArray.length <= 2)
         {
            if(!Boolean(GV.MC_AppLever.getChildByName("talkNoticeMC" + arr.UserID)))
            {
               talkNoticeMC = new this.tempCla();
               talkNoticeMC.pp = arr;
               talkNoticeMC.ID = arr.UserID;
               talkNoticeMC.lgh = 0;
               talkNoticeMC.name = "talkNoticeMC" + arr.UserID;
               talkNoticeMC.isMy = true;
               sss = new ScrollBar(talkNoticeMC.chatAction_mc.scroll_mc,talkNoticeMC.chatAction_mc.chat_box,240,128);
               talkNoticeMC.scr = sss;
               GV.MC_AppLever.addChild(talkNoticeMC);
               GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
               talkNoticeMC.x = (GV.stageWidth - talkNoticeMC.width) / 2;
               talkNoticeMC.y = (GV.stageHeight - 350) / 2;
               trace("talkNoticeMC.x",talkNoticeMC.x);
               trace("talkNoticeMC.y",talkNoticeMC.y);
               this.talkInfo(talkNoticeMC);
            }
         }
      }
      
      public function showTalkUI(arr:*, idd:int) : void
      {
         var talkNoticeMC:* = undefined;
         this.ID = idd;
         talkNoticeMC = new this.tempCla();
         talkNoticeMC.pp = arr;
         talkNoticeMC.ID = this.ID;
         talkNoticeMC.name = "talkNoticeMC" + this.ID;
         talkNoticeMC.isMy = false;
         var sss:ScrollBar = new ScrollBar(talkNoticeMC.chatAction_mc.scroll_mc,talkNoticeMC.chatAction_mc.chat_box,240,128);
         talkNoticeMC.scr = sss;
         GV.MC_AppLever.addChild(talkNoticeMC);
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
         talkNoticeMC.x = (GV.stageWidth - talkNoticeMC.width) / 2;
         talkNoticeMC.y = (GV.stageHeight - 350) / 2;
         this.talkInfo(talkNoticeMC);
      }
      
      public function changBtFun(e:*) : void
      {
         var mc:* = e.target.parent;
         if(mc.IfShowList == false)
         {
            mc.IfShowList = true;
            mc.changBtn_mc.visible = true;
            mc.changBtn_mc.ByCtrlEnter.selected = mc.byCtrlEnter;
            mc.changBtn_mc.ByEnter.selected = mc.byEnter;
            mc.changBtn_mc.ByEnter.addEventListener(MouseEvent.CLICK,this.enter_sure);
            mc.changBtn_mc.ByCtrlEnter.addEventListener(MouseEvent.CLICK,this.ctrl_sure);
         }
         else
         {
            mc.IfShowList = false;
            mc.changBtn_mc.visible = false;
            mc.changBtn_mc.ByEnter.removeEventListener(MouseEvent.CLICK,this.enter_sure);
            mc.changBtn_mc.ByCtrlEnter.removeEventListener(MouseEvent.CLICK,this.ctrl_sure);
         }
      }
      
      public function enter_sure(e:*) : void
      {
         MainManager.getGlobalObject().data.selfTalkIsBtn = 1;
         var mc:* = e.currentTarget.parent.parent;
         e.currentTarget.parent.parent.byEnter = true;
         e.currentTarget.parent.ByEnter.selected = true;
         e.currentTarget.parent.parent.byCtrlEnter = false;
         e.currentTarget.parent.ByCtrlEnter.selected = false;
         mc.IfShowList = false;
         mc.changBtn_mc.visible = false;
         mc.changBtn_mc.ByEnter.removeEventListener(MouseEvent.CLICK,this.enter_sure);
         mc.changBtn_mc.ByCtrlEnter.removeEventListener(MouseEvent.CLICK,this.ctrl_sure);
      }
      
      public function ctrl_sure(e:*) : void
      {
         MainManager.getGlobalObject().data.selfTalkIsBtn = 2;
         var mc:* = e.currentTarget.parent.parent;
         e.currentTarget.parent.parent.byEnter = false;
         e.currentTarget.parent.ByEnter.selected = false;
         e.currentTarget.parent.parent.byCtrlEnter = true;
         e.currentTarget.parent.ByCtrlEnter.selected = true;
         mc.IfShowList = false;
         mc.changBtn_mc.visible = false;
         mc.changBtn_mc.ByEnter.removeEventListener(MouseEvent.CLICK,this.enter_sure);
         mc.changBtn_mc.ByCtrlEnter.removeEventListener(MouseEvent.CLICK,this.ctrl_sure);
      }
      
      public function talkListUI(e:*) : void
      {
         var mc:* = e.target.parent;
         if(mc.IfShowList == false)
         {
            this.ShowListFun(mc);
         }
         else
         {
            this.ClearListFun(mc);
         }
      }
      
      public function ShowListFun(mc:MovieClip) : void
      {
         mc.ShowList_mc.y = 308;
         mc.ShowList_mc.chatAction_mc;
         var sss:ScrollBar = new ScrollBar(mc.ShowList_mc.chatAction_mc.scroll_mc,mc.ShowList_mc.chatAction_mc.chat_box,240,128);
         mc.ShowList_mc.scr = sss;
      }
      
      public function ClearListFun(mc:MovieClip) : void
      {
      }
      
      public function showtip(E:MouseEvent) : void
      {
         GF.clearTip();
         GC.clearGTimeout(this.showTipTimer);
         if(E.currentTarget.name == "exp_btn")
         {
            this.showTipTimer = GC.setGTimeout(function():void
            {
               var myPoint:* = new Point(E.stageX,E.stageY - 18);
               GF.showTip("摩爾表情",{
                  "x":myPoint.x + 18,
                  "y":myPoint.y
               });
            },1000);
         }
         else if(E.currentTarget.name == "cupMap_btn")
         {
            this.showTipTimer = GC.setGTimeout(function():void
            {
               var myPoint:* = new Point(E.stageX,E.stageY - 18);
               GF.showTip("摩爾截圖",{
                  "x":myPoint.x + 18,
                  "y":myPoint.y
               });
            },1000);
         }
      }
      
      public function cleartip(event:MouseEvent = null) : void
      {
         GC.clearGTimeout(this.showTipTimer);
         GF.clearTip();
      }
      
      public function AddExpUI(event:MouseEvent) : void
      {
         var talkNoticeMC:MovieClip = null;
         talkNoticeMC = event.target.parent;
         if(!talkNoticeMC.exp_mc.getChildByName("getChildByName"))
         {
            GV.onlineSocket.addEventListener("expression_private_close",this.sandExpStr);
            this.expressionClass = new expSelfTalkLogic();
            this.expressionClass.showExpressionBorder(talkNoticeMC.exp_mc,talkNoticeMC.ID);
         }
      }
      
      public function GetCutMapUI(event:MouseEvent) : void
      {
         var tempClass:SaveCutMap = null;
         if(!SaveCutMap.busy)
         {
            tempClass = new SaveCutMap();
            tempClass.txt = event.currentTarget["parent"]["info_txt"] as TextField;
            BC.addEvent(this,tempClass,Event.COMPLETE,this.insideInfoBox);
         }
      }
      
      public function insideInfoBox(event:EventTaomee) : void
      {
         BC.removeEvent(this,null,Event.COMPLETE,this.insideInfoBox);
         var str:String = event.EventObj as String;
         MainManager.getStage().focus = event.target.txt;
         event.target.txt.parent.cc = str;
         event.target.txt.text = str;
         event.target.txt.visible = false;
         this.sandTalkInfo({"target":event.target.txt});
         event.target.txt = null;
      }
      
      public function sandExpStr(event:EventTaomee) : void
      {
         var txt:String = event.EventObj.str;
         var ID:uint = uint(event.EventObj.ID);
         trace("sandExpStr",ID,txt);
         GV.onlineClass.chating(ID,txt);
         var talkNoticeMC:* = GV.MC_AppLever.getChildByName("talkNoticeMC" + ID);
         talkNoticeMC.cc = "";
         talkNoticeMC.info_txt.text = "";
         this.expressionClass = null;
      }
      
      public function startHandler(msg:String, hasExpression:uint = 0, MC:MovieClip = null, ID:uint = 0) : void
      {
         var temp1:* = undefined;
         var temp2:* = undefined;
         if(!MC)
         {
            return;
         }
         if(ID == GV.MyInfo_userID)
         {
            if(MC.expTimeout1 != null)
            {
               clearTimeout(MC.expTimeout1);
               MC.expTimeout1 = null;
               if(Boolean(MC.getChildByName("ep" + GV.MyInfo_userID)))
               {
                  MC.exp_mask_mc1.visible = false;
                  temp1 = MC.getChildByName("ep" + GV.MyInfo_userID);
                  MC.removeChild(temp1);
               }
            }
         }
         else if(MC.expTimeout2 != null)
         {
            clearTimeout(MC.expTimeout2);
            MC.expTimeout2 = null;
            if(Boolean(MC.getChildByName("ep" + MC.ID)))
            {
               MC.exp_mask_mc2.visible = false;
               temp2 = MC.getChildByName("ep" + MC.ID);
               MC.removeChild(temp2);
            }
         }
         var myClass:* = UIManager.getClass("expression_mc");
         var tempMC:MovieClip = new myClass();
         tempMC.name = "ep" + ID;
         tempMC.gotoAndStop(hasExpression);
         tempMC.scaleX = 3;
         tempMC.scaleY = 3;
         tempMC.x = 280;
         tempMC.y = 0;
         if(ID == GV.MyInfo_userID)
         {
            tempMC.y = 203;
            MC.exp_mask_mc1.visible = true;
            MC.addChild(tempMC);
            MC.expTimeout1 = setTimeout(this.closeExpMC,2000,MC,tempMC);
         }
         else
         {
            tempMC.y = 73;
            MC.exp_mask_mc2.visible = true;
            MC.addChild(tempMC);
            MC.expTimeout2 = setTimeout(this.closeExpMC,2000,MC,tempMC);
         }
      }
      
      private function closeExpMC(MC:MovieClip, temp:MovieClip) : void
      {
         if(MC.expTimeout1 != null || MC.expTimeout2 != null)
         {
            if(temp.y == 203)
            {
               MC.exp_mask_mc1.visible = false;
               clearTimeout(MC.expTimeout1);
            }
            else
            {
               MC.exp_mask_mc2.visible = false;
               clearTimeout(MC.expTimeout2);
            }
            GC.stopAllMC(temp);
            GC.clearAllChildren(temp);
            if(Boolean(MC.getChildByName(temp.name)))
            {
               MC.removeChild(temp);
            }
         }
      }
      
      public function talkInfo(talkNoticeMC:MovieClip) : void
      {
         talkNoticeMC.exp_mask_mc1.visible = false;
         talkNoticeMC.exp_mask_mc2.visible = false;
         talkNoticeMC.exp_btn.addEventListener(MouseEvent.CLICK,this.AddExpUI);
         talkNoticeMC.exp_btn.addEventListener(MouseEvent.MOUSE_OVER,this.showtip);
         talkNoticeMC.exp_btn.addEventListener(MouseEvent.MOUSE_OUT,this.cleartip);
         talkNoticeMC.cupMap_btn.addEventListener(MouseEvent.CLICK,this.GetCutMapUI);
         talkNoticeMC.cupMap_btn.addEventListener(MouseEvent.MOUSE_OVER,this.showtip);
         talkNoticeMC.cupMap_btn.addEventListener(MouseEvent.MOUSE_OUT,this.cleartip);
         talkNoticeMC.up_bg_btn.addEventListener(MouseEvent.CLICK,this.showOtherInfo);
         talkNoticeMC.addEventListener(KeyboardEvent.KEY_UP,this.reportKeyUp);
         talkNoticeMC.addEventListener(KeyboardEvent.KEY_DOWN,this.reportKeyDown);
         talkNoticeMC.talkList_btn.visible = false;
         talkNoticeMC.changBt_btn.addEventListener(MouseEvent.CLICK,this.changBtFun);
         talkNoticeMC.changBtn_mc.visible = false;
         talkNoticeMC.IfShowList = false;
         if(MainManager.getGlobalObject().data.selfTalkIsBtn == 1 || !MainManager.getGlobalObject().data.selfTalkIsBtn)
         {
            talkNoticeMC.byEnter = true;
            talkNoticeMC.byCtrlEnter = false;
            talkNoticeMC.changBtn_mc.ByCtrlEnter.selected = false;
            talkNoticeMC.changBtn_mc.ByEnter.selected = true;
         }
         else
         {
            talkNoticeMC.byEnter = false;
            talkNoticeMC.byCtrlEnter = true;
            talkNoticeMC.changBtn_mc.ByCtrlEnter.selected = true;
            talkNoticeMC.changBtn_mc.ByEnter.selected = false;
         }
         talkNoticeMC.info_txt.addEventListener(MouseEvent.CLICK,this.nowMCFun);
         talkNoticeMC.info_txt.addEventListener(Event.CHANGE,this.nowTXTFun);
         talkNoticeMC.cc = "";
         talkNoticeMC.close_btn.addEventListener(MouseEvent.CLICK,this.delTalkUI);
         talkNoticeMC.enter_btn.addEventListener(MouseEvent.CLICK,this.sandTalkInfo);
         talkNoticeMC.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.dragMC,false,0,true);
         talkNoticeMC.drag_mc.addEventListener(MouseEvent.MOUSE_UP,this.stopdragMC,false,0,true);
         talkNoticeMC.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,this.movedragMC,false,0,true);
         talkNoticeMC.addEventListener(MouseEvent.MOUSE_DOWN,this.sendDepthToTop,false,0,true);
         new prevView(talkNoticeMC.self_mc,LocalUserInfo.getFamily().toString(16),LocalUserInfo.getClothItem());
         talkNoticeMC.mypet.visible = false;
         talkNoticeMC.otherpet.visible = false;
         talkNoticeMC.mypet.TIP = LocalUserInfo.getSLstar() + "星超級拉姆";
         talkNoticeMC.mypet.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         talkNoticeMC.mypet.addEventListener(MouseEvent.MOUSE_OUT,this.clearTip);
         this.myPetMC = talkNoticeMC.mypet;
         this.myPetMC.filters = [];
         if(LocalUserInfo.isVIP())
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 240,this.onHavePet101);
            homeSocket.queryHaveSuperLamu(LocalUserInfo.getUserID());
         }
         else if(LocalUserInfo.onceIsVIP())
         {
            this.myPetMC.visible = true;
            this.myPetMC.gotoAndStop(LocalUserInfo.getSLstar());
            this.myPetMC.filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
         }
         talkNoticeMC.self_mc.outline_mc.visible = false;
         talkNoticeMC.other_mc.outline_mc.visible = false;
         talkNoticeMC.other_mc.prev_mc.visible = true;
         var tempIDArr:Array = new Array();
         tempIDArr[0] = talkNoticeMC.ID;
         this.FriendStatusReq.lookOverFriendOnline(1,1,tempIDArr);
         GV.onlineSocket.addEventListener(LookOverFriendOnlineRes.LOOK_OVER_ONLINE_FRIEND,this.getFriend);
      }
      
      private function onHavePet101(evt:EventTaomee) : void
      {
         var hasPet101:Boolean = false;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 240,this.onHavePet101);
         var tempArr:Array = evt.EventObj.arr;
         for(var i:int = 0; i < tempArr.length; i++)
         {
            if(tempArr[i].Level == 101)
            {
               hasPet101 = true;
               break;
            }
         }
         this.myPetMC.filters = [];
         this.myPetMC.visible = true;
         if(hasPet101)
         {
            this.myPetMC.gotoAndStop(LocalUserInfo.getSLstar());
         }
         else
         {
            this.myPetMC.gotoAndStop(LocalUserInfo.getSLstar());
            this.myPetMC.filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
         }
      }
      
      private function showTip(evt:MouseEvent = null) : void
      {
         var tip:String = evt.currentTarget.TIP;
         this.clearTip();
         GF.showTip(tip,{
            "x":evt.currentTarget.x + 18 + evt.currentTarget.parent.x,
            "y":evt.currentTarget.y + evt.currentTarget.parent.y - 8
         });
      }
      
      private function clearTip(evt:MouseEvent = null) : void
      {
         GF.clearTip();
      }
      
      public function showOtherInfo(event:MouseEvent) : void
      {
         var ID:uint = uint(event.currentTarget.parent.ID);
         userPanelView.showUserPanel(ID);
      }
      
      public function showPet(mc:MovieClip, Level:uint, Color:uint) : void
      {
         mc.pet_mc.gotoAndStop(Level);
         mc.pet_ye.gotoAndStop(Level);
         this.setPetColor(mc.pet_mc,Color);
      }
      
      public function setPetColor(mc:DisplayObject, colorNum:uint) : void
      {
         var _array:Array = GV["petColor_" + colorNum];
         mc.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
      }
      
      private function getFriend(e:*) : void
      {
         var mc:* = undefined;
         var serverObj:Object = null;
         var userlg:* = undefined;
         var userArr:* = undefined;
         var info_arr:Array = null;
         var j:uint = 0;
         var userObj:Object = null;
         var serName:String = null;
         GV.onlineSocket.removeEventListener(LookOverFriendOnlineRes.LOOK_OVER_ONLINE_FRIEND,this.getFriend);
         var serverArr:* = e.EventObj.severFriend;
         var serlg:* = serverArr.length;
         var AllServerInfo:Array = new Array();
         var is_online:Boolean = false;
         for(var i:uint = 0; i < serlg; i++)
         {
            serverObj = new Object();
            serverObj.userSerID = serverArr[i].serverID;
            userlg = serverArr[i].friendCount;
            userArr = serverArr[i].friendArr;
            info_arr = new Array();
            for(j = 0; j < userlg; j++)
            {
               userObj = new Object();
               userObj.userID = userArr[j].UserID;
               userObj.userCount = userArr[j].Is_online;
               mc = GV.MC_AppLever.getChildByName("talkNoticeMC" + userObj.userID);
               if(userObj.userCount == 1)
               {
                  is_online = true;
                  if(serverObj.userSerID != 0)
                  {
                     serName = ServerListManager.getServerName(String(serverObj.userSerID));
                     mc.otherServerName = serName;
                     mc.otherServerID = serverObj.userSerID;
                  }
               }
               info_arr.push(userObj);
            }
            serverObj.userInfoArr = info_arr;
         }
         AllServerInfo.push(serverObj);
         if(is_online)
         {
            this.getSceneUserInfoReq.getSeceeUserInfo(mc.ID);
            GV.onlineSocket.addEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getSenceUserInfor);
         }
         else
         {
            this.getSceneUserInfoReq.getSeceeUserInfo(mc.ID);
            GV.onlineSocket.addEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getOutLineUserInfor);
            mc.other_mc.prev_mc.visible = false;
            mc.other_mc.outline_mc.visible = true;
         }
         if(mc.isMy == true)
         {
            if(Boolean(mc.otherServerName))
            {
               mc.tit_txt.text = "與" + mc.otherServerID + "." + mc.otherServerName + "伺服器的" + mc.pp.Nick + "(" + mc.pp.UserID + ")" + "通話中";
            }
            else
            {
               mc.tit_txt.text = "與好友" + mc.pp.Nick + "(" + mc.pp.UserID + ")" + "通話中";
            }
            mc.lastY = 0;
            UIArray.push(mc);
            this.showAddLineUI({
               "InfoMsg":"",
               "UserID":1001,
               "Nick":""
            },mc,true);
            this.showTalkMsgRecord(mc);
         }
         else
         {
            if(Boolean(mc.otherServerName))
            {
               mc.tit_txt.text = "與" + mc.otherServerID + "." + mc.otherServerName + "伺服器的" + mc.pp[0].Nick + "(" + mc.ID + ")" + "通話中";
            }
            else
            {
               mc.tit_txt.text = "與好友" + mc.pp[0].Nick + "(" + mc.ID + ")" + "通話中";
            }
            this.showSMGData(mc.pp,mc);
         }
      }
      
      private function showTalkMsgRecord(mc:MovieClip) : void
      {
         var data:Array = null;
         var str:String = null;
         var txt:String = null;
         if(talkRecords[mc.ID] != null)
         {
            data = talkRecords[mc.ID];
            str = "";
            for each(txt in data)
            {
               str += "<font color=\'#666666\'>" + txt + "</font>\n";
            }
            str += "<font size=\'12\' color=\'#666666\'>  ————聊天記錄分割線————</font>\n";
            this.showAddLineUI({
               "InfoMsg":str,
               "UserID":1001,
               "Nick":""
            },mc,false,true);
         }
      }
      
      private function addTalkMsgRecord(userid:int, txt:String) : void
      {
         if(talkRecords[userid] == null)
         {
            talkRecords[userid] = new Array();
         }
         var data:Array = talkRecords[userid];
         var maxRecord:int = 20;
         if(data.length == maxRecord)
         {
            data.push(txt);
            data.shift();
         }
         else
         {
            data.push(txt);
         }
      }
      
      private function getSenceUserInfor(evt:*) : void
      {
         var userInfo:* = evt.EventObj;
         var mc:* = GV.MC_AppLever.getChildByName("talkNoticeMC" + evt.EventObj.UserID);
         new prevView(mc.other_mc,userInfo.Color.toString(16),userInfo.itemArr);
         if(Boolean(userInfo.Vip >> 0 & 1))
         {
            mc.otherpet.TIP = userInfo.SLstar + "星超級拉姆";
            mc.otherpet.gotoAndStop(userInfo.SLstar);
            mc.otherpet.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
            mc.otherpet.addEventListener(MouseEvent.MOUSE_OUT,this.clearTip);
            this.otherPetMC = mc.otherpet;
            BC.addEvent(this,GV.onlineSocket,"read_" + 240,this.onOtherHavePet101);
            homeSocket.queryHaveSuperLamu(userInfo.UserID);
         }
         this.otherUserInfo = userInfo;
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getSenceUserInfor);
      }
      
      private function getOutLineUserInfor(evt:*) : void
      {
         var userInfo:* = evt.EventObj;
         var mc:* = GV.MC_AppLever.getChildByName("talkNoticeMC" + evt.EventObj.UserID);
         if(Boolean(userInfo.Vip >> 0 & 1))
         {
            mc.otherpet.TIP = userInfo.SLstar + "星超級拉姆";
            mc.otherpet.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
            mc.otherpet.addEventListener(MouseEvent.MOUSE_OUT,this.clearTip);
            this.otherPetMC = mc.otherpet;
            BC.addEvent(this,GV.onlineSocket,"read_" + 240,this.onOtherHavePet101);
            homeSocket.queryHaveSuperLamu(userInfo.UserID);
         }
         this.otherUserInfo = userInfo;
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getOutLineUserInfor);
      }
      
      private function onOtherHavePet101(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 240,this.onOtherHavePet101);
         var hasPet101:Boolean = false;
         var tempArr:Array = evt.EventObj.arr;
         for(var i:int = 0; i < tempArr.length; i++)
         {
            if(tempArr[i].Level == 101)
            {
               hasPet101 = true;
               break;
            }
         }
         if(hasPet101)
         {
            this.otherPetMC.visible = true;
            this.otherPetMC.gotoAndStop(this.otherUserInfo.SLstar);
         }
      }
      
      public function getBedTalkData(e:*) : void
      {
         var mc:* = GV.MC_AppLever.getChildByName("talkNoticeMC" + e.EventObj.otherUserID);
         var txt:String = "您發送的信息已經被屏蔽，請文明用語！";
         var arrObj:Object = {
            "UserID":GV.MyInfo_userID,
            "Nick":GV.MyInfo_nickName,
            "InfoMsg":txt
         };
         this.showAddLineUI(arrObj,mc);
      }
      
      public function addselfTalkLine(e:*) : void
      {
         for(var i:* = 0; i < UIArray.length; i++)
         {
            if(UIArray[i].ID == e.Mid)
            {
               this.showAddLineUI(e,UIArray[i]);
            }
         }
      }
      
      public function addTalkLine(e:*) : void
      {
         for(var i:* = 0; i < UIArray.length; i++)
         {
            if(UIArray[i].ID == e.UserID)
            {
               this.showAddLineUI(e,UIArray[i]);
            }
         }
      }
      
      public function showAddLineUI(addpp:*, mc:*, isSecurityTip:Boolean = false, thisIsRecordTxt:Boolean = false) : void
      {
         var target_mc:* = undefined;
         var temp2:MovieClip = null;
         var ip:uint = 0;
         var str:String = null;
         var aa:* = undefined;
         var ss:* = undefined;
         var bb:* = undefined;
         var i:* = undefined;
         var objs:* = undefined;
         target_mc = mc;
         var tempArray:Array = new Array();
         tempArray.push(addpp);
         tempArray[0].InfoMsg = this.checkAddMSG(tempArray[0].InfoMsg);
         var tempClass:* = UIManager.getClass("chat_item");
         var item:MovieClip = new tempClass();
         if(isSecurityTip)
         {
            tempClass = UIManager.getClass("securityTip_mc");
            temp2 = new tempClass();
            temp2.x = -5;
            temp2.y = -4;
            item.addChild(temp2);
         }
         item.name = target_mc.lgh;
         item.msg = tempArray[0].InfoMsg;
         item.userID = tempArray[0].UserID;
         item.userName = tempArray[0].Nick;
         item.msg_txt.wordWrap = true;
         item.msg_txt.autoSize = TextFieldAutoSize.LEFT;
         item.msg_txt.mouseWheelEnabled = false;
         BC.addEvent(this,item.msg_txt,TextEvent.LINK,this.linkHandler);
         var tempStrss:* = item.msg.substr(0,1);
         var tempStr:* = item.msg.substr(1,2);
         var tempNum:int = -1;
         if(tempStrss == "/")
         {
            for(ip = 0; ip < GV.expressionArray.length; ip++)
            {
               if(GV.expressionArray[ip] == tempStr)
               {
                  tempNum = int(ip);
                  break;
               }
            }
         }
         if(item.msg == "您發送的信息已經被屏蔽，請文明用語！")
         {
            item.msg_txt.htmlText = "<font color=\'#CC0000\'>" + item.msg + "</font>";
         }
         else
         {
            if(tempNum > -1)
            {
               this.startHandler(item.msg,tempNum + 1,target_mc,item.userID);
               return;
            }
            if(thisIsRecordTxt)
            {
               item.msg_txt.htmlText = "<font color=\'#000000\'>" + item.msg + "</font>";
            }
            else
            {
               item.msg_txt.htmlText = "<font color=\'#FF6600\'>" + item.userName + "說:</font><font color=\'#339900\'>" + item.msg + "</font>";
               if(isSecurityTip == false)
               {
                  str = item.userName + "說:" + item.msg;
                  this.addTalkMsgRecord(mc.ID,str);
               }
            }
         }
         item.bg_mc.height = item.msg_txt.numLines * 16 + 6;
         item.bg_mc.alpha = 0;
         item.y = target_mc.lastY;
         target_mc.chatAction_mc.chat_box.addChild(item);
         target_mc.lastY = item.y + item.bg_mc.height - 4;
         target_mc.scr.reSet();
         target_mc.lgh += 1;
         if(target_mc.lgh >= 30)
         {
            target_mc.lastY = item.y;
            aa = int(target_mc.lgh) - 30;
            ss = target_mc.chatAction_mc.chat_box.getChildByName(String(aa));
            target_mc.chatAction_mc.chat_box.removeChild(ss);
            bb = int(target_mc.lgh);
            for(i = aa + 1; i < bb; i++)
            {
               objs = target_mc.chatAction_mc.chat_box.getChildByName(String(i));
               objs.y = objs.y - item.bg_mc.height + 4;
            }
         }
         if(target_mc.info_txt.text == "\r")
         {
            target_mc.info_txt.text = "";
         }
      }
      
      public function showSMGData(pp:*, talkNoticeMC:MovieClip) : void
      {
         var target_mc:* = undefined;
         var ll:int = 0;
         var tempStrss:* = undefined;
         var tempStr:* = undefined;
         var tempNum:int = 0;
         var ipp:uint = 0;
         var item:MovieClip = null;
         target_mc = talkNoticeMC;
         GC.stopAllMC(target_mc.chatAction_mc.chat_box);
         var oldY:Number = 0;
         var tempClass:* = UIManager.getClass("chat_item");
         var tempArray:* = pp;
         if(tempArray.length >= 30)
         {
            ll = tempArray.length - 30;
            tempArray.splice(0,ll);
         }
         for(var i:uint = 0; i < tempArray.length; i++)
         {
            tempStrss = tempArray[i].InfoMsg.substr(0,1);
            tempStr = tempArray[i].InfoMsg.substr(1,2);
            tempNum = -1;
            if(tempStrss == "/")
            {
               for(ipp = 0; ipp < GV.expressionArray.length; ipp++)
               {
                  if(GV.expressionArray[ipp] == tempStr)
                  {
                     tempNum = int(ipp);
                     break;
                  }
               }
            }
            if(tempNum > -1)
            {
               this.startHandler(tempArray[i].InfoMsg,tempNum + 1,target_mc,tempArray[i].UserID);
            }
            else
            {
               tempArray[i].InfoMsg = this.checkAddMSG(tempArray[i].InfoMsg);
               item = new tempClass();
               item.name = String(i);
               item.msg = tempArray[i].InfoMsg;
               item.userID = tempArray[i].UserID;
               item.userName = tempArray[i].Nick;
               item.msg_txt.wordWrap = true;
               item.msg_txt.autoSize = TextFieldAutoSize.LEFT;
               item.msg_txt.mouseWheelEnabled = false;
               item.msg_txt.htmlText = "<font color=\'#FF6600\'>" + item.userName + "說:</font><font color=\'#339900\'>" + item.msg + "</font>";
               this.addTalkMsgRecord(item.userID,item.userName + "說:" + item.msg);
               BC.addEvent(this,item.msg_txt,TextEvent.LINK,this.linkHandler);
               item.bg_mc.height = item.msg_txt.numLines * 16 + 6;
               item.bg_mc.alpha = 0;
               item.y = oldY;
               oldY = item.y + item.bg_mc.height - 4;
               target_mc.chatAction_mc.chat_box.addChild(item);
            }
         }
         target_mc.lastY = oldY;
         target_mc.lgh = tempArray.length - 1;
         UIArray.push(target_mc);
         target_mc.scr.reSet();
      }
      
      public function checkAddMSG(filterStr:String) : String
      {
         var num:int = 0;
         var currentStr:String = null;
         var tempStr:String = null;
         var tempStr2:String = null;
         var MapTitle:String = null;
         var src:String = null;
         var imgStr:String = null;
         var mapArray:Array = Pop.popArray(filterStr,"[IMG (","[/IMG]");
         if(mapArray != null)
         {
            for(num = 0; num < mapArray.length; num++)
            {
               currentStr = mapArray[num];
               tempStr = Pop.popString(currentStr,"[IMG (",")]");
               tempStr2 = Pop.replaceStrng(currentStr,tempStr,"");
               MapTitle = Pop.replaceStrng(tempStr2,"[/IMG]","");
               src = Pop.popString(tempStr,"[IMG (",")]",0,false);
               imgStr = "<b><u><a href=\'event:" + src + "\' color=\'#00ff00\'>" + MapTitle + "</a></u></b>";
               filterStr = Pop.replaceStrng(filterStr,mapArray[num],imgStr);
            }
         }
         return filterStr;
      }
      
      public function sandTalkInfo(event:* = null) : void
      {
         var talkNoticeMC:MovieClip = null;
         var imgArray:Array = null;
         if(Boolean(this.expressionClass))
         {
            this.expressionClass.closeBorder();
            this.expressionClass = null;
         }
         talkNoticeMC = event.target.parent;
         var str:String = talkNoticeMC.info_txt.text;
         if(str.length >= 40)
         {
            talkNoticeMC.info_txt.text = str.substr(0,40);
         }
         if(talkNoticeMC.info_txt.text != "" && talkNoticeMC.info_txt.text.length <= 40)
         {
            if(talkNoticeMC.info_txt.text == "\n" || talkNoticeMC.info_txt.text == "\r")
            {
               talkNoticeMC.info_txt.text = "";
            }
            else
            {
               imgArray = Pop.popArray(talkNoticeMC.info_txt.text,"[IMG ","[/IMG]");
               if(imgArray.length > 0 && Pop.popArray(talkNoticeMC.info_txt.text,"[ID=","]").length > 0)
               {
                  this.sendIMGtoServer(imgArray,talkNoticeMC.info_txt);
                  return;
               }
               this.sendMSG(talkNoticeMC,talkNoticeMC.info_txt.text);
            }
         }
      }
      
      public function sendMSG(talkNoticeMC:MovieClip, txt:String) : void
      {
         var arrObj:Object = null;
         try
         {
            arrObj = {
               "UserID":GV.MyInfo_userID,
               "Nick":GV.MyInfo_nickName,
               "InfoMsg":txt
            };
            GV.onlineClass.chating(talkNoticeMC.ID,txt);
            talkNoticeMC.cc = "";
            talkNoticeMC.info_txt.text = "";
            talkNoticeMC.info_txt.type = TextFieldType.DYNAMIC;
            talkNoticeMC.showTxtNum = setTimeout(function(MC:MovieClip):*
            {
               clearTimeout(MC.showTxtNum);
               MC.showTxtNum = null;
               MC.info_txt.type = TextFieldType.INPUT;
            },300,talkNoticeMC);
         }
         catch(E:*)
         {
         }
      }
      
      public function sendIMGtoServer(imgArray:Array, txt:TextField) : void
      {
         var str:String = null;
         var IDString:String = null;
         var ID:Number = NaN;
         var item:Object = null;
         if(imgArray.length > 0)
         {
            str = imgArray.shift();
            if(Boolean(str.indexOf("[ID=")))
            {
               IDString = Pop.popString(str,"[ID=","]",0);
               ID = Number(SaveCutMap.getS2N(Pop.popString(str,"[ID=","]",0,false)));
               for each(item in SaveCutMap.cutMapArray)
               {
                  if(item.id == ID)
                  {
                     if(item.link == "")
                     {
                        this.curentCutMapArray = imgArray;
                        this.curentCutMapObj = item;
                        this.curentCutMapStr = IDString;
                        this.curentCutMapTxt = txt;
                        this.sendCutMap(item.data,item.ip,item.port);
                     }
                     else
                     {
                        txt.text = Pop.replaceStrng(txt.text,IDString,item.link);
                        this.sendIMGtoServer(imgArray,txt);
                     }
                     break;
                  }
               }
            }
            return;
         }
         txt.visible = true;
         this.sendMSG(txt.parent as MovieClip,txt.text);
      }
      
      public function sandTalkInfokey(event:MovieClip) : void
      {
         var talkNoticeMC:MovieClip = null;
         if(event == null)
         {
            return;
         }
         if(Boolean(this.expressionClass))
         {
            this.expressionClass.closeBorder();
            this.expressionClass = null;
         }
         talkNoticeMC = event;
         if(talkNoticeMC.info_txt.text != "" && talkNoticeMC.info_txt.text.length <= 40)
         {
            if(talkNoticeMC.info_txt.text == "\n" || talkNoticeMC.info_txt.text == "\r")
            {
               talkNoticeMC.info_txt.text = "";
            }
            else
            {
               this.sendMSG(talkNoticeMC,talkNoticeMC.info_txt.text);
            }
         }
      }
      
      public function linkHandler(E:TextEvent) : void
      {
         var tempPicMC:Sprite = null;
         var thisObj:selfTalk = null;
         var url:String = null;
         var myMCLoader:MCLoader = null;
         thisObj = this;
         url = E.text;
         if(SaveCutMap.PicViewClass != null)
         {
            tempPicMC = new SaveCutMap.PicViewClass(url);
            BC.addEvent(thisObj,tempPicMC,"onSave",this.onSaveCutMap);
            BC.addEvent(thisObj,tempPicMC,"onCopy",this.onCopyCutMapURL);
            GV.MC_AppLever.addChild(tempPicMC);
            thisObj = null;
         }
         else
         {
            myMCLoader = SaveCutMap.GetClass() as MCLoader;
            if(myMCLoader != null)
            {
               SaveCutMap.G_addEventListener(SaveCutMap.ADDED_CLASS,function(E:*):void
               {
                  SaveCutMap.G_removeEventListener(SaveCutMap.ADDED_CLASS,arguments.callee);
                  tempPicMC = new SaveCutMap.PicViewClass(url);
                  BC.addEvent(thisObj,tempPicMC,"onSave",onSaveCutMap);
                  BC.addEvent(thisObj,tempPicMC,"onCopy",onCopyCutMapURL);
                  GV.MC_AppLever.addChild(tempPicMC);
                  thisObj = null;
               });
            }
         }
      }
      
      public function onSaveCutMap(E:Event) : void
      {
         if(E.target.picURL != "")
         {
            SaveCutMap.FileReference_download(E.target.picURL,"摩爾截圖_" + new Date().valueOf() + ".jpg");
         }
      }
      
      public function onCopyCutMapURL(E:Event) : void
      {
         var msg:String = null;
         if(E.target.picURL != "")
         {
            System.setClipboard("[IMG (" + E.target.picURL + ")]摩爾截圖[/IMG]");
            msg = "　　復製成功，通過CTRl+V把它粘貼到輸入框，發給您的朋友吧!";
            Alert.showAlert(GV.MC_TopLever,msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
         }
      }
      
      public function nowMCFun(event:MouseEvent = null) : void
      {
         this.nowMC = event.target.parent;
         if(Boolean(this.expressionClass))
         {
            this.expressionClass.closeBorder();
            this.expressionClass = null;
         }
         this.nowMC.info_txt.text = this.nowMC.cc;
      }
      
      public function nowTXTFun(event:Event) : void
      {
         var MC:MovieClip = event.target.parent;
         var aa:String = event.target.text;
         if(Boolean(GV.JobLogics.isNumber(aa)))
         {
            MC.cc = aa;
         }
         else
         {
            event.target.text = MC.cc;
         }
         var str:String = event.target.text;
         if(str.length >= 40)
         {
            event.target.text = str.substr(0,40);
         }
      }
      
      public function reportKeyDown(event:KeyboardEvent) : void
      {
         var mc:* = event.currentTarget;
         if(mc.byCtrlEnter == true)
         {
            if(event.ctrlKey == true)
            {
               this.isKeyCtrl = true;
            }
            if(event.charCode == Keyboard.ENTER)
            {
               if(mc.info_txt.text != "")
               {
                  this.isKeyEnterNum += 1;
               }
               else
               {
                  mc.info_txt.text = "";
               }
            }
            if(this.isKeyCtrl == true && this.isKeyEnterNum == 1)
            {
               this.sandTalkInfokey(this.nowMC);
            }
         }
         if(mc.byEnter == true)
         {
            if(event.charCode == Keyboard.ENTER && event.ctrlKey == false)
            {
               this.sandTalkInfokey(this.nowMC);
            }
         }
      }
      
      public function reportKeyUp(event:KeyboardEvent) : void
      {
         if(event.ctrlKey == false)
         {
            this.isKeyCtrl = false;
         }
         if(event.charCode == Keyboard.ENTER)
         {
            this.isKeyEnterNum = 0;
         }
      }
      
      public function dragMC(event:MouseEvent = null) : void
      {
         event.currentTarget.parent.startDrag();
      }
      
      public function movedragMC(event:MouseEvent = null) : void
      {
         event.updateAfterEvent();
      }
      
      public function stopdragMC(event:MouseEvent = null) : void
      {
         event.currentTarget.parent.parent.stopDrag();
      }
      
      public function delTalkUI(e:MouseEvent = null) : void
      {
         var talkNoticeMC:* = undefined;
         talkNoticeMC = e.currentTarget.parent;
         this.removeEventss(talkNoticeMC);
      }
      
      public function sendDepthToTop(event:MouseEvent = null) : void
      {
         var topPosition:uint = event.currentTarget.parent.numChildren - 1;
         event.currentTarget.parent.setChildIndex(event.currentTarget,topPosition);
      }
      
      private function removeEventss(talkNoticeMC:*) : void
      {
         var p:int = 0;
         var i:* = undefined;
         BC.removeEvent(this);
         if(talkNoticeMC.expTimeout1 != null)
         {
            clearTimeout(talkNoticeMC.expTimeout1);
            talkNoticeMC.expTimeout1 = null;
         }
         if(talkNoticeMC.expTimeout2 != null)
         {
            clearTimeout(talkNoticeMC.expTimeout2);
            talkNoticeMC.expTimeout2 = null;
         }
         if(talkNoticeMC.myTimeout != null)
         {
            clearTimeout(talkNoticeMC.myTimeout);
            talkNoticeMC.myTimeout = null;
         }
         if(talkNoticeMC.showTxtNum != null)
         {
            clearTimeout(talkNoticeMC.showTxtNum);
            talkNoticeMC.showTxtNum = null;
         }
         GV.onlineSocket.removeEventListener("expression_private_close",this.sandExpStr);
         talkNoticeMC.scr.removeFun();
         talkNoticeMC.removeEventListener(KeyboardEvent.KEY_UP,this.reportKeyUp);
         talkNoticeMC.removeEventListener(KeyboardEvent.KEY_DOWN,this.reportKeyDown);
         talkNoticeMC.info_txt.removeEventListener(MouseEvent.CLICK,this.nowMCFun);
         talkNoticeMC.info_txt.removeEventListener(Event.CHANGE,this.nowTXTFun);
         talkNoticeMC.close_btn.removeEventListener(MouseEvent.CLICK,this.delTalkUI);
         talkNoticeMC.enter_btn.removeEventListener(MouseEvent.CLICK,this.sandTalkInfo);
         talkNoticeMC.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.dragMC);
         talkNoticeMC.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,this.stopdragMC);
         talkNoticeMC.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.movedragMC);
         talkNoticeMC.removeEventListener(MouseEvent.MOUSE_DOWN,this.sendDepthToTop);
         if(UIArray.length == 1)
         {
            UIArray = new Array();
         }
         else
         {
            p = 0;
            for(i = 0; i < UIArray.length; i++)
            {
               if(UIArray[i].ID == talkNoticeMC.ID)
               {
                  p = i;
               }
            }
            UIArray.splice(p,1);
         }
         GC.clearAllChildren(talkNoticeMC);
         GV.MC_AppLever.removeChild(talkNoticeMC);
         talkNoticeMC = null;
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
      }
      
      private function removeEvent(evt:EventTaomee = null) : void
      {
         var talkNoticeMC:* = undefined;
         if(Boolean(!UIArray[0] as MovieClip))
         {
            return;
         }
         for(var i:* = 0; i < UIArray.length; i++)
         {
            talkNoticeMC = UIArray[i];
            if(Boolean(talkNoticeMC))
            {
               if(talkNoticeMC.expTimeout1 != null)
               {
                  clearTimeout(talkNoticeMC.expTimeout1);
                  talkNoticeMC.expTimeout1 = null;
               }
               if(talkNoticeMC.expTimeout2 != null)
               {
                  clearTimeout(talkNoticeMC.expTimeout2);
                  talkNoticeMC.expTimeout2 = null;
               }
               if(talkNoticeMC.myTimeout != null)
               {
                  clearTimeout(talkNoticeMC.myTimeout);
                  talkNoticeMC.myTimeout = null;
               }
               if(talkNoticeMC.showTxtNum != null)
               {
                  clearTimeout(talkNoticeMC.showTxtNum);
                  talkNoticeMC.showTxtNum = null;
               }
               talkNoticeMC.removeEventListener(KeyboardEvent.KEY_UP,this.reportKeyUp);
               talkNoticeMC.removeEventListener(KeyboardEvent.KEY_DOWN,this.reportKeyDown);
               talkNoticeMC.removeEventListener(MouseEvent.MOUSE_DOWN,this.sendDepthToTop);
               talkNoticeMC.info_txt.removeEventListener(MouseEvent.CLICK,this.nowMCFun);
               talkNoticeMC.info_txt.removeEventListener(Event.CHANGE,this.nowTXTFun);
               talkNoticeMC.close_btn.removeEventListener(MouseEvent.CLICK,this.delTalkUI);
               talkNoticeMC.enter_btn.removeEventListener(MouseEvent.CLICK,this.sandTalkInfo);
               talkNoticeMC.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.dragMC);
               talkNoticeMC.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,this.stopdragMC);
               talkNoticeMC.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.movedragMC);
               GC.stopAllMC(talkNoticeMC);
               GC.clearAll(talkNoticeMC);
            }
         }
         UIArray = new Array();
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getSenceUserInfor);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
         this.curentCutMapObj = null;
         this.curentCutMapTxt = null;
      }
      
      private function sendCutMap(cutMapInfo:ByteArray, _ip:String, _port:int) : void
      {
         var loader:URLLoader;
         var header:URLRequestHeader;
         var request:URLRequest;
         cutMapInfo.position = 0;
         Security.loadPolicyFile("http://" + _ip + ":" + String(_port) + "/crossdomain.xml");
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         this.configureListeners(loader);
         header = new URLRequestHeader("user-ID",String(GV.MyInfo_userID));
         request = VL.getURLRequest("http://" + _ip + ":" + String(_port) + "/cgi-bin/processor/screenshot_upload_processor.php");
         request.data = cutMapInfo;
         request.method = URLRequestMethod.POST;
         request.contentType = "text/plain";
         request.requestHeaders.push(header);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
            trace("Unable to load requested document.");
         }
      }
      
      private function configureListeners(dispatcher:IEventDispatcher) : void
      {
         dispatcher.addEventListener(Event.COMPLETE,this.completeHandler);
         dispatcher.addEventListener(Event.OPEN,this.openHandler);
         dispatcher.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
         dispatcher.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
      }
      
      private function completeHandler(event:Event) : void
      {
         var url:String = null;
         var tempMC:MovieClip = null;
         var loader:URLLoader = URLLoader(event.target);
         var returnByteArray:ByteArray = loader.data as ByteArray;
         trace("returnByteArray: ",returnByteArray.position,returnByteArray.bytesAvailable);
         trace(loader.data);
         if(loader.data != 0)
         {
            url = "http://" + loader.data;
            this.curentCutMapObj.link = url;
            this.curentCutMapTxt.text = Pop.replaceStrng(this.curentCutMapTxt.text,this.curentCutMapStr,this.curentCutMapObj.link);
            this.sendIMGtoServer(this.curentCutMapArray,this.curentCutMapTxt);
            trace("link: " + this.curentCutMapObj.link);
         }
         try
         {
            tempMC = this.curentCutMapTxt.parent.getChildByName("Loading_mc") as MovieClip;
         }
         catch(E:*)
         {
         }
         if(tempMC != null)
         {
            tempMC.gotoAndStop(1);
            this.curentCutMapTxt.parent.removeChild(tempMC);
         }
      }
      
      private function openHandler(event:Event) : void
      {
         trace("openHandler: " + event);
         var tempClass:Class = SaveCutMap.getLibClass("Loading_mc") as Class;
         var tempMC:MovieClip = new tempClass();
         tempMC.name = "Loading_mc";
         tempMC.x = 125;
         tempMC.y = 110;
         tempMC.gotoAndPlay(2);
         try
         {
            this.curentCutMapTxt.parent.addChild(tempMC);
         }
         catch(E:*)
         {
         }
      }
      
      private function progressHandler(event:ProgressEvent) : void
      {
         trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         var tempMC:MovieClip = null;
         trace("securityErrorHandler: " + event);
         try
         {
            tempMC = this.curentCutMapTxt.parent.getChildByName("Loading_mc") as MovieClip;
         }
         catch(E:*)
         {
         }
         if(tempMC != null)
         {
            tempMC.gotoAndStop("onFail");
            GC.setGTimeout(function():void
            {
               try
               {
                  curentCutMapTxt.parent.removeChild(tempMC);
               }
               catch(E:*)
               {
               }
            },1000);
            this.curentCutMapTxt.visible = true;
            this.curentCutMapTxt.text = "";
            this.curentCutMapTxt.parent["cc"] = "";
         }
      }
      
      private function httpStatusHandler(event:HTTPStatusEvent) : void
      {
         trace("httpStatusHandler: " + event);
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         var tempMC:MovieClip = null;
         trace("ioErrorHandler: " + event);
         try
         {
            tempMC = this.curentCutMapTxt.parent.getChildByName("Loading_mc") as MovieClip;
         }
         catch(E:*)
         {
         }
         if(tempMC != null)
         {
            tempMC.gotoAndStop("onFail");
            GC.setGTimeout(function():void
            {
               try
               {
                  curentCutMapTxt.parent.removeChild(tempMC);
               }
               catch(E:*)
               {
               }
            },1000);
            this.curentCutMapTxt.visible = true;
            this.curentCutMapTxt.text = "";
            this.curentCutMapTxt.parent["cc"] = "";
         }
      }
   }
}

