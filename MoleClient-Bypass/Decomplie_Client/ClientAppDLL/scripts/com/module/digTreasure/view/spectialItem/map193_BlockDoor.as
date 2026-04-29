package com.module.digTreasure.view.spectialItem
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.digTreasure.DigTreasureSocket;
   import com.module.digTreasure.DigTreasureEvent;
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import com.module.digTreasure.IDigTreasureSpecialCtl;
   import com.module.digTreasure.data.DigTreasureData;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Dictionary;
   
   public class map193_BlockDoor implements IDigTreasureSpecialCtl
   {
      
      private var _mapUI:MovieClip;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _dataCtl:DigTreasureData;
      
      private var _doorMC:MovieClip;
      
      private var _doorPanel:MovieClip;
      
      private var _tragger:IDigTreasureItemCtl;
      
      private var _mole:PeopleManageView;
      
      public function map193_BlockDoor()
      {
         super();
      }
      
      public function Init(mapUI:MovieClip, View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._mapUI = mapUI;
         this._doorMC = this._mapUI.buttonLevel.mapBtn_194;
         this._doorMC.visible = false;
         this._doorPanel = this._mapUI.top_mc.openDoor_panel;
         this._viewCtl = View;
         this._tragger = this._viewCtl.GetSpecialCtlItem(0);
         this._tragger.StartDigFun = this.TriggerStartDigFun;
         this._dataCtl = dataCtl;
         this._mole = GV.MAN_PEOPLE as PeopleManageView;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,GV.onlineSocket,DigTreasureEvent.DigItemOver,this.CheckState);
      }
      
      private function CheckState(e:Event) : void
      {
         if(this._tragger.state > 1)
         {
            this._doorMC.visible = true;
         }
      }
      
      private function TriggerStartDigFun(tragger:IDigTreasureItemCtl = null) : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.GetBagCmd,this.GetBagHandler);
         DigTreasureSocket.GetBag();
      }
      
      private function GetBagHandler(e:EventTaomee) : void
      {
         var item:Object = null;
         var items:Array = e.EventObj.items;
         var itemDic:Dictionary = new Dictionary();
         for each(item in items)
         {
            itemDic[int(item.id)] = int(item.count);
         }
         if(itemDic[1453060] > 0)
         {
            this._doorPanel.goldKey_mc.visible = true;
            this._doorPanel.goldKey_icon.filters = [];
         }
         else
         {
            this._doorPanel.goldKey_mc.visible = false;
            this._doorPanel.goldKey_icon.filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
         }
         if(itemDic[1453061] > 0)
         {
            this._doorPanel.silverKey_mc.visible = true;
            this._doorPanel.silverKey_icon.filters = [];
         }
         else
         {
            this._doorPanel.silverKey_mc.visible = false;
            this._doorPanel.silverKey_icon.filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
         }
         if(itemDic[1453062] > 0)
         {
            this._doorPanel.copperKey_mc.visible = true;
            this._doorPanel.copperKey_icon.filters = [];
         }
         else
         {
            this._doorPanel.copperKey_mc.visible = false;
            this._doorPanel.copperKey_icon.filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
         }
         this._doorPanel.visible = true;
         this._doorPanel.goldKey_txt.text = GoodsInfo.getItemNameByID(1453060);
         this._doorPanel.silverKey_txt.text = GoodsInfo.getItemNameByID(1453061);
         this._doorPanel.copperKey_txt.text = GoodsInfo.getItemNameByID(1453062);
         if(Boolean(this._doorPanel.copperKey_mc.visible) && Boolean(this._doorPanel.silverKey_mc.visible) && Boolean(this._doorPanel.goldKey_mc.visible))
         {
            SimpleButton(this._doorPanel.open_btn).mouseEnabled = true;
            SimpleButton(this._doorPanel.open_btn).filters = [];
            BC.removeEvent(this,SimpleButton(this._doorPanel.open_btn));
            BC.addOnceEvent(this,SimpleButton(this._doorPanel.open_btn),MouseEvent.CLICK,this.OpenDoor);
         }
         else
         {
            SimpleButton(this._doorPanel.open_btn).filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
            SimpleButton(this._doorPanel.open_btn).mouseEnabled = false;
         }
      }
      
      private function OpenDoor(e:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.OpenDoorOKHandler);
         exchange.exchange_goods(365);
      }
      
      private function OpenDoorOKHandler(e:EventTaomee) : void
      {
         if(e.EventObj.type == 365)
         {
            this._doorPanel.visible = false;
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.OpenDoorOKHandler);
            this._tragger.SendDigCmd();
         }
      }
      
      private function removeEventHandler(e:Event) : void
      {
         BC.removeEvent(this);
      }
   }
}

