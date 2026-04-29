package com.module.coin
{
   import com.event.EventTaomee;
   import com.logic.socket.coinBuy.*;
   import flash.events.EventDispatcher;
   
   public class CoinInfo extends EventDispatcher
   {
      
      public static var All_Info:Array;
      
      public static var Item_Info:Array;
      
      public static var Home_Info:Array;
      
      public static var Coin_Info:CoinInfo;
      
      public static var GET_INFO:String = "GET_INFO_COIN";
      
      public static var askIndex:uint = 0;
      
      private var SLGoodsXMLs:SLGoodsXML;
      
      private var Max_Flag:uint = 0;
      
      public function CoinInfo()
      {
         super();
         All_Info = null;
         Item_Info = null;
         Home_Info = null;
         this.SLGoodsXMLs = new SLGoodsXML();
      }
      
      public static function getCoin() : CoinInfo
      {
         if(!Coin_Info)
         {
            Coin_Info = new CoinInfo();
         }
         return Coin_Info;
      }
      
      public function getOneInfo(ID:uint) : Object
      {
         var Obj:Object = new Object();
         for(var i:uint = 0; i < All_Info.length; i++)
         {
            if(All_Info[i].commodity_ID == ID)
            {
               Obj = All_Info[i];
               break;
            }
         }
         return Obj;
      }
      
      public function gerXML() : void
      {
         if(Boolean(All_Info))
         {
            dispatchEvent(new EventTaomee(GET_INFO));
         }
         BC.addEvent(this,this.SLGoodsXMLs,SLGoodsXML.ALLDATE,this.backXML);
         this.SLGoodsXMLs.Info();
      }
      
      private function backXML(event:EventTaomee) : void
      {
         BC.removeEvent(this,this.SLGoodsXMLs,SLGoodsXML.ALLDATE,this.backXML);
         All_Info = SLGoodsXML.All_Item;
         var Arr:Array = SLGoodsXML.All_CommodityID;
         if(Arr.length > 225)
         {
            this.Max_Flag = uint(Arr.length / 225);
            this.getMoreCoinPrice(Arr.slice(0,225));
         }
         else
         {
            this.Max_Flag = 0;
            this.getMoreCoinPrice(Arr);
         }
      }
      
      private function makePriceInfo(obj:Object) : void
      {
         var p:uint = 0;
         var one_obj:Object = null;
         if(obj.Count == 0)
         {
            if(this.Max_Flag == 0)
            {
               dispatchEvent(new EventTaomee(GET_INFO));
            }
            return;
         }
         var Arr:Array = SLGoodsXML.All_CommodityID;
         for(var i:uint = 0; i < Arr.length; i++)
         {
            for(p = 0; p < obj.Arr.length; p++)
            {
               one_obj = obj.Arr[p];
               if(one_obj.ID == Arr[i])
               {
                  All_Info[i].count = 1;
                  All_Info[i].price = one_obj.UNVIP_Price;
                  All_Info[i].price_Vip = one_obj.VIP_Price;
               }
            }
         }
         Item_Info = All_Info.slice(0,SLGoodsXML.Item_num);
         Home_Info = All_Info.slice(SLGoodsXML.Item_num,SLGoodsXML.Item_num + SLGoodsXML.House_num);
         if(this.Max_Flag > 0)
         {
            if(Arr.length > askIndex * 226 + 225)
            {
               this.getMoreCoinPrice(Arr.slice(askIndex * 226,askIndex * 226 + 225));
            }
            else
            {
               this.getMoreCoinPrice(Arr.slice(askIndex * 226,Arr.length));
            }
            --this.Max_Flag;
         }
         else if(this.Max_Flag == 0)
         {
            dispatchEvent(new EventTaomee(GET_INFO));
         }
      }
      
      public function getOneCoinPrice(ID:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,GetOneCoinRes.GETITEM_OK,this.bakeOneCoinPrice);
         GetOneCoinReq.Info(ID);
      }
      
      private function bakeOneCoinPrice(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetOneCoinRes.GETITEM_OK,this.bakeOneCoinPrice);
         var obj:Object = event.EventObj.obj;
      }
      
      public function getMoreCoinPrice(Arr:Array) : void
      {
         BC.addEvent(this,GV.onlineSocket,GetMoreCoinRes.GETITEM_OK,this.bakeMoreCoinPrice);
         GetMoreCoinReq.Info(Arr);
      }
      
      private function bakeMoreCoinPrice(event:EventTaomee) : void
      {
         ++askIndex;
         BC.removeEvent(this,GV.onlineSocket,GetMoreCoinRes.GETITEM_OK,this.bakeMoreCoinPrice);
         var obj:Object = event.EventObj.obj;
         this.makePriceInfo(obj);
      }
      
      public function getOneCoinInfo(ID:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,GetOneCoinInfoRes.GETITEM_OK,this.bakeOneCoinInfo);
         GetOneCoinInfoReq.Info(ID);
      }
      
      private function bakeOneCoinInfo(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetOneCoinInfoRes.GETITEM_OK,this.bakeOneCoinInfo);
         var obj:Object = event.EventObj.obj;
      }
      
      public function CoinApply(ID:uint, Count:uint, Passwd:*) : void
      {
         BC.addEvent(this,GV.onlineSocket,CoinApplyRes.GETITEM_OK,this.bakeCoinApply);
         CoinApplyReq.Info(ID,Count,Passwd);
      }
      
      private function bakeCoinApply(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CoinApplyRes.GETITEM_OK,this.bakeCoinApply);
         var obj:Object = event.EventObj.obj;
      }
      
      public function CoinParApply(ID:uint, Count:uint, Passwd:*) : void
      {
         BC.addEvent(this,GV.onlineSocket,CoinParApplyRes.GETITEM_OK,this.bakeCoinParApply);
         CoinParApplyReq.Info(ID,Count,Passwd);
      }
      
      private function bakeCoinParApply(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CoinParApplyRes.GETITEM_OK,this.bakeCoinParApply);
         var obj:Object = event.EventObj.obj;
      }
      
      public function CoinParAsk() : void
      {
         BC.addEvent(this,GV.onlineSocket,CoinParAskRes.GETITEM_OK,this.bakeCoinParAsk);
         CoinParAskReq.Info();
      }
      
      private function bakeCoinParAsk(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CoinParAskRes.GETITEM_OK,this.bakeCoinParAsk);
         var obj:Object = event.EventObj.obj;
      }
   }
}

