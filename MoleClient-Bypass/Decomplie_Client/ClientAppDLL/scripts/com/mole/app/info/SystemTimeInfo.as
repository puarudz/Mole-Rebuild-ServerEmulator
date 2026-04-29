package com.mole.app.info
{
   import com.core.info.ServerUpTime;
   
   public class SystemTimeInfo
   {
      
      public var id:uint;
      
      private var desc:String;
      
      private var _startTime:Array;
      
      private var _endTime:Array;
      
      public var outTimeMsg:String = "";
      
      public var displayTimeStr:String;
      
      public function SystemTimeInfo(xml:XML)
      {
         var timeXml:XML = null;
         var timeType:int = 0;
         var week:Array = null;
         super();
         this.id = uint(xml.@id);
         this.desc = xml.@desc;
         this.outTimeMsg = xml.@outTimeMsg;
         this.displayTimeStr = xml.@displayTimeStr;
         this._startTime = new Array();
         this._endTime = new Array();
         var timeList:XMLList = xml.descendants("time");
         for each(timeXml in timeList)
         {
            timeType = int(timeXml.@type);
            week = [];
            if(Boolean(String(timeXml.@week)))
            {
               week = String(timeXml.@week).split("|");
            }
            this._startTime.push(this.formatTime(String(timeXml.@startTime).split("-"),timeType,week));
            this._endTime.push(this.formatTime(String(timeXml.@endTime).split("-"),timeType,week));
         }
      }
      
      private function formatTime(arr:Array, timeType:int, week:Array) : Array
      {
         var rtnArr:Array = null;
         var i:int = 0;
         if(Boolean(arr))
         {
            rtnArr = [0,0,0,0,0,0,timeType,week];
            for(i = 0; i < arr.length; i++)
            {
               rtnArr[i] = arr[i];
            }
         }
         return rtnArr;
      }
      
      public function get startTime() : Array
      {
         return this._startTime;
      }
      
      public function get endTime() : Array
      {
         return this._endTime;
      }
      
      public function checkTime() : Boolean
      {
         var startTimeArr:Array = null;
         var endTimeArr:Array = null;
         var startDate:Date = null;
         var endDate:Date = null;
         var severDate:Date = null;
         var severCurDate:Date = null;
         var ix:int = 0;
         for(var index:int = 0; index < this._startTime.length; index++)
         {
            startTimeArr = this._startTime[index];
            endTimeArr = this._endTime[index];
            startDate = new Date(startTimeArr[0],startTimeArr[1] - 1,startTimeArr[2],startTimeArr[3],startTimeArr[4],startTimeArr[5]);
            endDate = new Date(endTimeArr[0],endTimeArr[1] - 1,endTimeArr[2],endTimeArr[3],endTimeArr[4],endTimeArr[5]);
            if(ServerUpTime.getInstance().timeLimit(startDate,endDate))
            {
               if(startTimeArr[6] == 0)
               {
                  return true;
               }
               if(startTimeArr[6] == 1)
               {
                  severDate = ServerUpTime.getInstance().valueDate;
                  startDate.setFullYear(severDate.getFullYear(),severDate.getMonth(),severDate.getDate());
                  endDate.setFullYear(severDate.getFullYear(),severDate.getMonth(),severDate.getDate());
                  if(ServerUpTime.getInstance().timeLimit(startDate,endDate))
                  {
                     return true;
                  }
               }
               else if(startTimeArr[6] == 2)
               {
                  severCurDate = ServerUpTime.getInstance().valueDate;
                  for(ix = 0; ix < startTimeArr[7].length; ix++)
                  {
                     if(startTimeArr[7][ix] == severCurDate.getDay())
                     {
                        return true;
                     }
                  }
               }
            }
         }
         return false;
      }
   }
}

