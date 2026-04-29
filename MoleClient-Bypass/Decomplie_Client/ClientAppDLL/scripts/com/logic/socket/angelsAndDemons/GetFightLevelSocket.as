package com.logic.socket.angelsAndDemons
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class GetFightLevelSocket extends SocketProtocol
   {
      
      private var _level:uint;
      
      private var _score:uint;
      
      private var _count:uint;
      
      public function GetFightLevelSocket()
      {
         super(CommandID.GET_ANGEL_LEVEL);
      }
      
      public static function getFightLevelFun() : void
      {
         MsgHead.Command = CommandID.GET_ANGEL_LEVEL;
         GF.writeHead();
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var obj:Object = new Object();
         this._level = obj.level = bodyData.readUnsignedInt();
         this._score = obj.score = bodyData.readUnsignedInt();
         this._count = obj.count = bodyData.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 7004,obj));
      }
      
      public function get level() : uint
      {
         return this._level;
      }
      
      public function get score() : uint
      {
         return this._score;
      }
      
      public function get count() : uint
      {
         return this._count;
      }
   }
}

