package com.module.sendBirthdayCard
{
   import com.event.EventTaomee;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import flash.events.Event;
   
   public class GetSomeSeed
   {
      
      private static var instance:GetSomeSeed;
      
      public static const GET_SEED:String = "get_seed";
      
      private var seedArr:Array = [];
      
      private var changeArr:Array = [];
      
      public function GetSomeSeed()
      {
         super();
      }
      
      public static function getInstance() : GetSomeSeed
      {
         if(instance == null)
         {
            instance = new GetSomeSeed();
         }
         return instance;
      }
      
      public function set buyArr(arr:Array) : void
      {
         this.seedArr = arr;
      }
      
      public function set isChangeArr(arr:Array) : void
      {
         this.changeArr = arr;
      }
      
      public function getSeed() : void
      {
         GV.onlineSocket.addEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.changeHandler);
         var giveCS:giveMeMoneyReq = new giveMeMoneyReq(this.changeArr,this.seedArr);
      }
      
      private function changeHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.changeHandler);
         GV.onlineSocket.dispatchEvent(new Event(GET_SEED));
      }
   }
}

