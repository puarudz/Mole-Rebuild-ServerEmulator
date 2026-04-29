package com.module.angelPark
{
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.angelPark.AngelParkSocket;
   import com.module.popupMsg.PopupMsgCtl;
   import flash.utils.Dictionary;
   
   public class AngelMainControler
   {
      
      public static var honerDic:Dictionary;
      
      public function AngelMainControler()
      {
         super();
      }
      
      public static function Init() : void
      {
         InitAngelHonerHandler();
      }
      
      private static function InitAngelHonerHandler() : void
      {
         var honerInfo:Object = null;
         honerDic = new Dictionary();
         var allHoners:Array = XMLInfo.agenlHoners;
         for each(honerInfo in allHoners)
         {
            honerDic[honerInfo.id + "_" + honerInfo.type] = honerInfo;
         }
         BC.addEvent(honerDic,GV.onlineSocket,"read_" + AngelParkSocket.UnlockHonerCmd,UnlockHonerHandler);
      }
      
      private static function UnlockHonerHandler(e:EventTaomee) : void
      {
         var honerName:String = null;
         var honer:Object = e.EventObj;
         var honerInfo:Object = honerDic[honer.id + "_" + honer.type];
         if(Boolean(honerInfo))
         {
            honerName = honerInfo.name;
            PopupMsgCtl.PopupMsg("恭喜你獲得了" + honerName + "榮譽！",5000,3000);
         }
      }
   }
}

