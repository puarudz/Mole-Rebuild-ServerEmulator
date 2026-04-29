package com.mole.app.activity
{
   import com.event.EventTaomee;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.QueryItemCntManager;
   
   public class CheckItemNum
   {
      
      private static var _inst:CheckItemNum;
      
      private var _curItemIndex:uint;
      
      private var _itemArr:Array;
      
      private const STARTID:uint = 1351704;
      
      private const ENDID:uint = 1351710;
      
      private var _query:QueryItemCntManager;
      
      public function CheckItemNum()
      {
         super();
      }
      
      public static function get inst() : CheckItemNum
      {
         if(_inst == null)
         {
            _inst = new CheckItemNum();
         }
         return _inst;
      }
      
      public function getItemArr() : void
      {
         if(!this._query)
         {
            this._query = new QueryItemCntManager();
         }
         this._query.addEventListener(QueryItemCntManager.CONTINUOUSITEM_QUERY,this.continousItemQueryHandle);
         this._query.continousItemQuery(this.STARTID,this.ENDID + 1);
         BufferManager.addBufferEvent(BufferManager.CHECK_ITEM_INDEX,this.checkBufferHandle);
         BufferManager.getBuffer(BufferManager.CHECK_ITEM_INDEX);
      }
      
      private function checkBufferHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.CHECK_ITEM_INDEX,this.checkBufferHandle);
         this._curItemIndex = uint(e.EventObj);
      }
      
      private function continousItemQueryHandle(e:EventTaomee) : void
      {
         this._query.removeEventListener(QueryItemCntManager.CONTINUOUSITEM_QUERY,this.continousItemQueryHandle);
         this._itemArr = e.EventObj as Array;
         var len:uint = this._itemArr.length - 1;
         this._itemArr = this._itemArr.splice(0,len);
      }
      
      public function get itemArr() : Array
      {
         return this._itemArr;
      }
      
      public function get curItemIndex() : uint
      {
         return this._curItemIndex;
      }
   }
}

