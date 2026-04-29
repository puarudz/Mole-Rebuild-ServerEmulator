package com.module.treasureHouse.view
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.event.EventTaomee;
   import com.logic.socket.treasureHouse.TreasureHouseSocket;
   import com.module.treasureHouse.TreasureHouseEvent;
   import com.module.treasureHouse.TreasureHouseViewCtl;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class TreasureHouseWarehouseView extends EventDispatcher
   {
      
      public static const CLASS_All:int = 100;
      
      public static const CLASS_STATUE:int = 1;
      
      public static const CLASS_BADGE:int = 2;
      
      public static const CLASS_WEAPON:int = 3;
      
      public static const CLASS_OTHER:int = 4;
      
      public static const PAGE_COUNT:int = 7;
      
      private var _ui:MovieClip;
      
      private var _hideBtn:SimpleButton;
      
      private var _preBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _classUIs:Array;
      
      private var _classDatas:Dictionary;
      
      private var _currKind:int;
      
      private var _itemList:Array;
      
      private var _currentDataList:Array;
      
      private var _pageNum:int;
      
      public function TreasureHouseWarehouseView(ui:MovieClip)
      {
         var itemCtl:TreasureItemCtl = null;
         super();
         this._ui = ui;
         this._hideBtn = this._ui.hide_btn;
         this._preBtn = this._ui.prev_btn;
         this._nextBtn = this._ui.next_btn;
         var all_mc:MovieClip = this._ui.all_mc;
         var statue_mc:MovieClip = this._ui.statue_mc;
         var badge_mc:MovieClip = this._ui.badge_mc;
         var weapon_mc:MovieClip = this._ui.weapon_mc;
         var other_mc:MovieClip = this._ui.other_mc;
         this._classUIs = new Array();
         this._classUIs[CLASS_All] = all_mc;
         this._classUIs[CLASS_STATUE] = statue_mc;
         this._classUIs[CLASS_BADGE] = badge_mc;
         this._classUIs[CLASS_WEAPON] = weapon_mc;
         this._classUIs[CLASS_OTHER] = other_mc;
         this._itemList = new Array();
         for(var i:int = 0; i < PAGE_COUNT; i++)
         {
            itemCtl = new TreasureItemCtl(this._ui["item_" + i]);
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
         if(this._classUIs.indexOf(currTarget) != this._currKind)
         {
            currTarget.gotoAndStop(1);
         }
      }
      
      private function ChangeShowKind(e:MouseEvent) : void
      {
         var currTarget:MovieClip = e.currentTarget as MovieClip;
         this.ShowKind(this._classUIs.indexOf(currTarget));
      }
      
      private function ShowKind(kind:int) : void
      {
         var kindMC:MovieClip = null;
         this._currKind = kind;
         for(var i:int = 0; i < this._classUIs.length; i++)
         {
            kindMC = this._classUIs[i];
            if(Boolean(kindMC))
            {
               kindMC.gotoAndStop(1);
               if(i == this._currKind)
               {
                  kindMC.gotoAndStop(2);
               }
            }
         }
         this._currentDataList = this._classDatas[this._currKind];
         if(this._currentDataList == null)
         {
            this._currentDataList = new Array();
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
               TreasureItemCtl(this._itemList[i]).UpdateData(data);
            }
         }
      }
      
      public function HideWareHouseToolBar(e:MouseEvent) : void
      {
         this.dispatchEvent(new Event(TreasureHouseEvent.HIDE_WAREHOUSE_BAR));
         TreasureHouseDragCtl.StopDrag();
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
            this._currKind = CLASS_All;
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
         var kindMC:MovieClip = null;
         tip.tipTailDisPlayObject(this._hideBtn,"返回");
         BC.addEvent(this,this._hideBtn,MouseEvent.CLICK,this.HideWareHouseToolBar);
         BC.addEvent(this,this._preBtn,MouseEvent.CLICK,this.PrePage);
         BC.addEvent(this,this._nextBtn,MouseEvent.CLICK,this.NextPage);
         BC.addEvent(this,GV.onlineSocket,TreasureHouseEvent.MOVE_ITEM_BACK,this.MoveBackItem);
         BC.addEvent(this,this._ui,MouseEvent.MOUSE_OVER,this.OnMoveOverWareHouse);
         BC.addEvent(this,this._ui,MouseEvent.MOUSE_OUT,this.OnMoveOutWareHouse);
         for each(kindMC in this._classUIs)
         {
            if(Boolean(kindMC))
            {
               kindMC.buttonMode = true;
               BC.addEvent(this,kindMC,MouseEvent.CLICK,this.ChangeShowKind);
               BC.addEvent(this,kindMC,MouseEvent.MOUSE_OVER,this.OnMouseOverKindMC);
               BC.addEvent(this,kindMC,MouseEvent.MOUSE_OUT,this.OnMouseOutKindMC);
            }
         }
         BC.addEvent(this,GV.onlineSocket,"read_" + TreasureHouseSocket.SetBoothCmd,this.UpdateWareHouseItemHandler);
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + TreasureHouseSocket.GetTreasureWareHouseCmd,this.UpdateWareHouseHandler);
         TreasureHouseSocket.GetTreasureWareHouse(TreasureHouseViewCtl.instance.userId);
      }
      
      private function OnMoveOutWareHouse(e:MouseEvent) : void
      {
         if(TreasureHouseDragCtl.dragId != -1)
         {
            TreasureHouseDragCtl.HideMoveBackIcon();
            e.stopImmediatePropagation();
         }
      }
      
      private function OnMoveOverWareHouse(e:MouseEvent) : void
      {
         if(TreasureHouseDragCtl.dragId != -1)
         {
            TreasureHouseDragCtl.ShowMoveBackIcon();
            e.stopImmediatePropagation();
         }
      }
      
      private function MoveBackItem(e:EventTaomee) : void
      {
         if(e.EventObj.posId != -1)
         {
            TreasureHouseSocket.SetBooth(e.EventObj.posId,e.EventObj.itemId,0);
         }
      }
      
      private function UpdateWareHouseItemHandler(e:EventTaomee) : void
      {
         var item:Object = null;
         var itemId:int = int(e.EventObj.itemId);
         var state:int = int(e.EventObj.state);
         if(state == 0)
         {
            BC.addOnceEvent(this,GV.onlineSocket,"read_" + TreasureHouseSocket.GetTreasureWareHouseCmd,this.UpdateWareHouseHandler);
            TreasureHouseSocket.GetTreasureWareHouse(TreasureHouseViewCtl.instance.userId);
            TreasureHouseSocket.GetTreasureHouseInfo(TreasureHouseViewCtl.instance.userId);
            return;
         }
         if(Boolean(this._currentDataList))
         {
            for each(item in this._currentDataList)
            {
               if(item.itemId == itemId)
               {
                  if(item.count > 1)
                  {
                     --item.count;
                     break;
                  }
                  TreasureHouseDragCtl.StopDrag();
                  BC.addOnceEvent(this,GV.onlineSocket,"read_" + TreasureHouseSocket.GetTreasureWareHouseCmd,this.UpdateWareHouseHandler);
                  TreasureHouseSocket.GetTreasureWareHouse(TreasureHouseViewCtl.instance.userId);
                  return;
               }
            }
         }
         this.UpdateKindsInfo();
      }
      
      private function UpdateWareHouseHandler(e:EventTaomee) : void
      {
         var item:Object = null;
         var classType:int = 0;
         var itemList:Array = null;
         var items:Array = e.EventObj.items;
         this._classDatas = new Dictionary();
         this._classDatas[CLASS_All] = items;
         for each(item in items)
         {
            classType = int(GoodsInfo.getInfoById(item.itemId).Class);
            if(this._classDatas[classType] == null)
            {
               this._classDatas[classType] = new Array();
            }
            itemList = this._classDatas[classType];
            itemList.push(item);
         }
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

