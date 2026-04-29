package com.logic.socket.angelsAndDemons
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class GetFightAngelsSocket extends SocketProtocol
   {
      
      private var _angleList:Array;
      
      public function GetFightAngelsSocket()
      {
         super(CommandID.GET_ANGEL_LIST);
      }
      
      public static function getFightAngelsFun() : void
      {
         MsgHead.Command = CommandID.GET_ANGEL_LIST;
         GF.writeHead();
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var obj:Object = null;
         this._angleList = new Array();
         var count:uint = bodyData.readUnsignedInt();
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            obj = new Object();
            obj.angelId = bodyData.readUnsignedInt();
            obj.angelCount = bodyData.readUnsignedInt();
            arr.push(obj);
            this._angleList.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 7070,arr));
      }
      
      public function get angleList() : Array
      {
         return this._angleList;
      }
   }
}

