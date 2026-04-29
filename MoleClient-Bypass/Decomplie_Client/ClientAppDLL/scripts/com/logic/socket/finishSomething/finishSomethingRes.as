package com.logic.socket.finishSomething
{
   import com.common.Alert.Alert;
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class finishSomethingRes extends SocketProtocol
   {
      
      private static var _doneMsg:String;
      
      private static var _doneCount:uint;
      
      public static var FINISH_SOMETHING_SUCC:String = "FINISH_SOMETHING_SUCC";
      
      public var Type:uint;
      
      public var Done:uint;
      
      public function finishSomethingRes()
      {
         super(CommandID.FINISH_SOMETHING);
      }
      
      public static function sendReq(id:Number, doneMsg:String = "", doneCount:uint = 1) : void
      {
         _doneMsg = doneMsg;
         _doneCount = doneCount;
         MsgHead.Command = CommandID.FINISH_SOMETHING;
         var bodyData:ByteArray = new ByteArray();
         bodyData.writeUnsignedInt(id);
         GF.writeHead(bodyData);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this.Type = bodyData.readUnsignedInt();
         this.Done = bodyData.readUnsignedInt();
         if(_doneMsg != "" && this.Done >= _doneCount && _doneMsg != null)
         {
            Alert.smileAlart("    " + _doneMsg);
            _doneMsg = "";
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(FINISH_SOMETHING_SUCC,this));
         }
      }
   }
}

