package com.mole.app.manager
{
   import com.common.data.HashMap;
   import com.common.util.Tick;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.ServerUpTime;
   import com.module.popupMsg.PopupMsgCtl;
   
   public class BroadcastMessageManager
   {
      
      private static var _msgHash:HashMap;
      
      private static var _timeCount:uint = 0;
      
      public function BroadcastMessageManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _msgHash = new HashMap();
         var resID:uint = DownLoadManager.add("resource/xml/BoardcastMessage.xml",ResType.STRING,true);
         DownLoadManager.addEvent(resID,onLoaderXmlSucc);
      }
      
      private static function onLoaderXmlSucc(e:DownLoadEvent) : void
      {
         var msgObj:Object = null;
         var dateList:Array = null;
         var tmpDate:Date = null;
         var tmpMsg:String = null;
         var msgXml:XML = null;
         var boardXml:XML = XML(e.data);
         var curDate:Date = ServerUpTime.getInstance().chinaDate;
         for each(msgXml in boardXml.children())
         {
            msgObj = new Object();
            dateList = String(msgXml.@Date).split("-");
            msgObj.date = new Date(dateList[0],dateList[1],dateList[2],dateList[3],dateList[4]);
            msgObj.msg = String(msgXml.@Msg);
            msgObj.id = uint(msgXml.@ID);
            if(msgObj.date > curDate)
            {
               _msgHash.add(msgObj.id,msgObj);
            }
         }
         Tick.instance.addCallback(onCheckBoardcast);
      }
      
      private static function onCheckBoardcast(delay:Number) : void
      {
         var msgList:Array = null;
         var msgObj:Object = null;
         var curDate:Date = null;
         var tmpDate:Date = null;
         if(_timeCount++ > 60)
         {
            _timeCount = 0;
            msgList = _msgHash.values;
            curDate = ServerUpTime.getInstance().chinaDate;
            for each(msgObj in msgList)
            {
               tmpDate = msgObj.date;
               if(curDate.fullYear == tmpDate.fullYear && curDate.month == tmpDate.month && curDate.date == tmpDate.date && curDate.hours == tmpDate.hours && curDate.minutes == tmpDate.minutes)
               {
                  PopupMsgCtl.PopupMsg(msgObj.msg);
                  _msgHash.remove(msgObj.id);
               }
            }
         }
      }
   }
}

