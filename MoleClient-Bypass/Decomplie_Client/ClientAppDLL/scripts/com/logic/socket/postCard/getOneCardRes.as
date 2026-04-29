package com.logic.socket.postCard
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class getOneCardRes extends EventDispatcher
   {
      
      public static var GETBACKONECARD_INFO:String = "getback_onecard";
      
      public function getOneCardRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var date:Date = null;
         var msg:String = null;
         var reg:RegExp = null;
         var arr:Array = null;
         var target_obj:Object = new Object();
         target_obj.CardID = GV.onlineSocket.readUnsignedInt();
         target_obj.SenderID = GV.onlineSocket.readUnsignedInt();
         target_obj.SenderNick = GV.onlineSocket.readUTFBytes(16);
         var SentTime:uint = GV.onlineSocket.readUnsignedInt();
         target_obj.CardPic = GV.onlineSocket.readUnsignedInt();
         target_obj.MapID = GV.onlineSocket.readUnsignedInt();
         target_obj.MsgLgh = GV.onlineSocket.readUnsignedInt();
         if(target_obj.CardPic == 1000212 || target_obj.CardPic == 1000213)
         {
            msg = GV.onlineSocket.readUTFBytes(uint(target_obj.MsgLgh));
            reg = /\|/;
            arr = msg.split(reg);
            target_obj.userid = arr[0];
            target_obj.username = arr[1];
            target_obj.invitecode = arr[2];
            if(target_obj.CardPic == 1000212)
            {
               target_obj.Msg = "<b><font COLOR=\'#ffffff\' size=\'14\'>HI," + LocalUserInfo.getNickName() + ",我是" + target_obj.username + "</b><br><b><font size=\'12\'>淘米校巴已經開動了，我在這裡建空間、寫日記、傳照片，你<br>快過來看看吧！在淘米校巴也可以玩遊戲、找朋友，我們班上<br>好多同學都在呢！<br>你還等什麼，趕緊來吧！</b>";
            }
            else
            {
               target_obj.Msg = "<p><b>HI," + LocalUserInfo.getNickName() + "。</b></p>恭喜你拿到淘米校巴的“車票”啦~這可不是誰都會有的殊榮哦~現在就登上校巴開始你的旅程吧";
            }
         }
         else
         {
            target_obj.Msg = GV.onlineSocket.readUTFBytes(uint(target_obj.MsgLgh));
         }
         date = new Date(SentTime * 1000);
         var years:Number = date.getFullYear();
         var months:Number = date.getMonth() + 1;
         var days:Number = date.getDate();
         var hourss:Number = date.getHours();
         var miss:Number = date.getMinutes();
         var mis:String = String(miss);
         if(miss == 0)
         {
            mis = "00";
         }
         else if(miss < 10)
         {
            mis = "0" + miss;
         }
         var sims:Number = date.getSeconds();
         var sim:String = String(sims);
         if(sims == 0)
         {
            sim = "00";
         }
         else if(sims < 10)
         {
            sim = "0" + sim;
         }
         target_obj.Day = years + "年" + months + "月" + days + "日  " + hourss + ":" + mis + ":" + sim + "";
         var obj:Object = {"arr":target_obj};
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETBACKONECARD_INFO,obj));
      }
   }
}

