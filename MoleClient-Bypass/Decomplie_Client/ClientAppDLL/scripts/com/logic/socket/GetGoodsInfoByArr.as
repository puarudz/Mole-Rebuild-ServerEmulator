package com.logic.socket
{
   import com.common.data.HashMap;
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.mole.info.ItemInfo;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GetGoodsInfoByArr extends SocketProtocol
   {
      
      public static const GetGoodsInfoByArrCmd:uint = 517;
      
      private var _itemHash:HashMap;
      
      public function GetGoodsInfoByArr()
      {
         super(GetGoodsInfoByArrCmd);
      }
      
      public static function GetGoodsInfo(flag:uint, arr:Array) : void
      {
         MsgHead.Command = GetGoodsInfoByArrCmd;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(flag);
         var len:int = int(arr.length);
         tempByteArray.writeUnsignedInt(len);
         for(var i:int = 0; i < len; i++)
         {
            tempByteArray.writeUnsignedInt(arr[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function send(flag:uint, arr:Array) : void
      {
         GetGoodsInfo(flag,arr);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var itemInfo:ItemInfo = null;
         var itemObj:Object = null;
         this._itemHash = new HashMap();
         var obj:Object = new Object();
         obj.count = bodyData.readUnsignedInt();
         obj.itemArr = [];
         for(var i:int = 0; i < obj.count; i++)
         {
            itemInfo = new ItemInfo();
            itemObj = new Object();
            itemInfo.ID = itemObj.itemID = bodyData.readUnsignedInt();
            itemInfo.count = itemObj.count = bodyData.readUnsignedInt();
            obj.itemArr.push(itemObj);
            this._itemHash.add(itemInfo.ID,itemInfo);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GetGoodsInfoByArrCmd,obj));
      }
      
      public function get itemHash() : HashMap
      {
         return this._itemHash;
      }
   }
}

