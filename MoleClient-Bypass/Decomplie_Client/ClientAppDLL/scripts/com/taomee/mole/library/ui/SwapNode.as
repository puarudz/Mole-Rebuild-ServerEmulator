package com.taomee.mole.library.ui
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.module.LocusWork.NumSprite;
   import com.module.coin.CoinBuyNewModle;
   import com.mole.app.info.SwapInfo;
   import com.mole.app.ui.LoaderItemIcon;
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class SwapNode
   {
      
      private var _node_mc:Sprite;
      
      private var _iconLoad:LoaderItemIcon;
      
      private var _count_txt:TextField;
      
      private var _countSpr:NumSprite;
      
      private var _num_txt:TextField;
      
      private var _name_txt:TextField;
      
      private var _good_txt:TextField;
      
      private var _swap_btn:SimpleButton;
      
      private var _buy_btn:SimpleButton;
      
      private var _swap:SwapUI;
      
      private var _swapInfo:SwapInfo;
      
      public function SwapNode(node_mc:Sprite, swap:SwapUI, scale:Number)
      {
         super();
         this._node_mc = node_mc;
         this._node_mc.visible = false;
         this._swap = swap;
         this._iconLoad = new LoaderItemIcon(this._node_mc["iconCon"],scale);
         this._count_txt = this._node_mc["count_txt"];
         var count_mc:DisplayObject = this._node_mc.getChildByName("count_mc");
         if(Boolean(count_mc))
         {
            this._countSpr = new NumSprite(count_mc,0,false,true);
         }
         this._swap_btn = this._node_mc["swap_btn"];
         this._swap_btn.addEventListener(MouseEvent.CLICK,this.onSwap);
         this._num_txt = this._node_mc["num_txt"];
         this._name_txt = this._node_mc["name_txt"];
         this._good_txt = this._node_mc["good_txt"];
         this._buy_btn = this._node_mc["buy_btn"];
         if(Boolean(this._buy_btn))
         {
            BC.addEvent(this,this._buy_btn,MouseEvent.CLICK,this.onClickBuy);
         }
      }
      
      private function onClickBuy(e:Event) : void
      {
         var con:* = new CoinBuyNewModle();
         con.BuyModle(this._swapInfo.goodsID,1);
      }
      
      protected function get numXStr() : String
      {
         return "x";
      }
      
      public function get swapInfo() : SwapInfo
      {
         return this._swapInfo;
      }
      
      public function get swapBtn() : SimpleButton
      {
         return this._swap_btn;
      }
      
      public function setInfo(info:SwapInfo) : void
      {
         this._swapInfo = info;
         if(Boolean(this._swapInfo))
         {
            this._node_mc.visible = true;
            this._iconLoad.setIconID(this._swapInfo.resID);
            if(Boolean(this._count_txt))
            {
               this._count_txt.text = this.numXStr + String(this._swapInfo.needCount);
            }
            if(Boolean(this._countSpr))
            {
               this._countSpr.value = this._swapInfo.needCount;
            }
            if(Boolean(this._swapInfo.dec))
            {
               tip.tipTailDisPlayObject(this._node_mc,this._swapInfo.dec);
            }
            if(Boolean(this._num_txt))
            {
               this._num_txt.text = String(this._swapInfo.needCount);
            }
            if(Boolean(this._name_txt))
            {
               this._name_txt.text = GoodsInfo.getItemNameByID(this._swapInfo.resID);
            }
            if(Boolean(this._good_txt))
            {
               this._good_txt.text = String(this._swapInfo.goodsPrize);
            }
         }
         else
         {
            this._node_mc.visible = false;
         }
      }
      
      private function onSwap(e:MouseEvent) : void
      {
         this._swap.swap(this._swapInfo);
      }
      
      public function destroy() : void
      {
         this._swap_btn.removeEventListener(MouseEvent.CLICK,this.onSwap);
         this._swap = null;
      }
   }
}

