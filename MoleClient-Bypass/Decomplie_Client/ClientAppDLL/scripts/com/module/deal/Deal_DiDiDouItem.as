package com.module.deal
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.shopItem.BuyDiDiDouSocket;
   import flash.events.Event;
   
   public class Deal_DiDiDouItem implements IDeal
   {
      
      private var _itemID:uint;
      
      private var _count:uint;
      
      private var _successFun:Function;
      
      private var _failFun:Function;
      
      private var _checkPriceFun:*;
      
      private var _isEnough:Boolean = true;
      
      private var _needNum:uint;
      
      public function Deal_DiDiDouItem()
      {
         super();
      }
      
      public function BuyItem(itemID:uint, count:uint = 1, successFun:Function = null, failFun:Function = null, checkPriceFun:* = true) : void
      {
         var msg:String = null;
         this._itemID = itemID;
         this._count = count;
         this._successFun = successFun;
         this._failFun = failFun;
         this._checkPriceFun = checkPriceFun;
         var obj:Object = GoodsInfo.getInfoById(this._itemID);
         var price:uint = uint(obj.SpottedBean);
         if(price <= 0)
         {
            this.destroy();
            Alert.smileAlart("      該物品不能使用點點豆購買！");
            return;
         }
         if(obj.VipBuyable == 1 && !LocalUserInfo.isVIP())
         {
            Alert.SLAlart("    只有擁有神奇力量的超級拉姆才能幫你得到這個寶貝哦！我們期待你的加入！");
            return;
         }
         if(1200000 < itemID && itemID < 1210000)
         {
            if(!GV.MAN_PEOPLE.Petlevel || GV.MAN_PEOPLE.Petlevel == 0)
            {
               Alert.smileAlart("    你的拉姆不在你的身邊,不能購買拉姆裝扮！");
               return;
            }
         }
         else if(Boolean(this._checkPriceFun as Function))
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
         var dididouNum:Number = obj.SpottedBean * this._count * 0.01;
         var tit:String = "購買確認";
         msg = "    你確認要花費" + dididouNum + "個點點豆購買" + this._count + "個" + obj.name + "嗎？";
         var url:String = GoodsInfo.GetFullURLByItemId(this._itemID);
         var myAlert:* = Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
         myAlert.addEventListener(Alert.CLICK_ + "1",this.confirmHander);
         myAlert.addEventListener(Alert.CLICK_ + "2",this.cancelHander);
      }
      
      private function confirmHander(evt:*) : void
      {
         this.buy();
      }
      
      private function cancelHander(evt:*) : void
      {
         evt.target.removeEventListener(Alert.CLICK_ + "2",this.cancelHander);
         GV.onlineSocket.dispatchEvent(new Event("diandiandouCancelBuy"));
      }
      
      private function buy() : void
      {
         var getYF:BuyDiDiDouSocket = new BuyDiDiDouSocket();
         getYF.buyItemRequest(this._itemID,this._count);
         GV.itemID = this._itemID;
         BC.addEvent(this,GV.onlineSocket,"read_1256",this.buysuccess);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_dididou",this.buyError);
      }
      
      private function buysuccess(E:EventTaomee) : void
      {
         if(GV.itemID == this._itemID)
         {
            if(this._successFun != null)
            {
               this._successFun(this._itemID,this._count);
            }
            GV.itemID = 0;
            this.destroy();
         }
      }
      
      private function buyError(E:EventTaomee) : void
      {
         var msg:String = null;
         switch(E.EventObj)
         {
            case -10015:
               msg = "   你已經擁有足夠多的該物品，不能再擁有了！";
               GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
               break;
            case -100207:
               Alert.SLAlart("    只有擁有神奇力量的超級拉姆才能幫你得到這個寶貝哦！我們期待你的加入！");
               break;
            case -11201:
               msg = "   你已經擁有足夠多的該物品，不能再擁有了！";
               GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
               break;
            case -12734:
               msg = "   你已經擁有足夠多的該物品，不能再擁有了！";
               GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
               break;
            case -11119:
               msg = "   兌換物品數量不足！";
               GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
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

