package com.logic.socket.task
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TaskChangeProtocol extends SocketProtocol
   {
      
      private var _taskID:uint;
      
      private var _taskStateList:Array;
      
      private var _oldObj:Object;
      
      public function TaskChangeProtocol()
      {
         super(CommandID.CHANGLIST_ITEM);
      }
      
      public static function send(taskID:uint, state:uint = 1) : void
      {
         MsgHead.Command = CommandID.CHANGLIST_ITEM;
         var bodyData:ByteArray = new ByteArray();
         bodyData.writeUnsignedInt(taskID);
         bodyData.writeByte(state);
         GF.writeHead(bodyData);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var aa:uint = 0;
         this._taskStateList = new Array();
         this._taskID = bodyData.readUnsignedInt();
         var taskCount:uint = bodyData.readUnsignedInt();
         for(var i:uint = 0; i < taskCount; i++)
         {
            aa = bodyData.readUnsignedByte();
            this._taskStateList.push(aa);
         }
         this._oldObj = {
            "taskID":this._taskID,
            "List":this._taskStateList
         };
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
      
      public function get taskStateList() : Array
      {
         return this._taskStateList;
      }
      
      public function get oldObj() : Object
      {
         return this._oldObj;
      }
   }
}

