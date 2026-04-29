package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.BoardcastPopupMsgProtocol;
   import com.module.popupMsg.PopupMsgCtl;
   import com.mole.net.events.SocketEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class BoardcastPopupMsgManager
   {
      
      public function BoardcastPopupMsgManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         OnlineManager.addCmdListener(CommandID.BOARDCAST_POPUP_MSG,onPopMsg);
         GV.onlineSocket.addCmdListener(CommandID.GET_ITEM_REQUET,onRequet);
      }
      
      private static function onPopMsg(e:com.mole.net.events.SocketEvent) : void
      {
         var msgPro:BoardcastPopupMsgProtocol = e.bodyInfo;
         PopupMsgCtl.PopupMsg(msgPro.nick + " 在淘淘樂街用水彈喚出美人魚，獲得1萬摩爾豆！");
      }
      
      private static function onRequet(e:org.taomee.net.SocketEvent) : void
      {
         var count:uint = 0;
         var item:uint = 0;
         var name:String = null;
         var num:uint = 0;
         var arr:Array = null;
         var i:uint = 0;
         var recData:ByteArray = e.data as ByteArray;
         var str:String = "    恭喜你獲得";
         if(recData != null)
         {
            recData.position = 0;
            count = recData.readUnsignedInt();
            arr = [];
            for(i = 0; i < count; i++)
            {
               item = recData.readUnsignedInt();
               num = recData.readUnsignedInt();
               name = GoodsInfo.getInfoById(item).name;
               str += name + "×" + num.toString() + ",";
               arr.push({
                  "id":item,
                  "num":num
               });
            }
         }
         str = str.substr(0,str.length - 1);
         Alert.smileAlart(str);
         GV.onlineSocket.dispatchEvent(new EventTaomee("SocketEvent_Data" + CommandID.GET_ITEM_REQUET,arr));
      }
   }
}

