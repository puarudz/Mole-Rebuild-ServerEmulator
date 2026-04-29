package com.module.homeBook.homeBookView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.PageSandMsg.sandMsgReq;
   import com.logic.socket.PageSandMsg.sandMsgRes;
   import com.logic.socket.lookBag.LookBagReq;
   import com.logic.socket.lookBag.LookBagRes;
   import com.logic.socket.traffic.trafficReq;
   import com.logic.socket.traffic.trafficRes;
   import com.module.activityModule.Presented;
   import com.module.deal.Deal;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class homeBookView
   {
      
      public static var homeBookMC:MovieClip;
      
      public static var sendPanelMc:MovieClip;
      
      public static var halfPrice:uint;
      
      public static var IsVIP:Boolean = false;
      
      private var _clickBool:Boolean = true;
      
      public var lookBagClass:LookBagReq = new LookBagReq();
      
      private var myMoreBag_arr:Array = [160973,160946,160912];
      
      private var bagArr:Array = [];
      
      public function homeBookView(obj:*)
      {
         super();
         homeBookMC = obj;
         BC.addEvent(this,GV.onlineSocket,trafficRes.TRAFFIC_OVER,this.halfHandler);
         trafficReq.trafficSend(10);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventFun);
         var panelC:Class = homeBookMC.loaderInfo.applicationDomain.getDefinition("sendPanel") as Class;
         sendPanelMc = new panelC() as MovieClip;
         sendPanelMc.name = "sendPanelMc";
         BC.addEvent(this,GV.onlineSocket,"GETPASS_ITEM",this.getPassEvent);
      }
      
      public static function BuyGoods(mc:MovieClip, itemID:uint) : void
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
         mc.money_txt.text = obj.price;
      }
      
      public static function SLBuyGoodsIsClick(mc:MovieClip, itemID:uint) : void
      {
         /*
          * Decompilation error
          * Code may be obfuscated
          * Tip: You can try enabling "Deobfuscate code" option in Settings
          * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to error");
      }
      
      private static function checkbuyFun(e:MouseEvent) : void
      {
         var alert:*;
         var id:uint = 0;
         var obj:Object = null;
         var msg:String = null;
         id = uint(e.currentTarget.parent.id);
         obj = GoodsInfo.getInfoById(id);
         if(halfPrice == 2)
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
      
      public static function sendMsg() : void
      {
         sendPanelMc.msgBTxt.text = "";
         sendPanelMc.msgTTxt.text = "";
         sendPanelMc.x = 960 / 2;
         sendPanelMc.y = 560 / 2;
         homeBookMC.addChild(sendPanelMc);
         BC.addEvent(homeBookView,sendPanelMc.closeBtn,MouseEvent.CLICK,onSPCloseBtn);
         BC.addEvent(homeBookView,sendPanelMc.sendBtn,MouseEvent.CLICK,onSPSendBtn);
      }
      
      public static function onSPSendBtn(evt:MouseEvent) : void
      {
         var msg:String = sendPanelMc.msgBTxt.text;
         var tit:String = sendPanelMc.msgTTxt.text;
         if(msg != "" && tit != "")
         {
            new sandMsgReq().sandFun(1012,tit,msg);
            BC.addEvent(homeBookView,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,showsandTit);
         }
         else
         {
            Alert.smileAlart("    一定要填寫標題和內容才可以哦~");
         }
      }
      
      public static function showsandTit(e:* = null) : void
      {
         BC.removeEvent(homeBookView,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,showsandTit);
         Alert.smileAlart("    太好了！投稿成功,大衛感謝你的參與");
         onSPCloseBtn();
      }
      
      public static function onSPCloseBtn(evt:MouseEvent = null) : void
      {
         var spmc:MovieClip = homeBookMC.getChildByName("sendPanelMc") as MovieClip;
         homeBookMC.removeChild(spmc);
      }
      
      private function getPassEvent(evt:EventTaomee) : void
      {
         if(evt.EventObj.id == 160982 && this._clickBool)
         {
            this._clickBool = false;
            this.receiveEvent();
         }
      }
      
      private function receiveEvent() : void
      {
         this.sandBegEvent(16);
      }
      
      private function sandBegEvent(type:int = 128) : void
      {
         this.lookBagClass.lookBag(LocalUserInfo.getUserID(),type,0);
         try
         {
            BC.addEvent(this,GV.onlineSocket,LookBagRes.BAG_OVER,this.getBagList2);
         }
         catch(e:*)
         {
         }
         BC.addEvent(this,GV.onlineSocket,LookBagRes.BAG_OVER,this.getBagList2,false,0,false);
      }
      
      private function getBagList2(evt:* = null) : void
      {
         this._clickBool = true;
         try
         {
            BC.removeEvent(this,GV.onlineSocket,LookBagRes.BAG_OVER,this.getBagList2);
         }
         catch(e:*)
         {
         }
         var bagObj:Object = evt.EventObj.obj;
         this.bagArr = bagObj.arr;
         if(this.chartbagFun(160982))
         {
            Alert.smileAlart("    你已經有這個物品了，看看其他的吧！");
         }
         else if(this.startEvent())
         {
            Presented.getInstance().celebrate1225(737);
         }
         else
         {
            Alert.smileAlart("    你還沒有收集齊章魚壽司小屋、香蕉船小屋、美味漢堡房無法兌換哦~");
         }
      }
      
      private function startEvent() : Boolean
      {
         var _b:Boolean = true;
         for(var i:int = 0; i < this.myMoreBag_arr.length; i++)
         {
            if(!this.chartbagFun(this.myMoreBag_arr[i]))
            {
               _b = false;
            }
         }
         return _b;
      }
      
      private function chartbagFun(p:*) : Boolean
      {
         var b:int = 0;
         var myBoolean:Boolean = false;
         var arr:Array = new Array();
         if(this.bagArr != arr)
         {
            for(b = 0; b < this.bagArr.length; b++)
            {
               if(this.bagArr[b].id == p)
               {
                  myBoolean = true;
               }
            }
         }
         return myBoolean;
      }
      
      private function halfHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,trafficRes.TRAFFIC_OVER,this.halfHandler);
         if(e.EventObj.type == 10)
         {
            if(e.EventObj.Status == 0)
            {
               halfPrice = 1;
            }
            else
            {
               halfPrice = 2;
            }
         }
      }
      
      public function removeEventFun(event:* = null) : void
      {
         BC.removeEvent(this);
         var tempMC:* = MainManager.getGameLevel().getChildByName("bookView");
         GC.clearAll(tempMC);
      }
   }
}

