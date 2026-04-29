package com.logic.socket.lamuFoodGot
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.IDataInput;
   
   public class LamuFoodGot
   {
      
      public function LamuFoodGot()
      {
         super();
      }
      
      public static function lamuFoodGotReq() : void
      {
         MsgHead.Command = 6001;
         GF.writeHead();
      }
      
      public static function lamuFoodGotRes() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemID = output.readUnsignedInt();
         obj.flag = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 6001,obj));
      }
   }
}

