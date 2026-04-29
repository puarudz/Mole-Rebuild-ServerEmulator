package com.module.coin
{
   import com.common.Alert.Alert;
   import com.common.Alert.childAlert.SLBuyAlert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.logic.socket.MoleShop.MoleShopSelect;
   import com.logic.socket.MoleShop.MoleShopSocket;
   import com.module.activityModule.superPetLogin;
   import com.mole.debug.DebugManager;
   import com.mole.net.events.SocketEvent;
   import com.view.mapView.activity.Task83.GolBdeansView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   
   public class CoinBuyNewModle
   {
      
      public static var CLOSE_MIBI_EVENT:String = "CLOSE_MIBI_EVENT";
      
      public static const Buy_Item_Success_Event:String = "CoinBuyNewModle Buy_Item_Success_Event";
      
      private static const XML_PATH:String = "resource/xml/JDGoodsXmlData.xml";
      
      private var good_id:uint;
      
      private var good_info:Object;
      
      private var count:uint;
      
      private var activityID:uint;
      
      private var quantifierStr:String = "";
      
      private var _sellItemList:Array;
      
      private var url:String;
      
      private var SLAlerts:SLBuyAlert;
      
      private var alt_mc:MovieClip;
      
      private var totalNum:Number;
      
      private var myAle:*;
      
      private var _parentMC:Sprite;
      
      private var timerBool:Boolean;
      
      public function CoinBuyNewModle()
      {
         super();
      }
      
      public function BuyModle(ID:uint, Count:uint, _str:String = "", parentMC:Sprite = null, activity:uint = 0) : void
      {
         if(Boolean(_str))
         {
            this.quantifierStr = "<font color=\'#ff0000\'>" + Count + _str + "</font>";
         }
         else
         {
            this.quantifierStr = "";
         }
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeAll);
         this.good_id = ID;
         this.count = Count;
         this.activityID = activity;
         this.alt_mc = new MovieClip();
         if(Boolean(parentMC))
         {
            this._parentMC = parentMC;
         }
         else
         {
            this._parentMC = MainManager.getAppLevel();
         }
         this._parentMC.addChild(this.alt_mc);
         BC.addEvent(this,GV.onlineSocket,"read_" + 2032,this.bakeCoinApply);
         MoleShopSelect.selectDou();
      }
      
      private function bakeCoinApply(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2032,this.bakeCoinApply);
         this.totalNum = evt.EventObj.count;
         var urlloader:URLLoader = new URLLoader();
         urlloader.addEventListener(Event.COMPLETE,this.XmlCompleteHandler);
         urlloader.addEventListener(IOErrorEvent.IO_ERROR,this.XmlErrorHandler);
         urlloader.load(VL.getURLRequest(XML_PATH));
      }
      
      private function XmlCompleteHandler(e:Event) : void
      {
         var info:String;
         var AddMC:MovieClip;
         var de:Date;
         var xml:XML = null;
         var xmlList:XMLList = null;
         var i:uint = 0;
         var tempObj:Object = null;
         var disOff:uint = 0;
         URLLoader(e.currentTarget).removeEventListener(Event.COMPLETE,this.XmlCompleteHandler);
         URLLoader(e.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.XmlErrorHandler);
         try
         {
            this._sellItemList = new Array();
            xml = new XML(e.target.data);
            xmlList = xml.children();
            for(i = 0; i < xmlList.length(); i++)
            {
               tempObj = new Object();
               tempObj.ID = String(xmlList[i].@ID);
               tempObj.Name = String(xmlList[i].@Name);
               tempObj.commodityID = String(xmlList[i].@commodityID);
               tempObj.Price = uint(xmlList[i].@Price);
               tempObj.mustVip = uint(xmlList[i].@must_vip);
               disOff = uint(xmlList[i].@vip_discount);
               tempObj.disOff = disOff;
               if(LocalUserInfo.isVIP())
               {
                  tempObj.Price = uint(xmlList[i].@Price) * (disOff / 100);
               }
               this._sellItemList.push(tempObj);
            }
         }
         catch(err:Error)
         {
            DebugManager.traceMsg("配置文件格式不對");
            return;
         }
         this.good_info = this.getOneInfo(this.good_id);
         if(this.good_info == null)
         {
            return;
         }
         if(this.good_info.ID.indexOf("|") >= 0)
         {
            this.url = "resource/cloth/slicon/" + this.good_info.commodityID + ".swf";
         }
         else
         {
            this.url = GoodsInfo.GetFullURLByItemId(this.good_info.ID);
         }
         info = "";
         AddMC = this.alt_mc;
         this.SLAlerts = new SLBuyAlert();
         de = ServerUpTime.getInstance().date;
         this.timerBool = false;
         if(LocalUserInfo.isVIP())
         {
            if(this.good_info.disOff < 100)
            {
               this.timerBool = true;
            }
         }
         if(this.timerBool)
         {
            info = "    你選擇了<b>" + this.quantifierStr + this.good_info.Name + "</b>已打折，需要花費<font color=\'#ff0000\'>" + this.count * this.good_info.Price + "</font>金豆，目前你擁有<font color=\'#ff0000\'>" + this.totalNum + "</font>金豆!";
         }
         else
         {
            info = "    你選擇了<b>" + this.quantifierStr + this.good_info.Name + "</b>，需要花費<font color=\'#ff0000\'>" + this.count * this.good_info.Price + "</font>金豆，目前你擁有<font color=\'#ff0000\'>" + this.totalNum + "</font>金豆!";
         }
         BC.addEvent(this,this.SLAlerts,SLBuyAlert.CLICK_EVENT_A,this.buyFun);
         this.SLAlerts.showUI(AddMC,this.url,info,true);
      }
      
      private function buyFun(event:EventTaomee) : void
      {
         BC.removeEvent(this,this.SLAlerts,SLBuyAlert.CLICK_EVENT_A,this.buyFun);
         if(this.totalNum >= this.count * this.good_info.Price)
         {
            if(this.good_info.mustVip == 0 || LocalUserInfo.isVIP())
            {
               BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-52016",this.onBuyError);
               BC.addEvent(this,GV.onlineSocket,"read_" + 2031,this.buyBackHandler);
               BC.addEvent(this,GV.onlineSocket,SocketEvent.ERROR + 2031,this.buyErrorHandler);
               MoleShopSocket.buyCommodity(this.good_id,this.count,this.activityID);
            }
            else if(this.good_info.mustVip == 1 && LocalUserInfo.isVIP() == false)
            {
               superPetLogin.gotoPay();
            }
         }
         else
         {
            this.myAle = GF.showAlert(this._parentMC,"    你的金豆餘額不足，現在就去兌換金豆嗎？","",100,"sure,cancel",true,false,"E");
            BC.addEvent(this,this.myAle,Alert.CLICK_ + "1",this.gotoMap);
         }
      }
      
      private function onBuyError(e:Event) : void
      {
         BC.removeEvent(this);
      }
      
      private function gotoMap(evt:*) : void
      {
         BC.removeEvent(this,this.myAle,Alert.CLICK_ + "1",this.gotoMap);
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
         if(GoodsInfo.getType(this.good_info.ID) == 36)
         {
            msg = "　　恭喜你購買了" + GoodsInfo.getItemNameByID(this.good_info.ID) + ",已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(this.good_info.ID) + "中！";
         }
         else if(GoodsInfo.getType(this.good_info.ID) == 1350137)
         {
            msg = "　　恭喜你購買了" + GoodsInfo.getItemNameByID(this.good_info.ID) + ",已經放入你的騎寵背包中！";
         }
         else if(this.good_info.ID == 1351055)
         {
            this.url = GoodsInfo.GetFullURLByItemId(this.good_info.ID);
            msg = "　　購買成功，阿七已經到你的家園中了，快回去看看吧！";
         }
         if(this.good_info.ID == 1320001)
         {
            this.url = "resource/allJob/icon/" + this.good_info.ID + ".swf";
            msg = "　　購買成功，阿七已經到你的家園中了，快回去看看吧！";
         }
         else if(this.good_info.ID == 1351095)
         {
            this.url = "resource/allJob/icon/" + this.good_info.ID + ".swf";
            msg = "　　恭喜你購買了繽紛彈彈牌，快去扭扭，看看你的RP有多高！";
         }
         else if(this.good_info.ID == 190639)
         {
            this.url = "resource/allJob/icon/" + this.good_info.ID + ".swf";
            msg = "　　購買成功！" + GoodsInfo.getItemNameByID(this.good_info.ID) + "已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(this.good_info.ID) + "中！";
         }
         else if(this.good_info.ID == 190594)
         {
            this.url = "resource/allJob/icon/" + this.good_info.ID + ".swf";
            msg = "　　購買成功！" + GoodsInfo.getItemNameByID(this.good_info.ID) + "已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(this.good_info.ID) + "中！";
         }
         else if(this.good_info.ID > 160000 && this.good_info.ID < 9900000)
         {
            this.url = GoodsInfo.GetFullURLByItemId(this.good_info.ID);
            msg = "　　購買成功！" + GoodsInfo.getItemNameByID(this.good_info.ID) + "已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(this.good_info.ID) + "中！";
         }
         else if(this.good_info.ID.indexOf("|") >= 0)
         {
            this.url = "resource/cloth/slicon/" + this.good_info.commodityID + ".swf";
            msg = "　　購買成功！" + this.good_info.Name + "已經放入你的倉庫中了！";
         }
         else
         {
            this.url = "resource/cloth/icon/" + this.good_info.ID + ".swf";
            msg = "　　購買成功！" + GoodsInfo.getItemNameByID(this.good_info.ID) + "已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(this.good_info.ID) + "中！";
         }
         GF.showAlert(this.alt_mc,this.url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
         GV.onlineSocket.dispatchEvent(new EventTaomee(Buy_Item_Success_Event,this.good_info.ID));
      }
      
      public function getOneInfo(good_id:uint) : Object
      {
         var Obj:Object = new Object();
         for(var i:uint = 0; i < this._sellItemList.length; i++)
         {
            if(this._sellItemList[i].commodityID == good_id)
            {
               Obj = this._sellItemList[i];
               break;
            }
         }
         return Obj;
      }
      
      private function XmlErrorHandler(e:IOErrorEvent) : void
      {
         URLLoader(e.currentTarget).removeEventListener(Event.COMPLETE,this.XmlCompleteHandler);
         URLLoader(e.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.XmlErrorHandler);
      }
      
      private function removeAll(event:* = null) : void
      {
         BC.removeEvent(this);
         this.good_id = 0;
         this.good_info = null;
         this.count = 0;
      }
   }
}

