package com.common.Alert.childAlert
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class GetItemsAlert
   {
      
      public static const CLOSED_ALL_ALERT_EVENT:String = "CLOSED_ALL_ALERT_EVENT";
      
      private var _itemList:Array;
      
      private var _callBack:Function;
      
      private var _sizeAlert:sizeAlert;
      
      private var _container:DisplayObjectContainer;
      
      public function GetItemsAlert(itemList:Array, container:*, closeAll_hnadler:Function = null)
      {
         super();
         this._callBack = closeAll_hnadler;
         this._itemList = itemList;
         this._container = container;
         this.ShowAlert();
      }
      
      private function ShowAlert() : void
      {
         var item:Array = null;
         var itemId:int = 0;
         var itemCount:int = 0;
         var iconContainer:MovieClip = null;
         var iconloader:Loader = null;
         var gotoMCloader:Loader = null;
         var itemTypeloader:Loader = null;
         var countformat:TextFormat = null;
         var itemCountTxt:TextField = null;
         var format:TextFormat = null;
         var itemNameTxt:TextField = null;
         var itemTypeTxt:TextField = null;
         if(Boolean(this._itemList) && this._itemList.length > 0)
         {
            item = this._itemList.pop();
            itemId = int(item[0]);
            itemCount = 1;
            if(item.length > 1)
            {
               itemCount = int(item[1]);
            }
            this._sizeAlert = new sizeAlert(this._container,"","",0,"ok");
            this._sizeAlert.addEventListener(Alert.CLICK_ + "1",this.CloseOneAlertHandler);
            iconContainer = this._sizeAlert.TARGET.ico_mc;
            iconContainer.x = 20;
            iconContainer.y = 70;
            iconloader = new Loader();
            iconloader.load(VL.getURLRequest(GoodsInfo.GetFullURLByItemId(itemId)));
            iconloader.x = 10;
            iconContainer.addChild(iconloader);
            gotoMCloader = new Loader();
            gotoMCloader.load(VL.getURLRequest("resource/allJob/itemKindIcon/goto.swf"));
            gotoMCloader.x = 100;
            iconContainer.addChild(gotoMCloader);
            itemTypeloader = new Loader();
            itemTypeloader.load(VL.getURLRequest("resource/allJob/itemKindIcon/" + GoodsInfo.getType(itemId) + ".swf"));
            itemTypeloader.x = 190;
            itemTypeloader.y = 3;
            iconContainer.addChild(itemTypeloader);
            countformat = new TextFormat();
            countformat.align = "left";
            countformat.size = 14;
            countformat.color = 16711680;
            itemCountTxt = new TextField();
            itemCountTxt.defaultTextFormat = countformat;
            itemCountTxt.text = itemCount.toString();
            itemCountTxt.y = 50 - itemCountTxt.textHeight;
            itemCountTxt.x = 48;
            iconContainer.addChild(itemCountTxt);
            format = new TextFormat();
            format.align = TextFormatAlign.CENTER;
            itemNameTxt = new TextField();
            itemNameTxt.autoSize = TextFieldAutoSize.CENTER;
            itemNameTxt.text = GoodsInfo.getItemNameByID(itemId);
            itemNameTxt.x = iconloader.x + 25 - itemNameTxt.textWidth / 2;
            itemNameTxt.y = 70 - itemNameTxt.textHeight;
            iconContainer.addChild(itemNameTxt);
            itemTypeTxt = new TextField();
            itemTypeTxt.autoSize = TextFieldAutoSize.CENTER;
            itemTypeTxt.text = GoodsInfo.getItemCollectionBoxNameByID(itemId);
            itemTypeTxt.y = 70 - itemTypeTxt.textHeight;
            itemTypeTxt.x = itemTypeloader.x + 25 - itemTypeTxt.textWidth / 2;
            iconContainer.addChild(itemTypeTxt);
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new Event(CLOSED_ALL_ALERT_EVENT));
            if(this._callBack != null)
            {
               this._callBack();
            }
         }
      }
      
      private function CloseOneAlertHandler(e:Event) : void
      {
         this.ShowAlert();
      }
   }
}

