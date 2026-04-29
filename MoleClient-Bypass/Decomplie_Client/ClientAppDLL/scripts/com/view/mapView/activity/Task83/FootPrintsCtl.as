package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.view.MapManageView.MapManageView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FootPrintsCtl
   {
      
      public static const PATH:String = "resource/newTask/task10003/foot_";
      
      private const StartTypeID:uint = 1994;
      
      private const DataStartType:uint = 2100000191;
      
      private var _btn:DisplayObject;
      
      private var _typeID:int;
      
      private var _dataType:int;
      
      public function FootPrintsCtl(id:uint)
      {
         super();
         this._typeID = this.StartTypeID + id - 1;
         this._dataType = this.DataStartType + id - 1;
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
         finishSomethingReq.sendReq(this._dataType);
         GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.onDestroy);
      }
      
      private function onDestroy(e:Event) : void
      {
         this.destroy();
      }
      
      private function onLoadSucc(e:DownLoadEvent) : void
      {
         this._btn = e.data;
         this._btn.visible = false;
         var level_mc:DisplayObjectContainer = MapManageView.inst.mapLevel.controlLevel;
         level_mc.addChild(this._btn);
         this._btn.visible = true;
         BC.addEvent(this,this._btn,MouseEvent.CLICK,this.onGetFootPrints);
      }
      
      private function dofinishSomething(event:EventTaomee) : void
      {
         var resID:uint = 0;
         if(event.EventObj.Type == this._dataType)
         {
            if(event.EventObj.Done == 0)
            {
               resID = DownLoadManager.add(PATH + this._typeID + ".swf",ResType.DISPLAY_OBJECT,true);
               DownLoadManager.addEvent(resID,this.onLoadSucc);
            }
         }
      }
      
      private function onGetFootPrints(event:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.onExchangeSuc);
         exchange.exchange_goods(this._typeID);
      }
      
      private function onExchangeSuc(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.onExchangeSuc);
         BC.removeEvent(this,this._btn,MouseEvent.CLICK,this.onGetFootPrints);
         this._btn.visible = false;
         var msg:String = "    恭喜你獲得" + event.EventObj.arr[0].count + "個" + GoodsInfo.getItemNameByID(event.EventObj.arr[0].itemID) + "，已經放入你的2012年腳印收集曆中！";
         Alert.smileAlart(msg);
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.onDestroy);
         BC.removeEvent(this);
      }
   }
}

