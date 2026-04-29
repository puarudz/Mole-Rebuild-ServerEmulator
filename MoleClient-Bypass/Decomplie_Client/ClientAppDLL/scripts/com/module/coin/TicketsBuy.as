package com.module.coin
{
   import com.common.Alert.Alert;
   import com.common.Alert.childAlert.SLBuyAlert;
   import com.common.Alert.type.AlertType;
   import com.event.EventTaomee;
   import com.logic.socket.MoleShop.MoleShopSelect;
   import com.logic.socket.MoleShop.MoleShopSocket;
   import com.mole.net.events.SocketEvent;
   import com.view.mapView.activity.Task83.GolBdeansView;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class TicketsBuy
   {
      
      public static const Buy_Item_Success_Event:String = "CoinBuyNewModle Buy_Item_Success_Event";
      
      private var _id:uint;
      
      private var _count:uint;
      
      private var _activity:uint;
      
      private var _spendName:String;
      
      private var _getname:String;
      
      private var _price:uint;
      
      private var totalNum:Number;
      
      private var SLAlerts:SLBuyAlert;
      
      private var myAle:*;
      
      private var quantifierStr:String = "";
      
      public function TicketsBuy()
      {
         super();
      }
      
      public function BuyModle(ID:uint, count:uint, activity:uint, price:uint, spendName:String, getname:String) : void
      {
         this._id = ID;
         this._count = count;
         this._activity = activity;
         this._spendName = spendName;
         this._getname = getname;
         this._price = price;
         if(Boolean(spendName))
         {
            this.quantifierStr = spendName;
         }
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeAll);
         BC.addEvent(this,GV.onlineSocket,"read_" + 2032,this.bakeCoinApply);
         MoleShopSelect.selectDou();
      }
      
      private function bakeCoinApply(evt:EventTaomee) : void
      {
         var AddMC:MovieClip;
         var info:String;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2032,this.bakeCoinApply);
         this.totalNum = evt.EventObj.count;
         this.SLAlerts = new SLBuyAlert();
         AddMC = new MovieClip();
         info = "    你選擇了" + this.quantifierStr + "需要花費" + this._price + "金豆，目前你擁有" + this.totalNum + "金豆!";
         Alert.angryAlart(info,function(e:Event):void
         {
            buyFun();
         },AlertType.SURE + "," + AlertType.CANCEL);
      }
      
      private function buyFun() : void
      {
         if(this.totalNum >= this._price)
         {
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-52016",this.onBuyError);
            BC.addEvent(this,GV.onlineSocket,"read_" + 2031,this.buyBackHandler);
            BC.addEvent(this,GV.onlineSocket,SocketEvent.ERROR + 2031,this.buyErrorHandler);
            MoleShopSocket.buyCommodity(this._id,this._count,this._activity);
         }
         else
         {
            Alert.angryAlart("    你的金豆餘額不足，現在就去兌換金豆嗎？",function(e:Event):void
            {
               gotoMap();
            },AlertType.SURE + "," + AlertType.CANCEL);
         }
      }
      
      private function onBuyError(e:Event) : void
      {
         BC.removeEvent(this);
      }
      
      private function gotoMap(evt:* = null) : void
      {
         GolBdeansView.getInstance().init();
      }
      
      private function buyErrorHandler(evt:SocketEvent) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2031,this.buyBackHandler);
         BC.removeEvent(this,GV.onlineSocket,SocketEvent.ERROR + 2031,this.buyErrorHandler);
      }
      
      private function buyBackHandler(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2031,this.buyBackHandler);
         BC.removeEvent(this,GV.onlineSocket,SocketEvent.ERROR + 2031,this.buyErrorHandler);
         msg = "　　恭喜你購買了" + this._getname + ",已經放入你的背包中！";
         Alert.smileAlart(msg);
         GV.onlineSocket.dispatchEvent(new EventTaomee(Buy_Item_Success_Event,this._id));
      }
      
      private function removeAll(event:* = null) : void
      {
         BC.removeEvent(this);
         this._id = 0;
         this._count = 0;
         this._activity = 0;
      }
   }
}

