package
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.msgHead.MsgHead;
   import com.common.tip.npcTip;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.manager.IndexManager;
   import com.core.socketlogic.baseSocket.MoleSocket;
   import com.core.socketlogic.baseSocket.ProxySocket;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.interfaces.ExtendsInterface;
   import com.mole.net.MoleSharedObject;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class GF
   {
      
      public static var regAlert:*;
      
      public static var presec:uint;
      
      public static var nowsec:uint;
      
      public static var testSpeedTimer:Timer;
      
      public static var clearPeoples:Function;
      
      public static var getPeopleByID:Function;
      
      public static var LOAD_OVER:String = "load_over";
      
      public static var LOAD_FAIL:String = "load_fail";
      
      public static var XML_OVER:String = "xml_over";
      
      public static var XML_FAIL:String = "xml_fail";
      
      public static var ALERT_CLICK_:String = "CLICK";
      
      public static var ALERT_CUSTOM_LOADED:String = "onLoad";
      
      public static var ALERT_CUSTOM_ADDED:String = "onAdded";
      
      public static var ALERT_COMMON:uint = Alert.COMMON_ALERT;
      
      public static var ALERT_CUSTOM:uint = Alert.CUSTOM_ALERT;
      
      public static var ALERT_RIGHT:uint = Alert.RIGHT_ALERT;
      
      public static var ALERT_WRONG:uint = Alert.WRONG_ALERT;
      
      public static var ALERT_REGISTER:uint = Alert.REGISTER_ALERT;
      
      public static var ALERT_ICO:uint = Alert.ICO_ALERT;
      
      public static var isAirBall:Boolean = false;
      
      public function GF()
      {
         super();
      }
      
      public static function showRegAlert() : void
      {
      }
      
      public static function loginGame(faceNum:Number, chairID:Number, type:Number, singleGameID:Number = 0) : *
      {
         var joingame:* = getDefinitionByName("com.logic.JoinGameLogic.JoinGameLogic");
         joingame.joinGameAction(faceNum,chairID,type,singleGameID);
         return joingame;
      }
      
      public static function leaveGame(reason:int) : void
      {
         var leaveGameReq:* = getDefinitionByName("com.logic.socket.leaveGame.LeaveGameReq");
         leaveGameReq.leaveGame(reason);
      }
      
      public static function leaveGame2(refresh:Boolean = false) : void
      {
         var leaveGameReq:* = getDefinitionByName("com.logic.socket.leaveGame.LeaveGameReq");
         var moveTo:* = getDefinitionByName("com.logic.FindPathLogic.MoveTo");
         try
         {
            leaveGameReq.leaveGame(0);
         }
         catch(E:*)
         {
         }
         GV.isSitDown = false;
         moveTo.CanMove = true;
         if(refresh)
         {
            GV.map_ManagerChange.refreshMap();
         }
      }
      
      public static function showGameSocre(data:* = null) : void
      {
         var act:* = getDefinitionByName("com.logic.GameframeLogic.GameframeLogic");
         act.getSingleResult({"EventObj":data});
      }
      
      public static function GetRandomItem(itemID:int) : void
      {
         var getRandomItemReq:* = getDefinitionByName("com.logic.socket.getRandomItem.GetRandomItemReq");
         getRandomItemReq.doAction(itemID);
      }
      
      public static function collectRandomItem(pos:int) : void
      {
         var c:* = getDefinitionByName("com.logic.socket.CollectRrandomItemLoginc.CollectRrandomItemReq");
         c.CollectRrandomItemAction(pos);
      }
      
      public static function referItem(itemID:uint) : void
      {
         var p:* = getDefinitionByName("com.logic.socket.smc.PickItem.PickItemReq");
         p.pickItem(itemID);
      }
      
      public static function forbid_guest() : Boolean
      {
         if(!MainManager.getIsMember())
         {
            if(!regAlert)
            {
               showRegAlert();
            }
            return true;
         }
         return false;
      }
      
      public static function setDrag(mc:Sprite) : void
      {
         mc.startDrag();
         if(Boolean(mc.parent.parent as Loader))
         {
            mc.parent.parent.parent.setChildIndex(mc.parent.parent,mc.parent.parent.parent.numChildren - 1);
         }
         else
         {
            mc.parent.setChildIndex(mc,mc.parent.numChildren - 1);
         }
      }
      
      public static function stopDrag(mc:Sprite) : void
      {
         mc.stopDrag();
      }
      
      public static function showAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "確定", closeB:Boolean = true, showBtn:Boolean = false, picTip:String = "A", WH:String = "298,228") : *
      {
         return Alert.showAlert(obj,title,content,style,bottomArray,closeB,showBtn,picTip,WH);
      }
      
      public static function closeAlert(instanceAleart:*, type:String = "") : void
      {
         Alert.closeAlert(instanceAleart,type);
      }
      
      public static function closeAllAlert() : void
      {
         Alert.closeAllAlert();
      }
      
      public static function showNPCtip(mc:MovieClip, msg:String) : void
      {
         npcTip.showTip(mc,msg);
      }
      
      public static function closeNPCtip(mc:MovieClip) : void
      {
         npcTip.hideTip(mc);
      }
      
      public static function delItem(itemID:uint) : void
      {
         MsgHead.Command = 508;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemID);
         tempByteArray.writeShort(1);
         writeHead(tempByteArray);
      }
      
      public static function switchToPigHouse(userId:Number) : void
      {
         switchMapDirectly(userId,false,34);
      }
      
      public static function switchToBeautyHouse(userId:Number) : void
      {
         switchMapDirectly(userId,false,35);
      }
      
      public static function switchToMachinistSquare(userId:Number) : void
      {
         switchMapDirectly(userId,false,36);
      }
      
      public static function switchMapDirectly(mapId:Number, isReset:Boolean = true, type:int = 0) : void
      {
         switchMap(mapId,true,type);
      }
      
      public static function switchMap(mapID_new:Number, isReset:Boolean = true, type:int = 0) : void
      {
         var cls:*;
         var mapinfo:MapInfo = null;
         var DragonBagSocket:* = undefined;
         var p:* = GV.MAN_PEOPLE;
         if(Boolean(p))
         {
            mapinfo = MapInfo.getMapInfo(mapID_new);
            if(Boolean(mapinfo.isHSL))
            {
               if(Boolean(p.hasAnimal))
               {
                  Alert.smileAlart("    拉姆世界很危險，你要把動物送回家，才能進入拉姆世界哦！");
                  return;
               }
               if(Boolean(p.hasCar))
               {
                  Alert.smileAlart("    拉姆世界很危險，你要把車開回家，才能進入拉姆世界哦！");
                  return;
               }
               if(Boolean(mapinfo.isLamuWorld) && Boolean(p.hasDragon) && Boolean(p.dragon_Info))
               {
                  DragonBagSocket = getDefinitionByName("com.logic.socket.dragon.DragonBagSocket");
                  DragonBagSocket.setDragonStateRequest(p.dragon_Info.ItemID,0);
                  GC.setGTimeout(function():void
                  {
                     Alert.smileAlart("    這裡是拉姆世界，你的坐騎個子太大被擠在外頭，它現在已經回到你的騎寵背包了！",null,"iknow",115);
                  },1000);
               }
            }
         }
         if(type == 1)
         {
            if(LocalUserInfo.getMapID() == mapID_new && LocalUserInfo.getMapType() == 1)
            {
               return;
            }
         }
         cls = getDefinitionByName("com.logic.switchMapLogic.switchMapLogic");
         cls.switchMapLogicHandler(mapID_new,isReset,type);
      }
      
      public static function deleteItemAction(itemID:uint = 12110) : void
      {
         trace("---------------------------刪除道具111---");
         if(!isAirBall)
         {
            ExtendsInterface.addEventListener(ExtendsInterface.Read + "508",initAction);
            isAirBall = true;
            delItem(itemID);
         }
      }
      
      private static function initAction(evt:EventTaomee) : void
      {
         ExtendsInterface.removeEventListener(ExtendsInterface.Read + "508",initAction);
         doAction(2,GV.MAN_PEOPLE.x,GV.MAN_PEOPLE.y);
         isAirBall = false;
      }
      
      public static function drawAirBall(mc:MovieClip) : void
      {
         var act:* = getDefinitionByName("com.module.airBallModule.airBallModule");
         act.drawBall(mc);
      }
      
      public static function doAction(action:int, x:int = 0, y:int = 0) : void
      {
         MsgHead.Command = CommandID.MOLESLIDE;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeShort(action);
         tempByteArray.writeShort(x);
         tempByteArray.writeShort(y);
         writeHead(tempByteArray);
      }
      
      public static function revertPeople(id:int) : void
      {
         var tempPeopleMC:* = undefined;
         try
         {
            tempPeopleMC = GF.getPeopleByID(id);
            tempPeopleMC.Action = 0;
            tempPeopleMC.scaleBody(1);
            tempPeopleMC.getVisualize(tempPeopleMC,1,0);
            tempPeopleMC.stopAction();
         }
         catch(E:*)
         {
         }
      }
      
      public static function showWordBoxMSG(msg:String, useID:Number = 0) : void
      {
         var tempMan:MovieClip = null;
         if(useID != 0)
         {
            tempMan = getPeopleByID(useID);
            if(Boolean(tempMan))
            {
               tempMan.showWordBoxMSG({"EventObj":{"msg":msg}});
            }
         }
         else
         {
            GV.MAN_PEOPLE.showWordBoxMSG({"EventObj":{"msg":msg}});
         }
      }
      
      public static function showTip(str:String = "", obj:* = null) : void
      {
         var tip_mc:* = new tip();
         tip_mc.message = str;
         tip_mc.data = obj;
         MainManager.getRootMC().addChild(tip_mc);
         if(tip_mc.x < tip_mc.width / 2)
         {
            tip_mc.x += tip_mc.width / 2 - tip_mc.x;
         }
         else if(tip_mc.x + tip_mc.width / 2 > 960 - 5)
         {
            tip_mc.x = 960 - tip_mc.width / 2 - 5;
         }
         if(tip_mc.y < 0)
         {
            tip_mc.y = 0;
         }
      }
      
      public static function clearTip() : void
      {
         tip.hideTip();
      }
      
      public static function getItemName(id:uint) : XML
      {
         var _xml:XML = null;
         var i:String = null;
         var str:String = "";
         str = "<Item";
         var itemObjre:Object = GoodsInfo.getInfoById(id);
         var itemObj:Object = copy(itemObjre);
         itemObj["ID"] = itemObj.id;
         itemObj["Name"] = itemObj.name;
         itemObj["Grade"] = itemObj.grade;
         itemObj["Price"] = itemObj.price;
         itemObj["Layer"] = itemObj.layer;
         itemObj["VipOnly"] = itemObj.vipOnly;
         itemObj["Tradability"] = itemObj.Tradability;
         for(i in itemObj)
         {
            str = str + " " + i + "=\"" + itemObj[i] + "\"";
         }
         str += "/>";
         return XML(str);
      }
      
      public static function copy(o:Object) : Object
      {
         var bytes:ByteArray = new ByteArray();
         bytes.writeObject(o);
         bytes.position = 0;
         return bytes.readObject();
      }
      
      public static function getPropData(id:uint) : Object
      {
         return GoodsInfo.getInfoById(id);
      }
      
      public static function getType(id:int) : uint
      {
         return GoodsInfo.getType(id);
      }
      
      public static function getUserInfoByID(id:int, obj:*, returnFun:Function) : void
      {
         var act1:* = getDefinitionByName("com.logic.socket.getUserBasicInfo.GetUserBasicInfoReq");
         var act2:* = getDefinitionByName("com.logic.socket.getUserBasicInfo.GetUserBasicInfoRes");
         var dogetUserInfoClass:* = new act1();
         var getUserInfoClass:* = new act2();
         BC.addEvent(obj,GV.onlineSocket,act2.GET_USER_BASIC_INFO,returnFun);
         dogetUserInfoClass.getUserBasicInfo(id);
      }
      
      public static function getPrimitiveColors(colorStr:String) : Array
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
      
      public static function getPeopleObj(userid:uint) : Object
      {
         for(var i:uint = 0; i < GV.OnLineArray.length; i++)
         {
            if(GV.OnLineArray[i].UserID == userid)
            {
               return GV.OnLineArray[i];
            }
         }
         return null;
      }
      
      public static function peopleInSameMap(userid:int) : Boolean
      {
         for(var i:int = 0; i < GV.OnLineArray.length; i++)
         {
            if(GV.OnLineArray[i].UserID == userid)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getExpByLevel(level:int) : Number
      {
         var lv:int = 0;
         var js:* = undefined;
         var baseExp:Number = NaN;
         var n:int = 0;
         var newExp:Number = NaN;
         lv = 1;
         js = 15;
         baseExp = 108900;
         n = 0;
         if(level <= 120)
         {
            while(leve(n) != level)
            {
               n += 15;
            }
         }
         else
         {
            lv = 120;
            newExp = baseExp;
            while(lv != level)
            {
               lv++;
               newExp += (lv - 105) * lv;
            }
            n = newExp;
         }
         return n;
      }
      
      public static function leve(exp:Number) : int
      {
         var lv:int = 0;
         var js:Number = NaN;
         var baseExp:* = undefined;
         var n:Number = NaN;
         lv = 1;
         js = 108900;
         if(exp < 0)
         {
            lv = 201;
         }
         else if(exp <= js)
         {
            baseExp = 15;
            while(exp >= lv * baseExp)
            {
               exp -= lv * baseExp;
               lv++;
            }
         }
         else
         {
            lv = 120;
            n = js;
            while(n <= exp && lv <= 200)
            {
               lv++;
               n += (lv - 105) * lv;
            }
         }
         return lv - 1;
      }
      
      public static function checkID(id:*) : String
      {
         var str:String = null;
         trace("id-------------斷線",id);
         for(var i:int = 0; i < GV.OnLineArray.length; i++)
         {
            if(id == GV.OnLineArray[i].UserID)
            {
               str = GV.OnLineArray[i].Nick;
               break;
            }
         }
         return str;
      }
      
      public static function checklever(targetObj:*, exp:Number) : void
      {
         var newlever:int = 0;
         var oldStep:int = 0;
         try
         {
            newlever = leve(exp);
            oldStep = LocalUserInfo.getLevel();
            trace("檢查升級:",newlever != LocalUserInfo.getLevel(),newlever);
            if(newlever != oldStep)
            {
               GV.hasNewLever = true;
            }
            LocalUserInfo.setLevel(newlever);
         }
         catch(err:Error)
         {
            trace(err);
         }
      }
      
      public static function writeHead(tempByteArr:ByteArray = null) : void
      {
         if(Boolean(GV.onlineClass))
         {
            if(tempByteArr == null)
            {
               tempByteArr = new ByteArray();
            }
            MsgHead.Result = 0;
            MsgHead.PkgLen = 17 + tempByteArr.length;
            MsgHead.UserID = LocalUserInfo.getUserID();
            GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
            GV.onlineSocket.writeByte(MsgHead.Version);
            GV.onlineSocket.writeUnsignedInt(MsgHead.Command);
            GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
            GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
            GV.onlineSocket.writeBytes(tempByteArr,0,tempByteArr.length);
            GV.onlineSocket.flush();
         }
      }
      
      public static function sendSocket(cmdID:uint, ... args) : void
      {
         var arg:* = undefined;
         var socket:ProxySocket = GV.onlineSocket;
         var byteLen:uint = 0;
         var bodyData:ByteArray = new ByteArray();
         for each(arg in args)
         {
            if(arg is String)
            {
               bodyData.writeUTFBytes(arg);
            }
            else if(arg is ByteArray)
            {
               bodyData.writeBytes(arg);
            }
            else if(arg is uint)
            {
               bodyData.writeUnsignedInt(arg);
            }
            else
            {
               bodyData.writeInt(arg);
            }
         }
         byteLen = bodyData.length + MoleSocket.HEAD_LEN;
         MsgHead.Command = cmdID;
         GF.writeHead(bodyData);
      }
      
      public static function talkAll(isMadel:Boolean = false, MadelId:uint = 101) : void
      {
         var tempByteArray:ByteArray = null;
         try
         {
            if(isMadel)
            {
               MsgHead.Command = CommandID.actions;
               tempByteArray = new ByteArray();
               tempByteArray.writeUnsignedInt(6);
               tempByteArray.writeByte(MadelId);
               writeHead(tempByteArray);
            }
            else
            {
               MsgHead.Command = 10010;
               tempByteArray = new ByteArray();
               tempByteArray.writeShort(LocalUserInfo.getLevel());
               writeHead(tempByteArray);
               MsgHead.Command = CommandID.actions;
               tempByteArray = new ByteArray();
               tempByteArray.writeUnsignedInt(5);
               tempByteArray.writeByte(0);
               writeHead(tempByteArray);
               GV.hasNewLever = false;
            }
         }
         catch(E:*)
         {
            trace(E);
         }
      }
      
      public static function showLeverUp(targetObj:*, isMadel:uint = 0) : void
      {
         var tempPeopleMC:* = undefined;
         var tempLeverup_Class:Class = null;
         var tempLeverup_mc:MovieClip = null;
         try
         {
            if(Boolean(targetObj as MovieClip))
            {
               tempPeopleMC = targetObj;
            }
            else
            {
               tempPeopleMC = GF.getPeopleByID(targetObj);
            }
            if(isMadel != 0)
            {
               tempLeverup_mc = IndexManager.getInstance().getMovieClip("madel" + isMadel + "_Action");
            }
            else
            {
               tempLeverup_mc = IndexManager.getInstance().getMovieClip("leverup_mc");
            }
            tempPeopleMC.avatarMC.shadow_mc.visible = false;
            tempPeopleMC.avatarMC.addChild(tempLeverup_mc);
         }
         catch(E:*)
         {
            trace(E);
         }
      }
      
      public static function showRemoveEffect(targetObj:*) : void
      {
         var tempPeopleMC:* = undefined;
         var tempLeverup_Class:Class = null;
         var tempLeverup_mc:MovieClip = null;
         try
         {
            if(Boolean(targetObj as MovieClip))
            {
               tempPeopleMC = targetObj;
            }
            else
            {
               tempPeopleMC = GF.getPeopleByID(targetObj);
            }
            tempLeverup_mc = IndexManager.getInstance().getMovieClip("removeEffect_mc");
            tempPeopleMC.avatarMC.shadow_mc.visible = false;
            tempPeopleMC.avatarMC.addChild(tempLeverup_mc);
         }
         catch(E:*)
         {
            trace(E);
         }
      }
      
      public static function returnGM(id:int) : Boolean
      {
         if(199989 < id && id < 200010 || 299989 < id && id < 300010 || 399989 < id && id < 400000)
         {
            return true;
         }
         return false;
      }
      
      public static function getRGBColor(num:uint) : Object
      {
         var blue:uint = uint(num & 0xFF);
         var green:uint = uint(num >> 8 & 0xFF);
         var red:uint = uint(num >> 16 & 0xFF);
         return {
            "red":red,
            "green":green,
            "blue":blue
         };
      }
      
      public static function setOffsetColor(mc:DisplayObjectContainer, color:uint) : void
      {
         var red:int = color >> 16 & 0xFF ^ -255;
         var green:int = color >> 8 & 0xFF ^ -255;
         var blue:int = color & 0xFF ^ -255;
         var tc:ColorTransform = new ColorTransform(1,1,1,1,red,green,blue,0);
         mc.transform.colorTransform = tc;
      }
      
      public static function testSpeed() : void
      {
         presec = new Date().minutes;
         testSpeedTimer = new Timer(70000);
         testSpeedTimer.addEventListener(TimerEvent.TIMER,oneSec);
         testSpeedTimer.start();
      }
      
      private static function oneSec(e:TimerEvent) : void
      {
         var noticeExitObj:Object = null;
         nowsec = new Date().minutes;
         if(presec == nowsec)
         {
            noticeExitObj = new Object();
            noticeExitObj.UserID = GV.MyInfo_userID;
            noticeExitObj.Error = "-99999999";
            GV.isDefault = true;
            GV.onlineClass.dispatchEvent(new EventTaomee("notice_exit",noticeExitObj));
            GV.onlineSocket.close();
            testSpeedTimer.stop();
            testSpeedTimer.removeEventListener(TimerEvent.TIMER,oneSec);
         }
         else
         {
            presec = nowsec;
         }
      }
      
      public static function isFireHandler() : Boolean
      {
         var popleMC:MovieClip = GF.getPeopleByID(GV.MyInfo_userID);
         var clothArr:Array = popleMC.clothsArray;
         var byte:ByteArray = popleMC.Activity;
         byte.position = 0;
         if(Boolean(byte.readUnsignedShort()))
         {
            return true;
         }
         return false;
      }
      
      public static function showMadel(ID:*) : void
      {
         var MyMadel:MovieClip = null;
         GV.hasNewMadel = ID;
         MyMadel = IndexManager.getInstance().getMovieClip("madel" + String(ID));
         MainManager.getGameLevel().addChild(MyMadel);
         GC.setGTimeout(function():void
         {
            GC.clearAll(MyMadel);
         },8000);
      }
      
      public static function getMySOValue(att:String) : *
      {
         if(Boolean(MainManager.getGlobalObject().data.sovalue))
         {
            if(Boolean(MainManager.getGlobalObject().data.sovalue["mole" + att]))
            {
               return MainManager.getGlobalObject().data.sovalue["mole" + att];
            }
         }
         return null;
      }
      
      public static function setMySOValue(att:String, value:*) : void
      {
         if(!Boolean(MainManager.getGlobalObject().data.sovalue))
         {
            MainManager.getGlobalObject().data.sovalue = new Object();
         }
         MainManager.getGlobalObject().data.sovalue["mole" + att] = value;
      }
      
      public static function updateLocalGameHighScore(gameid:String, score:uint) : void
      {
         trace("---updateLocalGameHighScore----------",gameid,score);
         if(Boolean(MainManager.getGlobalObject().data.HighScoreObj))
         {
            if(Boolean(MainManager.getGlobalObject().data.HighScoreObj["game" + gameid]))
            {
               if(score > MainManager.getGlobalObject().data.HighScoreObj["game" + gameid])
               {
                  MainManager.getGlobalObject().data.HighScoreObj["game" + gameid] = score;
               }
            }
            else
            {
               MainManager.getGlobalObject().data.HighScoreObj["game" + gameid] = score;
            }
         }
         else
         {
            MainManager.getGlobalObject().data.HighScoreObj = new Object();
            MainManager.getGlobalObject().data.HighScoreObj["game" + gameid] = score;
         }
         MoleSharedObject.flush();
      }
      
      public static function getLocalGameHighScore(gameid:String) : Number
      {
         trace("---getLocalGameHighScore----------",gameid);
         if(Boolean(MainManager.getGlobalObject().data.HighScoreObj))
         {
            if(Boolean(MainManager.getGlobalObject().data.HighScoreObj["game" + gameid]))
            {
               trace("---HighScoreObj----------",MainManager.getGlobalObject().data.HighScoreObj["game" + gameid]);
               return MainManager.getGlobalObject().data.HighScoreObj["game" + gameid];
            }
         }
         return 0;
      }
      
      public static function setPetColor(mc:DisplayObject, colorNum:uint) : void
      {
         var _array:Array = GV["petColor_" + colorNum];
         mc.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
      }
      
      public static function BT(NUM:uint, bits:uint) : Boolean
      {
         return Boolean(NUM >> bits - 1 & 1);
      }
      
      public static function SickType(i:uint) : uint
      {
         if(BT(i,1) == 1)
         {
            return 1;
         }
         if(BT(i,3) == 1)
         {
            return 2;
         }
         if(BT(i,5) == 1)
         {
            return 3;
         }
         return 0;
      }
      
      public static function getRecentFriendObj(id:Object) : Object
      {
         var so:SharedObject = MainManager.getGlobalObject();
         var friendsList:Array = so.data.FriendsList;
         for(var i:uint = 0; i < friendsList.length; i++)
         {
            if(friendsList[i].UserID == id)
            {
               return friendsList[i];
            }
         }
         return null;
      }
      
      public static function isMyFriendOfMyself(id:int) : Boolean
      {
         var i:uint = 0;
         var so:SharedObject = MainManager.getGlobalObject();
         var friendsList:Array = so.data.ServerFriendsList;
         if(Boolean(friendsList))
         {
            for(i = 0; i < friendsList.length; i++)
            {
               if(friendsList[i].friend == id)
               {
                  return true;
               }
            }
         }
         if(id == LocalUserInfo.getUserID())
         {
            return true;
         }
         return false;
      }
      
      public static function isMyFriend(id:int) : Boolean
      {
         var i:uint = 0;
         var so:SharedObject = MainManager.getGlobalObject();
         var friendsList:Array = so.data.ServerFriendsList;
         if(Boolean(friendsList))
         {
            for(i = 0; i < friendsList.length; i++)
            {
               if(friendsList[i].friend == id)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function hideActionView(id:int) : void
      {
         var tv1_mc:DisplayObject = null;
         var tv2_mc:DisplayObject = null;
         if(id == GV.MyInfo_userID)
         {
            tv1_mc = MainManager.getAppLevel().getChildByName("bigMc");
            if(Boolean(tv1_mc))
            {
               tv1_mc.x = 1500;
            }
            tv2_mc = MainManager.getToolLevel().getChildByName("special_mc");
            if(Boolean(tv2_mc))
            {
               tv2_mc.x = 1500;
            }
         }
      }
      
      public static function addRecentFriend(id:Object) : void
      {
         var obj:Object = null;
         var i:uint = 0;
         var recentAllObj:Object = null;
         var recentlist:* = MainManager.getGlobalObject().data.recentFriendsList313;
         var myid:int = LocalUserInfo.getUserID();
         if(Boolean(recentlist))
         {
            if(Boolean(recentlist[myid]))
            {
               for(i = 0; i < recentlist[myid].length; i++)
               {
                  try
                  {
                     if(id == recentlist[myid][i].UserID)
                     {
                        return;
                     }
                  }
                  catch(e:Error)
                  {
                     return;
                  }
               }
               if(recentlist[myid].length >= 20)
               {
                  recentlist[myid].pop();
               }
               obj = getRecentFriendObj(id);
               if(Boolean(obj))
               {
                  recentlist[myid].unshift(obj);
               }
            }
            else
            {
               recentlist[myid] = new Array();
               obj = getRecentFriendObj(id);
               if(Boolean(obj))
               {
                  recentlist[myid].unshift(obj);
               }
            }
         }
         else
         {
            recentAllObj = new Object();
            recentAllObj[myid] = new Array();
            obj = getRecentFriendObj(id);
            if(Boolean(obj))
            {
               recentAllObj[myid].unshift(obj);
            }
            MainManager.getGlobalObject().data.recentFriendsList313 = recentAllObj;
         }
         MoleSharedObject.flush();
      }
      
      public static function getBitBool(data:int, position:int) : Boolean
      {
         if(position <= 0)
         {
            throw "指定位必須大於0.";
         }
         position--;
         data >>= position;
         return Boolean(data & 1);
      }
      
      public static function setBitBool(data:int, position:int, flag:Boolean) : int
      {
         if(position <= 0)
         {
            throw "指定位必須大於0.";
         }
         var b:Boolean = getBitBool(data,position);
         position--;
         if(b == flag)
         {
            return data;
         }
         if(b)
         {
            return data - Math.pow(2,position);
         }
         return data + Math.pow(2,position);
      }
      
      public static function switchPrevMap() : void
      {
         var MapManageLogic:* = getDefinitionByName("com.logic.MapManageLogic.MapManageLogic");
         var mapObj:Object = MapManageLogic.recordMapArray[MapManageLogic.recordMapArray.length - 2];
         var mapID:int = int(mapObj.mapID);
         var mapType:int = int(mapObj.mapType);
         if(GV.MapInfo_mapID == mapID)
         {
            GF.switchMap(1,true,mapType);
         }
         else
         {
            GF.switchMap(mapID,true,mapType);
         }
      }
   }
}

