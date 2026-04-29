package com.logic.socket.finishSomething
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class finishedSomethingRes extends EventDispatcher
   {
      
      public static var FINISHED_SOMETHING_SUCC:String = "FINISHED_SOMETHING_SUCC";
      
      public static var GET_PETLEVEL_SUCC:String = "GET_PETLEVEL_SUCC";
      
      public function finishedSomethingRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var i:uint = 0;
         var tmp:Object = null;
         var obj:Object = new Object();
         obj.type = GV.onlineSocket.readUnsignedInt();
         obj.count = GV.onlineSocket.readUnsignedInt();
         obj.arr = new Array();
         if(obj.count != 0)
         {
            for(i = 0; i < obj.count; i++)
            {
               tmp = new Object();
               tmp.ItemID = GV.onlineSocket.readUnsignedInt();
               tmp.ItemCount = GV.onlineSocket.readUnsignedInt();
               obj.arr.push(tmp);
            }
         }
         if(obj.type == 4)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(GET_PETLEVEL_SUCC,obj));
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(FINISHED_SOMETHING_SUCC,obj));
         }
      }
   }
}

