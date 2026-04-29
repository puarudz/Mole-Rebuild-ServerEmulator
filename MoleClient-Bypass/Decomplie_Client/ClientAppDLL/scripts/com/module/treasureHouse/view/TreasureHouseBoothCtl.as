package com.module.treasureHouse.view
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.event.EventTaomee;
   import com.logic.socket.treasureHouse.TreasureHouseSocket;
   import com.module.treasureHouse.TreasureHouseEvent;
   import com.module.treasureHouse.TreasureHouseViewCtl;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   
   public class TreasureHouseBoothCtl
   {
      
      private var _ui:MovieClip;
      
      private var _lockMC:MovieClip;
      
      private var _contentMC:MovieClip;
      
      private var _boothId:int;
      
      private var _data:Object;
      
      private var _itemMC:MovieClip;
      
      public function TreasureHouseBoothCtl(ui:MovieClip, boothId:int)
      {
         super();
         this._ui = ui;
         this._ui.gotoAndStop(1);
         this._lockMC = this._ui.lock_mc;
         this._lockMC.visible = this.isShowLock();
         this._contentMC = this._ui.content_mc;
         GC.clearAllChildren(this._contentMC);
         this._boothId = boothId;
      }
      
      public function Clear() : void
      {
         this._data = this.GetBoothData(this._boothId);
         this._ui.gotoAndStop(1);
         if(!Boolean(this._data))
         {
            GC.clearAllChildren(this._contentMC);
         }
      }
      
      public function UpdateData() : void
      {
         var loader:Loader = null;
         var id:String = null;
         var path:String = null;
         var data:Object = this.GetBoothData(this._boothId);
         if(Boolean(this._data && data) && Boolean(data.posId == this._data.posId) && data.itemId == this._data.itemId)
         {
            this._data = data;
            this.UpdateBooth();
         }
         else
         {
            this._data = data;
            BC.removeEvent(this);
            GC.clearAllChildren(this._contentMC);
            this._itemMC = null;
            if(Boolean(this._data))
            {
               loader = new Loader();
               id = this._data.itemId;
               path = "resource/digTreasure/swf/" + id + ".swf";
               loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.ItemMCLoadOk);
               loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ItemMCLoadError);
               loader.load(VL.getURLRequest(path));
            }
            else
            {
               this.AddEvent();
               this.UpdateBooth();
            }
         }
      }
      
      private function ItemMCLoadOk(e:Event) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         loaderInfo.removeEventListener(Event.COMPLETE,this.ItemMCLoadError);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ItemMCLoadError);
         this._itemMC = loaderInfo.content as MovieClip;
         this._itemMC = this._itemMC.getChildAt(0) as MovieClip;
         this._contentMC.addChild(this._itemMC);
         loaderInfo = null;
         this.AddEvent();
         this.UpdateBooth();
      }
      
      private function ItemMCLoadError(e:IOErrorEvent) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         loaderInfo.removeEventListener(Event.COMPLETE,this.ItemMCLoadOk);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ItemMCLoadError);
         throw new Error("藏寶閣素材加載錯誤:" + this._data.itemId);
      }
      
      private function AddEvent() : void
      {
         BC.addEvent(this,this._ui,MouseEvent.MOUSE_OVER,this.OnMouseOverHandler);
         BC.addEvent(this,this._ui,MouseEvent.MOUSE_OUT,this.OnMouseOutHandler);
         BC.addEvent(this,this._ui,MouseEvent.CLICK,this.OnClickHandler);
         BC.addEvent(this,this._ui,MouseEvent.MOUSE_DOWN,this.OnMouseDownHandler);
      }
      
      private function OnMouseDownHandler(e:MouseEvent) : void
      {
         if(TreasureHouseViewCtl.instance.edit)
         {
            if(Boolean(this._data))
            {
               if(TreasureHouseDragCtl.dragId != -1)
               {
                  e.stopImmediatePropagation();
               }
            }
         }
      }
      
      private function OnClickHandler(e:MouseEvent) : void
      {
         if(this.isShowLock())
         {
            return;
         }
         if(TreasureHouseViewCtl.instance.edit)
         {
            if(Boolean(this._data))
            {
               if(this._boothId == TreasureHouseDragCtl.dragPos)
               {
                  this._itemMC.visible = true;
                  TreasureHouseDragCtl.StopDrag();
               }
               else if(TreasureHouseDragCtl.dragId == -1)
               {
                  this._itemMC.visible = false;
                  var _temp_4:* = BC;
                  var _temp_3:* = this;
                  var _temp_2:* = GV.onlineSocket;
                  var _temp_1:* = TreasureHouseEvent.STOP_DRAG;
                  with({})
                  {
                     
                     _temp_4.addOnceEvent(_temp_3,_temp_2,_temp_1,function h(e:EventTaomee):void
                     {
                        if(e.EventObj.posId == _boothId && e.EventObj.itemId == _data.itemId && e.EventObj.banVisible == true && e.EventObj.moveBackVisible == false)
                        {
                           _itemMC.visible = true;
                           TreasureHouseDragCtl.StopDrag();
                        }
                     });
                  }
                  else
                  {
                     TreasureHouseDragCtl.StopDrag();
                  }
               }
               else
               {
                  this.SetBooth();
               }
            }
            else if(Boolean(this._data) && TreasureHouseViewCtl.isInMyHouse)
            {
               this.ChangeState();
            }
         }
         
         private function ChangeState() : void
         {
            var state:int;
            var maxState:int;
            var _temp_4:* = BC;
            var _temp_3:* = this;
            var _temp_2:* = GV.onlineSocket;
            var _temp_1:* = "read_" + TreasureHouseSocket.ChangeBoothStateCmd;
            with({})
            {
               _temp_4.addOnceEvent(_temp_3,_temp_2,_temp_1,function handler(e:EventTaomee):void
               {
                  _data.state = e.EventObj.state;
                  UpdateBooth();
               });
               state = int(this._data.state);
               maxState = 2;
               state++;
               if(state > maxState)
               {
                  state = 1;
               }
               TreasureHouseSocket.ChangeBoothState(this._boothId,state);
            }
            
            private function SetBooth() : void
            {
               /*
                * Decompilation error
                * Code may be obfuscated
                * Tip: You can try enabling "Deobfuscate code" option in Settings
                * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
                */
               throw new flash.errors.IllegalOperationError("Not decompiled due to error");
            }
            
            private function OnMouseOutHandler(e:MouseEvent) : void
            {
               if(TreasureHouseDragCtl.dragId != -1)
               {
                  TreasureHouseDragCtl.ShowBanIcon();
               }
            }
            
            private function OnMouseOverHandler(e:MouseEvent) : void
            {
               if(TreasureHouseViewCtl.instance.edit && !this.isShowLock() && TreasureHouseDragCtl.dragId != -1 && !this._data)
               {
                  TreasureHouseDragCtl.HideBanIcon();
               }
            }
            
            private function UpdateBooth() : void
            {
               this._lockMC.visible = this.isShowLock();
               if(this._lockMC.visible)
               {
                  tip.tipTailDisPlayObject(this._ui,TreasureHouseViewCtl.instance.nextUnLockLevel + "級後解鎖");
               }
               this._ui.visible = this._boothId < TreasureHouseViewCtl.instance.nextLevelBoothCount;
               if(TreasureHouseViewCtl.instance.edit)
               {
                  this._ui.buttonMode = false;
                  if(Boolean(this._data))
                  {
                     this._ui.gotoAndStop(3);
                  }
                  else
                  {
                     this._ui.gotoAndStop(2);
                  }
               }
               else
               {
                  this._ui.buttonMode = true;
                  this._ui.gotoAndStop(1);
               }
               if(!this._data)
               {
                  this._ui.buttonMode = false;
               }
               if(Boolean(this._itemMC))
               {
                  this._itemMC.gotoAndStop(this._data.state);
                  if(TreasureHouseViewCtl.instance.edit)
                  {
                     tip.delTipTailDisPlayObject(this._ui);
                  }
                  else
                  {
                     tip.tipTailDisPlayObject(this._ui,GoodsInfo.getItemNameByID(this._data.itemId));
                  }
               }
            }
            
            private function isShowLock() : Boolean
            {
               if(!TreasureHouseViewCtl.instance.edit)
               {
                  return false;
               }
               return this._boothId < TreasureHouseViewCtl.instance.nextLevelBoothCount && this._boothId >= TreasureHouseViewCtl.instance.lockedBoothId;
            }
            
            private function GetBoothData(boothId:int) : Object
            {
               var boothData:Object = null;
               var data:Object = null;
               var booths:Array = TreasureHouseViewCtl.instance.boothDatas;
               if(Boolean(booths))
               {
                  for each(boothData in booths)
                  {
                     if(boothId == boothData.posId)
                     {
                        data = boothData;
                        break;
                     }
                  }
               }
               return data;
            }
         }
      }
      
      