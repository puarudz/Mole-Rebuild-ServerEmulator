package com.view.mapView.activity.mapActivity.elaineParty
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class GuessPartyInfoView extends BasePartyView
   {
      
      private static const PAGE_COUNT:int = 10;
      
      private var _itemList:Array;
      
      private var _itemIconList:Array;
      
      private var _loaded:Boolean = false;
      
      private var _preBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _pageNum:int = 1;
      
      public function GuessPartyInfoView(ui:MovieClip)
      {
         super(ui);
         this._itemList = [{
            "mc":null,
            "id":190801,
            "count":1
         },{
            "mc":null,
            "id":1220157,
            "count":1
         },{
            "mc":null,
            "id":190802,
            "count":1
         },{
            "mc":null,
            "id":190749,
            "count":1
         },{
            "mc":null,
            "id":190803,
            "count":1
         },{
            "mc":null,
            "id":190748,
            "count":1
         },{
            "mc":null,
            "id":190713,
            "count":1
         },{
            "mc":null,
            "id":190712,
            "count":1
         },{
            "mc":null,
            "id":190715,
            "count":1
         },{
            "mc":null,
            "id":190750,
            "count":1
         },{
            "mc":null,
            "id":190751,
            "count":1
         },{
            "mc":null,
            "id":190752,
            "count":1
         },{
            "mc":null,
            "id":190753,
            "count":1
         },{
            "mc":null,
            "id":190754,
            "count":1
         },{
            "mc":null,
            "id":190755,
            "count":1
         },{
            "mc":null,
            "id":190756,
            "count":1
         },{
            "mc":null,
            "id":190757,
            "count":1
         },{
            "mc":null,
            "id":1270017,
            "count":1
         },{
            "mc":null,
            "id":1270018,
            "count":1
         },{
            "mc":null,
            "id":1270012,
            "count":1
         },{
            "mc":null,
            "id":1270055,
            "count":1
         },{
            "mc":null,
            "id":1270052,
            "count":1
         },{
            "mc":null,
            "id":1270059,
            "count":1
         },{
            "mc":null,
            "id":1270060,
            "count":1
         },{
            "mc":null,
            "id":1270065,
            "count":1
         },{
            "mc":null,
            "id":1270064,
            "count":1
         },{
            "mc":null,
            "id":1270044,
            "count":1
         },{
            "mc":null,
            "id":1270010,
            "count":1
         },{
            "mc":null,
            "id":1270021,
            "count":1
         },{
            "mc":null,
            "id":190028,
            "count":50
         },{
            "mc":null,
            "id":190026,
            "count":50
         },{
            "mc":null,
            "id":190351,
            "count":20
         },{
            "mc":null,
            "id":190196,
            "count":30
         }];
         this._itemIconList = [_ui["item_0"],_ui["item_1"],_ui["item_2"],_ui["item_3"],_ui["item_4"],_ui["item_5"],_ui["item_6"],_ui["item_7"],_ui["item_8"],_ui["item_9"]];
         this._closeBtn = _ui["close_btn"];
         this._preBtn = _ui["pre_btn"];
         this._nextBtn = _ui["next_btn"];
      }
      
      override protected function Init() : void
      {
         var obj:Object = null;
         var loader:Loader = null;
         var path:String = null;
         var name:String = null;
         super.Init();
         this._pageNum = 1;
         BC.addEvent(this,this._preBtn,MouseEvent.CLICK,this.PrePage);
         BC.addEvent(this,this._nextBtn,MouseEvent.CLICK,this.NextPage);
         if(this._loaded)
         {
            this.UpdateItems();
            return;
         }
         for each(obj in this._itemList)
         {
            loader = new Loader();
            path = GoodsInfo.GetFullURLByItemId(obj.id);
            name = GoodsInfo.getItemNameByID(obj.id);
            obj.mc = loader;
            tip.tipTailDisPlayObject(loader,name + ": " + obj.count + "個");
            loader.load(new URLRequest(path));
         }
         this._loaded = true;
         this.UpdateItems();
      }
      
      public function PrePage(e:MouseEvent) : void
      {
         if(Boolean(this._itemList[(this._pageNum - 2) * PAGE_COUNT]))
         {
            --this._pageNum;
            this.UpdateItems();
         }
      }
      
      public function NextPage(e:MouseEvent) : void
      {
         if(Boolean(this._itemList[this._pageNum * PAGE_COUNT]))
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
            data = this._itemList[(this._pageNum - 1) * PAGE_COUNT + i];
            if(Boolean(data))
            {
               MovieClip(this._itemIconList[i]).addChild(data.mc);
            }
         }
      }
   }
}

