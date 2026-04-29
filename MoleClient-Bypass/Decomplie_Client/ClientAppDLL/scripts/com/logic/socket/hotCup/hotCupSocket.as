package com.logic.socket.hotCup
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.info.ItemInfo;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class hotCupSocket extends SocketProtocol
   {
      
      private var _itemList:Array;
      
      public function hotCupSocket()
      {
         super(CommandID.EXCHANGE_GAME_SCORE);
      }
      
      public static function getGameAward(tempGameid:int, tempFraction:int) : void
      {
         MsgHead.Command = 1246;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(tempGameid);
         tempByteArray.writeUnsignedInt(tempFraction);
         GF.writeHead(tempByteArray);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var itemInfo:ItemInfo = null;
         var obj1:Object = null;
         this._itemList = new Array();
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var arr:Array = new Array();
         obj.count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.count; i++)
         {
            itemInfo = new ItemInfo();
            obj1 = new Object();
            itemInfo.ID = obj1.itemId = output.readUnsignedInt();
            itemInfo.count = obj1.itemCount = output.readUnsignedInt();
            arr[i] = obj1;
            this._itemList.push(itemInfo);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1246,obj));
      }
      
      public function get itemList() : Array
      {
         return this._itemList;
      }
   }
}

