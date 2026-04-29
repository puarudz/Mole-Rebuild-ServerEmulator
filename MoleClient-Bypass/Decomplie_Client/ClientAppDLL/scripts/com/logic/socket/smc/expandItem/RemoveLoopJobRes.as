package com.logic.socket.smc.expandItem
{
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class RemoveLoopJobRes extends SocketProtocol
   {
      
      public static var GET_BACK:String = "remove_back_loopjob";
      
      private var _taskID:uint;
      
      public function RemoveLoopJobRes()
      {
         super(CommandID.LOOP_SMCJOB_REMOVE);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._taskID = bodyData.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_BACK,{"obj":{"job":this._taskID}}));
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
   }
}

