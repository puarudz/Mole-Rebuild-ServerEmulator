package com.logic.socket.getFrendList
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class GetVisitorRes extends EventDispatcher
   {
      
      public static var GET_VISITOR_LIST:String = "GET_VISITOR_LIST";
      
      public function GetVisitorRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var visitor:Object = null;
         var obj:Object = new Object();
         var visitorArr:Array = new Array();
         var len:int = GV.onlineSocket.readShort();
         for(var i:uint = 0; i < len; i++)
         {
            visitor = new Object();
            visitor.UserID = GV.onlineSocket.readUnsignedInt();
            visitor.Nick = GV.onlineSocket.readUTFBytes(16);
            visitor.Color = GV.onlineSocket.readUnsignedInt();
            visitor.Vip = GV.onlineSocket.readUnsignedByte();
            visitor.Time = GV.onlineSocket.readUnsignedInt();
            visitorArr.push(visitor);
         }
         obj.arr = visitorArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_VISITOR_LIST,obj));
      }
   }
}

