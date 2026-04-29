package com.logic.socket.GetItemCount
{
   import com.common.data.HashMap;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.info.ItemInfo;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class GetItemCountRes extends SocketProtocol
   {
      
      public static var GET_ITEMCOUNT:String = "get_itemcount";
      
      private var _userID:uint;
      
      private var _count:uint;
      
      private var _itemHash:HashMap;
      
      public function GetItemCountRes()
      {
         super(CommandID.ITEMCOUNT);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var itemInfo:ItemInfo = null;
         var itemObj:Object = null;
         this._itemHash = new HashMap();
         var getItemCountObj:Object = new Object();
         var getItemCountArr:Array = new Array();
         this._userID = getItemCountObj.UserID = GV.onlineSocket.readUnsignedInt();
         this._count = getItemCountObj.Count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < this._count; i++)
         {
            itemInfo = new ItemInfo();
            itemObj = new Object();
            itemInfo.ID = itemObj.id = GV.onlineSocket.readUnsignedInt();
            itemObj = GF.getPropData(itemObj.id);
            itemInfo.count = itemObj.itemCount = GV.onlineSocket.readUnsignedInt();
            itemObj.Count = itemObj.itemCount;
            itemObj.ID = itemObj.id;
            getItemCountArr.push(itemObj);
            this._itemHash.add(itemInfo.ID,itemInfo);
         }
         getItemCountObj.arr = getItemCountArr;
         getItemCountObj.itemHash = this._itemHash;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_ITEMCOUNT,{"obj":getItemCountObj}));
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get count() : uint
      {
         return this._count;
      }
      
      public function get itemHash() : HashMap
      {
         return this._itemHash;
      }
   }
}

