package com.logic.socket.textNotice
{
   import com.common.soundControl.soundControl;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class TextNoticeRes extends EventDispatcher
   {
      
      public static var TEXT_NOTICE:String = "text_notice";
      
      public static var TEXT_INFO_BROADCAST:String = "text_info_broadcast";
      
      private var timeoutNum:uint;
      
      private var date:Date;
      
      public function TextNoticeRes()
      {
         super();
      }
      
      public function textNotice() : void
      {
         var textNoticeObj:Object = null;
         textNoticeObj = new Object();
         textNoticeObj.Type = GV.onlineSocket.readUnsignedInt();
         textNoticeObj.Map = GV.onlineSocket.readUnsignedInt();
         textNoticeObj.MapType = GV.onlineSocket.readUnsignedInt();
         textNoticeObj.Grid = GV.onlineSocket.readUnsignedInt();
         textNoticeObj.UserID = GV.onlineSocket.readUnsignedInt();
         textNoticeObj.Nike = GV.onlineSocket.readUTFBytes(16);
         textNoticeObj.ICON = GV.onlineSocket.readUnsignedInt();
         textNoticeObj.Schema = GV.onlineSocket.readUnsignedInt();
         textNoticeObj.Pic = GV.onlineSocket.readUnsignedInt();
         this.date = new Date(textNoticeObj.Schema * 1000);
         textNoticeObj.year = this.date.getFullYear();
         textNoticeObj.month = this.date.getMonth() + 1;
         textNoticeObj.day = this.date.getDate();
         textNoticeObj.InfoMsgLen = GV.onlineSocket.readUnsignedInt();
         if(Boolean(textNoticeObj.InfoMsgLen))
         {
            textNoticeObj.InfoMsg = GV.onlineSocket.readUTFBytes(textNoticeObj.InfoMsgLen);
            if(textNoticeObj.MapType == 31)
            {
               textNoticeObj.InfoMsg = textNoticeObj.Nike + "邀請您到米勒街店鋪去，您是否願意？";
            }
         }
         if(textNoticeObj.Pic == 999)
         {
            this.sendListMsg(textNoticeObj);
            return;
         }
         if(GV.Lib_Map == null)
         {
            GV.myInfo_noticeArr.push(textNoticeObj);
         }
         if(!GV.isChangeMap)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(TEXT_NOTICE,textNoticeObj));
         }
         else
         {
            this.timeoutNum = setTimeout(function():void
            {
               clearTimeout(timeoutNum);
               GV.onlineSocket.dispatchEvent(new EventTaomee(TEXT_NOTICE,textNoticeObj));
            },1000);
         }
         if(Boolean(UIManager.getClass("MessageSound")))
         {
            soundControl(GV.soundCon).getSound(UIManager.getClass("MessageSound"),0,1);
         }
      }
      
      public function sendListMsg(textNoticeObj:Object) : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(TEXT_INFO_BROADCAST,{
            "Pic":999,
            "Type":textNoticeObj.Type,
            "msyInfo":textNoticeObj.InfoMsg
         }));
      }
      
      public function textBodySurgery() : void
      {
         var obj:Object = new Object();
         obj.Type = GV.onlineSocket.readUnsignedInt();
         if(obj.Type == 14)
         {
            obj.msyInt = GV.onlineSocket.readUnsignedInt();
            obj.id = GV.onlineSocket.readUnsignedInt();
            obj.namelg = GV.onlineSocket.readUnsignedInt();
            obj.name = GV.onlineSocket.readUTFBytes(obj.namelg);
            obj.msglg = GV.onlineSocket.readUnsignedInt();
            obj.msg = GV.onlineSocket.readUTFBytes(obj.msglg);
            GV.onlineSocket.dispatchEvent(new EventTaomee("text_info_broadcast_14",obj));
         }
         else
         {
            obj.msyInt = GV.onlineSocket.readUnsignedInt();
            if(obj.Type == 15)
            {
               obj.msyInfo = "小C已暫時撤退，小摩爾請備戰下一波攻擊！";
            }
            else if(obj.Type == 20)
            {
               obj.name = GV.onlineSocket.readUTFBytes(obj.msyInt);
               obj.msyInfo = "<" + obj.name + ">開啟了幽靈魔盒";
            }
            else
            {
               obj.msyInfo = GV.onlineSocket.readUTFBytes(obj.msyInt);
            }
            GV.onlineSocket.dispatchEvent(new EventTaomee(TEXT_INFO_BROADCAST,obj));
         }
      }
   }
}

