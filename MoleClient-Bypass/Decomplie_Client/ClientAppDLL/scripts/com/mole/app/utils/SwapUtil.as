package com.mole.app.utils
{
   import com.common.Alert.Alert;
   import com.common.data.HashMap;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.CommandID;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.module.activityModule.Presented;
   import com.mole.app.info.SwapInfo;
   import com.mole.app.manager.OnlineManager;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   
   public class SwapUtil
   {
      
      private var _swapInfo:SwapInfo;
      
      private var _needItemCount:int;
      
      private var _lackMsg:String;
      
      public function SwapUtil(swapInfo:SwapInfo, itemCount:int, lackMsg:String)
      {
         var peopleView:PeopleManageView = null;
         var itemObj:Object = null;
         super();
         this._swapInfo = swapInfo;
         this._needItemCount = itemCount;
         this._lackMsg = "    " + lackMsg;
         if(this._swapInfo.resID > 1200001 && this._swapInfo.resID < 1210000)
         {
            peopleView = GV.MAN_PEOPLE;
            if(peopleView.Petlevel <= 0)
            {
               Alert.smileAlart("    你沒有帶拉姆，不能領取獎勵哦！");
            }
            else
            {
               this.checkCount();
            }
         }
         else
         {
            itemObj = GoodsInfo.getInfoById(this._swapInfo.resID);
            if(Boolean(itemObj.VipBuyable))
            {
               if(LocalUserInfo.isVIP())
               {
                  this.checkCount();
               }
               else
               {
                  Alert.smileAlart("    只有超級拉姆才能擁有這件物品哦！");
               }
            }
            else
            {
               this.checkCount();
            }
         }
      }
      
      public static function swap(swapInfo:SwapInfo, itemCount:int = -1, lackMsg:String = "兌換物品數量不足") : void
      {
         new SwapUtil(swapInfo,itemCount,lackMsg);
      }
      
      private function checkCount() : void
      {
         if(this._needItemCount == -1)
         {
            OnlineManager.addCmdListener(CommandID.ITEMCOUNT,this.onGetItemCount);
            OnlineManager.addErrorListener(CommandID.ITEMCOUNT,this.onGetItemCountError);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this._swapInfo.needID,2);
         }
         else
         {
            this.sendSwap();
         }
      }
      
      private function onGetItemCount(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onGetItemCount);
         OnlineManager.removeErrorListener(CommandID.ITEMCOUNT,this.onGetItemCountError);
         var itemCountPro:GetItemCountRes = e.bodyInfo;
         var itemCountMap:HashMap = itemCountPro.itemHash;
         var itemInfo:ItemInfo = itemCountMap.getValue(this._swapInfo.needID);
         if(Boolean(itemInfo))
         {
            this._needItemCount = itemInfo.count;
         }
         else
         {
            this._needItemCount = 0;
         }
         this.sendSwap();
      }
      
      private function onGetItemCountError(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onGetItemCount);
         OnlineManager.removeErrorListener(CommandID.ITEMCOUNT,this.onGetItemCountError);
      }
      
      private function sendSwap() : void
      {
         if(this._needItemCount >= this._swapInfo.needCount)
         {
            Presented.getInstance().celebrate1225(this._swapInfo.typeID);
         }
         else
         {
            Alert.smileAlart(this._lackMsg);
         }
      }
   }
}

