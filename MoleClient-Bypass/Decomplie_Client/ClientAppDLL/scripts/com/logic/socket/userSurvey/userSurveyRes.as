package com.logic.socket.userSurvey
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class userSurveyRes extends EventDispatcher
   {
      
      public static var GET_USERSURVEY_SUCC:String = "GET_USERSURVEY_SUCC";
      
      public function userSurveyRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.Done = GV.onlineSocket.readUnsignedByte();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_USERSURVEY_SUCC,obj));
      }
   }
}

