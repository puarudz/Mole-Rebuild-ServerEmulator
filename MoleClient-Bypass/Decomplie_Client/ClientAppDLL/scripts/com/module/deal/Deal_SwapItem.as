package com.module.deal
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   
   public class Deal_SwapItem implements ISwapDeal
   {
      
      private var _dropArray:Array;
      
      private var _giveArray:Array;
      
      private var _successFun:Function;
      
      private var _failFun:Function;
      
      private var _checkPriceFun:*;
      
      public function Deal_SwapItem()
      {
         super();
      }
      
      public function SwapItem(dropArray:Array, giveArray:Array, successFun:Function = null, failFun:Function = null, checkPriceFun:* = true) : void
      {
         this._dropArray = dropArray;
         this._giveArray = giveArray;
         this._successFun = successFun;
         this._checkPriceFun = checkPriceFun;
         this._failFun = failFun;
         var price1:uint = 0;
         var price2:uint = 0;
         for(var i:int = 0; i < giveArray.length; i++)
         {
            price1 += GoodsInfo.getInfoById(this._giveArray[i].kind).price;
         }
         for(i = 0; i < this._dropArray.length; i++)
         {
            price2 += GoodsInfo.getInfoById(this._dropArray[i].kind).price;
         }
         if(price1 != price2)
         {
            trace("錯誤:非等價交換物品!");
            this.destroy();
            return;
         }
         if(Boolean(this._checkPriceFun as Function))
         {
            if(!this._checkPriceFun(price1))
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
      
      public function DelItem(dropArray:Array, successFun:Function = null, failFun:Function = null, checkPriceFun:* = true) : void
      {
         this._dropArray = dropArray;
         this._giveArray = [];
         this._successFun = successFun;
         this._checkPriceFun = checkPriceFun;
         this._failFun = failFun;
         var price:uint = 0;
         for(var i:int = 0; i < this._dropArray.length; i++)
         {
            price += GoodsInfo.getInfoById(this._dropArray[i].kind).price;
         }
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
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_512",this.buyError);
         BC.addEvent(this,GV.onlineSocket,giveMeMoneyRes.SERVER_GIVEMONEY,this.buysuccess);
         new giveMeMoneyReq(this._dropArray,this._giveArray);
      }
      
      private function buysuccess(E:EventTaomee) : void
      {
         var Info:Object = E.EventObj;
         if(this._successFun != null)
         {
            this._successFun(Info.arr);
         }
         this.destroy();
      }
      
      private function buyError(E:EventTaomee) : void
      {
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

