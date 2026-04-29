package com.logic.socket.cupMap
{
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class cupMapRes
   {
      
      public static var GET_SESSION:String = "getSession";
      
      public function cupMapRes()
      {
         super();
      }
      
      public function doAction() : void
      {
         var ip:String = GV.onlineSocket.readUTFBytes(16);
         var port:uint = uint(GV.onlineSocket.readShort());
         var _Session:ByteArray = new ByteArray();
         GV.onlineSocket.readBytes(_Session);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_SESSION,{
            "Session":_Session,
            "Port":port,
            "Ip":ip
         }));
      }
   }
}

