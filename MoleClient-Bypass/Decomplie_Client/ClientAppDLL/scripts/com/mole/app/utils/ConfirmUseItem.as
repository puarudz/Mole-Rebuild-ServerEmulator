package com.mole.app.utils
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.manager.LevelManager;
   import com.core.manager.UIManager;
   import com.module.query.QueryImpl;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ConfirmUseItem extends Sprite
   {
      
      private var ui:MovieClip;
      
      private var _bkFunc:Function;
      
      private var _itemId:uint;
      
      private var _useCount:uint;
      
      private var _curHaveCount:uint;
      
      private var _isGetCount:Boolean;
      
      private var loader:Loader;
      
      private var closeBtn:SimpleButton;
      
      private var okBtn:SimpleButton;
      
      private var cancelBtn:SimpleButton;
      
      private var curHaveTxt:TextField;
      
      private var askTxt:TextField;
      
      private var curCountTxt:TextField;
      
      private var _ico:Sprite;
      
      public function ConfirmUseItem(itemId:uint, useCount:uint, bkFunc:Function)
      {
         super();
         this._bkFunc = bkFunc;
         this._itemId = itemId;
         this._useCount = useCount;
         this.ui = UIManager.getMovieClip("UI_ConfirmUseItem");
         addChild(LevelManager.drawBG());
         this.ui.x = (TaomeeManager.stageWidth - this.ui.width) / 2;
         this.ui.y = (TaomeeManager.stageHeight - this.ui.height) / 2;
         addChild(this.ui);
         this.closeBtn = this.ui["close_btn"] as SimpleButton;
         this.okBtn = this.ui["yes_btn"] as SimpleButton;
         this.cancelBtn = this.ui["no_btn"] as SimpleButton;
         this.curHaveTxt = this.ui["curHave_txt"] as TextField;
         this.askTxt = this.ui["ask_txt"] as TextField;
         this.curCountTxt = this.ui["curCount_txt"] as TextField;
         this._ico = this.ui["ico_mc"] as Sprite;
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.cancelBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.okBtn.addEventListener(MouseEvent.CLICK,this.okHandler);
         QueryImpl.getInstance().QueryItem([itemId],this.getSuccessFun);
         TaomeeManager.stage.addChild(this);
         this.loader = new Loader();
         this.loader.load(new URLRequest(VL.getURL(GoodsInfo.GetFullURLByItemId(this._itemId))));
         this._ico.addChild(this.loader);
      }
      
      private function getSuccessFun(arr:Array) : void
      {
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i].itemID == this._itemId)
            {
               this.curHaveCount = arr[i].count;
               this._isGetCount = true;
               break;
            }
         }
      }
      
      private function set curHaveCount(val:uint) : void
      {
         this._curHaveCount = val;
         this.curCountTxt.text = String(this._curHaveCount);
         this.askTxt.text = "您確定消耗 " + this._useCount + " " + GoodsInfo.getItemNameByID(this._itemId) + "嗎？";
         this.curHaveTxt.text = "您當前擁有 " + GoodsInfo.getItemNameByID(this._itemId) + ":" + this._curHaveCount;
         if(this._curHaveCount < this._useCount)
         {
            FilterUtil.applyGray(this.okBtn);
            this.okBtn.mouseEnabled = false;
            this.okBtn.removeEventListener(MouseEvent.CLICK,this.okHandler);
            this.askTxt.appendText("\n完成魔法隨心變任務,可獲得靈石!");
         }
      }
      
      private function closeHandler(evt:MouseEvent) : void
      {
         this._bkFunc(0);
         this.destroy();
      }
      
      private function okHandler(evt:MouseEvent) : void
      {
         if(!this._isGetCount)
         {
            return;
         }
         this._bkFunc(1);
         this.destroy();
      }
      
      private function destroy() : void
      {
         if(Boolean(this.loader))
         {
            this.loader = null;
         }
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
         this.cancelBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
         this.okBtn.removeEventListener(MouseEvent.CLICK,this.okHandler);
         DisplayUtil.removeFromParent(this);
      }
   }
}

