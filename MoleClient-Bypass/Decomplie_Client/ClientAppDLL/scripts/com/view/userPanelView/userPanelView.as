package com.view.userPanelView
{
   import com.common.Alert.Alert;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.manager.ServerListManager;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.addBlackList.*;
   import com.logic.socket.addFrends.*;
   import com.logic.socket.classSystem.classSocket;
   import com.logic.socket.delBlackList.*;
   import com.logic.socket.delFrend.*;
   import com.logic.socket.getBlackList.*;
   import com.logic.socket.getSceneUserInfo.*;
   import com.logic.socket.home.homeSocket;
   import com.logic.socket.requestFriendToRoom.*;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.PK.PKManager;
   import com.module.changeClothsModule.prevView;
   import com.module.classModule.classManage;
   import com.module.classModule.medalManage;
   import com.module.friendList.friendView.FView;
   import com.module.userInfo.view.MyUserView;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.task.TaskManager;
   import com.mole.net.MoleSharedObject;
   import com.view.noticeView.postcardLogic;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   public class userPanelView extends Sprite
   {
      
      public static var friendMC:*;
      
      public static var userPanel:*;
      
      public static var myLoader:Loader;
      
      public static var infoMC:*;
      
      public static var infoClass:*;
      
      public static var userID:int;
      
      private static var nike:String;
      
      private static var nikeName:String;
      
      public static var userInfo:Object;
      
      private static var blackListObj:Object;
      
      private static var vip:int;
      
      private static var mySelfinfoMC:MovieClip;
      
      private static var myAle:*;
      
      private static var addFrendsReq:AddFrendsReq;
      
      public static var addFrendsRes:AddFrendsRes;
      
      public static var requset_mc:*;
      
      private static var honorArray:Array;
      
      private static var requestUser_mc:*;
      
      private static var delFriendPanle:Class;
      
      private static var delFriendPanle_mc:*;
      
      private static var listBlackList:*;
      
      private static var listBlackList_mc:*;
      
      private static var addBlackList:*;
      
      private static var addBlackList_mc:*;
      
      private static var game:Class;
      
      private static var game_mc:*;
      
      private static var delFrendReq:DelFrendReq;
      
      private static var delBlackListReq:DelBlackListReq;
      
      private static var getSceneUserInfoReq:GetSceneUserInfoReq;
      
      private static var addBlackListReq:AddBlackListReq;
      
      private static var getBlackListReq:GetBlackListReq;
      
      private static var serID:uint;
      
      private static var postcardLogics:postcardLogic;
      
      private static var smcFlag:uint = 4;
      
      public static var ADDFRIEND_SUCCESS:String = "addfriendsuccess";
      
      public static var ADDFRIEND_FAIL:String = "addfriendfail";
      
      private static var fireCup_team:uint = 0;
      
      public function userPanelView()
      {
         super();
      }
      
      public static function showUserPanel(id:int, serverID:uint = 0) : void
      {
         var tempAlert:* = undefined;
         if(isNPC(id))
         {
            return;
         }
         if(GF.returnGM(id))
         {
            return;
         }
         if(id <= GV.userIDLimit)
         {
            userID = id;
            serID = serverID;
            GV.onlineSocket.addEventListener(GetSceneUserRes.GET_SCENE_INFO,getSenceUserInfor);
            GV.onlineSocket.addEventListener(GetBlackListRes.GET_BLACKLIST,getBlackHandler);
            getUserDetailInfo();
         }
         else
         {
            tempAlert = Alert.showAlert(MainManager.getAppLevel(),"對方是遊客","",6,"D");
         }
      }
      
      private static function getUserDetailInfo() : void
      {
         getBlackListReq = new GetBlackListReq();
         getBlackListReq.getBlackList();
         getBlackListReq = null;
      }
      
      private static function getBlackHandler(evt:*) : void
      {
         GV.onlineSocket.removeEventListener(GetBlackListRes.GET_BLACKLIST,getBlackHandler);
         blackListObj = new Object();
         blackListObj = evt.EventObj;
         getSceneUserInfoReq = new GetSceneUserInfoReq();
         getSceneUserInfoReq.getSeceeUserInfo(userID);
         getSceneUserInfoReq = null;
      }
      
      private static function getSenceUserInfor(evt:*) : void
      {
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,getSenceUserInfor);
         userInfo = new Object();
         userInfo = evt.EventObj;
         nike = userInfo.Nick;
         vip = userInfo.Vip;
         userInfo.Activity.position = 0;
         fireCup_team = userInfo.Activity.readUnsignedInt();
         userInfo.Activity.position = 0;
         if(userID != LocalUserInfo.getUserID())
         {
            showPanel();
         }
         else
         {
            LocalUserInfo.setEngineer(userInfo.Engineer);
            showMySelf();
         }
      }
      
      public static function checkUser(id:int) : Boolean
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
      
      private static function showPanel() : void
      {
         var bool:uint;
         var tempObj:Object;
         var mc:DisplayObject = null;
         if(!MainManager.getAppLevel().getChildByName("friend_MC"))
         {
            postcardLogics = new postcardLogic();
            friendMC = UIManager.getClass("uiFriendMC");
            userPanel = new friendMC();
            userPanel.name = "friend_MC";
            MainManager.getAppLevel().addChild(userPanel);
            userPanel.smc.visible = false;
            userPanel.sandPostBtn.addEventListener(MouseEvent.CLICK,sandPostFun);
            if(!MainManager.getAppLevel().getChildByName("friendMC"))
            {
               userPanel.x = (MainManager.getStageWidth() - userPanel.width) / 2;
               userPanel.y = (MainManager.getStageHeight() - userPanel.height) / 2;
            }
            else
            {
               mc = MainManager.getAppLevel().getChildByName("friendMC");
               userPanel.x = mc.x - userPanel.width;
               userPanel.y = mc.y;
            }
            userPanel.nikeName.text = nike + "\n" + "(" + String(userID) + ")";
            userPanel.nikeName.autoSize = TextFieldAutoSize.CENTER;
         }
         else
         {
            userPanel.nikeName.text = nike + "\n" + "(" + String(userID) + ")";
            userPanel.nikeName.autoSize = TextFieldAutoSize.CENTER;
            userPanel.smc.visible = false;
         }
         bool = Boolean(vip & smcFlag) ? 1 : 0;
         if(bool == 0)
         {
            userPanel.smc.visible = false;
         }
         else
         {
            userPanel.smc.visible = true;
         }
         userPanel.fxp_icon.visible = Boolean(true);
         initSLstar();
         try
         {
            userPanel.fxp_icon.visible = GF.getPeopleByID(userID).hasCar;
         }
         catch(err:Error)
         {
            userPanel.fxp_icon.visible = false;
         }
         tempObj = GF.getPeopleObj(userID);
         new prevView(userPanel.mole_mc,userInfo.Color.toString(16),userInfo.itemArr,tempObj,false,userInfo.roleType);
         GC.stopAllMC(userPanel);
         if(userID > 1999 && userID < 10000)
         {
            showNpcPanelView();
            return;
         }
         if(checkFriend(userID) == 3)
         {
            getUser();
         }
         else if(checkFriend(userID) == 0)
         {
            getUserInfo();
         }
         else if(checkFriend(userID) != 1)
         {
            if(checkFriend(userID) == 2)
            {
               showBlackPanle();
            }
         }
         GV.onlineSocket.addEventListener("read_" + 5011,getClassIcon);
         classSocket.class_getBadgeID(userID);
         addTips();
      }
      
      private static function addTips() : void
      {
         tip.tipTailDisPlayObject(userPanel.addFriendBtn,"添加好友");
         tip.tipTailDisPlayObject(userPanel.delBtn,"刪除好友");
         tip.tipTailDisPlayObject(userPanel.addFriendBtn1,"添加好友");
         tip.tipTailDisPlayObject(userPanel.sandPostBtn,"發郵件");
         tip.tipTailDisPlayObject(userPanel.game,"邀請好友前來");
         tip.tipTailDisPlayObject(userPanel.hometown,"去他的小屋");
         tip.tipTailDisPlayObject(userPanel.seach,"查看好友位置");
         tip.tipTailDisPlayObject(userPanel.listBlackListBtn,"黑名單");
         tip.tipTailDisPlayObject(userPanel.say,"舉報");
      }
      
      private static function initSLstar() : void
      {
         BC.addEvent(userPanelView,GV.onlineSocket,"read_" + 240,onHavePet101);
         homeSocket.queryHaveSuperLamu(userID);
      }
      
      private static function onHavePet101(evt:EventTaomee) : void
      {
         BC.removeEvent(userPanelView,GV.onlineSocket,"read_" + 240,onHavePet101);
         if(checkPel101(evt.EventObj.arr))
         {
            userPanel.slstar.visible = true;
            userPanel.slstar.gotoAndStop(userInfo.SLstar + 1);
            userPanel.slstar.addEventListener(MouseEvent.MOUSE_OVER,onSLstarHandler);
            userPanel.slstar.addEventListener(MouseEvent.MOUSE_OUT,onSLstarHandler);
         }
         else
         {
            userPanel.slstar.visible = false;
         }
      }
      
      private static function checkPel101(tempArr:Array) : Boolean
      {
         var ret:Boolean = false;
         for(var i:int = 0; i < tempArr.length; i++)
         {
            if(tempArr[i].Level == 101)
            {
               ret = true;
               break;
            }
         }
         return ret;
      }
      
      private static function onSLstarHandler(evt:MouseEvent) : void
      {
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            GF.showTip(userInfo.SLstar + "星超級拉姆");
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            GF.clearTip();
         }
      }
      
      public static function getClassIcon(evt:EventTaomee) : void
      {
         userPanel.class_ico_mc.buttonMode = true;
         GV.onlineSocket.removeEventListener("read_" + 5011,getClassIcon);
         GC.clearAllChildren(userPanel.class_ico_mc);
         var showClassID:uint = uint(evt.EventObj);
         if(showClassID > 0)
         {
            userPanel.class_ico_mc.addChild(medalManage.getMedal(showClassID,35,showClassInfo));
         }
      }
      
      private static function showClassInfo(e:Object, mc:Object) : void
      {
         classManage.getInstance().showClassInfo(Number(mc.classID));
      }
      
      private static function showMySelf() : void
      {
         var tempMC:Class = null;
         if(!MainManager.getAppLevel().getChildByName("mySelfinfoMC") && !GV.isChangeMap)
         {
            tempMC = UIManager.getClass("userInfo");
            mySelfinfoMC = new tempMC();
            mySelfinfoMC.name = "mySelfinfoMC";
            mySelfinfoMC.icon_mc.gotoAndStop(LocalUserInfo.roleType + 1);
            mySelfinfoMC.x = (MainManager.getStageWidth() - mySelfinfoMC.width) / 2;
            mySelfinfoMC.y = (MainManager.getStageHeight() - mySelfinfoMC.height) / 2;
            MainManager.getAppLevel().addChild(mySelfinfoMC);
            MyUserView.getInstance().init(mySelfinfoMC);
         }
      }
      
      private static function showBlackPanle() : void
      {
         userPanel.hometown4.visible = true;
         userPanel.hometown4.enabled = false;
         userPanel.hometown.visible = false;
         userPanel.sandPostBtn.visible = false;
         userPanel.seach5.visible = true;
         userPanel.seach5.enabled = false;
         userPanel.seach.visible = false;
         userPanel.game3.visible = true;
         userPanel.game3.enabled = false;
         userPanel.game.visible = false;
         userPanel.listBlackListBtn6.visible = true;
         userPanel.listBlackListBtn6.enabled = false;
         userPanel.listBlackListBtn.visible = false;
         userPanel.addFriendBtn1.visible = true;
         userPanel.addFriendBtn1.enabled = false;
         userPanel.addFriendBtn.visible = false;
         userPanel.say7.visible = false;
         userPanel.say.visible = true;
         userPanel.say.enabled = true;
         userPanel.userInfor2.visible = false;
         userPanel.userInfor.visible = true;
         userPanel.userInfor.enabled = true;
         userPanel.delBtn1.visible = false;
         userPanel.delBtn.visible = false;
         userPanel.say.addEventListener(MouseEvent.CLICK,sayClickHandler);
         userPanel.userInfor.addEventListener(MouseEvent.CLICK,dataListBtnClick);
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,drag_start);
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_UP,drag_stop);
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,drag_move);
         userPanel.lookFriendCloseBtn.addEventListener(MouseEvent.CLICK,lookFriendCloseBtnHandle);
      }
      
      private static function getUser() : void
      {
         if(serID != GV.serverID + 1)
         {
            userPanel.game3.visible = true;
            userPanel.game3.enabled = false;
            userPanel.game.visible = false;
            if(userInfo.Status == 3 && serID != 10000)
            {
               userPanel.seach5.visible = false;
               userPanel.seach.visible = true;
               userPanel.seach.enabled = true;
            }
            else if(serID == 0 && userInfo.MapID != 0)
            {
               userPanel.seach5.visible = false;
               userPanel.seach.visible = true;
               userPanel.seach.enabled = true;
               userPanel.game.visible = true;
               userPanel.game3.visible = false;
               userPanel.game3.enabled = false;
            }
            else
            {
               userPanel.seach5.visible = true;
               userPanel.seach5.enabled = false;
               userPanel.seach.visible = false;
            }
         }
         else if(userInfo.Status == 3)
         {
            userPanel.game3.visible = true;
            userPanel.game3.enabled = false;
            userPanel.game.visible = false;
            userPanel.seach5.visible = false;
            userPanel.seach.visible = true;
            userPanel.seach.enabled = true;
         }
         else
         {
            userPanel.game.visible = true;
            userPanel.game.enabled = true;
            userPanel.game3.visible = false;
            userPanel.seach5.visible = true;
            userPanel.seach5.enabled = false;
            userPanel.seach.visible = false;
         }
         userPanel.hometown4.visible = false;
         userPanel.hometown.visible = true;
         userPanel.hometown.enabled = true;
         userPanel.listBlackListBtn6.visible = true;
         userPanel.listBlackListBtn6.enabled = false;
         userPanel.listBlackListBtn.visible = true;
         userPanel.listBlackListBtn.enabled = true;
         userPanel.listBlackListBtn.addEventListener(MouseEvent.CLICK,listOtherPeoBlackList);
         userPanel.say7.visible = false;
         userPanel.say.visible = true;
         userPanel.say.enabled = true;
         userPanel.userInfor2.visible = false;
         userPanel.userInfor.visible = true;
         userPanel.userInfor.enabled = true;
         userPanel.addFriendBtn1.visible = false;
         userPanel.delBtn1.visible = false;
         userPanel.delBtn.enabled = true;
         userPanel.delBtn.visible = true;
         userPanel.addFriendBtn.visible = false;
         userPanel.game.addEventListener(MouseEvent.CLICK,shouPlayGamePanel);
         userPanel.seach.addEventListener(MouseEvent.CLICK,searchHandler);
         userPanel.delBtn.addEventListener(MouseEvent.CLICK,delBtnFriendHandler);
         userPanel.hometown.addEventListener(MouseEvent.CLICK,homeHandler);
         userPanel.userInfor.addEventListener(MouseEvent.CLICK,dataListBtnClick);
         userPanel.say.addEventListener(MouseEvent.CLICK,sayClickHandler);
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,drag_start);
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_UP,drag_stop);
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,drag_move);
         userPanel.lookFriendCloseBtn.addEventListener(MouseEvent.CLICK,lookFriendCloseBtnHandle);
      }
      
      public static function getUserInfo() : void
      {
         userPanel.hometown4.visible = true;
         userPanel.hometown4.enabled = false;
         userPanel.hometown.visible = false;
         userPanel.seach5.visible = true;
         userPanel.seach5.enabled = false;
         userPanel.seach.visible = false;
         userPanel.hometown4.visible = false;
         userPanel.hometown.visible = true;
         userPanel.hometown.enabled = true;
         userPanel.game3.visible = true;
         userPanel.game3.enabled = false;
         userPanel.game.visible = false;
         userPanel.say7.visible = false;
         userPanel.say.visible = true;
         userPanel.say.enabled = true;
         userPanel.userInfor2.visible = false;
         userPanel.userInfor.visible = true;
         userPanel.userInfor.enabled = true;
         userPanel.delBtn1.visible = false;
         userPanel.delBtn.visible = false;
         userPanel.addFriendBtn.visible = true;
         userPanel.addFriendBtn.enabled = true;
         userPanel.addFriendBtn1.visible = false;
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,drag_start);
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_UP,drag_stop);
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,drag_move);
         if(checkBlackList(userID))
         {
            userPanel.listBlackListBtn.visible = false;
            userPanel.listBlackListBtn6.visible = true;
            userPanel.listBlackListBtn6.enabled = true;
         }
         else
         {
            userPanel.listBlackListBtn.visible = true;
            userPanel.listBlackListBtn.enabled = true;
            userPanel.listBlackListBtn.addEventListener(MouseEvent.CLICK,listOtherPeoBlackList);
         }
         userPanel.say.addEventListener(MouseEvent.CLICK,sayClickHandler);
         userPanel.addFriendBtn.addEventListener(MouseEvent.CLICK,shouUserPanel);
         userPanel.userInfor.addEventListener(MouseEvent.CLICK,dataListBtnClick);
         userPanel.lookFriendCloseBtn.addEventListener(MouseEvent.CLICK,lookFriendCloseBtnHandle);
         userPanel.hometown.addEventListener(MouseEvent.CLICK,homeHandler);
      }
      
      public static function searchHandler(e:*) : void
      {
         var serverName:String = null;
         var flag:Boolean = false;
         var str:String = null;
         var mapinfo:MapInfo = null;
         var msg:String = null;
         var msgs:String = null;
         var msga:String = null;
         var serName:String = null;
         var serID:String = null;
         var msgd:String = null;
         if(serID > 0)
         {
            serverName = GV.serverArrs[serID - 1];
         }
         var mapID:int = int(userInfo.MapID);
         if(GV.serverID == serID || serID == 0)
         {
            if(userInfo.Status == 0)
            {
               if(userInfo.MapID != LocalUserInfo.getMapID())
               {
                  if(!MapsConfig.MapsInfo[userInfo.MapID])
                  {
                     flag = false;
                  }
                  else
                  {
                     flag = Boolean(MapsConfig.MapsInfo[userInfo.MapID].isLamuWorld);
                  }
                  if(flag)
                  {
                     str = "你的好友正在拉姆縮小世界,你不能直接過去。";
                     GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     return;
                  }
                  if(userInfo.MapID == 117 || userInfo.MapID == 118 || userInfo.MapID == 66)
                  {
                     str = "目前這裡只有超級拉姆才享受優先進入權哦！等段時間再邀請朋友吧。";
                     GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     return;
                  }
                  if(userInfo.MapID == 64)
                  {
                     str = "您的好友正在騎士秘密基地，你不能直接過去！";
                     GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     return;
                  }
                  if(userInfo.MapID == 102 || userInfo.MapID == 103 || userInfo.MapID == 104)
                  {
                     str = "非常抱歉，你的朋友離你太遠了，你沒辦法穿越時光到它身邊哦！";
                     GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     return;
                  }
                  if(userInfo.MapID >= 120 && userInfo.MapID <= 135)
                  {
                     str = "嘿，你朋友正在" + MapsConfig.MapsInfo[userInfo.MapID].note + "很危險，不能直接過去！";
                     GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     return;
                  }
                  if(userInfo.MapID == 82)
                  {
                     str = "你的好友正在秘密流星花園，你不能直接過去！";
                     GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     return;
                  }
                  if(Boolean(userInfo.isNewUserMap))
                  {
                     str = "你的好友正在新手場景，你不能直接過去！";
                     GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     return;
                  }
                  if(userInfo.MapID == 148)
                  {
                     str = "你的朋友正在參與菲力的餐廳體驗,你不能直接過去！";
                     GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     return;
                  }
                  mapinfo = MapInfo.getMapInfo(userInfo.MapID,LocalUserInfo.getMapType());
                  if(Boolean(mapinfo.isHSL))
                  {
                     str = "嘿，你朋友正在" + MapsConfig.MapsInfo[userInfo.MapID].note + "很危險，不能直接過去！";
                     GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     return;
                  }
                  if(userInfo.MapID == 172 || userInfo.MapID == 173 || userInfo.MapID == 174)
                  {
                     str = "嘿，你朋友正在" + MapsConfig.MapsInfo[userInfo.MapID].note + "，不能直接過去！";
                     GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     return;
                  }
                  if(mapinfo.digTreasureId > 0)
                  {
                     str = "你的好友正在地下城探險呢，快點過去找他吧！";
                     myAle = GF.showAlert(GV.MC_AppLever,str,"",100,"iknow",true,false,"E");
                     myAle.addEventListener(Alert.CLICK_ + "1",gotoMAPFun,false,0,true);
                     return;
                  }
                  msg = "";
                  if(userInfo.MapID > GV.TwentyBillion)
                  {
                     msg = "您的好友" + userInfo.Nick + "(" + userInfo.UserID + ")" + "\r正在家園.";
                  }
                  else if(userInfo.MapType == 1)
                  {
                     msg = "您的好友" + userInfo.Nick + "(" + userInfo.UserID + ")" + "\r正在班級.";
                  }
                  else if(userInfo.MapType == 2)
                  {
                     msg = "您的好友" + userInfo.Nick + "(" + userInfo.UserID + ")" + "\r正在牧場.";
                  }
                  else if(userInfo.MapType == 31)
                  {
                     msg = "您的好友" + userInfo.Nick + "(" + userInfo.UserID + ")" + "\r正在米勒街區店鋪.";
                  }
                  else if(userInfo.MapType == 33)
                  {
                     msg = "您的好友" + userInfo.Nick + "(" + userInfo.UserID + ")" + "\r正在藏寶閣.";
                  }
                  else
                  {
                     msg = "您的好友" + userInfo.Nick + "(" + userInfo.UserID + ")" + "\r正在" + (Boolean(MapsConfig.MapsInfo[mapID]) ? MapsConfig.MapsInfo[mapID].note : "小屋") + ".";
                  }
                  myAle = Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"go,notgo",true,false,"A");
                  myAle.addEventListener(Alert.CLICK_ + "1",nextMAPFun,false,0,true);
               }
               else
               {
                  msgs = "您的好友" + userInfo.Nick + "(" + userInfo.UserID + ")" + "\r就在您的身邊哦。";
                  myAle = Alert.showAlert(MainManager.getAppLevel(),msgs,"",Alert.CHANG_ALERT,"sure",true,false,"A");
               }
            }
            else
            {
               msga = "您的好友" + userInfo.Nick + "(" + userInfo.UserID + ")" + "\r正在遊戲中。";
               myAle = Alert.showAlert(MainManager.getAppLevel(),msga,"",Alert.CHANG_ALERT,"sure",true,false,"A");
            }
         }
         else if(userInfo.Status == 3)
         {
            serName = ServerListManager.getServerName(String(serID));
            serID = String(serID) + ".";
            msgd = "您的好友" + userInfo.Nick + "(" + userInfo.UserID + ")" + "\r正在" + serID + serName + "伺服器";
            myAle = Alert.showAlert(MainManager.getAppLevel(),msgd,"",Alert.CHANG_ALERT,"sure",true,false,"A");
         }
      }
      
      public static function gotoMAPFun(e:*) : void
      {
         myAle.removeEventListener(Alert.CLICK_ + "1",gotoMAPFun);
         if(userInfo.MapID != LocalUserInfo.getMapID())
         {
            LocalUserInfo.setMapID(0);
            GV.Room_DefaultRoomID = 0;
            GF.switchMap(184,true);
         }
      }
      
      public static function nextMAPFun(e:*) : void
      {
         myAle.removeEventListener(Alert.CLICK_ + "1",nextMAPFun);
         if(userInfo.MapID != LocalUserInfo.getMapID())
         {
            switchMapLogic.switchMapLogicHandler(userInfo.MapID,true,userInfo.MapType);
         }
      }
      
      private static function addFriend(evt:*) : void
      {
         if(evt.EventObj.Type == 604)
         {
            if(evt.EventObj.ICON == 1)
            {
               if(!MainManager.getGlobalObject().data.FriendsList)
               {
                  MainManager.getGlobalObject().data.FriendsList = new Array();
               }
               if(checkUser(evt.EventObj.UserID))
               {
                  MainManager.getGlobalObject().data.ServerFriendsList.push({
                     "friend":evt.EventObj.UserID,
                     "time":0
                  });
                  MainManager.getGlobalObject().data.FriendsList.push({
                     "Vip":-1,
                     "Color":0,
                     "UserID":evt.EventObj.UserID,
                     "time":-1,
                     "type":evt.EventObj.Type,
                     "map":evt.EventObj.Map,
                     "Nick":evt.EventObj.Nike,
                     "icon":evt.EventObj.ICON,
                     "schema":evt.EventObj.Schema,
                     "infoMsgLen":evt.EventObj.InfoMsgLen,
                     "infoMsg":evt.EventObj.InfoMsg
                  });
                  MainManager.getGlobalObject().flush();
                  GV.onlineSocket.dispatchEvent(new EventTaomee(ADDFRIEND_SUCCESS));
               }
            }
            else
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee(ADDFRIEND_FAIL));
            }
         }
      }
      
      private static function homeHandler(event:MouseEvent) : void
      {
         if(GV.MapInfo_mapID < 1000)
         {
            GV.MyInfo_PrevMap = GV.MapInfo_mapID;
         }
         if(GV.MapInfo_mapID != userID + GV.TwentyBillion)
         {
            GV.Room_DefaultRoomID = userID + GV.TwentyBillion;
            switchMapLogic.switchMapLogicHandler(userID + GV.TwentyBillion);
         }
      }
      
      private static function shouPlayGamePanel(event:MouseEvent) : void
      {
         var mapName_num:int = 0;
         var msgs:String = null;
         if(userInfo.Status == 0)
         {
            if(!MainManager.getAppLevel().getChildByName("game_mc"))
            {
               game = UIManager.getClass("playGame_mc");
               game_mc = new game();
               game_mc.name = "game_mc";
               MainManager.getAppLevel().addChild(game_mc);
               game_mc.x = (MainManager.getStageWidth() - game_mc.width) / 2;
               game_mc.y = (MainManager.getStageHeight() - game_mc.height) / 2;
            }
            game_mc.playGame_txt.autoSize = TextFieldAutoSize.CENTER;
            game_mc.playGame_txt.wordWrap = true;
            game_mc.playGame_txt.multiline = true;
            mapName_num = int(LocalUserInfo.getMapID());
            if(LocalUserInfo.getMapID() > GV.TwentyBillion)
            {
               game_mc.playGame_txt.text = "是否邀請" + userInfo.Nick + "(" + userID + ")" + "到\r家園";
            }
            else if(LocalUserInfo.getMapType() == 1)
            {
               game_mc.playGame_txt.text = "是否邀請" + userInfo.Nick + "(" + userID + ")" + "到\r班級";
            }
            else if(LocalUserInfo.getMapType() == 2)
            {
               game_mc.playGame_txt.text = "是否邀請" + userInfo.Nick + "(" + userID + ")" + "到\r牧場";
            }
            else if(LocalUserInfo.getMapType() == 31)
            {
               game_mc.playGame_txt.text = "是否邀請" + userInfo.Nick + "(" + userID + ")" + "到\r米勒街區店鋪";
            }
            else
            {
               game_mc.playGame_txt.text = "是否邀請" + userInfo.Nick + "(" + userID + ")" + "到\r" + (Boolean(MapsConfig.MapsInfo[mapName_num]) ? MapsConfig.MapsInfo[mapName_num].note : "小屋");
            }
            game_mc.gamemc.addEventListener(MouseEvent.MOUSE_DOWN,gameDrag);
            game_mc.gamemc.addEventListener(MouseEvent.MOUSE_UP,gameStopDrag);
            game_mc.playconfirmBtn.addEventListener(MouseEvent.CLICK,playconfirmHandler);
            game_mc.playcancelBtn.addEventListener(MouseEvent.CLICK,playcancelHandler);
            GC.stopAllMC(game_mc);
         }
         else
         {
            msgs = "您的好友" + userInfo.Nick + "(" + userInfo.UserID + ")" + "\r正在遊戲中。";
            myAle = Alert.showAlert(MainManager.getAppLevel(),msgs,"",Alert.CHANG_ALERT,"sure",true,false,"C");
         }
      }
      
      private static function shouUserPanel(event:MouseEvent) : void
      {
         if(MainManager.getGlobalObject().data.ServerFriendsList.length >= LocalUserInfo.friendsLimitNum())
         {
            Alert.showAlert(MainManager.getAppLevel(),"你的好友已經到達上限!","",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
         else
         {
            if(!MainManager.getAppLevel().getChildByName("requset_mc"))
            {
               requset_mc = UIManager.getClass("requestUserPanel_MC");
               requestUser_mc = new requset_mc();
               requestUser_mc.name = "requset_mc";
               MainManager.getAppLevel().addChild(requestUser_mc);
               requestUser_mc.x = (MainManager.getStageWidth() - requestUser_mc.width) / 2;
               requestUser_mc.y = (MainManager.getStageHeight() - requestUser_mc.height) / 2;
            }
            requestUser_mc.addfriend_txt.wordWrap = true;
            requestUser_mc.addfriend_txt.text = "你要加" + userInfo.Nick + "(" + userID + ")" + "為好友?";
            requestUser_mc.friend_mc.addEventListener(MouseEvent.MOUSE_DOWN,friendDrag);
            requestUser_mc.friend_mc.addEventListener(MouseEvent.MOUSE_UP,friendStopDrag);
            requestUser_mc.confirmBtn.addEventListener(MouseEvent.CLICK,reqUsrConfir);
            requestUser_mc.cancelBtn.addEventListener(MouseEvent.CLICK,reqUsrCancel);
            GC.stopAllMC(requestUser_mc);
         }
      }
      
      private static function checkFriend(id:int) : int
      {
         var i:int = 0;
         var friendBoo:int = 0;
         if(id == LocalUserInfo.getUserID())
         {
            return 1;
         }
         for(var j:int = 0; j < blackListObj.countArr.length; j++)
         {
            if(id == blackListObj.countArr[j].UserID)
            {
               return 2;
            }
         }
         if(MainManager.getGlobalObject().data.ServerFriendsList != null)
         {
            for(i = 0; i < MainManager.getGlobalObject().data.ServerFriendsList.length; i++)
            {
               if(MainManager.getGlobalObject().data.ServerFriendsList[i].friend == id)
               {
                  return 3;
               }
            }
         }
         return friendBoo;
      }
      
      private static function dataListBtnClick(event:MouseEvent) : void
      {
         var exp1:Number = NaN;
         var exp2:Number = NaN;
         trace("顯示個人資料",userInfo.Vip,userInfo.Vip & 4);
         var date:Date = new Date(Number(userInfo.Birthday) * 1000);
         if(!MainManager.getAppLevel().getChildByName("infoMC"))
         {
            infoMC = UIManager.getClass("userInfo");
            infoClass = new infoMC();
            infoClass.name = "infoMC";
            infoClass.icon_mc.gotoAndStop(userInfo.roleType + 1);
            MainManager.getAppLevel().addChild(infoClass);
         }
         var gloryIcoArray:Array = [];
         infoClass.icon_mc.gotoAndStop(userInfo.roleType + 1);
         infoClass.x = userPanel.x + 258;
         infoClass.y = userPanel.y;
         GC.stopAllMC(infoClass);
         infoClass.pen.visible = false;
         infoClass.useID.text = userID;
         infoClass.name_txt.text = userInfo.Nick;
         infoClass.name_txt.selectable = true;
         infoClass.name_txt.alwaysShowSelection = false;
         infoClass.name_txt.useRichTextClipboard = true;
         infoClass.name_txt.selectable = true;
         infoClass.useID.alwaysShowSelection = false;
         infoClass.useID.useRichTextClipboard = true;
         infoClass.useID.selectable = true;
         infoClass.mole.outline_mc.visible = false;
         var vip:uint = uint(userInfo.Vip & 1);
         var _smc:uint = uint(userInfo.Vip & 4);
         setIcon();
         if(GF.returnGM(userID))
         {
            infoClass.status_txt.text = "";
         }
         infoClass.level.text = String(GF.leve(userInfo.Exp));
         if(Number(infoClass.level.text) >= 200)
         {
            infoClass.level.text = "200";
            infoClass.Exp_txt.text = GF.getExpByLevel(200) + "/" + GF.getExpByLevel(200);
            infoClass.exp_mc.width = 60;
         }
         else
         {
            exp1 = GF.getExpByLevel(int(infoClass.level.text));
            exp2 = GF.getExpByLevel(int(infoClass.level.text) + 1);
            infoClass.Exp_txt.text = userInfo.Exp - exp1 + "/" + (exp2 - exp1);
            infoClass.exp_mc.width = (userInfo.Exp - exp1) / (exp2 - exp1) * 60;
         }
         var tempObj:Object = GF.getPeopleObj(userID);
         new prevView(infoClass.mole,userInfo.Color.toString(16),userInfo.itemArr,tempObj,false,userInfo.roleType);
         if(Boolean(userInfo.Engineer))
         {
            infoClass.Engineer_level.gotoAndStop(userInfo.Engineer + 1);
            gloryIcoArray.push(infoClass.Engineer_level);
         }
         else
         {
            infoClass.Engineer_level.gotoAndStop(1);
         }
         infoClass.planter_level.gotoAndStop(int(userInfo.planter / 5) + 1);
         infoClass.Restaurant_level.gotoAndStop(int(userInfo.Dining_level + userInfo.Dining_flag));
         infoClass.farmer_level.gotoAndStop(int(userInfo.farmer / 5) + 1);
         infoClass.year.text = date.getFullYear();
         infoClass.month.text = date.getMonth() + 1;
         infoClass.day.text = date.getDate();
         infoClass.money_txt.text = userInfo.YXQ;
         infoClass.Strong_txt.text = userInfo.Strong;
         infoClass.IQ_txt.text = userInfo.IQ;
         infoClass.Charm_txt.text = userInfo.Charm;
         infoClass.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,mySlefMouseDown);
         infoClass.drag_mc.addEventListener(MouseEvent.MOUSE_UP,mySlefMouseUp);
         infoClass.close_btn.addEventListener(MouseEvent.CLICK,closeBtnHandler);
         infoClass.king_level.gotoAndStop(PKManager.kingLevel(userInfo.Game_king) + 1);
         new MyProfession(infoClass.myprofession,userID);
         sortGloryICO(gloryIcoArray);
         honorArray = [];
         honorArray.push(infoClass.Engineer_level);
         infoClass.Engineer_level.id = honorArray.length - 1;
         honorArray.push(infoClass.king_level);
         infoClass.king_level.id = honorArray.length - 1;
         infoClass.king_level.value = userInfo.Game_king;
         honorArray.push(infoClass.planter_level);
         infoClass.planter_level.id = honorArray.length - 1;
         infoClass.planter_level.value = userInfo.planter;
         honorArray.push(infoClass.farmer_level);
         infoClass.farmer_level.id = honorArray.length - 1;
         infoClass.farmer_level.value = userInfo.farmer;
         honorArray.push(infoClass.Restaurant_level);
         infoClass.Restaurant_level.id = honorArray.length - 1;
         infoClass.Restaurant_level.value = userInfo.Dining_level;
         new MyHonor(infoClass.myhonor,LocalUserInfo.getUserID(),honorArray);
         if(Boolean(XMLInfo.otherbaseinfoArr[0][0]))
         {
            tip.tipTailDisPlayObject(infoClass.pen,XMLInfo.otherbaseinfoArr[0][0]);
         }
         if(Boolean(XMLInfo.otherbaseinfoArr[1]))
         {
            tip.tipTailDisPlayObject(infoClass.icon_1_mc,XMLInfo.otherbaseinfoArr[1]);
         }
         if(Boolean(XMLInfo.otherbaseinfoArr[2]))
         {
            tip.tipTailDisPlayObject(infoClass.icon_2_mc,XMLInfo.otherbaseinfoArr[2]);
         }
         if(Boolean(XMLInfo.otherbaseinfoArr[3]))
         {
            tip.tipTailDisPlayObject(infoClass.icon_3_mc,XMLInfo.otherbaseinfoArr[3]);
         }
         if(Boolean(XMLInfo.otherbaseinfoArr[4]))
         {
            tip.tipTailDisPlayObject(infoClass.icon_4_mc,XMLInfo.otherbaseinfoArr[4]);
         }
         if(Boolean(XMLInfo.otherbaseinfoArr[5]))
         {
            tip.tipTailDisPlayObject(infoClass.icon_5_mc,XMLInfo.otherbaseinfoArr[5]);
         }
         if(Boolean(XMLInfo.otherbaseinfoArr[6]))
         {
            tip.tipTailDisPlayObject(infoClass.icon_6_mc,XMLInfo.otherbaseinfoArr[6]);
         }
      }
      
      private static function sortGloryICO(gloryIcoArray:Array) : void
      {
         for(var i:int = 0; i < gloryIcoArray.length; i++)
         {
            gloryIcoArray[i].x = i * 30 + 79;
         }
      }
      
      private static function getPrimitiveColors(colorStr:String) : Array
      {
         var tempStr:String = null;
         var A:String = null;
         var B:String = null;
         var myObj:Object = {
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
      
      private static function listOtherPeoBlackList(event:MouseEvent) : void
      {
         if(!MainManager.getAppLevel().getChildByName("addBlackList"))
         {
            addBlackList = UIManager.getClass("addBlackList_MC");
            addBlackList_mc = new addBlackList();
            addBlackList_mc.name = "addBlackList";
            MainManager.getAppLevel().addChild(addBlackList_mc);
            addBlackList_mc.x = (MainManager.getStageWidth() - addBlackList_mc.width) / 2;
            addBlackList_mc.y = (MainManager.getStageHeight() - addBlackList_mc.height) / 2;
         }
         GC.stopAllMC(addBlackList_mc);
         addBlackList_mc.addBlackList_txt.wordWrap = true;
         addBlackList_mc.addBlackList_txt.text = "你要把" + userInfo.Nick + "(" + userID + ")" + "拉入黑名單嗎？";
         addBlackList_mc.addBlackListConfirm.addEventListener(MouseEvent.CLICK,addBlackListConfirmHandler);
         addBlackList_mc.addBlackListCance.addEventListener(MouseEvent.CLICK,addBlackListCanceHandler);
         addBlackList_mc.addBlack_mc.addEventListener(MouseEvent.MOUSE_DOWN,addBlack_mcDrag);
         addBlackList_mc.addBlack_mc.addEventListener(MouseEvent.MOUSE_UP,addBlack_mcStopDrag);
      }
      
      private static function sayClickHandler(event:MouseEvent) : void
      {
         var impeach:Impeach = new Impeach(userID,nike);
         impeach = null;
      }
      
      private static function addBlackListConfirmHandler(event:MouseEvent) : void
      {
         if(addBlackListReq == null)
         {
            addBlackListReq = new AddBlackListReq();
            addBlackListReq.addBlackList(userID);
         }
         else
         {
            addBlackListReq.addBlackList(userID);
         }
         addBlackListReq = null;
         if(MoleSharedObject.moleObj.BlackList == null)
         {
            MoleSharedObject.moleObj.BlackList = new Array();
         }
         MoleSharedObject.moleObj.BlackList.push(userID);
         event.target.parent.parent.removeChild(event.target.parent);
         addBlackList_mc.addBlackListConfirm.removeEventListener(MouseEvent.CLICK,addBlackListConfirmHandler);
         delfriendConfirm();
         var mc:MovieClip = MainManager.getAppLevel().getChildByName("friendMC") as MovieClip;
         if(!(!mc && !GV.isChangeMap))
         {
            FView.delFriendSuccess(null);
         }
      }
      
      private static function addBlackListCanceHandler(event:MouseEvent) : void
      {
         event.target.parent.parent.removeChild(event.target.parent);
         addBlackList_mc.addBlackListCance.removeEventListener(MouseEvent.CLICK,addBlackListCanceHandler);
      }
      
      private static function checkBlackList(id:int) : Boolean
      {
         var blackListBool:Boolean = false;
         for(var j:int = 0; j < blackListObj.countArr.length; j++)
         {
            if(id == blackListObj.countArr[j].UserID)
            {
               return true;
            }
         }
         return blackListBool;
      }
      
      private static function blackListCanceHandler(event:MouseEvent) : void
      {
         event.target.parent.parent.removeChild(event.target.parent);
      }
      
      private static function delBtnFriendHandler(event:MouseEvent) : void
      {
         if(!MainManager.getAppLevel().getChildByName("delFriendPanle"))
         {
            delFriendPanle = UIManager.getClass("DelFriend_MC");
            delFriendPanle_mc = new delFriendPanle();
            delFriendPanle_mc.name = "delFriendPanle";
            MainManager.getAppLevel().addChild(delFriendPanle_mc);
            delFriendPanle_mc.x = (MainManager.getStageWidth() - delFriendPanle_mc.width) / 2;
            delFriendPanle_mc.y = (MainManager.getStageHeight() - delFriendPanle_mc.height) / 2;
         }
         delFriendPanle_mc.delfriend_txt.wordWrap = true;
         delFriendPanle_mc.delfriend_txt.text = "確認要刪除" + userInfo.Nick + "(" + userID + ")" + "好友嗎?";
         delFriendPanle_mc.del_mc.addEventListener(MouseEvent.MOUSE_DOWN,delDrag);
         delFriendPanle_mc.del_mc.addEventListener(MouseEvent.MOUSE_UP,delStopDrag);
         delFriendPanle_mc.confirmBtn.addEventListener(MouseEvent.CLICK,delfriendConfirm);
         delFriendPanle_mc.cancelBtn.addEventListener(MouseEvent.CLICK,delfriendCancel);
         GC.stopAllMC(delFriendPanle_mc);
      }
      
      private static function delfriendConfirm(event:MouseEvent = null) : void
      {
         var j:int = 0;
         if(event != null)
         {
            if(delFrendReq == null)
            {
               delFrendReq = new DelFrendReq();
               delFrendReq.delfrend(userID);
            }
            else
            {
               delFrendReq.delfrend(userID);
            }
            delFrendReq = null;
            event.target.parent.parent.removeChild(event.target.parent);
         }
         lookFriendCloseBtnHandle();
         if(MainManager.getGlobalObject().data.ServerFriendsList != null)
         {
            for(j = 0; j < MainManager.getGlobalObject().data.ServerFriendsList.length; j++)
            {
               if(MainManager.getGlobalObject().data.ServerFriendsList[j].friend == userID)
               {
                  MainManager.getGlobalObject().data.ServerFriendsList.splice(j,1);
                  MainManager.getGlobalObject().flush();
                  break;
               }
            }
         }
      }
      
      private static function lookFriendCloseBtnHandle(event:MouseEvent = null) : void
      {
         userPanel.parent.removeChild(userPanel);
         userPanel.delBtn.removeEventListener(MouseEvent.CLICK,delBtnFriendHandler);
         userPanel.userInfor.removeEventListener(MouseEvent.CLICK,dataListBtnClick);
         userPanel.listBlackListBtn.removeEventListener(MouseEvent.CLICK,listOtherPeoBlackList);
         userPanel.lookFriendCloseBtn.removeEventListener(MouseEvent.CLICK,lookFriendCloseBtnHandle);
         userPanel.game.removeEventListener(MouseEvent.CLICK,shouPlayGamePanel);
         userPanel.seach.removeEventListener(MouseEvent.CLICK,searchHandler);
         GV.onlineSocket.removeEventListener(GetBlackListRes.GET_BLACKLIST,getBlackHandler);
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,getSenceUserInfor);
      }
      
      private static function delfriendCancel(event:MouseEvent) : void
      {
         event.target.parent.parent.removeChild(event.target.parent);
      }
      
      private static function reqUsrConfir(event:MouseEvent) : void
      {
         var addfriendObj:Object = null;
         if(userID > GV.userIDLimit)
         {
            addfriendObj = new Object();
            addfriendObj.msg = "不能加遊客為好友。";
         }
         else
         {
            addFrendsReq = new AddFrendsReq();
            addFrendsReq.addFrends(userID);
            addFrendsReq = null;
         }
         event.target.parent.parent.removeChild(event.target.parent);
      }
      
      private static function playconfirmHandler(event:MouseEvent) : void
      {
         var requestFriendToRoomReq:RequestFriendToRoomReq = null;
         if(userInfo.MapID != LocalUserInfo.getMapID())
         {
            requestFriendToRoomReq = new RequestFriendToRoomReq();
            requestFriendToRoomReq.requestFriendToRoom(userID,LocalUserInfo.getMapID(),LocalUserInfo.getMapType());
            BufferManager.addBufferEvent(BufferManager.KFCTASKFIVE,KFCFiveHandle);
            BufferManager.getBuffer(BufferManager.KFCTASKFIVE);
         }
         event.target.parent.parent.removeChild(event.target.parent);
         game_mc.playconfirmBtn.removeEventListener(MouseEvent.CLICK,playconfirmHandler);
      }
      
      private static function KFCFiveHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFCTASKFIVE,KFCFiveHandle);
         var times:uint = uint(e.EventObj);
         if(times == 0)
         {
            trace("沒有，完成過KFC的對話");
         }
         else
         {
            trace("完成過KFC的對話");
            BufferManager.setBuffer(BufferManager.KFCINVITED,1);
         }
         BufferManager.addBufferEvent(BufferManager.OPENTART,openTartHandle);
         BufferManager.getBuffer(BufferManager.OPENTART);
      }
      
      private static function openTartHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.OPENTART,openTartHandle);
         var times:uint = uint(e.EventObj);
         if(times >= 3)
         {
            BufferManager.addBufferEvent(BufferManager.TARTINVITED,tarInvited);
            BufferManager.getBuffer(BufferManager.TARTINVITED);
         }
      }
      
      private static function tarInvited(e:EventTaomee) : void
      {
         var invitedTimes:uint = uint(e.EventObj);
         BufferManager.setBuffer(BufferManager.TARTINVITED,invitedTimes++);
         if(TaskManager.getTask(585).state == 1 && TaskManager.getTask(585).getBit(3))
         {
            if(invitedTimes >= 3)
            {
               TaskManager.overTask(585);
               StatisticsManager.send(231);
               Alert.smileAlart("恭喜你已成為優秀小店員啦，可獲得1500摩爾豆/月的薪資喲。");
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 1500);
            }
         }
      }
      
      private static function playcancelHandler(event:MouseEvent) : void
      {
         event.target.parent.parent.removeChild(event.target.parent);
         game_mc.playcancelBtn.removeEventListener(MouseEvent.CLICK,playcancelHandler);
      }
      
      private static function reqUsrCancel(event:MouseEvent) : void
      {
         event.target.parent.parent.removeChild(event.target.parent);
      }
      
      private static function reqPlayGameConfir(event:MouseEvent) : void
      {
         event.target.parent.parent.removeChild(event.target.parent);
      }
      
      private static function refuseConfirm(event:MouseEvent) : void
      {
         event.target.parent.parent.removeChild(event.target.parent);
      }
      
      private static function refuseCancel(event:MouseEvent) : void
      {
         event.target.parent.parent.removeChild(event.target.parent);
      }
      
      private static function reqPlayGameCancel(event:MouseEvent) : void
      {
         event.target.parent.parent.removeChild(event.target.parent);
      }
      
      private static function closeBtnHandler(event:MouseEvent) : void
      {
         infoClass.parent.removeChild(infoClass);
         infoClass.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,mySlefMouseDown);
         infoClass.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,mySlefMouseUp);
         infoClass.close_btn.removeEventListener(MouseEvent.CLICK,closeBtnHandler);
      }
      
      private static function mySlefMouseDown(event:MouseEvent) : void
      {
         GF.setDrag(infoClass);
      }
      
      private static function mySlefMouseUp(event:MouseEvent) : void
      {
         GF.stopDrag(infoClass);
      }
      
      private static function delDrag(evt:MouseEvent) : void
      {
         GF.setDrag(delFriendPanle_mc);
      }
      
      private static function delStopDrag(evt:MouseEvent) : void
      {
         GF.stopDrag(delFriendPanle_mc);
      }
      
      private static function addBlack_mcDrag(evt:MouseEvent) : void
      {
         GF.setDrag(addBlackList_mc);
      }
      
      private static function addBlack_mcStopDrag(evt:MouseEvent) : void
      {
         GF.stopDrag(addBlackList_mc);
      }
      
      private static function gameDrag(evt:MouseEvent) : void
      {
         GF.setDrag(game_mc);
      }
      
      private static function gameStopDrag(evt:MouseEvent) : void
      {
         GF.stopDrag(game_mc);
      }
      
      private static function black_mcDrag(evt:MouseEvent) : void
      {
         GF.setDrag(listBlackList_mc);
      }
      
      private static function black_mcStopDrag(evt:MouseEvent) : void
      {
         GF.stopDrag(listBlackList_mc);
      }
      
      private static function friendDrag(evt:MouseEvent) : void
      {
         GF.setDrag(requestUser_mc);
      }
      
      private static function friendStopDrag(evt:MouseEvent) : void
      {
         GF.stopDrag(requestUser_mc);
      }
      
      private static function gamemove(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      private static function drag_start(evt:MouseEvent) : void
      {
         GF.setDrag(userPanel);
      }
      
      private static function drag_stop(evt:MouseEvent) : void
      {
         GF.stopDrag(userPanel);
      }
      
      private static function drag_move(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      private static function sandPostFun(eve:MouseEvent) : void
      {
         postcardLogic.setOpen_Flag(1);
         postcardLogic.setIDArr(userID);
         postcardLogics.addCardUI();
      }
      
      private static function isNPC(id:int) : Boolean
      {
         if(id > 1999 && id < 10000 && GV.MapInfo_mapID != 35)
         {
            return true;
         }
         return false;
      }
      
      private static function showNpcPanelView() : void
      {
         userPanel.nikeName.text = "";
         userPanel.seach5.enabled = false;
         userPanel.seach5.visible = true;
         userPanel.seach.visible = false;
         userPanel.hometown4.enabled = false;
         userPanel.hometown4.visible = true;
         userPanel.hometown.visible = false;
         userPanel.game3.enabled = false;
         userPanel.game3.visible = true;
         userPanel.game.visible = false;
         userPanel.say7.enabled = false;
         userPanel.say7.visible = true;
         userPanel.say.visible = false;
         userPanel.userInfor2.enabled = false;
         userPanel.userInfor2.visible = true;
         userPanel.userInfor.visible = false;
         userPanel.delBtn1.enabled = false;
         userPanel.delBtn1.visible = true;
         userPanel.delBtn.visible = false;
         userPanel.addFriendBtn.visible = false;
         userPanel.addFriendBtn1.visible = true;
         userPanel.addFriendBtn1.enabled = false;
         userPanel.listBlackListBtn.visible = false;
         userPanel.listBlackListBtn6.visible = true;
         userPanel.listBlackListBtn6.enabled = false;
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,drag_start);
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_UP,drag_stop);
         userPanel.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,drag_move);
         userPanel.lookFriendCloseBtn.addEventListener(MouseEvent.CLICK,lookFriendCloseBtnHandle);
      }
      
      private static function setIcon() : void
      {
         while(infoClass.icon_mc.numChildren > 1)
         {
            infoClass.icon_mc.removeChildAt(infoClass.icon_mc.numChildren - 1);
         }
         setIconMcHandler(10);
         for(var i:int = 2; i >= 0; i--)
         {
            if(Boolean(userInfo.Vip >> i & 1))
            {
               setIconMcHandler(i);
            }
         }
      }
      
      private static function setIconMcHandler(num:int) : void
      {
         var mc:MovieClip = null;
         switch(num)
         {
            case 0:
               mc = addChildMC("slIcon");
               if(Boolean(XMLInfo.otherbaseinfoArr[7]))
               {
                  tip.tipTailDisPlayObject(mc,XMLInfo.otherbaseinfoArr[7]);
               }
               break;
            case 1:
               break;
            case 2:
               infoClass.icon_mc.removeChildAt(0);
               mc = addChildMC("smcIcon");
               if(Boolean(XMLInfo.otherbaseinfoArr[8]))
               {
                  tip.tipTailDisPlayObject(mc,XMLInfo.otherbaseinfoArr[8]);
               }
               break;
            default:
               mc = infoClass.icon_mc.getChildAt(0);
               if(Boolean(mc) && Boolean(XMLInfo.otherbaseinfoArr[9]))
               {
                  tip.tipTailDisPlayObject(mc,XMLInfo.otherbaseinfoArr[9]);
               }
         }
      }
      
      private static function addChildMC(str:String) : MovieClip
      {
         var tempClass:Class = UIManager.getClass(str) as Class;
         var iconMC:MovieClip = new tempClass();
         var num:int = int(infoClass.icon_mc.numChildren);
         iconMC.x = num * 17 + num * 3;
         infoClass.icon_mc.addChild(iconMC);
         return iconMC;
      }
   }
}

