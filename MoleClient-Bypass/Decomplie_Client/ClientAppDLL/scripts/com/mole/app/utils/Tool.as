package com.mole.app.utils
{
   import com.common.Alert.Alert;
   import com.common.Alert.childAlert.sizeAlert;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.ColorMatrix;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.module.deal.Deal;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.type.ModuleType;
   import fl.motion.easing.Bounce;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class Tool
   {
      
      private static var stopDragFunc:Function;
      
      private static var buyPanel:MovieClip;
      
      private static var finishIndex:int = 0;
      
      public function Tool()
      {
         super();
      }
      
      public static function startDrag(s:Sprite, stopFunc:Function = null) : void
      {
         stopDragFunc = stopFunc;
         BC.addEvent(s,s,MouseEvent.MOUSE_DOWN,startDragSpr,false,0,true);
         BC.addEvent(s,s,MouseEvent.MOUSE_UP,stopDragSpr,false,0,true);
      }
      
      private static function startDragSpr(e:MouseEvent) : void
      {
         var s:Sprite = e.currentTarget as Sprite;
         var re:Rectangle = s.parent.getRect(s.parent);
         var rect:Rectangle = new Rectangle(re.x + s.width,re.y + s.height,re.width - s.width,re.height - s.height);
         s.startDrag(false,rect);
      }
      
      private static function stopDragSpr(e:MouseEvent) : void
      {
         var s:Sprite = e.currentTarget as Sprite;
         BC.removeEvent(s);
         if(stopDragFunc != null)
         {
            stopDragFunc.apply(null,null);
         }
      }
      
      public static function getTimeStr(sec:int, type:int = 0) : String
      {
         var h:int = 0;
         var m:int = 0;
         var s:int = 0;
         var hStr:String = null;
         var mStr:String = null;
         var sStr:String = null;
         if(sec > 0)
         {
            h = sec / 3600;
            m = (sec - h * 3600) / 60;
            s = sec % 60;
            hStr = h >= 10 ? String(h) : "0" + h;
            mStr = m >= 10 ? String(m) : "0" + m;
            sStr = s >= 10 ? String(s) : "0" + s;
            if(type == 0)
            {
               return hStr + ":" + mStr + ":" + sStr;
            }
            if(type == 1)
            {
               return hStr + ":" + mStr;
            }
            if(type == 2)
            {
               return mStr + ":" + sStr;
            }
            return "";
         }
         if(type == 0)
         {
            return "00:00:00";
         }
         return "00:00";
      }
      
      public static function handleXML(xml:XML) : Object
      {
         return XMLTool.handleXML(xml);
      }
      
      public static function loadAndHandleXML(path:String, obj:Object, complete:Function = null, completeParams:Array = null, errorFunc:Function = null, ignoreVertion:Boolean = false) : void
      {
         XMLTool.loadAndHandleXML(path,obj,complete,completeParams,errorFunc,ignoreVertion);
      }
      
      public static function isNum(str:String) : Boolean
      {
         var code:int = 0;
         var len:int = str.length;
         if(len == 0)
         {
            return false;
         }
         var code0:int = "0".charCodeAt(0);
         var code9:int = "9".charCodeAt(0);
         for(var i:int = 0; i < len; i++)
         {
            code = str.charCodeAt(i);
            if(code < code0 || code > code9)
            {
               return false;
            }
         }
         return true;
      }
      
      public static function loadIcon(itemID:int, container:DisplayObjectContainer, url:String = "") : Loader
      {
         var loader:Loader = new Loader();
         if(url == "")
         {
            url = GoodsInfo.GetFullURLByItemId(itemID);
         }
         loader.load(VL.getURLRequest(url));
         container.addChild(loader);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadIconOver,false,0,true);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadIconError,false,0,true);
         return loader;
      }
      
      private static function loadIconOver(e:Event) : void
      {
         var loader:Loader = null;
         var pW:int = 0;
         var pH:int = 0;
         var re:Rectangle = null;
         var rect:Rectangle = null;
         loader = (e.currentTarget as LoaderInfo).loader;
         loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadIconOver);
         var container:DisplayObjectContainer = loader.parent;
         if(container != null)
         {
            container.removeChild(loader);
            pW = container.width;
            pH = container.height;
            re = container.getRect(container);
            container.addChild(loader);
            rect = loader.getRect(loader);
            loader.x = (pW - loader.width) / 2 + re.x - rect.x;
            loader.y = (pH - loader.height) / 2 + re.y - rect.y;
         }
      }
      
      public static function newLoadIcon(itemID:int, container:DisplayObjectContainer) : void
      {
         var resID:uint = DownLoadManager.add(GoodsInfo.GetFullURLByItemId(itemID),ResType.DISPLAY_OBJECT);
         var tempOnLoadOver:Function = function(e:DownLoadEvent):void
         {
            var pW:int = 0;
            var pH:int = 0;
            var re:Rectangle = null;
            var rect:Rectangle = null;
            var removeIcon:MovieClip = null;
            if(Boolean(container))
            {
               pW = container.width;
               pH = container.height;
               re = container.getRect(container);
               container.addChild(e.data);
               rect = e.data.getRect(e.data);
               e.data.x = (pW - e.data.width) / 2 + re.x - rect.x;
               e.data.y = (pH - e.data.height) / 2 + re.y - rect.y;
               if(container.numChildren > 2)
               {
                  removeIcon = container.getChildAt(1) as MovieClip;
               }
               DisplayUtil.removeForParent(removeIcon);
            }
         };
         DownLoadManager.addEvent(resID,tempOnLoadOver);
      }
      
      private static function loadIconError(e:IOErrorEvent) : void
      {
         (e.currentTarget as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR,loadIconError);
         (e.currentTarget as LoaderInfo).removeEventListener(Event.COMPLETE,loadIconOver);
      }
      
      public static function prizeCome(s:Sprite, pt0:Point, pt1:Point, pt2:Point) : void
      {
         var tFunc:Function = function():void
         {
            var endFunc:Function = function():void
            {
               TweenLite.to(s,1,{
                  "x":pt2.x,
                  "y":pt2.y,
                  "ease":Bounce.easeOut
               });
            };
            TweenLite.to(s,0.4,{
               "x":pt2.x,
               "y":pt2.y - 60,
               "onComplete":endFunc
            });
         };
         BezierCurve.cubic_curve(s,pt0,pt1,pt2,tFunc);
      }
      
      public static function alert(itemID:int, itemCnt:int = 1, closeHandler:Function = null) : sizeAlert
      {
         return Alert.smileAlart("    恭喜你獲得" + itemCnt + "個" + GoodsInfo.getItemNameByID(itemID) + "， 已放入你的" + GoodsInfo.getItemCollectionBoxNameByID(itemID) + "中！",closeHandler);
      }
      
      public static function enableBtn(btn:SimpleButton) : void
      {
         btn.filters = [];
         btn.mouseEnabled = true;
         btn.enabled = true;
      }
      
      public static function disableBtn(btn:SimpleButton) : void
      {
         var matrix:ColorMatrix = new ColorMatrix();
         matrix.adjustSaturation(-255);
         btn.filters = [new ColorMatrixFilter(matrix)];
         btn.mouseEnabled = false;
         btn.enabled = false;
      }
      
      public static function openExePanel8(xmlUrl:String, id:int, headTxtUrl:String, parentPanel:String = "") : void
      {
         openExePanel("module/external/exeModule/exchangePanel8.swf",xmlUrl,id,8,headTxtUrl,parentPanel);
      }
      
      public static function openExePanel6(xmlUrl:String, id:int, headTxtUrl:String, parentPanel:String = "") : void
      {
         openExePanel("module/external/exeModule/exchangePanel6.swf",xmlUrl,id,6,headTxtUrl,parentPanel);
      }
      
      public static function openExePanel(url:String, xmlUrl:String, id:int, max:int, headTxtUrl:String = "", parentPanel:String = "") : void
      {
         ModuleManager.openPanel(ModuleType.UNIQUE_EXCHANGE_PANEL,{
            "url":url,
            "xmlUrl":xmlUrl,
            "id":id,
            "max":max,
            "headTxtUrl":headTxtUrl,
            "parentPanel":parentPanel
         });
      }
      
      public static function exchangeGoods(type:uint, showAlert:Boolean = true, overFunc:Function = null, count:int = 1, flag:int = 0) : void
      {
         var exeOver:Function = null;
         exeOver = function(e:EventTaomee):void
         {
            var arr:Array = null;
            var i:int = 0;
            GV.onlineSocket.removeEventListener(exchange.EXCHANGE_ITEM,exeOver);
            if(showAlert)
            {
               arr = e.EventObj.arr;
               if(Boolean(arr) && arr.length > 0)
               {
                  for(i = 0; i < arr.length; i++)
                  {
                     alert(arr[i].itemID,arr[i].count);
                  }
               }
            }
            if(overFunc != null)
            {
               overFunc.apply(null,[e.EventObj]);
            }
         };
         GV.onlineSocket.addEventListener(exchange.EXCHANGE_ITEM,exeOver);
         exchange.exchange_goods(type,count,flag);
      }
      
      public static function finishSomething(dayType:uint, callBack:Function) : void
      {
         var getDoneTimesOver:Function = null;
         getDoneTimesOver = function(e:EventTaomee):void
         {
            if(e.EventObj.Type == dayType)
            {
               GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,getDoneTimesOver);
               callBack.apply(null,[e.EventObj.Done]);
            }
         };
         GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,getDoneTimesOver);
         finishSomethingRes.sendReq(dayType);
      }
      
      public static function finishManything(dayTypeArr:Array, callBack:Function) : void
      {
         var doneTimesArr:Array = null;
         var finishOverFunc:Function = null;
         if(dayTypeArr == null || dayTypeArr.length == 0)
         {
            callBack.apply(null,[]);
         }
         finishIndex = 0;
         doneTimesArr = [];
         finishOverFunc = function(doneTimes:uint):void
         {
            if(finishIndex == dayTypeArr.length - 1)
            {
               callBack.apply(null,[doneTimesArr]);
               finishIndex = 0;
            }
            else
            {
               doneTimesArr.push(doneTimes);
               ++finishIndex;
               finishSomething(dayTypeArr[finishIndex],finishOverFunc);
            }
         };
         if(finishIndex < dayTypeArr.length)
         {
            finishSomething(dayTypeArr[finishIndex],finishOverFunc);
         }
      }
      
      public static function beanBuy(itemID:int, price:int, special:Boolean = false) : void
      {
         var loadBuyPanelOver:Function = function(e:DownLoadEvent):void
         {
            buyPanel = (e.data as MovieClip)["buyPanel"];
            buyPanel.itemID = itemID;
            buyPanel.special = special;
            buyPanel.price = price;
            MainManager.getAlertLevel().addChild(buyPanel);
            buyPanel.noBtn.addEventListener(MouseEvent.CLICK,onCloseBuyPanel);
            var titlePath:String = GoodsInfo.GetFullURLByItemId(itemID);
            var goodsLoad:Loader = new Loader();
            goodsLoad.unload();
            DisplayUtil.removeAllChild(buyPanel.goodsMc.icon);
            goodsLoad.load(new URLRequest(titlePath));
            buyPanel.goodsMc.icon.addChild(goodsLoad);
            buyPanel.numbeTxt.text = "1";
            var goodsMoney:int = price;
            var allGoodsMoney:int = int(buyPanel.numbeTxt.text) * goodsMoney;
            buyPanel.moneyTxt.text = "購買價格：" + allGoodsMoney + "摩爾豆";
            buyPanel.minusBtn.addEventListener(MouseEvent.CLICK,onMinusBtn);
            buyPanel.addBtn.addEventListener(MouseEvent.CLICK,onAddBtn);
            buyPanel.numbeTxt.addEventListener(Event.CHANGE,numbeChangeHanlder);
            buyPanel.yesBtn.addEventListener(MouseEvent.CLICK,onYesBtn);
         };
         var resID:int = int(DownLoadManager.add("module/external/exeModule/buyPanel.swf",ResType.DISPLAY_OBJECT));
         DownLoadManager.addEvent(resID,loadBuyPanelOver);
      }
      
      private static function onYesBtn(e:MouseEvent) : void
      {
         var buyPanel:MovieClip = (e.currentTarget as SimpleButton).parent as MovieClip;
         removeBuyEvents();
         var numbeTxtNum:int = int(buyPanel.numbeTxt.text);
         if(!buyPanel.special)
         {
            Deal.BuyItem(buyPanel.itemID,int(buyPanel.numbeTxt.text),onSetWillAgicalGoods,onBuyFailFun);
         }
         else
         {
            GV.onlineSocket.addCmdListener(CommandID.PARTY_MASK_GET_MATERIAL,getMaterial);
            GF.sendSocket(CommandID.PARTY_MASK_GET_MATERIAL,1351503,numbeTxtNum);
         }
         onCloseBuyPanel();
      }
      
      private static function getMaterial(e:SocketEvent) : void
      {
         var bArr:ByteArray;
         var state:int;
         var itemID:int;
         var count:int;
         GV.onlineSocket.removeCmdListener(CommandID.PARTY_MASK_GET_MATERIAL,getMaterial);
         bArr = e.data as ByteArray;
         state = int(bArr.readUnsignedInt());
         itemID = int(bArr.readUnsignedInt());
         count = int(bArr.readUnsignedInt());
         if(state == 1)
         {
            Tool.alert(itemID,count,function(e:*):void
            {
               ModuleManager.openPanel("PartyMaskMainPanel");
            });
         }
      }
      
      private static function onSetWillAgicalGoods(e:* = null) : void
      {
         if(Boolean(e))
         {
            GV.onlineSocket.removeEventListener("read_1225",onSetWillAgicalGoods);
         }
         var num:int = int(buyPanel.numbeTxt.text);
         var goodsMoney:int = GoodsInfo.getInfoById(buyPanel.itemID).buyPanel.price * num;
         var goodsName:String = GoodsInfo.getItemNameByID(buyPanel.itemID);
         var goodsBox:String = GoodsInfo.getItemCollectionBoxNameByID(buyPanel.itemID);
         Alert.smileAlart("    恭喜你花費了" + goodsMoney + "摩爾豆，獲得" + num + "個" + goodsName + ",已經放入你的" + goodsBox + "！");
      }
      
      private static function onBuyFailFun(errorID:int) : void
      {
         var msg:String = null;
         switch(errorID)
         {
            case -100095:
               msg = "      你的種植等級不夠，暫時還無法購買" + GoodsInfo.getItemNameByID(buyPanel.itemID) + "!";
         }
         if(Boolean(msg))
         {
            Alert.smileAlart(msg);
         }
      }
      
      private static function removeBuyEvents() : void
      {
         buyPanel.noBtn.removeEventListener(MouseEvent.CLICK,onCloseBuyPanel);
         buyPanel.minusBtn.removeEventListener(MouseEvent.CLICK,onMinusBtn);
         buyPanel.addBtn.removeEventListener(MouseEvent.CLICK,onAddBtn);
         buyPanel.numbeTxt.removeEventListener(Event.CHANGE,numbeChangeHanlder);
         buyPanel.yesBtn.removeEventListener(MouseEvent.CLICK,onYesBtn);
      }
      
      private static function onMinusBtn(e:MouseEvent) : void
      {
         var buyPanel:MovieClip = (e.currentTarget as SimpleButton).parent as MovieClip;
         var numbeTxtNum:int = int(buyPanel.numbeTxt.text);
         if(numbeTxtNum <= 100)
         {
            if(numbeTxtNum > 1)
            {
               buyPanel.numbeTxt.text = int(buyPanel.numbeTxt.text) - 1;
            }
         }
         else
         {
            buyPanel.numbeTxt.text = 1 + "";
         }
         var goodsMoney:int = int(buyPanel.price);
         var allGoodsMoney:int = int(buyPanel.numbeTxt.text) * goodsMoney;
         buyPanel.moneyTxt.text = "購買價格：" + allGoodsMoney + "摩爾豆";
      }
      
      private static function onAddBtn(e:MouseEvent) : void
      {
         var buyPanel:MovieClip = (e.currentTarget as SimpleButton).parent as MovieClip;
         var numbeTxtNum:int = int(buyPanel.numbeTxt.text) + 1;
         if(numbeTxtNum <= 100)
         {
            buyPanel.numbeTxt.text = numbeTxtNum;
         }
         else
         {
            buyPanel.numbeTxt.text = 100 + "";
         }
         var goodsMoney:int = int(buyPanel.price);
         var allGoodsMoney:int = int(buyPanel.numbeTxt.text) * goodsMoney;
         buyPanel.moneyTxt.text = "購買價格：" + allGoodsMoney + "摩爾豆";
      }
      
      private static function numbeChangeHanlder(e:Event) : void
      {
         var buyPanel:MovieClip = (e.currentTarget as TextField).parent as MovieClip;
         if(int(buyPanel.numbeTxt.text) == 0 || int(buyPanel.numbeTxt.text) != Number(buyPanel.numbeTxt.text))
         {
            buyPanel.numbeTxt.text = 1;
         }
         else if(int(buyPanel.numbeTxt.text) > 100)
         {
            buyPanel.numbeTxt.text = 100;
         }
         var goodsMoney:int = int(buyPanel.price);
         var allGoodsMoney:int = int(buyPanel.numbeTxt.text) * goodsMoney;
         buyPanel.moneyTxt.text = "購買價格：" + allGoodsMoney + "摩爾豆";
      }
      
      private static function onCloseBuyPanel(e:MouseEvent = null) : void
      {
         removeBuyEvents();
         DisplayUtil.removeForParent(buyPanel);
         buyPanel = null;
      }
      
      public static function getTempDate(type:int, overFunc:Function) : void
      {
         var readFunc:Function = null;
         var errorFunc:Function = null;
         readFunc = function(e:EventTaomee):void
         {
            OnlineManager.removeErrorListener(1215,errorFunc);
            GV.onlineSocket.removeEventListener("read_1215",readFunc);
            overFunc.apply(null,[int(e.EventObj.data)]);
         };
         errorFunc = function(e:*):void
         {
            OnlineManager.removeErrorListener(1215,errorFunc);
            GV.onlineSocket.removeEventListener("read_1215",readFunc);
            overFunc.apply(null,[0]);
         };
         OnlineManager.addErrorListener(1215,errorFunc);
         GV.onlineSocket.addEventListener("read_1215",readFunc);
         ephemeralDataSocket.getData(type);
      }
      
      public static function setTempDate(type:int, data:uint) : void
      {
         ephemeralDataSocket.setData(type,data);
      }
      
      public static function GC() : void
      {
      }
      
      public static function getSubType() : Array
      {
         var tempTime:Number = NaN;
         var year:uint = 0;
         var month:uint = 0;
         var nowDate:Date = null;
         var date:uint = 0;
         var oldDate:Date = null;
         var serverTime:Number = ServerUpTime.getInstance().serverTime;
         var day:uint = ServerUpTime.getInstance().date.day;
         var arr:Array = new Array();
         if(day == 5)
         {
            tempTime = serverTime;
            year = ServerUpTime.getInstance().date.fullYearUTC;
            month = ServerUpTime.getInstance().date.month + 1;
            date = ServerUpTime.getInstance().date.date;
         }
         else
         {
            if(day == 6)
            {
               tempTime = serverTime - 24 * 60 * 60 * 1000;
            }
            else
            {
               tempTime = serverTime - 24 * 60 * 60 * 1000 * (day + 2);
            }
            nowDate = new Date(tempTime);
            year = nowDate.fullYear;
            month = nowDate.month + 1;
            date = nowDate.date;
         }
         arr[0] = year * 10000 + month * 100 + date;
         oldDate = new Date(tempTime - 24 * 60 * 60 * 1000 * 7);
         arr[1] = oldDate.fullYear * 10000 + (oldDate.month + 1) * 100 + oldDate.date;
         return arr;
      }
      
      public static function getSubTypeByHours() : uint
      {
         var SubType:uint = 0;
         var hours:uint = 0;
         var data:Date = ServerUpTime.getInstance().date;
         if(data.hours < 20)
         {
            hours = 13;
         }
         else
         {
            hours = 20;
         }
         return uint(data.fullYear * 1000000 + (data.month + 1) * 10000 + data.date * 100 + hours);
      }
   }
}

