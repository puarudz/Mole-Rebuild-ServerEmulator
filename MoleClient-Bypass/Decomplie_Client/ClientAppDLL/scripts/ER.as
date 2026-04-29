package
{
   import com.core.info.*;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   
   public class ER
   {
      
      public static var message:String;
      
      public static var Developer_JACK:String = "jack";
      
      public static var countObj:Object = {};
      
      public static var countLimit:Object = {};
      
      public static var ErrorType_OnlineSocktIO:uint = 1;
      
      public static var ErrorType_OnlineSocktSBox:uint = 2;
      
      public static var ErrorType_RegistSocktIO:uint = 3;
      
      public static var ErrorType_RegistSocktSBox:uint = 4;
      
      public static var ErrorType_EmailSocktIO:uint = 5;
      
      public static var ErrorType_EmailSocktSBox:uint = 6;
      
      public static var ErrorType_DirSocktIO:uint = 7;
      
      public static var ErrorType_DirSocktSBox:uint = 8;
      
      public static var ErrorType_VisitorSocktIO:uint = 9;
      
      public static var ErrorType_VisitorSocktSBox:uint = 10;
      
      public static var ErrorType_OnlineSocktBreak:uint = 15;
      
      public static var ErrorType_GoodsID_NoFind:uint = 16;
      
      public static var ErrorType_LeaveGame_Timeout:uint = 17;
      
      public static var ErrorType_System_Busy:uint = 18;
      
      public static var ErrorType_DB_Timeout:uint = 19;
      
      public static var ErrorType_DepthLever:uint = 20;
      
      public static var ErrorType_Cloth_NoFind:uint = 21;
      
      public static var ErrorType_Loader_IO_Error:uint = 22;
      
      public static var ErrorType_CardGame:uint = 23;
      
      public static var StatType_LookTimesBook:uint = 99;
      
      public static var StatType_NetSpeed:uint = 100;
      
      private static var error_obj:Object = {};
      
      public static var serverName:String = "未登入";
      
      public static var Email:String = "";
      
      public static var ID:int = 0;
      
      public static var isOnline:int = 0;
      
      public static var isLogin:int = 0;
      
      public static var photo:String = "";
      
      private static var quality:int = 20;
      
      private static var width:String = "";
      
      private static var height:String = "";
      
      private static var XY:String = "";
      
      private static var Security_sandboxType:String = "";
      
      private static var isGuest:String = "true";
      
      private static var errorID:String = "0";
      
      private static var edition:Number = 0;
      
      private static var functionary:String = "";
      
      private static var errorTitle:String = "";
      
      private static var errorDescription:String = "";
      
      private static var errorType:String = "";
      
      private static var errorPosition:String = "";
      
      private static var time:Number = 0;
      
      private static var folderID:uint = 0;
      
      private static var cdnip:String = "";
      
      countLimit["E_" + 1] = 1;
      countLimit["E_" + 2] = 1;
      countLimit["E_" + 3] = 1;
      countLimit["E_" + 4] = 1;
      countLimit["E_" + 5] = 1;
      countLimit["E_" + 6] = 1;
      countLimit["E_" + 7] = 1;
      countLimit["E_" + 8] = 1;
      countLimit["E_" + 9] = 1;
      countLimit["E_" + 10] = 1;
      countLimit["E_" + 15] = 1;
      countLimit["E_" + 16] = 1;
      countLimit["E_" + 18] = 1;
      countLimit["E_" + 19] = 1;
      countLimit["E_" + 20] = 1;
      countLimit["E_" + 21] = 1;
      countLimit["E_" + 22] = 1;
      countLimit["E_" + 23] = 1;
      countLimit["E_" + 99] = 1;
      countLimit["E_" + 100] = 1;
      error_obj[1] = {
         "des":"連接錯誤",
         "type":1
      };
      error_obj[2] = {
         "des":"online安全沙箱",
         "type":2
      };
      error_obj[3] = {
         "des":"注冊IO錯誤",
         "type":3
      };
      error_obj[4] = {
         "des":"注冊安全沙箱",
         "type":4
      };
      error_obj[5] = {
         "des":"EmailIO錯誤",
         "type":5
      };
      error_obj[6] = {
         "des":"Email安全沙箱",
         "type":6
      };
      error_obj[7] = {
         "des":"DirIO錯誤",
         "type":7
      };
      error_obj[8] = {
         "des":"Dir安全沙箱",
         "type":8
      };
      error_obj[9] = {
         "des":"VisitorIO錯誤",
         "type":9
      };
      error_obj[10] = {
         "des":"Visitor安全沙箱",
         "type":10
      };
      error_obj[15] = {
         "des":"斷線",
         "type":15
      };
      error_obj[16] = {
         "des":"ID不存在",
         "type":16
      };
      error_obj[18] = {
         "des":"系統繁忙",
         "type":18
      };
      error_obj[19] = {
         "des":"DB返回超時",
         "type":19
      };
      error_obj[21] = {
         "des":"裝扮prop類缺少",
         "type":21
      };
      error_obj[22] = {
         "des":"加載IO錯誤",
         "type":22
      };
      error_obj[23] = {
         "des":"卡牌",
         "type":23
      };
      
      public function ER()
      {
         super();
      }
      
      public static function sendError(Name:String, Position:*, Title:*, ErrorContent:*, Description:String = "") : void
      {
      }
      
      private static function submit() : void
      {
         var loader:URLLoader;
         var request:URLRequest;
         var ActionHistory:Array;
         var lastArr:Array;
         var k:int;
         var ex_obj:Object;
         var ex_data:String;
         var ex_byteArray:ByteArray;
         var url:String = null;
         var variables:URLVariables = null;
         var i:String = null;
         var ip:String = null;
         var Links:* = getDefinitionByName("com.global.links::Links") as Class;
         sendIpToServer("",true);
         try
         {
            ip = ServerInfo.getDirSerInfo(ServerInfo.IP);
            isOnline = ip == "114.80.98.17" ? 1 : 0;
         }
         catch(E:*)
         {
            isOnline = 0;
         }
         if(folderID == 100)
         {
            sendIpToServer(String(functionary));
            return;
         }
         if(folderID > 90)
         {
            sendTimesBookCount(String(functionary));
            return;
         }
         if(folderID == 78)
         {
            sendTimesMailCount(String(functionary));
            return;
         }
         if(folderID == 80)
         {
            sendTimesNewsCount(String(functionary));
            return;
         }
         if(isOnline == 1)
         {
            url = "http://114.80.98.167/error_report/report.php?gameid=1";
         }
         else
         {
            url = "http://10.1.1.5/error_report/report.php?gameid=1";
         }
         loader = new URLLoader();
         configureListeners(loader);
         request = new URLRequest(url);
         time = ServerUpTime.getInstance().date.time;
         variables = new URLVariables();
         variables.errorDes = error_obj[folderID].des;
         variables.errorType = folderID;
         variables.userid = ID;
         variables.flag = 0;
         variables.flag = setBitBool(uint(variables.flag),1,isLogin != 0);
         variables.flag = setBitBool(uint(variables.flag),2,Capabilities.isDebugger);
         variables.flag = setBitBool(uint(variables.flag),3,true);
         variables.language = Capabilities.language;
         variables.flashVersion = Capabilities.version;
         variables.os = Capabilities.os;
         variables.playerType = Capabilities.playerType;
         variables.clientTime = int(time / 1000);
         variables.clientEdition = int(edition / 1000);
         variables.onlineIpPort = LocalUserInfo.socketIP + ":" + LocalUserInfo.socketport;
         variables.onlineid = GV.serverID;
         variables.mapid = GV.MapInfo_mapID > 1000 ? MapInfo.currentMapInfo().type : GV.MapInfo_mapID;
         variables.lastAction = GV.ActionHistory.length > 0 ? String(GV.ActionHistory) : "";
         ActionHistory = GV.ActionHistory;
         lastArr = ActionHistory.length >= 3 ? ActionHistory.splice(ActionHistory.length - 3) : ActionHistory.splice(0);
         for(k = 0; k < lastArr.length; k++)
         {
            lastArr[k] = lastArr[k].split(":")[0];
         }
         if(lastArr.length >= 3)
         {
            try
            {
               variables.lastCmd3 = lastArr[0] + "," + lastArr[1] + "," + lastArr[2];
            }
            catch(e:Error)
            {
            }
            try
            {
               variables.lastCmd2 = lastArr[1] + "," + lastArr[2];
            }
            catch(e:Error)
            {
            }
            try
            {
               variables.lastCmd1 = lastArr[2];
            }
            catch(e:Error)
            {
            }
         }
         else if(lastArr.length == 2)
         {
            try
            {
               variables.lastCmd3 = lastArr[0] + "," + lastArr[1];
            }
            catch(e:Error)
            {
            }
            try
            {
               variables.lastCmd2 = lastArr[0] + "," + lastArr[1];
            }
            catch(e:Error)
            {
            }
            try
            {
               variables.lastCmd1 = lastArr[1];
            }
            catch(e:Error)
            {
            }
         }
         else if(lastArr.length == 1)
         {
            try
            {
               variables.lastCmd3 = lastArr[0];
            }
            catch(e:Error)
            {
            }
            try
            {
               variables.lastCmd2 = lastArr[0];
            }
            catch(e:Error)
            {
            }
            try
            {
               variables.lastCmd1 = lastArr[0];
            }
            catch(e:Error)
            {
            }
         }
         else if(lastArr.length == 1)
         {
            variables.lastCmd3 = 0;
            variables.lastCmd2 = 0;
            variables.lastCmd1 = 0;
         }
         variables.cdnip = cdnip;
         variables.photo = "";
         try
         {
            variables.webServer = Links.stageMC.loaderInfo.url.split("/Login.swf")[0];
         }
         catch(E:*)
         {
            variables.webServer = "未初始化.";
         }
         ex_obj = {};
         ex_obj.errorDescription = errorDescription;
         ex_obj.functionary = functionary;
         ex_obj.pos = errorPosition;
         ex_obj.MapInfo = (GV.MapInfo_mapID > 1000 ? "小屋" : GV.MapInfo_name) + "(" + GV.MapInfo_mapID + ")";
         ex_obj.status = "暱稱:" + GV.MyInfo_nickName + "(" + GV.MyInfo_userID + ")";
         ex_data = "";
         ex_byteArray = new ByteArray();
         ex_byteArray.writeObject(ex_obj);
         ex_byteArray.compress();
         ex_data = B2S(ex_byteArray);
         variables.ex_data = ex_data;
         message = "";
         for(i in variables)
         {
            if(i == "z6_photo")
            {
               message += i + ":" + variables[i].substr(0,100);
               trace(i,variables[i].substr(0,100));
            }
            else
            {
               message += i + ":" + variables[i];
               trace(i,variables[i]);
            }
         }
         if(folderID == 100)
         {
            variables = new URLVariables();
         }
         request.data = variables;
         request.method = URLRequestMethod.POST;
         try
         {
            loader.load(request);
            photo = "";
         }
         catch(error:Error)
         {
            message += "Unable to load requested document. " + error;
            trace("Unable to load requested document.");
         }
         trace(request.url);
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
      
      public static function getInfo(myLoader:Loader) : String
      {
         var tempStr:String = "";
         tempStr += "\n\n\n\n加載:" + myLoader.contentLoaderInfo.url;
         tempStr += "\n\n\n\n信任:" + myLoader.contentLoaderInfo.childAllowsParent;
         tempStr += "\n\n\n\nMiME:" + myLoader.contentLoaderInfo.contentType;
         tempStr += "\n\n\n\nsameDomain:" + myLoader.contentLoaderInfo.sameDomain;
         tempStr += "\n\n\n\nSecurity_sandboxType:" + Security.sandboxType;
         message += "\n\n獲取加載對象的信息:" + tempStr;
         return tempStr;
      }
      
      public static function fullScreen(mc:DisplayObject, _quality:Number = 10, w:uint = 960, h:uint = 560) : void
      {
         quality = _quality;
         var tempQuality:Number = quality / 100;
         w *= tempQuality;
         h *= tempQuality;
         width = String(w);
         height = String(h);
         mc.root.scaleX = mc.root.scaleY = tempQuality;
         var str:String = B2S(getMapDataArray(mc.root,w,h));
         mc.root.scaleX = mc.root.scaleY = 1;
         XY = int(mc.x) + ":" + int(mc.y);
         photo = str;
      }
      
      public static function getPhoto(mc:DisplayObject, _quality:Number = 20, w:uint = 360, h:uint = 220) : void
      {
         quality = _quality;
         var tempQuality:Number = quality / 100;
         w *= tempQuality;
         h *= tempQuality;
         width = String(w);
         height = String(h);
         var tempRoot:* = mc.stage.getChildAt(0);
         tempRoot.scaleX = tempRoot.scaleY = tempQuality;
         tempRoot.x -= mc.x * tempQuality - w / 2;
         tempRoot.y -= mc.y * tempQuality - h / 2;
         var str:String = B2S(getMapDataArray(tempRoot,w,h));
         tempRoot.x = 0;
         tempRoot.y = 0;
         tempRoot.scaleX = tempRoot.scaleY = 1;
         XY = int(mc.x) + ":" + int(mc.y);
         photo = str;
      }
      
      public static function getMapDataArray(mc:DisplayObject, w:uint, h:uint) : ByteArray
      {
         var myBitmapData:BitmapData = new BitmapData(w,h);
         myBitmapData.draw(mc.stage);
         var bounds:Rectangle = new Rectangle(0,0,w,h);
         var pixels:ByteArray = myBitmapData.getPixels(bounds);
         pixels.compress();
         pixels.position = 0;
         return pixels;
      }
      
      public static function B2S(CB:ByteArray) : String
      {
         var tempString:String = "";
         while(CB.bytesAvailable > 0)
         {
            tempString += String.fromCharCode(CB.readUnsignedByte() + 119);
         }
         return tempString;
      }
      
      private static function sendMain() : void
      {
      }
      
      private static function parseContent(Content:String) : String
      {
         errorType = "自定義";
         errorID = "0";
         return Content;
      }
      
      private static function configureListeners(dispatcher:IEventDispatcher) : void
      {
         dispatcher.addEventListener(Event.COMPLETE,completeHandler);
         dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
         dispatcher.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
      }
      
      private static function completeHandler(event:Event) : void
      {
         trace("錯誤提交成功!",event.target.data);
         message += "\n錯誤提交成功!";
      }
      
      private static function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         trace("錯誤提交失敗: " + event);
         message += "\n錯誤提交失敗!" + event;
      }
      
      private static function ioErrorHandler(event:IOErrorEvent) : void
      {
         trace("錯誤提交失敗: " + event);
         message += "\n錯誤提交失敗!" + event;
      }
      
      private static function sendIpToServer(msg:String, b:Boolean = false) : void
      {
      }
      
      public static function statisticsEvent(_str:String, userId:String = null) : void
      {
         var url:String = null;
         var loader:URLLoader = null;
         var request:URLRequest = null;
         if(userId == null)
         {
            url = _str;
         }
         else
         {
            url = _str + userId;
         }
         try
         {
            loader = new URLLoader();
            request = new URLRequest(url);
            request.method = URLRequestMethod.GET;
            loader.load(request);
         }
         catch(E:*)
         {
         }
      }
      
      private static function sendTimesBookCount(msg:String) : void
      {
      }
      
      private static function sendTimesMailCount(msg:String) : void
      {
      }
      
      private static function sendTimesNewsCount(msg:String) : void
      {
      }
   }
}

