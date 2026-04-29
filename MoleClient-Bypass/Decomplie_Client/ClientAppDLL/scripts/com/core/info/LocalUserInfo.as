package com.core.info
{
   import com.adobe.crypto.MD5;
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.core.socketlogic.noticeExit.NoticeExitRes;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.module.npc.lamu.LamuInfo;
   import com.mole.net.events.SocketEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   
   public class LocalUserInfo extends EventDispatcher
   {
      
      public static var socketIP:String;
      
      public static var socketport:int;
      
      private static var MyInfo_userCode:String;
      
      public static var lamuinfo:LamuInfo;
      
      private static var MyInfo_userID:int;
      
      private static var MyInfo_nickName:String;
      
      private static var MyInfo_Family:int;
      
      private static var MyInfo_Vip:Number;
      
      private static var MyInfo_Birthday:String;
      
      private static var MyInfo_Exp:Number;
      
      private static var MyInfo_Strong:Number;
      
      private static var MyInfo_IQ:Number;
      
      private static var MyInfo_Charm:Number;
      
      private static var MyInfo_SLstar:uint;
      
      private static var MyInfo_Vip_monthr:uint;
      
      private static var MyInfo_VipValue:uint;
      
      private static var MyInfo_VipEndTime:uint;
      
      private static var MyInfo_AutoPayVip:uint;
      
      private static var MyInfo_Team:uint;
      
      private static var MyInfo_Familiary:String;
      
      private static var MyInfo_RMB:String;
      
      private static var MyInfo_YXQ:Number;
      
      private static var MyInfo_MapID:Number;
      
      private static var MyInfo_Status:String;
      
      private static var MyInfo_Action:String;
      
      private static var MyInfo_danceLevel:int;
      
      private static var Game_king:int;
      
      private static var Engineer:int;
      
      private static var planter:int;
      
      private static var farmer:int;
      
      private static var Dining_level:int;
      
      private static var Dining_flag:Boolean;
      
      private static var myInfo_Pox:String;
      
      private static var myInfo_Poy:String;
      
      private static var MyInfo_Step:int;
      
      private static var MyInfo_SuperPet:Boolean;
      
      private static var myInfo_petsign:Boolean;
      
      private static var myInfo_Activity:ByteArray;
      
      private static var MyInfo_superPet:Boolean;
      
      private static var MyInfo_LoginTimes:int;
      
      private static var MyInfo_RemainingTime:int;
      
      private static var BookBirthday:uint;
      
      public static var vipDays:int;
      
      public static var Magic_task:uint;
      
      public static var PetSkill5_Flag:uint;
      
      public static var MyInfo_Grid:uint;
      
      public static var isRepeatLogin:Boolean;
      
      public static var roleType:uint;
      
      public static var needPayPwd:Boolean;
      
      public static var USERINFO_OVER:String = "over";
      
      public static var USERINFO_FAIL:String = "fail";
      
      public static var UPDATE_YXQ_COUNT:String = "UPDATE_YXQ_COUNT";
      
      private static var _isHideOtherMole:Boolean = false;
      
      public static var _isHideOtherMoleByProgram:Boolean = false;
      
      private static var MyInfo_MapType:int = 0;
      
      private static var MyInfo_userClothItme:Array = [];
      
      private static var newRoleClothArr:Array = [];
      
      private static var fireCup_teamNum:int = 0;
      
      public static var CanGetGoodyBag:Boolean = false;
      
      private var SvrSocket:ClientOnLineSerSocket;
      
      private var connectObj:*;
      
      public function LocalUserInfo(ip:String, port:int)
      {
         super();
         socketIP = ip;
         socketport = port;
      }
      
      public static function getUserID() : int
      {
         return MyInfo_userID;
      }
      
      public static function getUserCode() : String
      {
         return MyInfo_userCode;
      }
      
      public static function setUserCode(str:String) : void
      {
         MyInfo_userCode = str;
      }
      
      public static function setNickName(i:String) : void
      {
         MyInfo_nickName = i;
      }
      
      public static function getNickName() : String
      {
         return MyInfo_nickName;
      }
      
      public static function getBookBirthday() : uint
      {
         return BookBirthday;
      }
      
      public static function setBookBirthday(i:uint) : void
      {
         BookBirthday = i;
      }
      
      public static function getFireCup_teamNum() : int
      {
         return fireCup_teamNum;
      }
      
      public static function setFireCup_teamNum(i:int) : void
      {
         fireCup_teamNum = i;
      }
      
      public static function setFamily(i:int) : void
      {
         MyInfo_Family = i;
      }
      
      public static function getFamily() : int
      {
         return MyInfo_Family;
      }
      
      public static function setVip(i:Number) : void
      {
         MyInfo_Vip = i;
      }
      
      public static function getVip() : Number
      {
         return MyInfo_Vip;
      }
      
      public static function getBirthday() : String
      {
         return MyInfo_Birthday;
      }
      
      public static function setExp(i:Number) : void
      {
         MyInfo_Exp = i;
         MyInfo_Step = GF.leve(MyInfo_Exp);
      }
      
      public static function getExp() : Number
      {
         return MyInfo_Exp;
      }
      
      public static function setStrong(i:Number) : void
      {
         MyInfo_Strong = i;
      }
      
      public static function getStrong() : Number
      {
         return MyInfo_Strong;
      }
      
      public static function setIQ(i:Number) : void
      {
         MyInfo_IQ = i;
      }
      
      public static function getIQ() : Number
      {
         return MyInfo_IQ;
      }
      
      public static function setCharm(i:Number) : void
      {
         MyInfo_Charm = i;
      }
      
      public static function getCharm() : Number
      {
         return MyInfo_Charm;
      }
      
      public static function setSLstar(i:uint) : void
      {
         MyInfo_SLstar = i;
      }
      
      public static function getSLstar() : Number
      {
         return MyInfo_SLstar;
      }
      
      public static function setTeam(i:uint) : void
      {
         MyInfo_Team = i;
      }
      
      public static function getTeam() : Number
      {
         return MyInfo_Team;
      }
      
      public static function getSLMonth() : Number
      {
         return MyInfo_Vip_monthr;
      }
      
      public static function getSLValue() : Number
      {
         return MyInfo_VipValue;
      }
      
      public static function setSLvalue(_value:Number) : void
      {
         MyInfo_VipValue = _value;
      }
      
      public static function getSLEndTime() : Number
      {
         return MyInfo_VipEndTime;
      }
      
      public static function getSLAutoPayVip() : Number
      {
         return MyInfo_AutoPayVip;
      }
      
      public static function getFamiliary() : String
      {
         return MyInfo_Familiary;
      }
      
      public static function getRMB() : String
      {
         return MyInfo_RMB;
      }
      
      public static function setYXQ(i:Number) : void
      {
         MyInfo_YXQ = i;
         GV.onlineSocket.dispatchEvent(new Event(UPDATE_YXQ_COUNT));
      }
      
      public static function getYXQ() : Number
      {
         return MyInfo_YXQ;
      }
      
      public static function setMapID(i:Number) : void
      {
         MyInfo_MapID = i;
      }
      
      public static function getMapID() : Number
      {
         return MyInfo_MapID;
      }
      
      public static function setMapType(i:int) : void
      {
         MyInfo_MapType = i;
      }
      
      public static function getMapType() : int
      {
         return MyInfo_MapType;
      }
      
      public static function getStatus() : String
      {
         return MyInfo_Status;
      }
      
      public static function setClothItem(i:Array) : void
      {
         if(roleType == 0)
         {
            MyInfo_userClothItme = i;
            newRoleClothArr = [];
         }
         else
         {
            newRoleClothArr = i;
            MyInfo_userClothItme = [];
         }
      }
      
      public static function getClothItem() : Array
      {
         if(roleType == 0)
         {
            return MyInfo_userClothItme;
         }
         return newRoleClothArr;
      }
      
      public static function getAction() : String
      {
         return MyInfo_Action;
      }
      
      public static function getPox() : String
      {
         return myInfo_Pox;
      }
      
      public static function getPoy() : String
      {
         return myInfo_Poy;
      }
      
      public static function getLevel() : int
      {
         return MyInfo_Step;
      }
      
      public static function setLevel(i:int) : void
      {
         var MoleWarmTips:* = undefined;
         var NewGrowTaskMovie:Class = null;
         MyInfo_Step = i;
         if(GV.hasNewLever)
         {
            MoleWarmTips = getDefinitionByName("com.module.moleWarmtips.MoleWarmTips");
            MoleWarmTips.getInstance().check(6,MyInfo_Step);
            NewGrowTaskMovie = getDefinitionByName("com.mole.app.user.RoleLevelUpNewGrow") as Class;
            new NewGrowTaskMovie();
         }
      }
      
      public static function getActivity() : ByteArray
      {
         return myInfo_Activity;
      }
      
      public static function countYXQ(i:int) : void
      {
         if(isNaN(i))
         {
            i = 0;
         }
         MyInfo_YXQ += i;
      }
      
      public static function countIQ(i:int) : void
      {
         if(isNaN(i))
         {
            i = 0;
         }
         MyInfo_IQ += i;
      }
      
      public static function countExp(i:int) : void
      {
         if(isNaN(i))
         {
            i = 0;
         }
         MyInfo_Exp += i;
      }
      
      public static function countCharm(i:int) : void
      {
         if(isNaN(i))
         {
            i = 0;
         }
         MyInfo_Charm += i;
      }
      
      public static function countStrong(i:int) : void
      {
         if(isNaN(i))
         {
            i = 0;
         }
         MyInfo_Strong += i;
      }
      
      public static function SuperPet(b:Boolean) : void
      {
         MyInfo_SuperPet = b;
      }
      
      public static function getSuperPet() : Boolean
      {
         return MyInfo_SuperPet;
      }
      
      public static function isVIP() : Boolean
      {
         return Boolean(MyInfo_Vip >> 0 & 1);
      }
      
      public static function onceIsVIP() : Boolean
      {
         return Boolean(MyInfo_Vip >> 5 & 1);
      }
      
      public static function friendsLimitNum() : uint
      {
         return isVIP() ? 200 : 100;
      }
      
      public static function getLoginTimes() : int
      {
         return MyInfo_LoginTimes;
      }
      
      public static function getRemainingTime() : int
      {
         return MyInfo_RemainingTime;
      }
      
      public static function setRemainingTime(time:int) : void
      {
         MyInfo_RemainingTime = time;
      }
      
      public static function setDanceLevel(num:int) : void
      {
         MyInfo_danceLevel = num;
      }
      
      public static function getDanceLevel() : int
      {
         return MyInfo_danceLevel;
      }
      
      public static function setSupetPet(bool:Boolean) : void
      {
         MyInfo_superPet = bool;
      }
      
      public static function getSupetPet() : Boolean
      {
         return MyInfo_superPet;
      }
      
      public static function setPetsign(bool:Boolean) : void
      {
         myInfo_petsign = bool;
      }
      
      public static function getPetsign() : Boolean
      {
         return myInfo_petsign;
      }
      
      public static function setMagic_task(num:uint) : void
      {
         Magic_task = num;
      }
      
      public static function getMagic_task() : uint
      {
         return Magic_task;
      }
      
      public static function setPetSkill5_Flag(num:uint) : void
      {
         PetSkill5_Flag = num;
      }
      
      public static function getPetSkill5_Flag() : uint
      {
         return PetSkill5_Flag;
      }
      
      public static function getGameKing() : uint
      {
         return Game_king;
      }
      
      public static function setGameKing(num:int) : void
      {
         Game_king = num;
      }
      
      public static function getEngineer() : uint
      {
         return Engineer;
      }
      
      public static function setEngineer(num:int) : void
      {
         Engineer = num;
      }
      
      public static function getPlanter() : uint
      {
         return planter;
      }
      
      public static function setPlanter(num:int) : void
      {
         planter = num;
      }
      
      public static function hasDining() : Boolean
      {
         return Dining_flag;
      }
      
      public static function setHasDining(b:Boolean) : void
      {
         Dining_flag = b;
      }
      
      public static function getDining() : uint
      {
         return Dining_level;
      }
      
      public static function setDining(num:int) : void
      {
         Dining_level = num;
      }
      
      public static function getFarmer() : uint
      {
         return farmer;
      }
      
      public static function setFarmer(num:int) : void
      {
         farmer = num;
      }
      
      public static function getRace_teamNum() : int
      {
         myInfo_Activity.position = 0;
         var race_teamNum:int = int(myInfo_Activity.readUnsignedInt());
         myInfo_Activity.position = 0;
         return race_teamNum;
      }
      
      public static function getMyInfo_Grid() : uint
      {
         return MyInfo_Grid;
      }
      
      public static function setMyInfo_Grid(num:int) : void
      {
         MyInfo_Grid = num;
      }
      
      public static function getIsHideOtherMole() : Boolean
      {
         return _isHideOtherMole;
      }
      
      public static function setIsHideOtherMole(b:Boolean, p:* = null) : void
      {
         _isHideOtherMole = b;
         refreshIsHideOtherMole(p);
      }
      
      public static function setIsHideOtherMoleForHandler(b:Boolean) : void
      {
         _isHideOtherMole = b;
      }
      
      public static function refreshIsHideOtherMole(p:* = null) : void
      {
         var PeopleCountLogic:*;
         if(Boolean(p))
         {
            try
            {
               if(p.id == LocalUserInfo.getUserID())
               {
                  return;
               }
               p.visible = !_isHideOtherMole;
               if(Boolean(p.hitBtn))
               {
                  p.hitBtn.hide = _isHideOtherMole;
               }
               if(Boolean(p.pet_hitBtn))
               {
                  p.pet_hitBtn.hide = _isHideOtherMole;
               }
            }
            catch(err:Error)
            {
            }
         }
         PeopleCountLogic = getDefinitionByName("com.logic.PeopleCountLogic.PeopleCountLogic");
         PeopleCountLogic.checkAllPeopleByFun(function(p:*):void
         {
            try
            {
               if(p == GV.MAN_PEOPLE)
               {
                  return;
               }
               if(Boolean(p.isIn204Game))
               {
                  return;
               }
               p.visible = !_isHideOtherMole;
               if(Boolean(p.hitBtn))
               {
                  p.hitBtn.hide = _isHideOtherMole;
               }
               if(Boolean(p.pet_hitBtn))
               {
                  p.pet_hitBtn.hide = _isHideOtherMole;
               }
            }
            catch(err:Error)
            {
            }
            p = null;
         });
      }
      
      public static function changPayPwdState(pwd:String) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.SET_PAY_PWD_STATE,changePayPwdBack,false,99);
         GV.onlineSocket.addEventListener(SocketEvent.ERROR,pwdError);
         GF.sendSocket(CommandID.SET_PAY_PWD_STATE,LocalUserInfo.needPayPwd ? 0 : 1,MD5.hash(pwd));
      }
      
      private static function changePayPwdBack(evt:Event) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.SET_PAY_PWD_STATE,changePayPwdBack);
         GV.onlineSocket.removeEventListener(SocketEvent.ERROR,pwdError);
         var recData:ByteArray = evt["data"] as ByteArray;
         LocalUserInfo.needPayPwd = recData.readUnsignedInt() == 1;
      }
      
      private static function pwdError(evt:SocketEvent) : void
      {
         if(evt.headInfo.commandID == CommandID.SET_PAY_PWD_STATE)
         {
            GV.onlineSocket.removeCmdListener(CommandID.SET_PAY_PWD_STATE,changePayPwdBack);
            GV.onlineSocket.removeEventListener(SocketEvent.ERROR,pwdError);
            Alert.angryAlart("支付密碼錯誤!");
         }
      }
      
      public function connectSocket() : void
      {
         trace("_______________user_______________",socketIP,socketport);
         this.SvrSocket = new ClientOnLineSerSocket(socketIP,socketport);
         GV.onlineClass = this.SvrSocket;
         this.SvrSocket.addEventListener(ClientOnLineSerSocket.SEND_DATA,this.getUserData);
         this.SvrSocket.addEventListener(ClientOnLineSerSocket.SOCKET_SUCCESS,this.doSvrConnectSuccess);
         this.SvrSocket.addEventListener(ClientOnLineSerSocket.SOCKET_ERROR,this.doSvrError);
         this.SvrSocket.addEventListener(ClientOnLineSerSocket.SOCKET_SHUTDOWN,this.doSvrShundown);
         this.SvrSocket.addEventListener("client_close",this.ClientShundown);
         this.SvrSocket.addEventListener(ClientOnLineSerSocket.SEND_FAIL,this.doSvrFAIL);
         GV.onlineClass.addEventListener(NoticeExitRes.NOTICE_EXIT,this.exitHandler);
      }
      
      public function getUserData(evt:EventTaomee) : void
      {
         trace("getData",evt.EventObj);
         var obj:Object = evt.EventObj;
         GV.MyInfo_userID = MyInfo_userID = obj.UserID;
         MyInfo_nickName = obj.Nick;
         GV.MyInfo_nickName = obj.Nick;
         MyInfo_Family = obj.Color;
         MyInfo_Vip = obj.Vip;
         trace("---------------------------------------------身份",obj.Vip.toString(2));
         MyInfo_Birthday = obj.Birthday;
         MyInfo_Exp = obj.Exp;
         MyInfo_Strong = obj.Strong;
         MyInfo_IQ = obj.IQ;
         MyInfo_Charm = obj.Charm;
         Game_king = obj.Game_king;
         Engineer = obj.Engineer;
         planter = obj.planter;
         farmer = obj.farmer;
         Dining_level = obj.Dining_level;
         Dining_flag = obj.Dining_flag;
         MyInfo_Familiary = obj.Familiary;
         MyInfo_RMB = obj.RMB;
         MyInfo_YXQ = Number(obj.YXQ);
         MyInfo_MapID = obj.MapID;
         MyInfo_MapType = obj.MyInfo_MapType;
         MyInfo_Status = obj.Status;
         MyInfo_userClothItme = obj.clothArry;
         MyInfo_Action = obj.Action;
         MyInfo_danceLevel = obj.DanceLevel;
         MyInfo_SLstar = obj.Vip_level;
         MyInfo_Vip_monthr = obj.Vip_month;
         MyInfo_VipValue = obj.VipValue;
         MyInfo_VipEndTime = obj.VipEndTime;
         MyInfo_AutoPayVip = obj.autoPayVip;
         MyInfo_Team = obj.Team;
         myInfo_Pox = obj.PosX;
         myInfo_Poy = obj.PosY;
         BookBirthday = obj.birthday;
         myInfo_petsign = Boolean(obj.petsign);
         Magic_task = obj.Magic_task;
         GV.Activity = obj.Activity;
         myInfo_Activity = obj.Activity;
         PetSkill5_Flag = obj.PetSkill5_Flag;
         CanGetGoodyBag = int(obj.CanGetGoodyBag) == 1;
         MyInfo_Step = GF.leve(MyInfo_Exp);
         MyInfo_LoginTimes = obj.LoginTimes;
         MyInfo_RemainingTime = obj.RemainingTime;
         roleType = obj.roleType;
         this.SvrSocket.removeEventListener(ClientOnLineSerSocket.SEND_DATA,this.getUserData);
         dispatchEvent(new Event(USERINFO_OVER));
         if(MyInfo_userID <= GV.userIDLimit)
         {
            MainManager.getGlobalObject().data.nickName = MyInfo_nickName;
            MainManager.getGlobalObject().data.Family = MyInfo_Family;
            MainManager.getGlobalObject().data.clothArray = MyInfo_userClothItme;
         }
         else
         {
            MyInfo_Family = 1;
         }
      }
      
      private function doSvrConnectSuccess(evt:EventTaomee) : void
      {
      }
      
      private function doSvrError(evt:EventTaomee) : void
      {
      }
      
      private function ClientShundown(evt:EventTaomee) : void
      {
         this.formatEvent();
         this.connectObj = Alert.showAlert(MainManager.getAppLevel(),"您已經離線超過30分鐘，請重新登錄","",6,"D");
         this.connectObj.addEventListener("CLICK" + 1,this.RefreshMain);
      }
      
      private function doSvrShundown(evt:* = null) : void
      {
         this.formatEvent();
      }
      
      private function exitHandler(evt:*) : void
      {
         var type:* = evt.EventObj.Error;
         var msg:String = "";
         trace("type-------------------",type);
         switch(type)
         {
            case "-10001":
               msg = "    密碼驗證失敗\n摩爾莊園,請重新登錄";
               break;
            case "-10010":
               isRepeatLogin = true;
               msg = "    您的賬號已經在別處登錄！如非本人操作，請立即更改密碼！";
               break;
            case "1048577":
               isRepeatLogin = true;
               msg = "    您的賬號已經在別處登錄！如非本人操作，請立即更改密碼！";
               break;
            case "1048578":
               msg = "    摩爾莊園進入休息時間\n你也趕快去休息吧！";
               break;
            case "-99999999":
               msg = "    系統發現你正在使用第三方軟件\n你將於伺服器斷開連接";
               break;
            case "-10012":
               msg = "使用了非法語言";
               Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.CHANG_ALERT,"iknow",true,false,"G");
               break;
            case "-10013":
               msg = "被舉報";
               break;
            case "1":
               msg = "    系統發現你使用了不文明暱稱\n你的米米號將被封停24小時";
               break;
            case "2":
               msg = "    系統發現你使用了不文明用語\n你的米米號將被封停24小時";
               break;
            case "3":
               msg = "    系統發現你索要個人資訊\n你的米米號將被封停24小時";
               break;
            case "4":
               msg = "    系統發現你使用了外掛\n你的米米號將被封停24小時";
               break;
            case "5":
               msg = "    系統發現你違反公民法令\n你的米米號將被封停24小時";
               break;
            case "65537":
               msg = "    系統發現你使用了不文明暱稱\n你的米米號將被永久封停";
               break;
            case "65538":
               msg = "    系統發現你使用了不文明用語\n你的米米號將被永久封停";
               break;
            case "65539":
               msg = "    系統發現你透露個人資訊\n你的米米號將被永久封停";
               break;
            case "65540":
               msg = "    系統發現你使用了外掛\n你的米米號將被永久封停";
               break;
            case "65541":
               msg = "    系統發現你違反公民法令\n你的米米號將被永久封停";
               break;
            case "196609":
               msg = "    系統發現你使用了不文明暱稱\n你的米米號將被封停7天";
               break;
            case "196610":
               msg = "    系統發現你使用了不文明用語\n你的米米號將被封停7天";
               break;
            case "196611":
               msg = "    系統發現你透露個人資訊\n你的米米號將被封停7天";
               break;
            case "196612":
               msg = "    系統發現你使用了外掛\n你的米米號將被封停7天";
               break;
            case "262145":
               msg = "    系統發現你使用了不文明暱稱\n你的米米號將被封停14天";
               break;
            case "262146":
               msg = "    系統發現你使用了不文明用語\n你的米米號將被封停14天";
               break;
            case "262147":
               msg = "    系統發現你透露個人資訊\n你的米米號將被封停14天";
               break;
            case "262148":
               msg = "    系統發現你使用了外掛\n你的米米號將被封停14天";
         }
         this.formatEvent();
         this.connectObj = Alert.showAlert(MainManager.getTopLevel(),"",msg,Alert.CHANG_ALERT,"iknow",true,false,"G");
         this.connectObj.addEventListener("CLICK" + 1,this.RefreshMain);
      }
      
      private function doSvrGetData(evt:*) : void
      {
      }
      
      private function doSvrFAIL(evt:*) : void
      {
      }
      
      private function formatEvent() : void
      {
         this.SvrSocket.removeEventListener(ClientOnLineSerSocket.SEND_DATA,this.getUserData);
         this.SvrSocket.removeEventListener(ClientOnLineSerSocket.SOCKET_SUCCESS,this.doSvrConnectSuccess);
         this.SvrSocket.removeEventListener(ClientOnLineSerSocket.SOCKET_ERROR,this.doSvrError);
         this.SvrSocket.removeEventListener(ClientOnLineSerSocket.SOCKET_SHUTDOWN,this.doSvrShundown);
         this.SvrSocket.removeEventListener(ClientOnLineSerSocket.SEND_FAIL,this.doSvrFAIL);
         this.SvrSocket.removeEventListener("client_close",this.ClientShundown);
         GV.MoveTo_Class.removeMouseEventToStage();
         GV.onlineSocket.removeEventListener(NoticeExitRes.NOTICE_EXIT,this.exitHandler);
      }
      
      private function RefreshMain(evt:*) : void
      {
         var urlRequest:URLRequest = VL.getURLRequest("http://mole.61.com.tw");
         navigateToURL(urlRequest,"_self");
      }
   }
}

