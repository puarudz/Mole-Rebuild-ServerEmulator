package com.module.ui
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   public class ItemCountAlert extends EventDispatcher
   {
      
      public static const ITEM_COUNT_SELECTED_OK:String = "ITEM_COUNT_SELECTED_OK";
      
      private static const UI_URL:String = "resource/ui/ItemCountAlert.swf";
      
      private var _ui:MovieClip;
      
      private var _minusBtn:SimpleButton;
      
      private var _addBtn:SimpleButton;
      
      private var _cancelBtn:SimpleButton;
      
      private var _okBtn:SimpleButton;
      
      private var _closeBtn:SimpleButton;
      
      private var _itemMC:MovieClip;
      
      private var _itemNameTxt:TextField;
      
      private var _tipTxt:TextField;
      
      private var _itemCountTxt:TextField;
      
      private var _itemId:int;
      
      private var _maxCount:int;
      
      private var _tip:String;
      
      public function ItemCountAlert()
      {
         super();
      }
      
      public function ShowAlert(itemId:int, maxCount:int, tip:String) : void
      {
         this._itemId = itemId;
         this._maxCount = maxCount;
         this._tip = tip;
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.OnUILoadedHandler);
         loader.load(new URLRequest(UI_URL));
      }
      
      private function OnUILoadedHandler(e:Event) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         loaderInfo.removeEventListener(Event.COMPLETE,this.OnUILoadedHandler);
         this._ui = loaderInfo.content as MovieClip;
         loaderInfo = null;
         this._ui = this._ui["alert_mc"];
         this._minusBtn = this._ui["minus_btn"];
         this._addBtn = this._ui["add_btn"];
         this._cancelBtn = this._ui["no_btn"];
         this._okBtn = this._ui["yes_btn"];
         this._closeBtn = this._ui["close_btn"];
         this._itemMC = this._ui["item_mc"];
         this._itemNameTxt = this._ui["name_txt"];
         this._tipTxt = this._ui["tips_txt"];
         this._itemCountTxt = this._ui["t_txt"];
         this._itemCountTxt.restrict = "0-9";
         MainManager.getStage().addChild(this._ui);
         this._tipTxt.text = this._tip;
         this._itemCountTxt.text = "1";
         this._itemNameTxt.text = GoodsInfo.getItemNameByID(this._itemId) + ": " + this._maxCount + "個";
         var loader:Loader = new Loader();
         this._itemMC.addChild(loader);
         loader.load(new URLRequest(GoodsInfo.GetFullURLByItemId(this._itemId)));
         BC.addEvent(this,this._minusBtn,MouseEvent.CLICK,this.MinusHandler);
         BC.addEvent(this,this._addBtn,MouseEvent.CLICK,this.AddHandler);
         BC.addEvent(this,this._cancelBtn,MouseEvent.CLICK,this.CloseHandler);
         BC.addEvent(this,this._closeBtn,MouseEvent.CLICK,this.CloseHandler);
         BC.addEvent(this,this._okBtn,MouseEvent.CLICK,this.OkHandler);
         BC.addEvent(this,this._itemCountTxt,Event.CHANGE,this.CountChangeHandler);
      }
      
      private function MinusHandler(e:MouseEvent) : void
      {
         var count:int = int(this._itemCountTxt.text);
         count--;
         this._itemCountTxt.text = count.toString();
         this.CountChangeHandler();
      }
      
      private function AddHandler(e:MouseEvent) : void
      {
         var count:int = int(this._itemCountTxt.text);
         count++;
         this._itemCountTxt.text = count.toString();
         this.CountChangeHandler();
      }
      
      private function CloseHandler(e:MouseEvent) : void
      {
         BC.removeEvent(this);
         try
         {
            this._ui.parent.removeChild(this._ui);
         }
         catch(e:Error)
         {
         }
      }
      
      private function OkHandler(e:MouseEvent) : void
      {
         var count:int = int(this._itemCountTxt.text);
         this.dispatchEvent(new EventTaomee(ITEM_COUNT_SELECTED_OK,{
            "id":this._itemId,
            "count":count
         }));
         this.CloseHandler(e);
      }
      
      private function CountChangeHandler(e:Event = null) : void
      {
         var count:int = int(this._itemCountTxt.text);
         if(count < 1)
         {
            count = 1;
         }
         else if(count > this._maxCount)
         {
            count = this._maxCount;
         }
         this._itemCountTxt.text = count.toString();
      }
   }
}

