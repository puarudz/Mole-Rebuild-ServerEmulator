package com.module.deal
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   
   public class Deal_ComplexItem implements IDeal
   {
      
      private var _itemID:uint;
      
      private var _count:uint;
      
      private var _successFun:Function;
      
      private var _failFun:Function;
      
      private var _checkPriceFun:*;
      
      public function Deal_ComplexItem()
      {
         super();
      }
      
      public function BuyItem(itemID:uint, count:uint = 1, successFun:Function = null, failFun:Function = null, checkPriceFun:* = true) : void
      {
         this._itemID = itemID;
         this._count = count;
         this._successFun = successFun;
         this._failFun = failFun;
         this._checkPriceFun = checkPriceFun;
         var price:uint = uint(GoodsInfo.getInfoById(itemID).price);
         if(Boolean(this._checkPriceFun as Function))
         {
            if(!this._checkPriceFun(price))
            {
               this.destroy();
               return;
            }
         }
         else if(!this._checkPriceFun)
         {
            this.destroy();
            return;
         }
         this.buy();
      }
      
      private function buy() : void
      {
         var getYF:BuyItemReq = new BuyItemReq();
         getYF.buyItems(this._itemID,this._count);
         GV.itemID = this._itemID;
         BC.addEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.buysuccess);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_501",this.buyError);
      }
      
      private function buysuccess(E:EventTaomee) : void
      {
         if(GV.itemID == this._itemID)
         {
            if(this._successFun != null)
            {
               this._successFun(this._itemID);
            }
            GV.itemID = 0;
            this.destroy();
         }
      }
      
      private function buyError(E:EventTaomee) : void
      {
         GV.itemID = 0;
         if(this._failFun != null)
         {
            this._failFun(E.EventObj as int);
         }
         this.destroy();
      }
      
      private function destroy() : void
      {
         BC.removeEvent(this);
         this._successFun = null;
         this._failFun = null;
         this._checkPriceFun = null;
      }
   }
}

