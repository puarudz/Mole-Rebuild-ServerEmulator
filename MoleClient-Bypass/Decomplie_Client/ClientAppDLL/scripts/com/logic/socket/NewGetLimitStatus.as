package com.logic.socket
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class NewGetLimitStatus extends SocketProtocol
   {
      
      private var _count:uint;
      
      private var _infoArr:Array;
      
      public function NewGetLimitStatus()
      {
         super(CommandID.FOR_CLI_REQUET);
      }
      
      public static function send(arr:Array) : void
      {
         var i:uint = 0;
         var data:ByteArray = new ByteArray();
         if(arr.length > 0)
         {
            data.writeUnsignedInt(arr.length);
            for(i = 0; i < arr.length; i++)
            {
               data.writeUnsignedInt(arr[i]);
            }
            GF.sendSocket(CommandID.FOR_CLI_REQUET,data);
         }
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var obj:Object = null;
         this._infoArr = new Array();
         this._count = bodyData.readUnsignedInt();
         for(var i:uint = 0; i < this._count; i++)
         {
            obj = new Object();
            obj.type = bodyData.readUnsignedInt();
            obj.value = bodyData.readUnsignedInt();
            this._infoArr.push(obj);
         }
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function get getInfo() : Array
      {
         return this._infoArr;
      }
   }
}

