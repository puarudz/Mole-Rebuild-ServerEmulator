package com.mole.app.manager
{
   import com.global.staticData.CommandID;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.mole.net.events.SocketEvent;
   
   public class KFCManager
   {
      
      private static var _isGetCapGift:Boolean = true;
      
      public function KFCManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         updateCapGift();
      }
      
      private static function onCheckSomething(evt:SocketEvent) : void
      {
         var somethingPro:finishSomethingRes = evt.bodyInfo;
         if(somethingPro.Type == 2100000120)
         {
            OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,onCheckSomething);
            if(Boolean(somethingPro.Done))
            {
               _isGetCapGift = true;
            }
            else
            {
               _isGetCapGift = false;
            }
         }
      }
      
      public static function updateCapGift() : void
      {
         OnlineManager.addCmdListener(CommandID.FINISH_SOMETHING,onCheckSomething);
         finishSomethingReq.sendReq(2100000120);
      }
      
      public static function get isGetCapGift() : Boolean
      {
         return _isGetCapGift;
      }
   }
}

