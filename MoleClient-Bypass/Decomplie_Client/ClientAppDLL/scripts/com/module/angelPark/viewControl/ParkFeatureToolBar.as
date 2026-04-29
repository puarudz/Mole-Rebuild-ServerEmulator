package com.module.angelPark.viewControl
{
   import com.common.tip.tip;
   import com.module.angelPark.ParkExtenalModelCtl;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class ParkFeatureToolBar extends EventDispatcher
   {
      
      public static const HIDE_FEATURE_TOOLBAR:String = "HIDE_FEATURE_TOOLBAR";
      
      private var _ui:MovieClip;
      
      private var _wareHouseToolBar:ParkWarehouseToolBar;
      
      private var _hideBtn:SimpleButton;
      
      private var _itemsBtn:SimpleButton;
      
      private var _angelParkMenuBtn:SimpleButton;
      
      private var _auraBtn:SimpleButton;
      
      private var _shopBtn:SimpleButton;
      
      private var _honorBtn:SimpleButton;
      
      private var _combineBtn:SimpleButton;
      
      public function ParkFeatureToolBar(ui:MovieClip, wareHouseBar:ParkWarehouseToolBar)
      {
         super();
         this._ui = ui;
         this._hideBtn = this._ui.hide_btn;
         this._itemsBtn = this._ui.items_btn;
         this._angelParkMenuBtn = this._ui.angelParkMenu_btn;
         this._auraBtn = this._ui.aura_btn;
         this._shopBtn = this._ui.shop_btn;
         this._honorBtn = this._ui.honor_btn;
         this._combineBtn = this._ui.combine_btn;
         this._wareHouseToolBar = wareHouseBar;
         BC.addEvent(this,this._wareHouseToolBar,ParkWarehouseToolBar.HIDE_WAREHOUSE_TOOLBAR,this.HideWareHouseBar);
         tip.tipTailDisPlayObject(this._hideBtn,"返回");
         BC.addEvent(this,this._hideBtn,MouseEvent.CLICK,this.HideFeatrueToolBar);
         tip.tipTailDisPlayObject(this._itemsBtn,"打開天使園倉庫");
         BC.addEvent(this,this._itemsBtn,MouseEvent.CLICK,this.ShowWareHouseBar);
         tip.tipTailDisPlayObject(this._angelParkMenuBtn,"進入天使聖殿");
         BC.addEvent(this,this._angelParkMenuBtn,MouseEvent.CLICK,this.OpenAngelParkMenu);
         tip.tipTailDisPlayObject(this._auraBtn,"補充天使園靈氣");
         BC.addEvent(this,this._auraBtn,MouseEvent.CLICK,this.OpenAddAuraPanel);
         tip.tipTailDisPlayObject(this._shopBtn,"打開天使園商店");
         BC.addEvent(this,this._shopBtn,MouseEvent.CLICK,this.OpenShopPanel);
         tip.tipTailDisPlayObject(this._honorBtn,"查看天使榮譽");
         BC.addEvent(this,this._honorBtn,MouseEvent.CLICK,this.OpenHonorPanel);
         tip.tipTailDisPlayObject(this._combineBtn,"天使強化");
         BC.addEvent(this,this._combineBtn,MouseEvent.CLICK,this.OpenCombinePanel);
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      private function OpenCombinePanel(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenCombinePanel();
      }
      
      private function OpenHonorPanel(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenHonorPanel();
      }
      
      private function OpenShopPanel(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenShopPanel();
      }
      
      private function OpenAddAuraPanel(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenAddAuraPanel();
      }
      
      private function OpenAngelParkMenu(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenAngelParkMenu();
      }
      
      public function HideWareHouseBar(e:Event = null) : void
      {
         this._wareHouseToolBar.visible = false;
         this.visible = true;
      }
      
      public function ShowWareHouseBar(e:MouseEvent = null) : void
      {
         this._wareHouseToolBar.visible = true;
         this.visible = false;
      }
      
      public function ShowWareHouseKinds(kind:int) : void
      {
         this._wareHouseToolBar.ShowKinds(kind);
         this.visible = false;
      }
      
      private function HideFeatrueToolBar(e:MouseEvent) : void
      {
         this.dispatchEvent(new Event(HIDE_FEATURE_TOOLBAR));
      }
      
      public function get visible() : Boolean
      {
         return this._ui.visible;
      }
      
      public function set visible(value:Boolean) : void
      {
         this._ui.visible = value;
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
      }
   }
}

