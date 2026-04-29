package com.module.paopao.paopaoLogic
{
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.module.paopao.paopaoView.paopaoView;
   import flash.events.EventDispatcher;
   
   public class paopaoLogic extends EventDispatcher
   {
      
      public static var data_OVER:String = "over";
      
      public static var myPaoNum:uint = 0;
      
      public function paopaoLogic()
      {
         super();
         try
         {
            GV.onlineClass.removeEventListener(ClientOnLineSerSocket.GET_BUBBLES_MESSAGE,getServerData);
         }
         catch(E:*)
         {
         }
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.GET_BUBBLES_MESSAGE,getServerData);
      }
      
      public static function getServerData(evt:*) : void
      {
         var paopaoview:paopaoView = new paopaoView(evt.EventObj.arr);
      }
      
      public function doshow() : void
      {
         this.sendServerData();
      }
      
      public function doshowpaopaoAction(mc:*) : void
      {
      }
      
      private function sendServerData() : void
      {
         if(myPaoNum < 5)
         {
            ++paopaoLogic.myPaoNum;
            GV.onlineClass.blowBubble();
         }
      }
   }
}

