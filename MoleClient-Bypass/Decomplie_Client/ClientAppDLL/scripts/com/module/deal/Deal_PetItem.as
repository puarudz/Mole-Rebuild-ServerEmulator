package com.module.deal
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.petSocket.adoptPet.petClothReq;
   import com.logic.socket.petSocket.adoptPet.petClothRes;
   
   public class Deal_PetItem implements IDeal
   {
      
      private var _itemID:uint;
      
      private var _count:uint;
      
      private var _successFun:Function;
      
      private var _failFun:Function;
      
      private var _checkPriceFun:*;
      
      public function Deal_PetItem()
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
         this.checkHasLamu();
      }
      
      private function checkHasLamu() : void
      {
         if(GV.MAN_PEOPLE.Petlevel > 1)
         {
            this.buy();
         }
         else if(this._failFun != null)
         {
            this._failFun(0);
         }
      }
      
      private function buy() : void
      {
         BC.addEvent(this,GV.onlineSocket,petClothRes.PET_GET_ITEM_SUCC,this.getPetItemEvent);
         petClothReq.petItemReq(LocalUserInfo.getUserID(),GV.MyInfo_PetObj.SpriteID,this._itemID,this._itemID + 1,2);
      }
      
      private function getPetItemEvent(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,petClothRes.PET_GET_ITEM_SUCC,this.getPetItemEvent);
         if(evt.EventObj.Count == 0)
         {
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_1123",this.buyError);
            BC.addEvent(this,GV.onlineSocket,petClothRes.PET_BUY_ITEM_SUCC,this.buysuccess);
            petClothReq.buyItem(GV.MyInfo_PetObj.SpriteID,this._itemID,this._count);
         }
         else
         {
            if(!(this._itemID < 1200001 || this._itemID > 1219999))
            {
               Alert.smileAlart("    你的拉姆已經有這件裝扮了，看看其他的吧！");
            }
            if(this._failFun != null)
            {
               this._failFun(evt.EventObj.Count);
            }
            this.destroy();
         }
      }
      
      private function buysuccess(E:EventTaomee) : void
      {
         if(this._successFun != null)
         {
            this._successFun(this._itemID);
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

