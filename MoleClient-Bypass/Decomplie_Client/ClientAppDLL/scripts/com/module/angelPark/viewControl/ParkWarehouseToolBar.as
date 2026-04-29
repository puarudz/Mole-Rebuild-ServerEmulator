package com.module.angelPark.viewControl
{
   import com.common.tip.tip;
   import com.event.EventTaomee;
   import com.module.angelPark.AngelParkView;
   import com.module.angelPark.ParkDragCtl;
   import com.module.angelPark.data.AngelParkDataCtl;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class ParkWarehouseToolBar extends EventDispatcher
   {
      
      public static const HIDE_WAREHOUSE_TOOLBAR:String = "HIDE_WAREHOUSE_TOOLBAR";
      
      public static const KIND_SEED:int = 0;
      
      public static const KIND_ITEM:int = 2;
      
      public static const KIND_BG:int = 1;
      
      public static const PAGE_COUNT:int = 7;
      
      private var _angelParkData:AngelParkDataCtl;
      
      private var _ui:MovieClip;
      
      private var _hideBtn:SimpleButton;
      
      private var _preBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _seedKindMC:MovieClip;
      
      private var _itemKindMC:MovieClip;
      
      private var _bgKindMC:MovieClip;
      
      private var _kindList:Array;
      
      private var _currKind:int;
      
      private var _itemList:Array;
      
      private var _currentDataList:Array;
      
      private var _pageNum:int;
      
      public function ParkWarehouseToolBar(ui:MovieClip)
      {
         var itemCtl:ParkItemCtl = null;
         this._angelParkData = AngelParkView.instance.parkDataCtl;
         super();
         this._ui = ui;
         this._hideBtn = this._ui.hide_btn;
         this._preBtn = this._ui.prev_btn;
         this._nextBtn = this._ui.next_btn;
         this._seedKindMC = this._ui.seedKind_mc;
         this._seedKindMC.buttonMode = true;
         this._itemKindMC = this._ui.itemKind_mc;
         this._itemKindMC.buttonMode = true;
         this._bgKindMC = this._ui.bgKind_mc;
         this._bgKindMC.buttonMode = true;
         this._kindList = new Array();
         this._kindList[KIND_SEED] = this._seedKindMC;
         this._kindList[KIND_ITEM] = this._itemKindMC;
         this._kindList[KIND_BG] = this._bgKindMC;
         this._itemList = new Array();
         for(var i:int = 0; i < PAGE_COUNT; i++)
         {
            itemCtl = new ParkItemCtl(this._ui["item_" + i]);
            this._itemList.push(itemCtl);
         }
      }
      
      public function get currKind() : int
      {
         return this._currKind;
      }
      
      public function set currKind(value:int) : void
      {
         this._currKind = value;
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      private function PrePage(e:MouseEvent) : Boolean
      {
         if(Boolean(this._currentDataList) && Boolean(this._currentDataList[(this._pageNum - 2) * PAGE_COUNT]))
         {
            --this._pageNum;
            this.UpdateKindsInfo();
            return true;
         }
         return false;
      }
      
      private function NextPage(e:MouseEvent) : Boolean
      {
         if(Boolean(this._currentDataList) && Boolean(this._currentDataList[this._pageNum * PAGE_COUNT]))
         {
            ++this._pageNum;
            this.UpdateKindsInfo();
            return true;
         }
         return false;
      }
      
      private function OnMouseOverKindMC(e:MouseEvent) : void
      {
         var currTarget:MovieClip = e.currentTarget as MovieClip;
         currTarget.gotoAndStop(2);
      }
      
      private function OnMouseOutKindMC(e:MouseEvent) : void
      {
         var currTarget:MovieClip = e.currentTarget as MovieClip;
         if(this._kindList.indexOf(currTarget) != this._currKind)
         {
            currTarget.gotoAndStop(1);
         }
      }
      
      private function ChangeShowKind(e:MouseEvent) : void
      {
         var currTarget:MovieClip = e.currentTarget as MovieClip;
         this.ShowKind(this._kindList.indexOf(currTarget));
         BC.addEvent(this,this._seedKindMC,MouseEvent.CLICK,this.ChangeShowKind);
         BC.addEvent(this,this._seedKindMC,MouseEvent.MOUSE_OVER,this.OnMouseOverKindMC);
         BC.addEvent(this,this._seedKindMC,MouseEvent.MOUSE_OUT,this.OnMouseOutKindMC);
      }
      
      private function ShowKind(kind:int) : void
      {
         var kindMC:MovieClip = null;
         this._currKind = kind;
         for(var i:int = 0; i < this._kindList.length; i++)
         {
            kindMC = this._kindList[i];
            kindMC.gotoAndStop(1);
            if(i == this._currKind)
            {
               kindMC.gotoAndStop(2);
            }
         }
         switch(this._currKind)
         {
            case KIND_SEED:
               this._currentDataList = this._angelParkData.wareHouseVO.seedList;
               break;
            case KIND_ITEM:
               this._currentDataList = this._angelParkData.wareHouseVO.itemList;
               break;
            case KIND_BG:
               this._currentDataList = this._angelParkData.wareHouseVO.bgList;
         }
         this._pageNum = 1;
         this.UpdateKindsInfo();
      }
      
      private function UpdateKindsInfo() : void
      {
         var i:int = 0;
         var data:Object = null;
         if(Boolean(this._currentDataList))
         {
            for(i = 0; i < PAGE_COUNT; i++)
            {
               data = this._currentDataList[(this._pageNum - 1) * PAGE_COUNT + i];
               ParkItemCtl(this._itemList[i]).UpdateData(data);
            }
         }
      }
      
      public function HideWareHouseToolBar(e:MouseEvent) : void
      {
         this.dispatchEvent(new Event(HIDE_WAREHOUSE_TOOLBAR));
         ParkDragCtl.StopDrag();
      }
      
      public function get visible() : Boolean
      {
         return this._ui.visible;
      }
      
      public function set visible(value:Boolean) : void
      {
         this._ui.visible = value;
         if(value)
         {
            this._currKind = KIND_SEED;
            this.InitEvent();
         }
         else
         {
            this.RemoveEvent();
         }
      }
      
      public function ShowKinds(kind:int) : void
      {
         if(this._ui.visible)
         {
            this.ShowKind(kind);
         }
         else
         {
            this._ui.visible = true;
            this._currKind = kind;
            this.InitEvent();
         }
      }
      
      public function InitEvent() : void
      {
         tip.tipTailDisPlayObject(this._hideBtn,"返回");
         BC.addEvent(this,this._hideBtn,MouseEvent.CLICK,this.HideWareHouseToolBar);
         BC.addEvent(this,this._preBtn,MouseEvent.CLICK,this.PrePage);
         BC.addEvent(this,this._nextBtn,MouseEvent.CLICK,this.NextPage);
         BC.addEvent(this,this._seedKindMC,MouseEvent.CLICK,this.ChangeShowKind);
         BC.addEvent(this,this._itemKindMC,MouseEvent.CLICK,this.ChangeShowKind);
         BC.addEvent(this,this._bgKindMC,MouseEvent.CLICK,this.ChangeShowKind);
         BC.addEvent(this,this._seedKindMC,MouseEvent.MOUSE_OVER,this.OnMouseOverKindMC);
         BC.addEvent(this,this._itemKindMC,MouseEvent.MOUSE_OVER,this.OnMouseOverKindMC);
         BC.addEvent(this,this._bgKindMC,MouseEvent.MOUSE_OVER,this.OnMouseOverKindMC);
         BC.addEvent(this,this._seedKindMC,MouseEvent.MOUSE_OUT,this.OnMouseOutKindMC);
         BC.addEvent(this,this._itemKindMC,MouseEvent.MOUSE_OUT,this.OnMouseOutKindMC);
         BC.addEvent(this,this._bgKindMC,MouseEvent.MOUSE_OUT,this.OnMouseOutKindMC);
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.UPDATE_WAREHOUSE_EVENT,this.UpdateWareHouseHandler);
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.UPDATE_WAREHOUSE_ITEM_EVENT,this.UpdateWareHouseItemHandler);
         this._angelParkData.GetWareHouseInfo();
      }
      
      private function UpdateWareHouseItemHandler(e:EventTaomee) : void
      {
         var item:Object = null;
         var id:int = 0;
         var index:int = 0;
         if(Boolean(this._currentDataList))
         {
            for each(item in this._currentDataList)
            {
               id = int(e.EventObj);
               if(item.id == id)
               {
                  if(item.count <= 1)
                  {
                     index = this._currentDataList.indexOf(item);
                     this._currentDataList.splice(index,1);
                     if(ParkDragCtl.dragId == id)
                     {
                        ParkDragCtl.StopDrag();
                     }
                     break;
                  }
                  --item.count;
               }
            }
         }
         this.UpdateKindsInfo();
      }
      
      private function UpdateWareHouseHandler(e:Event) : void
      {
         BC.removeEvent(this,this._angelParkData,AngelParkDataCtl.UPDATE_WAREHOUSE_EVENT,this.UpdateWareHouseHandler);
         this.ShowKind(this._currKind);
      }
      
      private function RemoveEvent() : void
      {
         BC.removeEvent(this);
      }
      
      public function Clear() : void
      {
         this.RemoveEvent();
      }
   }
}

