package com.logic.socket.giveMeMoney
{
   import com.event.EventTaomee;
   
   public class giveMeMoneyRes
   {
      
      public static var SERVER_GIVEMONEY:String = "SERVER_GIVEMONEY";
      
      public function giveMeMoneyRes()
      {
         super();
      }
      
      public function money() : void
      {
         var obj:Object = null;
         var Info:Object = new Object();
         Info.arr = new Array();
         Info.count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < Info.count; i++)
         {
            obj = new Object();
            obj.kind = GV.onlineSocket.readUnsignedInt();
            obj.num = GV.onlineSocket.readUnsignedInt();
            Info.arr.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(SERVER_GIVEMONEY,Info));
      }
   }
}

