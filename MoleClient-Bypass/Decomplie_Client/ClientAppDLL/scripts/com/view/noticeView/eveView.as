package com.view.noticeView
{
   import com.common.Alert.*;
   import com.common.newAlert.IAlert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.global.staticData.MapsConfig;
   import com.logic.socket.classSystem.classSocket;
   import com.logic.socket.huluGroup.*;
   import com.logic.socket.reponseFriendInvate.ResponseFriendInvateReq;
   import com.logic.socket.responsetAddFrend.ResAddFrendReq;
   import com.module.friendList.friendView.GView;
   import com.module.hulupuModule.requestAddToMyGroupView;
   import com.module.myselfTalk.selfTalk;
   import com.view.userPanelView.userPanelView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class eveView extends EventDispatcher
   {
      
      public static var myAdd_arr:Array;
      
      public static var nowLg:int = 0;
      
      public static var nowTalkID:int = 0;
      
      public static var isMC:int = 0;
      
      private var _groupObj:Object;
      
      private var _talkUI:selfTalk;
      
      private var pp:*;
      
      private var myAle:*;
      
      private var titArr:Array;
      
      private var talkArr:Array;
      
      private var talkGArr:Array;
      
      private var titGArr:Array;
      
      private var _infoList:Array;
      
      private var ResAddFrend:ResAddFrendReq;
      
      private var FriendInvateReq:ResponseFriendInvateReq;
      
      private var alert:IAlert;
      
      public function eveView()
      {
         super();
         this._groupObj = {};
         this._talkUI = new selfTalk();
         this._infoList = new Array();
         this.titArr = new Array();
         this.talkArr = new Array();
         this.talkGArr = new Array();
         this.titGArr = new Array();
         myAdd_arr = new Array();
         this.ResAddFrend = new ResAddFrendReq();
         this.FriendInvateReq = new ResponseFriendInvateReq();
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
      }
      
      public function info(e:*) : void
      {
         var lgh:uint = 0;
         var p:uint = 0;
         var temp:Array = null;
         if(e.Type == 1004 || e.Type == 1005)
         {
            this.infoG(e);
            return;
         }
         var tt:Array = new Array();
         tt.push(e);
         if(Boolean(this.titArr[0] as Array))
         {
            lgh = this.titArr.length;
            for(p = 0; p < lgh; p++)
            {
               temp = this.titArr[p];
               if(temp[0].InfoMsg == e.InfoMsg)
               {
                  this.titArr.splice(p,1);
                  break;
               }
            }
         }
         this.titArr.push(tt);
         this._infoList = this.titGArr.concat(this.talkGArr).concat(this.talkArr).concat(this.titArr);
         nowLg = this._infoList.length;
      }
      
      public function infoG(e:*) : void
      {
         var lgh:uint = 0;
         var p:uint = 0;
         var temp:Array = null;
         var tt:Array = new Array();
         tt.push(e);
         if(Boolean(this.titGArr[0] as Array))
         {
            lgh = this.titGArr.length;
            for(p = 0; p < lgh; p++)
            {
               temp = this.titGArr[p];
               if(temp[0].InfoMsg == e.InfoMsg)
               {
                  this.titGArr.splice(p,1);
                  break;
               }
            }
         }
         this.titGArr.push(tt);
         this._infoList = this.titGArr.concat(this.talkGArr).concat(this.talkArr).concat(this.titArr);
         nowLg = this._infoList.length;
      }
      
      public function talkInfo(objs:*) : void
      {
         var j:uint = 0;
         var aap:Array = null;
         var aaStr:String = null;
         var aa:Array = null;
         var mm:Array = new Array();
         var lastArr:Array = new Array();
         lastArr.push(objs);
         var tlg:uint = this.talkArr.length;
         var tempStr:* = objs.InfoMsg.substr(1,2);
         var tempNum:int = -1;
         for(var i:uint = 0; i < GV.expressionArray.length; i++)
         {
            if(GV.expressionArray[i] == tempStr)
            {
               tempNum = int(i);
               break;
            }
         }
         if(tempNum > -1)
         {
            for(j = 0; j < tlg; j++)
            {
               aap = this.talkArr[j];
               aaStr = aap[0].InfoMsg.substr(1,2);
               if(GV.expressionArray.indexOf(aaStr) > -1)
               {
                  this.talkArr.splice(j,1);
                  break;
               }
            }
         }
         tlg = this.talkArr.length;
         for(var k:uint = 0; k < tlg; k++)
         {
            aa = this.talkArr[k];
            if(aa[0].UserID == objs.UserID)
            {
               lastArr = aa.concat(lastArr);
               mm.push(k);
            }
         }
         for(var a:uint = 0; a < mm.length; a++)
         {
            this.talkArr.splice(mm[a],1);
         }
         this.talkArr.push(lastArr);
         this._infoList = this.titGArr.concat(this.talkGArr).concat(this.talkArr).concat(this.titArr);
         nowLg = this._infoList.length;
      }
      
      public function talkGInfo(objs:*) : void
      {
         var Arr:Array = [objs];
         this.talkGArr.push(Arr);
         this._infoList = this.titGArr.concat(this.talkGArr).concat(this.talkArr).concat(this.titArr);
         nowLg = this._infoList.length;
      }
      
      public function addUI() : void
      {
         isMC = 1;
      }
      
      public function renovateArr(chart_id:*) : void
      {
         var chart_pp:int = myAdd_arr.indexOf(chart_id);
         myAdd_arr.splice(chart_pp);
      }
      
      public function showTip() : void
      {
         var strTit:String = null;
         var strInfo:String = null;
         var aa:String = null;
         var bb:String = null;
         var tempAlert:requestAddToMyGroupView = null;
         var tempAlert1:requestAddToMyGroupView = null;
         this._infoList = this.titGArr.concat(this.talkGArr).concat(this.talkArr).concat(this.titArr);
         this.pp = this._infoList.shift();
         nowLg = this._infoList.length;
         switch(this.pp[0].Type)
         {
            case 601:
               this.addUI();
               strTit = this.pp[0].InfoMsg;
               aa = strTit.slice(0,strTit.length - 6);
               bb = strTit.slice(strTit.length - 6);
               if(aa.length > 16)
               {
                  aa = strTit.slice(0,16);
                  bb = strTit.slice(16);
               }
               strTit = aa + "\r" + bb;
               this.myAle = Alert.showAlert(MainManager.getAppLevel(),strTit,"",Alert.SURE_ALERT,"C");
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.nextGameFun,false,0,true);
               this.myAle.addEventListener(Alert.CLICK_ + "2",this.noGameFun,false,0,true);
               this.titArr.shift();
               break;
            case 602:
               this.addUI();
               if(this.pp[0].ICON == 1)
               {
                  strTit = "";
                  strInfo = "恭喜！" + this.pp[0].Nike + "(" + this.pp[0].UserID + ")" + "\n" + "接受了您的邀請。";
                  this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"E");
               }
               else
               {
                  strTit = "";
                  strInfo = this.pp[0].Nike + "(" + this.pp[0].UserID + ")" + "\n" + "拒絕了您的邀請。";
                  this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"D");
               }
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.closeUIFun,false,0,true);
               this.titArr.shift();
               break;
            case 603:
               this.addUI();
               strInfo = "<font color=\'#000000\' size=\'14\' >同意</font>" + "<a href=\"event:aa\">" + "<u>" + "<font color=\'#FF6600\' size=\'14\' >" + this.pp[0].Nike + "</font>" + "</u>" + "</a><br>" + "<font color=\'#000000\' size=\'14\' >" + "成為您的好友嗎？" + "</font>";
               this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.CHANG_ALERT,"yes,not",true,true,"E");
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.addFun,false,0,true);
               this.myAle.addEventListener(Alert.CLICK_ + "2",this.addnoFun,false,0,true);
               this.myAle.addEventListener("CLOSED",this.removeAddFun);
               BC.addEvent(this,this.myAle,"CLICK_100",this.TextHandler);
               this.titArr.shift();
               break;
            case 604:
               this.addUI();
               if(this.pp[0].ICON == 1)
               {
                  strTit = "";
                  strInfo = "恭喜！" + this.pp[0].Nike + "(" + this.pp[0].UserID + ")" + "\n" + "已成為您的好友。";
                  this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"E");
               }
               else
               {
                  strTit = "";
                  strInfo = this.pp[0].Nike + "(" + this.pp[0].UserID + ")" + "\n" + "可能因為好友已滿，而無法成為你的好友哦！";
                  this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"D");
               }
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.closeUIFun,false,0,true);
               this.titArr.shift();
               break;
            case 302:
               nowTalkID = this.pp[0].UserID;
               if(selfTalk.UIArray.length <= 2)
               {
                  if(!MainManager.getAppLevel().getChildByName("talkNoticeMC" + nowTalkID))
                  {
                     this._talkUI.showTalkUI(this.pp,nowTalkID);
                  }
                  else
                  {
                     this.addTalkLine(this.pp[0]);
                  }
                  this.talkArr.shift();
               }
               break;
            case 303:
               GView.getGroup(this.pp[0].CroupID);
               this._groupObj[this.pp[0].CroupID] = false;
               this.talkGArr.shift();
               break;
            case 1003:
               this.addUI();
               tempAlert = requestAddToMyGroupView.getInstance(this.pp[0].UserID,this.pp[0].Nike,this.pp[0].InfoMsg,1);
               BC.addEvent(this,tempAlert,Alert.CLICK_ + "1",this.addGFun);
               BC.addEvent(this,tempAlert,Alert.CLICK_ + "2",this.addnoGFun);
               this.titArr.shift();
               break;
            case 1004:
               this.addUI();
               if(this.pp[0].ICON == 1)
               {
                  strTit = "";
                  strInfo = "恭喜！" + this.pp[0].Nike + "(" + this.pp[0].UserID + ")" + "\n" + "同意你加入他的（" + this.pp[0].Map + "）咕嚕噗。";
                  this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"E");
               }
               else
               {
                  strTit = "";
                  strInfo = this.pp[0].Nike + "(" + this.pp[0].UserID + ")" + "\n" + "拒絕你加入他的（" + this.pp[0].Map + "）咕嚕噗。";
                  this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"D");
               }
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.closeUIFun,false,0,true);
               this.titGArr.shift();
               break;
            case 1005:
               this.addUI();
               strTit = "";
               strInfo = "恭喜！" + this.pp[0].Nike + "(" + this.pp[0].UserID + ")" + "\n" + "把你加入他的（" + this.pp[0].Map + "）咕嚕噗。";
               this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"E");
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.closeUIFun,false,0,true);
               this.titGArr.shift();
               break;
            case 1006:
               this.addUI();
               strTit = "";
               strInfo = "通知！咕嚕噗（" + this.pp[0].Map + "）已經解散了。";
               this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"D");
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.closeUIFun,false,0,true);
               this.titArr.shift();
               break;
            case 5005:
               this.addUI();
               if(this.pp[0].InfoMsg == null)
               {
                  this.pp[0].InfoMsg = "    ";
               }
               tempAlert1 = requestAddToMyGroupView.getInstance(this.pp[0].UserID,this.pp[0].Nike,this.pp[0].InfoMsg,2);
               BC.addEvent(this,tempAlert1,Alert.CLICK_ + "1",function(E:*):*
               {
                  classSocket.class_Auditing(pp[0].UserID,1);
                  deleteFun();
               });
               BC.addEvent(this,tempAlert1,Alert.CLICK_ + "2",function(E:*):*
               {
                  classSocket.class_Auditing(pp[0].UserID,0);
                  deleteFun();
               });
               isMC = 0;
               this.titArr.shift();
               break;
            case 5006:
               this.addUI();
               if(this.pp[0].ICON == 1)
               {
                  strTit = "";
                  strInfo = "恭喜！" + this.pp[0].Nike + "(" + this.pp[0].UserID + ")" + "\n" + "同意你加入他的（" + this.pp[0].Map + "）班級。";
                  this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"E");
               }
               else
               {
                  strTit = "";
                  strInfo = this.pp[0].Nike + "(" + this.pp[0].UserID + ")" + "\n" + "拒絕你加入他的（" + this.pp[0].Map + "）班級。";
                  this.myAle = Alert.showAlert(MainManager.getAppLevel(),strInfo,"",Alert.ICO_ALERT2,"D");
               }
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.closeUIFun,false,0,true);
               this.titArr.shift();
         }
      }
      
      public function addTalkLine(e:*) : void
      {
         this._talkUI.addTalkLine(e);
      }
      
      public function addTalkGLine(e:*) : void
      {
      }
      
      private function addGFun(event:Event) : void
      {
         BC.removeEvent(this,null,Alert.CLICK_ + "1",this.addGFun);
         BC.removeEvent(this,null,Alert.CLICK_ + "2",this.addnoGFun);
         BC.addEvent(this,GV.onlineSocket,"CMD_" + CommandID.GROUP_INVITEFRIEND_TO_MYGROUP,this.inviterFriendSure);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + CommandID.GROUP_INVITEFRIEND_TO_MYGROUP,this.inviterFriendFail);
         var inviteFriendToMyGroups:inviteFriendToMyGroup = new inviteFriendToMyGroup();
         inviteFriendToMyGroups.doAction(this.pp[0].Map,this.pp[0].UserID);
      }
      
      private function addnoGFun(event:Event) : void
      {
         BC.removeEvent(this,null,Alert.CLICK_ + "1",this.addGFun);
         BC.removeEvent(this,null,Alert.CLICK_ + "2",this.addnoGFun);
         this.sandGOnLine(0);
      }
      
      private function sandGOnLine(type:uint) : void
      {
         var postilToMyGroups:postilToMyGroup = new postilToMyGroup();
         postilToMyGroups.doAction(type,this.pp[0].UserID,this.pp[0].Map);
         myAdd_arr.push(this.pp[0].UserID);
         this.deleteFun();
      }
      
      private function inviterFriendSure(event:EventTaomee) : void
      {
         this.sandGOnLine(1);
         BC.removeEvent(this,GV.onlineSocket,"CMD_" + CommandID.GROUP_INVITEFRIEND_TO_MYGROUP,this.inviterFriendSure);
      }
      
      private function inviterFriendFail(event:EventTaomee) : void
      {
         this.sandGOnLine(0);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_" + CommandID.GROUP_INVITEFRIEND_TO_MYGROUP,this.inviterFriendFail);
      }
      
      public function nextMapFun(e:*) : void
      {
         this.myAle.removeEventListener(Alert.CLICK_ + "1",this.nextMapFun);
         if(this.pp[0].Map != LocalUserInfo.getMapID())
         {
            LocalUserInfo.setMapID(0);
            GF.switchMap(this.pp[0].Map,false,this.pp[0].MapType);
         }
         this.deleteFun();
      }
      
      public function nextGameFun(e:*) : void
      {
         var flag:Boolean = false;
         var str:String = null;
         this.myAle.removeEventListener(Alert.CLICK_ + "1",this.nextGameFun);
         if(!MapsConfig.MapsInfo[this.pp[0].Map])
         {
            flag = false;
         }
         else
         {
            flag = Boolean(MapsConfig.MapsInfo[this.pp[0].Map].isLamuWorld);
         }
         var mapinfo:MapInfo = MapInfo.getMapInfo(this.pp[0].Map,LocalUserInfo.getMapType());
         if(Boolean(mapinfo.isNewUserMap))
         {
            str = "你的好友正在新手場景，你不能直接過去！";
            GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
         }
         else if(Boolean(mapinfo.isHSL) && mapinfo.id != 316)
         {
            str = "你的好友離你比較遠哦,你不能直接過去！";
            GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
         }
         else if(flag)
         {
            str = "你的好友正在拉姆縮小世界,你不能直接過去。";
            GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
         }
         else if(this.pp[0].Map != LocalUserInfo.getMapID())
         {
            if(this.pp[0].Map == 64)
            {
               str = "你的好友正在騎士秘密基地,你不能直接過去";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(this.pp[0].Map == 98 || this.pp[0].Map == 99)
            {
               str = "你的好友正在戰鬥中,你不能直接過去！";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(this.pp[0].Map > 97 && this.pp[0].Map < 102)
            {
               str = "你的好友離你比較遠哦,你不能直接過去！";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(this.pp[0].Map == 55)
            {
               str = "迷宮洞穴黑漆漆，需要超級拉姆的炫光氣團才能照亮洞穴挖取寶藏哦！";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(this.pp[0].Map == 102 || this.pp[0].Map == 103 || this.pp[0].Map == 104)
            {
               str = "非常抱歉，你的朋友離你太遠了，你沒辦法穿越時光到它身邊哦！";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(this.pp[0].Map >= 120 && this.pp[0].Map <= 135)
            {
               str = "嘿，你朋友所處的地方很危險，不能直接過去！";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(this.pp[0].Map == 117)
            {
               str = "目前這裡只有超級拉姆才享受優先進入權哦！等段時間再邀請朋友吧。";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(this.pp[0].Map == 66)
            {
               str = "目前這裡只有超級拉姆才享受優先進入權哦！等段時間再邀請朋友吧。";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(this.pp[0].Map == 82)
            {
               str = "你的好友正在秘密流星花園，你不能直接過去！";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(this.pp[0].Map == 148)
            {
               str = "你的好友正在參與菲力的餐廳體驗，你不能直接過去！";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(this.pp[0].Map == 172 || this.pp[0].Map == 173 || this.pp[0].Map == 174)
            {
               str = "你的好友離你比較遠哦,你不能直接過去！";
               GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
            }
            else if(mapinfo.digTreasureId > 0)
            {
               str = "你的好友正在地下城探險呢，快點過去找他吧！";
               this.myAle = GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
               this.myAle.addEventListener(Alert.CLICK_ + "1",this.gotoMapFun,false,0,true);
            }
            else
            {
               this.FriendInvateReq.responseFriendInvate(this.pp[0].UserID,this.pp[0].Map,1);
               LocalUserInfo.MyInfo_Grid = this.pp[0].Grid;
               LocalUserInfo.setMapID(0);
               GV.Room_DefaultRoomID = 10000;
               GF.switchMap(this.pp[0].Map,true,this.pp[0].MapType);
            }
         }
         this.deleteFun();
      }
      
      private function gotoMapFun(evt:*) : void
      {
         this.myAle.removeEventListener(Alert.CLICK_ + "1",this.gotoMapFun);
         GF.switchMap(185,true);
      }
      
      public function noGameFun(e:*) : void
      {
         this.myAle.removeEventListener(Alert.CLICK_ + "2",this.noGameFun);
         this.FriendInvateReq.responseFriendInvate(this.pp[0].UserID,this.pp[0].Map,0);
         this.deleteFun();
      }
      
      public function removeAddFun(e:Event = null) : void
      {
         this.myAle.removeEventListener("CLOSED",this.removeAddFun);
         this.deleteFun();
      }
      
      public function addFun(e:* = null) : void
      {
         var nonoInfo:String = null;
         this.myAle.removeEventListener(Alert.CLICK_ + "1",this.addFun);
         this.myAle.removeEventListener(Alert.CLICK_ + "2",this.addnoFun);
         this.myAle.removeEventListener("CLOSED",this.removeAddFun);
         BC.removeEvent(this,this.myAle,"CLICK_100",this.TextHandler);
         if(MainManager.getGlobalObject().data.ServerFriendsList.length >= LocalUserInfo.friendsLimitNum())
         {
            nonoInfo = "你的好友已經到達上限";
            Alert.showAlert(MainManager.getAppLevel(),nonoInfo,"",Alert.ICO_ALERT2,"D");
            this.ResAddFrend.resAddFrend(this.pp[0].UserID,0);
         }
         else
         {
            if(!MainManager.getGlobalObject().data.FriendsList)
            {
               MainManager.getGlobalObject().data.FriendsList = new Array();
            }
            if(this.checkUser(this.pp[0].UserID))
            {
               MainManager.getGlobalObject().data.ServerFriendsList.push({
                  "friend":this.pp[0].UserID,
                  "time":0
               });
               MainManager.getGlobalObject().data.FriendsList.push({
                  "Vip":-1,
                  "Color":0,
                  "UserID":this.pp[0].UserID,
                  "time":-1,
                  "type":this.pp[0].Type,
                  "map":this.pp[0].Map,
                  "Nick":this.pp[0].Nike,
                  "icon":this.pp[0].ICON,
                  "schema":this.pp[0].Schema,
                  "infoMsgLen":this.pp[0].InfoMsgLen,
                  "infoMsg":this.pp[0].InfoMsg
               });
               MainManager.getGlobalObject().flush();
               GV.onlineSocket.dispatchEvent(new EventTaomee("addfriendsuccess"));
            }
            this.ResAddFrend.resAddFrend(this.pp[0].UserID,1);
         }
         myAdd_arr.push(this.pp[0].UserID);
         this.deleteFun();
      }
      
      public function addnoFun(e:* = null) : void
      {
         this.myAle.removeEventListener(Alert.CLICK_ + "1",this.addFun);
         this.myAle.removeEventListener(Alert.CLICK_ + "2",this.addnoFun);
         this.myAle.removeEventListener("CLOSED",this.removeAddFun);
         BC.removeEvent(this,this.myAle,"CLICK_100",this.TextHandler);
         this.ResAddFrend.resAddFrend(this.pp[0].UserID,0);
         myAdd_arr.push(this.pp[0].UserID);
         this.deleteFun();
      }
      
      public function hereAddFun() : void
      {
         MainManager.getGlobalObject().data.ServerFriendsList.push({
            "friend":this.pp[0].UserID,
            "time":0
         });
         MainManager.getGlobalObject().data.FriendsList.push({
            "friend":this.pp[0].UserID,
            "time":0,
            "type":this.pp[0].Type,
            "map":this.pp[0].Map,
            "nike":this.pp[0].Nike,
            "icon":this.pp[0].ICON,
            "schema":this.pp[0].Schema,
            "infoMsgLen":this.pp[0].InfoMsgLen,
            "infoMsg":this.pp[0].InfoMsg
         });
         MainManager.getGlobalObject().flush();
         GV.onlineSocket.dispatchEvent(new EventTaomee("addfriendsuccess"));
      }
      
      public function closeUIFun(e:*) : void
      {
         e.target.removeEventListener(Alert.CLICK_ + "1",this.closeUIFun);
         e.target.removeEventListener(Alert.CLICK_ + "2",this.closeUIFun);
         this.deleteFun();
      }
      
      public function removeEvent(e:*) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
         isMC = 0;
      }
      
      private function deleteFun() : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
         isMC = 0;
      }
      
      private function checkUser(id:int) : Boolean
      {
         for(var j:int = 0; j < MainManager.getGlobalObject().data.ServerFriendsList.length; j++)
         {
            if(MainManager.getGlobalObject().data.ServerFriendsList[j].friend == id)
            {
               return false;
            }
         }
         return true;
      }
      
      private function TextHandler(e:*) : void
      {
         userPanelView.showUserPanel(this.pp[0].UserID);
      }
      
      public function get groupObj() : Object
      {
         return this._groupObj;
      }
   }
}

