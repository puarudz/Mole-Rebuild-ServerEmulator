package com.mole.app.info
{
   public class CompenStateInfo
   {
      
      private var _year:uint;
      
      private var _month:uint;
      
      private var _beginDay:uint;
      
      private var _endDay:uint;
      
      private var _dayType:uint;
      
      private var _swapZhi:uint;
      
      private var _socketType:uint;
      
      private var _prizeTip:String;
      
      public function CompenStateInfo(xmlInfo:XML)
      {
         super();
         this._year = xmlInfo.@year;
         this._month = xmlInfo.@month;
         this._beginDay = xmlInfo.@beginDay;
         this._endDay = xmlInfo.@endDay;
         this._dayType = xmlInfo.@dayType;
         this._swapZhi = xmlInfo.@swapZhi;
         this._prizeTip = xmlInfo.@prizeTip;
         this._socketType = xmlInfo.@socketType;
      }
      
      public function get year() : uint
      {
         return this._year;
      }
      
      public function get month() : uint
      {
         return this._month;
      }
      
      public function get beginDay() : uint
      {
         return this._beginDay;
      }
      
      public function get endDay() : uint
      {
         return this._endDay;
      }
      
      public function get dayType() : uint
      {
         return this._dayType;
      }
      
      public function get swapZhi() : uint
      {
         return this._swapZhi;
      }
      
      public function get prizeTip() : String
      {
         return this._prizeTip;
      }
      
      public function get socketType() : uint
      {
         return this._socketType;
      }
      
      public function get glzTime() : Number
      {
         var data:Date = new Date(this._year,this._month,this._beginDay);
         return data.time;
      }
      
      public function get endTime() : Number
      {
         var m:uint = this._month;
         if(this._endDay < this._beginDay)
         {
            m = this._month + 1;
         }
         var data:Date = new Date(this._year,m,this._endDay);
         return data.time;
      }
   }
}

