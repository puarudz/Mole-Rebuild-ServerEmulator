package com.logic.socket.getServerTimer
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class getServerTimerRes extends EventDispatcher
   {
      
      public static var GET_SERVER_TIMER:String = "getServerTimer";
      
      public function getServerTimerRes()
      {
         super();
      }
      
      public function parseServerTimer() : void
      {
         var Sec:uint = GV.onlineSocket.readUnsignedInt();
         var MicroSec:uint = GV.onlineSocket.readUnsignedInt();
         var MicroSecStr:String = String(MicroSec);
         if(MicroSec < 10)
         {
            MicroSecStr = "00" + MicroSecStr;
         }
         else if(MicroSec < 100)
         {
            MicroSecStr = "0" + MicroSecStr;
         }
         var tempDate:Date = new Date();
         var num:Number = Number(String(Sec) + MicroSecStr.substr(0,3));
         tempDate.setTime(num);
         GV.onlineSocket.dispatchEvent(new EventTaomee("beforeGetServerTimer",tempDate));
         GV.onlineSocket.dispatchEvent(new EventTaomee("debugChange",tempDate));
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_SERVER_TIMER,tempDate));
         getServerTimerReq.returnRes(tempDate);
      }
      
      public function hasBeenServerTimer() : void
      {
         var Sec:uint = GV.onlineSocket.readUnsignedInt();
         var MicroSec:uint = GV.onlineSocket.readUnsignedInt();
         var MicroSecStr:String = String(MicroSec);
         if(MicroSec < 10)
         {
            MicroSecStr = "00" + MicroSecStr;
         }
         else if(MicroSec < 100)
         {
            MicroSecStr = "0" + MicroSecStr;
         }
         var tempDate:Date = new Date();
         var num:Number = Number(String(Sec) + MicroSecStr.substr(0,3));
         tempDate.setTime(num);
         GV.onlineSocket.dispatchEvent(new EventTaomee("beforeGetServerTimer",tempDate));
         GV.onlineSocket.dispatchEvent(new EventTaomee("debugChange",tempDate));
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_SERVER_TIMER,tempDate));
         getServerTimerReq.returnRes(tempDate);
      }
   }
}

