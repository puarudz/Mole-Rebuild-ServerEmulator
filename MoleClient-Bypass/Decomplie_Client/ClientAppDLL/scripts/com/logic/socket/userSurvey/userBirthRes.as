package com.logic.socket.userSurvey
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class userBirthRes extends EventDispatcher
   {
      
      public static var GET_USERSURVEYDONE_SUCC:String = "GET_USERSURVEYDONE_SUCC";
      
      public function userBirthRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var tmp:Object = null;
         var obj:Object = new Object();
         obj.count = GV.onlineSocket.readUnsignedInt();
         obj.arr = new Array();
         for(var i:uint = 0; i < obj.count; i++)
         {
            tmp = new Object();
            tmp.ItemID = GV.onlineSocket.readUnsignedInt();
            tmp.ItemCount = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(tmp);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_USERSURVEYDONE_SUCC,obj));
      }
   }
}

