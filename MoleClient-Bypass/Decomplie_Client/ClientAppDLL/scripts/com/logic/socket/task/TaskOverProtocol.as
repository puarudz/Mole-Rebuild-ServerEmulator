package com.logic.socket.task
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TaskOverProtocol extends SocketProtocol
   {
      
      public static const GET_ITEMCOUNT:String = "collect_get_itemcount";
      
      public function TaskOverProtocol()
      {
         super(CommandID.COLEET_ITEM);
      }
      
      public static function send(taskID:int) : void
      {
         MsgHead.Command = CommandID.COLEET_ITEM;
         var bodyData:ByteArray = new ByteArray();
         bodyData.writeUnsignedInt(taskID);
         GF.writeHead(bodyData);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var obj:Object = null;
         var Info:Object = new Object();
         Info.arr = new Array();
         Info.count = bodyData.readUnsignedInt();
         for(var i:uint = 0; i < Info.count; i++)
         {
            obj = new Object();
            obj.king = bodyData.readUnsignedInt();
            obj.num = bodyData.readUnsignedInt();
            Info.arr.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_ITEMCOUNT,{"obj":Info}));
      }
   }
}

