package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.util.StringUtil;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.PreLoginTimeProtocol;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.net.MoleSharedObject;
   import flash.external.ExternalInterface;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class LoginGiftManager
   {
      
      public static var FirstLogin:Boolean = true;
      
      public function LoginGiftManager()
      {
         super();
      }
      
      public static function CheckFirstTask() : Boolean
      {
         var task:Task = TaskManager.getTask(382);
         var myBirthday:uint = uint(LocalUserInfo.getBirthday());
         var date:Date = new Date(2012,5,20);
         var minTime:Number = date.getTime() / 1000;
         if(myBirthday < minTime)
         {
            if(!Boolean(task))
            {
               return true;
            }
            task.state = 2;
         }
         if(Boolean(task))
         {
            if(task.state >= 2)
            {
               return true;
            }
         }
         return false;
      }
      
      private static function get_TodayInServer() : uint
      {
         var server:Date = ServerUpTime.getInstance().date;
         var today:uint = server.date;
         if(server.month == 8)
         {
            today += 24;
         }
         else if(today >= 8 && server.month == 7)
         {
            today -= 7;
         }
         else if(today < 8 && server.month == 7)
         {
            Alert.angryAlart("日期不在活動時間內：2014-" + server.month + 1 + "-" + server.date);
            return 0;
         }
         return today;
      }
      
      public static function checkWeekGift() : void
      {
         var getResponseInfo:Function = null;
         getResponseInfo = function(evt:SocketEvent):void
         {
            GV.onlineSocket.removeCmdListener(8755,getResponseInfo);
            var res:ByteArray = evt.data as ByteArray;
            var type:uint = res.readUnsignedInt();
            var value1:uint = res.readUnsignedInt();
            var value2:uint = res.readUnsignedInt();
            if(value1 == 1)
            {
               ModuleManager.openPanel("PasswordBound");
            }
         };
         setTimeout(function():void
         {
            var firstBln:Boolean = false;
            var date:Date = ServerUpTime.getInstance().date;
            if(FirstLogin)
            {
               firstBln = isFirstLoginToday();
               if(firstBln)
               {
                  FiveYearBook();
                  finishSomethingReq.sendReq(2025);
               }
               FirstLogin = false;
            }
         },2000);
         setTimeout(function():void
         {
            GV.onlineSocket.addCmdListener(8755,getResponseInfo);
            GF.sendSocket(8755,2025);
         },1000);
      }
      
      public static function onCheckTimes(e:*) : void
      {
      }
      
      private static function FiveYearBook() : void
      {
         var url:String = null;
         var arr:Array = null;
         var uid:* = undefined;
         if(ExternalInterface.available)
         {
            url = ExternalInterface.call("function getURL(){return window.location.href;}");
            arr = url.split("Y5DB_uid=");
            uid = arr[1];
            if(StringUtil.isNumber(uid) == true)
            {
               GF.sendSocket(CommandID.FIVEYEAR_BACKUSER_SET,uint(uid));
               OnlineManager.addCmdListener(CommandID.PRE_LOGIN_TIME,onPreLoginTime);
               GF.sendSocket(CommandID.PRE_LOGIN_TIME);
            }
         }
      }
      
      private static function onPreLoginTime(e:*) : void
      {
         OnlineManager.removeCmdListener(CommandID.PRE_LOGIN_TIME,onPreLoginTime);
         var timeInfo:PreLoginTimeProtocol = e.bodyInfo;
         if(timeInfo.preTime < 20130301 && timeInfo.preTime > 19700102)
         {
            OnlineManager.addCmdListener(CommandID.FINISH_SOMETHING,onCheckSomethingRR);
            finishSomethingReq.sendReq(2100000244);
         }
      }
      
      private static function onCheckSomethingRR(evt:*) : void
      {
         OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,onCheckSomethingRR);
         var somethingPro:finishSomethingRes = evt.bodyInfo;
         if(somethingPro.Type == 2100000244)
         {
            if(somethingPro.Done == 0)
            {
               GV.onlineSocket.addEventListener(exchange.EXCHANGE_ITEM,socksHandler);
               exchange.exchange_goods(2298,1,1);
            }
         }
      }
      
      private static function socksHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(exchange.EXCHANGE_ITEM,socksHandler);
         if(evt.EventObj.Count != 0)
         {
            Alert.smileAlart("   歡迎回到摩爾莊園！回歸大禮包已經放入你的背包中，請查收。");
         }
      }
      
      public static function isFirstLoginToday() : Boolean
      {
         var dayNow:Number = NaN;
         var monNow:Number = NaN;
         var yeaNow:Number = NaN;
         var dayLas:Number = NaN;
         var monLas:Number = NaN;
         var yeaLas:Number = NaN;
         var daNow:Date = ServerUpTime.getInstance().date;
         var lastLoginDate:Date = MoleSharedObject.moleObj.lastLoginDate;
         if(lastLoginDate == null)
         {
            MoleSharedObject.moleObj.lastLoginDate = daNow;
            return true;
         }
         dayNow = daNow.getDate();
         monNow = daNow.getMonth();
         yeaNow = daNow.getFullYear();
         dayLas = lastLoginDate.getDate();
         monLas = lastLoginDate.getMonth();
         yeaLas = lastLoginDate.getFullYear();
         if(yeaNow != yeaLas || yeaNow == yeaLas && monNow != monLas || yeaNow == yeaLas && monNow == monLas && dayNow != dayLas)
         {
            MoleSharedObject.moleObj.lastLoginDate = daNow;
            MoleSharedObject.flush();
            return true;
         }
         return false;
      }
   }
}

