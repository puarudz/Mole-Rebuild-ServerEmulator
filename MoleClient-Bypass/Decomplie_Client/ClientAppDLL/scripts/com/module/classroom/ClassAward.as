package com.module.classroom
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.classSystem.DoctorQGSocket;
   import flash.events.Event;
   
   public class ClassAward
   {
      
      public static var awardNO:uint;
      
      public static var awardArr:Array;
      
      public function ClassAward()
      {
         super();
         init();
      }
      
      public static function init(bool:Boolean = true) : void
      {
         awardNO = 0;
         GV.onlineSocket.addEventListener("removeMapEvent",removeHandler);
         if(bool)
         {
            GV.onlineSocket.addEventListener("read_" + 5404,acceptAwardSucc);
            DoctorQGSocket.acceptAward();
         }
         else if(ClassroomView.isJoin)
         {
            GV.onlineSocket.addEventListener("read_" + 5405,classmateacceptAwardSucc);
            DoctorQGSocket.classmateAcceptAward();
         }
      }
      
      public static function acceptAwardSucc(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 5404,acceptAwardSucc);
         awardArr = e.EventObj.arr;
         showalert();
      }
      
      public static function classmateacceptAwardSucc(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 5405,classmateacceptAwardSucc);
         awardArr = e.EventObj.arr;
         if(awardArr.length == 0)
         {
            Alert.showAlert(MainManager.getAppLevel(),"","非常抱歉，你們班級沒有達到領獎的分數，記得下次努力哦！",Alert.IKNOW_ALERT);
            return;
         }
         showalert();
      }
      
      public static function showalert(e:Event = null) : void
      {
         var itemid:int = 0;
         var _msg:String = null;
         var _url:String = null;
         var alt:* = undefined;
         if(awardNO < awardArr.length)
         {
            itemid = int(awardArr[awardNO]);
            _msg = "    你獲得了一個" + GoodsInfo.getItemNameByID(itemid);
            _url = GoodsInfo.getItemPathByID(itemid) + "/" + itemid + ".swf";
            alt = Alert.showAlert(MainManager.getAppLevel(),_url,_msg,Alert.CHANG_ALERT,"sure",true,false,"EMP_BUY");
            alt.addEventListener("CLICK" + 1,showalert);
            ++awardNO;
         }
      }
      
      public static function removeHandler(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",removeHandler);
         GV.onlineSocket.removeEventListener("read_" + 5404,acceptAwardSucc);
         GV.onlineSocket.removeEventListener("read_" + 5405,classmateacceptAwardSucc);
      }
   }
}

