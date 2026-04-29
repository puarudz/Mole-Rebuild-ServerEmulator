package com.logic.socket.task
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TaskGetListProtocol extends SocketProtocol
   {
      
      public static const LIST_ITEM:String = "list_item";
      
      private var _taskList:Array;
      
      public function TaskGetListProtocol()
      {
         super(CommandID.LISTITEM);
      }
      
      public static function send(userID:uint) : void
      {
         MsgHead.Command = CommandID.LISTITEM;
         var bodyData:ByteArray = new ByteArray();
         bodyData.writeUnsignedInt(userID);
         GF.writeHead(bodyData);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var taskState:uint = 0;
         this._taskList = new Array();
         var taskCount:uint = bodyData.readUnsignedInt();
         for(var i:uint = 0; i < taskCount; i++)
         {
            taskState = bodyData.readUnsignedByte();
            this._taskList.push(taskState);
         }
         var Obj:Object = {"List":this._taskList};
         GV.onlineSocket.dispatchEvent(new EventTaomee(LIST_ITEM,Obj));
         GV.onlineSocket.dispatchEvent(new EventTaomee("only_joblist",{"arr":this._taskList}));
      }
      
      public function get taskList() : Array
      {
         return this._taskList;
      }
   }
}

