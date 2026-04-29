package com.module.bookItem
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.ShowUtil;
   import com.common.util.Tick;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.traffic.trafficReq;
   import com.logic.socket.traffic.trafficRes;
   import com.module.deal.Deal;
   import com.taomee.mole.library.utils.TimeFormat;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class clothbookView
   {
      
      private static var content:MovieClip;
      
      private static var cdTime:uint;
      
      private static var itemID:uint;
      
      private static var preItemID:uint;
      
      private static var gapHour:uint;
      
      private static var gapMinutes:uint;
      
      private static var gapSeconds:uint;
      
      public static var IsVIP:Boolean = false;
      
      public static var halfPrice:Boolean = false;
      
      private var clothBookMC:MovieClip;
      
      public function clothbookView(obj:*)
      {
         super();
         this.clothBookMC = obj;
         BC.addEvent(this,GV.onlineSocket,trafficRes.TRAFFIC_OVER,this.halfHandler);
         trafficReq.trafficSend(5);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventFun);
         this.clothBookMC.visible = false;
      }
      
      public static function BuyCloth(mc:MovieClip, itemID:uint) : void
      {
         var obj:Object = GoodsInfo.getInfoById(itemID);
         if(!(Number(obj.Tradability) & 1))
         {
            mc.noBuy.visible = false;
            mc.btn.addEventListener(MouseEvent.CLICK,checkbuyFun);
         }
         else
         {
            mc.noBuy.visible = true;
         }
         if(Boolean(obj.price))
         {
            mc.money_txt.text = obj.price;
         }
         else
         {
            mc.money_txt.text = obj.Price;
         }
      }
      
      public static function makeCloth(mc:MovieClip, itemID:uint) : void
      {
         content = mc;
         preItemID = itemID;
         itemID = itemID;
         GV.onlineSocket.addCmdListener(CommandID.COME_BK_STATUS,getStatusHandler);
         GF.sendSocket(CommandID.COME_BK_STATUS,647);
         GV.onlineSocket.addEventListener("removeMapEvent",removeAll);
         BC.addEvent(content,content["noMake"],MouseEvent.CLICK,makeHandle);
         BC.addEvent(content,content["noGet"],MouseEvent.CLICK,getHandle);
         MovieClip(content["noMake"]).buttonMode = true;
         MovieClip(content["noGet"]).buttonMode = true;
      }
      
      private static function removeAll(e:*) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.COME_BK_STATUS,getStatusHandler);
         GV.onlineSocket.removeEventListener("removeMapEvent",removeAll);
         Tick.instance.removeCallback(onCallTime);
         var tempMC:* = MainManager.getGameLevel().getChildByName("bookMC");
         GC.clearAll(tempMC);
      }
      
      private static function makeHandle(e:Event) : void
      {
         BC.removeEvent(content,content["noMake"],MouseEvent.CLICK,makeHandle);
         if(preItemID == 15285 || preItemID == 15286)
         {
            if(!LocalUserInfo.isVIP() || LocalUserInfo.isVIP() == false)
            {
               Alert.angryAlart("  只有超拉才能製作哦！");
               return;
            }
         }
         if(LocalUserInfo.getYXQ() >= 10000)
         {
            if(gapHour == 0 && gapMinutes == 0 && gapSeconds == 0)
            {
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - 10000);
               GV.onlineSocket.addCmdListener(CommandID.MOLE_FASHION_MAKE,moleMakeHandle);
               GF.sendSocket(CommandID.MOLE_FASHION_MAKE,preItemID);
            }
            else
            {
               Alert.angryAlart("  小摩爾時間還沒有冷卻哦！");
            }
         }
         else
         {
            Alert.smileAlart("  小摩爾摩爾豆不夠1W,無法製作!");
         }
      }
      
      private static function moleMakeHandle(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.MOLE_FASHION_MAKE,moleMakeHandle);
         var data:ByteArray = e.data as ByteArray;
         var state:uint = data.readUnsignedInt();
         if(gapHour == 0 && gapMinutes == 0 && gapSeconds == 0)
         {
            if(state == 0)
            {
               Alert.smileAlart("  小摩爾現在開始製作了");
               GF.sendSocket(CommandID.COME_BK_STATUS,647);
            }
            else if(state == 1)
            {
               Alert.smileAlart("很可惜小摩爾現在還不能製作哦！");
            }
         }
         else
         {
            Alert.angryAlart("  小摩爾時間還沒有冷卻哦！");
         }
      }
      
      private static function getHandle(e:Event) : void
      {
         BC.removeEvent(content,content["noGet"],MouseEvent.CLICK,getHandle);
         if(preItemID == 15285 || preItemID == 15286)
         {
            if(!LocalUserInfo.isVIP() || LocalUserInfo.isVIP() == false)
            {
               Alert.angryAlart("  只有超拉才能製作哦！");
               return;
            }
         }
         if(gapHour == 0 && gapMinutes == 0 && gapSeconds == 0)
         {
            if(cdTime == 0)
            {
               Alert.angryAlart("  小摩爾還沒有製作哦！");
            }
            else
            {
               GV.onlineSocket.addCmdListener(CommandID.MOLE_FASHION_GET,moleGetHandle);
               GV.onlineSocket.addEventListener("SocketEvent_error",onGetError);
               GF.sendSocket(CommandID.MOLE_FASHION_GET);
            }
         }
         else
         {
            Alert.angryAlart("  小摩爾時間還沒有冷卻哦，無法領取!");
         }
      }
      
      private static function onGetError(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("SocketEvent_error",onGetError);
         GV.onlineSocket.removeCmdListener(CommandID.MOLE_FASHION_GET,moleGetHandle);
         trace("錯誤");
         Alert.angryAlart("  小摩爾還沒有製作哦！");
      }
      
      private static function moleGetHandle(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         var itemNUmber:uint = data.readUnsignedInt();
         if(itemNUmber == 0)
         {
            Alert.angryAlart("  小摩爾暫時還不能領取哦!");
         }
         else
         {
            Alert.smileAlart("  恭喜小摩爾獲得" + GoodsInfo.getItemNameByID(itemNUmber));
         }
      }
      
      private static function getStatusHandler(evt:SocketEvent) : void
      {
         var xixi:uint = 0;
         var recData:ByteArray = evt.data as ByteArray;
         var type:uint = recData.readUnsignedInt();
         if(type == 647)
         {
            xixi = recData.readUnsignedInt();
            cdTime = recData.readUnsignedInt();
            Tick.instance.addCallback(onCallTime);
         }
      }
      
      private static function onCallTime(delay:Number) : void
      {
         var _curDate:Date = ServerUpTime.getInstance().chinaDate;
         var _curMin:Number = Number(_curDate.time);
         trace(_curDate.time / 1000);
         var seconds:Number = _curMin / 1000 - cdTime;
         var timeStr:String = TimeFormat.getTimeStrFromSec(seconds);
         var arr:Array = timeStr.split(":");
         gapHour = 14 - arr[0];
         gapMinutes = 59 - arr[1];
         gapSeconds = 59 - arr[2];
         if(gapHour == 0 && gapMinutes == 0 && gapSeconds == 0)
         {
            Tick.instance.removeCallback(onCallTime);
            ShowUtil.ableShow(content["noMake"]);
         }
         else if(gapHour < 0 || gapMinutes < 0 || gapSeconds < 0 || gapHour > 14)
         {
            Tick.instance.removeCallback(onCallTime);
            gapHour = 0;
            gapMinutes = 0;
            gapSeconds = 0;
         }
         content["time_txt"].text = String(gapHour) + ":" + gapMinutes + ":" + gapSeconds;
      }
      
      private static function checkbuyFun(e:MouseEvent) : void
      {
         var alert:*;
         var id:uint = 0;
         var obj:Object = null;
         var msg:String = null;
         id = uint(e.currentTarget.parent.id);
         obj = GoodsInfo.getInfoById(id);
         if(!obj.price)
         {
            obj.price = obj.Price;
         }
         if(halfPrice)
         {
            msg = "    " + obj.name + "原價" + obj.price + "摩爾豆，半價後" + int(obj.price) / 2 + "摩爾豆，你現在擁有" + LocalUserInfo.getYXQ() + "摩爾豆，要確定購買嗎？";
         }
         else
         {
            msg = "    " + obj.name + "需要花費" + obj.price + "摩爾豆，你現在擁有" + LocalUserInfo.getYXQ() + "摩爾豆，要確定購買嗎？";
         }
         alert = Alert.getIconByID_Alart(id,msg,null,"sure,cancel",105);
         alert.addEventListener("CLICK" + 1,function():void
         {
            Deal.BuyItem(id,1,function(itemID:uint):void
            {
               if(itemID == id)
               {
                  Alert.smileAlart("    購買成功！" + obj.name + "已經放到" + GoodsInfo.getItemCollectionBoxNameByID(id) + "中！");
                  e = null;
                  obj = null;
               }
            },function(errorNum:int):void
            {
               if(errorNum == -10015)
               {
                  Alert.smileAlart("    你已經有這個寶貝啦！");
                  e = null;
                  obj = null;
               }
               else if(errorNum == -100034)
               {
                  throw "前後台配置文件不一致,【" + obj.name + ":" + id + "】，請聯系開發人員。";
               }
            });
         });
      }
      
      public static function SLBuyCloth(mc:MovieClip, itemID:uint) : void
      {
         var obj:Object = GoodsInfo.getInfoById(itemID);
         if(obj.vipOnly == 1 && LocalUserInfo.isVIP() && obj.vipLevel == null)
         {
            mc.noBuy.visible = false;
            mc.btn.addEventListener(MouseEvent.CLICK,checkbuyFun);
         }
         else if(obj.vipOnly == 1 && LocalUserInfo.isVIP() && obj.vipLevel != null && LocalUserInfo.getSLstar() >= obj.vipLevel)
         {
            mc.noBuy.visible = false;
            mc.btn.addEventListener(MouseEvent.CLICK,checkbuyFun);
         }
         else
         {
            mc.noBuy.visible = true;
         }
         mc.money_txt.text = halfPrice ? int(obj.price) / 2 : obj.price;
      }
      
      public static function SLBuyClothIsClick(mc:MovieClip, itemID:uint) : void
      {
         /*
          * Decompilation error
          * Code may be obfuscated
          * Tip: You can try enabling "Deobfuscate code" option in Settings
          * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to error");
      }
      
      private function halfHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,trafficRes.TRAFFIC_OVER,this.halfHandler);
         this.clothBookMC.visible = true;
         IsVIP = LocalUserInfo.isVIP();
         if(evt.EventObj.type == 5)
         {
            if(evt.EventObj.Status == 0)
            {
               halfPrice = false;
            }
            else
            {
               halfPrice = true;
            }
         }
      }
      
      public function removeEventFun(event:* = null) : void
      {
         Tick.instance.removeCallback(onCallTime);
         BC.removeEvent(this);
         var tempMC:* = MainManager.getGameLevel().getChildByName("bookMC");
         GC.clearAll(tempMC);
      }
   }
}

