package com.mole.app.manager
{
   import com.common.data.HashMap;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.GetGoodsInfoByArr;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import flash.events.EventDispatcher;
   
   public class QueryItemCntManager extends EventDispatcher
   {
      
      public static const DayTYPE_QUERY:String = "DAYTYPE_QUERY";
      
      public static const ONEITEM_QUERY:String = "ONEITEM_QUERY";
      
      public static const CONTINUOUSITEM_QUERY:String = "CONTINUOUSITEM_QUERY";
      
      public static const SOMEGOODS_QUERY:String = "SOMEGOODS_QUERY";
      
      private var _dayType:uint;
      
      private var _cbeginID:uint;
      
      private var _cendID:uint;
      
      private var _goodsIDArr:Array;
      
      private var _oneItemID:uint;
      
      public function QueryItemCntManager()
      {
         super();
      }
      
      public function someGoosQuery(goodsIDArr:Array) : void
      {
         this._goodsIDArr = goodsIDArr;
         GV.onlineSocket.addEventListener("read_" + GetGoodsInfoByArr.GetGoodsInfoByArrCmd,this.onCheckItemCount);
         GetGoodsInfoByArr.GetGoodsInfo(2,this._goodsIDArr);
      }
      
      private function onCheckItemCount(e:EventTaomee) : void
      {
         var i:uint = 0;
         var j:uint = 0;
         GV.onlineSocket.removeEventListener("read_" + GetGoodsInfoByArr.GetGoodsInfoByArrCmd,this.onCheckItemCount);
         var tarArr:Array = new Array();
         for(i = 0; i < this._goodsIDArr.length; i++)
         {
            tarArr[i] = 0;
         }
         var itemArr:Array = e.EventObj.itemArr;
         for(i = 0; i < itemArr.length; i++)
         {
            for(j = 0; j < this._goodsIDArr.length; j++)
            {
               if(itemArr[i].itemID == this._goodsIDArr[j])
               {
                  tarArr[j] = itemArr[i].count;
               }
            }
         }
         trace("查詢的相對應的物品數量的數組為" + tarArr);
         dispatchEvent(new EventTaomee(SOMEGOODS_QUERY,tarArr));
      }
      
      public function continousItemQuery(cbeginID:uint, cendID:uint) : void
      {
         this._cbeginID = cbeginID;
         this._cendID = cendID;
         OnlineManager.addCmdListener(CommandID.ITEMCOUNT,this.continousItemQueryHandle);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this._cbeginID,2,this._cendID);
      }
      
      public function continousItemQueryHandle(e:SocketEvent) : void
      {
         var _itemHash:HashMap = null;
         var itemInfo:ItemInfo = null;
         OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.continousItemQueryHandle);
         var _ciqArr:Array = new Array();
         var countPro:GetItemCountRes = e.bodyInfo;
         _itemHash = countPro.itemHash;
         for(var i:int = int(this._cbeginID); i <= this._cendID; i++)
         {
            itemInfo = _itemHash.getValue(i);
            if(Boolean(itemInfo))
            {
               _ciqArr.push(itemInfo.count);
            }
            else
            {
               _ciqArr.push(0);
            }
         }
         trace(_ciqArr);
         dispatchEvent(new EventTaomee(CONTINUOUSITEM_QUERY,_ciqArr));
      }
      
      public function oneItemQuery(itemID:uint) : void
      {
         this._oneItemID = itemID;
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.oneItemQueryHandle);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),itemID,2);
      }
      
      public function oneItemQueryHandle(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.oneItemQueryHandle);
         var arr:Array = e.EventObj.obj.arr;
         var len:int = int(arr.length);
         if(len == 0 || arr[0].Count == 0)
         {
            dispatchEvent(new EventTaomee(ONEITEM_QUERY,0));
         }
         else
         {
            dispatchEvent(new EventTaomee(ONEITEM_QUERY,arr[0].Count));
         }
      }
      
      public function dayTypeQuery(dayType:uint) : void
      {
         this._dayType = dayType;
         OnlineManager.addCmdListener(CommandID.FINISH_SOMETHING,this.dayTypeHandle);
         finishSomethingReq.sendReq(this._dayType);
      }
      
      public function dayTypeHandle(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.dayTypeHandle);
         var somethingPro:finishSomethingRes = e.bodyInfo;
         if(somethingPro.Type == this._dayType)
         {
            if(Boolean(somethingPro.Done))
            {
               dispatchEvent(new EventTaomee(DayTYPE_QUERY,somethingPro.Done));
            }
            else
            {
               dispatchEvent(new EventTaomee(DayTYPE_QUERY,0));
            }
         }
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeEventListener("read_" + GetGoodsInfoByArr.GetGoodsInfoByArrCmd,this.onCheckItemCount);
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.oneItemQueryHandle);
         OnlineManager.addCmdListener(CommandID.ITEMCOUNT,this.oneItemQueryHandle);
         OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.dayTypeHandle);
      }
      
      public function get dayType() : uint
      {
         return this._dayType;
      }
      
      public function get oneItemID() : uint
      {
         return this._oneItemID;
      }
   }
}

