package com.view.mapView.activity.mapActivity.elaineParty
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.elaineParty.ElainePartySocket;
   import com.logic.socket.lookBag.LookBagReq;
   import com.logic.socket.lookBag.LookBagRes;
   import com.module.ui.ItemCountAlert;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class DonateItemView extends BasePartyView
   {
      
      private static const PAGE_COUNT:int = 6;
      
      private var _cancelBtn:SimpleButton;
      
      private var _rankView:DonateItemRankView;
      
      private var _rankBtn:SimpleButton;
      
      private var _itemIconList:Array;
      
      private var _showItemList:Array;
      
      private var _preBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _pageNum:int = 1;
      
      private var _donateId:int;
      
      private var _donateCount:int;
      
      public function DonateItemView(ui:MovieClip)
      {
         super(ui);
         _closeBtn = _ui["close_btn"];
         this._cancelBtn = _ui["cancelBtn"];
         this._rankView = new DonateItemRankView(_ui["rank_mc"]);
         this._rankBtn = _ui["showRank_btn"];
         this._itemIconList = [_ui["item_0"],_ui["item_1"],_ui["item_2"],_ui["item_3"],_ui["item_4"],_ui["item_5"]];
         this._preBtn = _ui["preBtn"];
         this._nextBtn = _ui["nextBtn"];
      }
      
      override protected function Init() : void
      {
         super.Init();
         BC.addEvent(this,this._rankBtn,MouseEvent.CLICK,this.ShowRankView);
         BC.addEvent(this,this._preBtn,MouseEvent.CLICK,this.PrePage);
         BC.addEvent(this,this._nextBtn,MouseEvent.CLICK,this.NextPage);
         BC.addEvent(this,this._cancelBtn,MouseEvent.CLICK,CloseBtnHandler);
         BC.addEvent(this,GV.onlineSocket,LookBagRes.BAG_OVER,this.LoadBagItemsHandler);
         var lookBagReq:LookBagReq = new LookBagReq();
         lookBagReq.lookBag(GV.MyInfo_userID,1 | 2 | 0x80,0);
      }
      
      private function LoadBagItemsHandler(e:EventTaomee) : void
      {
         var bagObj:Object;
         var items:Array;
         var item:Object = null;
         var obj:Object = null;
         var itemId:int = 0;
         var itemCount:int = 0;
         var loader:Loader = null;
         var path:String = null;
         var container:Sprite = null;
         var xml:XML = XMLInfo.DonateXML;
         this._showItemList = new Array();
         bagObj = e.EventObj.obj;
         items = bagObj.arr;
         for each(item in items)
         {
            itemId = int(item.id);
            itemCount = int(item.itemCount);
            if(itemCount > 0 && Boolean(xml.Item.(@ID == itemId)[0]))
            {
               this._showItemList.push(item);
            }
         }
         for each(obj in this._showItemList)
         {
            loader = new Loader();
            path = GoodsInfo.GetFullURLByItemId(obj.id);
            container = new Sprite();
            container.addChild(loader);
            container.buttonMode = true;
            obj.mc = container;
            tip.tipTailDisPlayObject(container,obj.name + ": " + obj.itemCount + "個");
            loader.load(new URLRequest(path));
            BC.addEvent(this,container,MouseEvent.CLICK,this.DonateItemHandler);
         }
         this._pageNum = 1;
         this.UpdateItems();
      }
      
      public function PrePage(e:MouseEvent) : void
      {
         if(Boolean(this._showItemList[(this._pageNum - 2) * PAGE_COUNT]))
         {
            --this._pageNum;
            this.UpdateItems();
         }
      }
      
      public function NextPage(e:MouseEvent) : void
      {
         if(Boolean(this._showItemList[this._pageNum * PAGE_COUNT]))
         {
            ++this._pageNum;
            this.UpdateItems();
         }
      }
      
      private function UpdateItems() : void
      {
         var data:Object = null;
         for(var i:int = 0; i < PAGE_COUNT; i++)
         {
            try
            {
               MovieClip(this._itemIconList[i]).removeChildAt(0);
            }
            catch(e:Error)
            {
            }
            data = this._showItemList[(this._pageNum - 1) * PAGE_COUNT + i];
            if(Boolean(data))
            {
               MovieClip(this._itemIconList[i]).addChild(data.mc);
            }
         }
      }
      
      private function DonateItemHandler(e:MouseEvent) : void
      {
         var item:Object = null;
         var itemCountAlert:ItemCountAlert = null;
         var tar:Object = e.currentTarget;
         for each(item in this._showItemList)
         {
            if(item.mc == tar)
            {
               break;
            }
         }
         if(Boolean(item))
         {
            itemCountAlert = new ItemCountAlert();
            BC.addEvent(this,itemCountAlert,ItemCountAlert.ITEM_COUNT_SELECTED_OK,this.ItemCountAlertHandler);
            itemCountAlert.ShowAlert(item.id,item.itemCount,"你要捐幾個呢？");
         }
      }
      
      private function ItemCountAlertHandler(e:EventTaomee) : void
      {
         this._donateId = e.EventObj.id;
         this._donateCount = e.EventObj.count;
         var name:String = GoodsInfo.getItemNameByID(this._donateId);
         var elaineMCUrl:String = "resource/allJob/AlertPic/elaine.swf";
         var msg:String = "     親愛的小摩爾，你確定要捐贈" + this._donateCount + "個" + name + "嗎？熱心公益是一種美德哦！";
         var alert:* = Alert.showAlert(MainManager.getAppLevel(),elaineMCUrl,msg,Alert.CHANG_ALERT,"sure,notgo",true,false,"SMCUI");
         BC.addEvent(this,alert,"CLICK" + 1,this.DonateItemSureHandler);
      }
      
      private function DonateItemSureHandler(e:Event) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + ElainePartySocket.CharityOfferCommand,this.DonateItemOkHandler);
         ElainePartySocket.CharityOffer(this._donateId,this._donateCount);
      }
      
      private function DonateItemOkHandler(e:EventTaomee) : void
      {
         var item:Object = null;
         var elaineMCUrl:String = null;
         var msg:String = null;
         var index:int = 0;
         for each(item in this._showItemList)
         {
            if(item.id == this._donateId)
            {
               item.itemCount -= this._donateCount;
               tip.tipTailDisPlayObject(item.mc,item.name + ": " + item.itemCount + "個");
               if(item.itemCount <= 0)
               {
                  index = this._showItemList.indexOf(item);
                  this._showItemList.splice(index,1);
                  this.UpdateItems();
               }
               break;
            }
         }
         BC.removeEvent(this,GV.onlineSocket,"read_" + ElainePartySocket.CharityOfferCommand,this.DonateItemOkHandler);
         elaineMCUrl = "resource/allJob/AlertPic/elaine.swf";
         msg = "    非常感謝你為莊園慈善基金貢獻愛心哦！我們一定會把你的愛心傳遞給需要幫助的摩爾和拉姆！";
         Alert.showAlert(MainManager.getAppLevel(),elaineMCUrl,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
      }
      
      private function ShowRankView(e:MouseEvent) : void
      {
         MainManager.getAppLevel().addChild(this._rankView.GetUI());
      }
   }
}

