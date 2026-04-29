package com.module.activityModule
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.getItemEveryDay.GetItemEveryDay;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.logic.socket.presentGoods.PresentGoodsRes;
   import com.logic.socket.summerAct.SummerSocket;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.messageTips.MT;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.task.TaskManager;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   
   public class Presented
   {
      
      private static var instance:Presented;
      
      public static var EXCHANGE_COMPLETE:String = "EXCHANGE_COMPLETE";
      
      private var _rndSwapFun:Function;
      
      private var _exchangOkStr:String;
      
      private var _exchangNoStr:String;
      
      private var _okCallBack:Function;
      
      private var callBackFun:Function;
      
      public function Presented()
      {
         super();
      }
      
      public static function getInstance() : Presented
      {
         if(instance == null)
         {
            instance = new Presented();
         }
         return instance;
      }
      
      public static function showAwardAlert(itemList:Array) : void
      {
         var itemObj:ItemInfo = null;
         var msg:String = null;
         var i:uint = 0;
         for each(itemObj in itemList)
         {
            if(itemObj.ID == 0)
            {
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + itemObj.count);
            }
         }
         msg = "    恭喜你獲得";
         for(i = 0; i < itemList.length; i++)
         {
            itemObj = itemList[i];
            msg += itemObj.count + "個" + GoodsInfo.getItemNameByID(itemObj.ID) + ",";
         }
         msg = msg.substr(0,msg.length - 1);
         msg += "。";
         Alert.smileAlart(msg);
      }
      
      public function FreeReceive(type:int = 7) : void
      {
         GV.onlineSocket.addEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getSeedSucc);
         GV.onlineSocket.addEventListener("ERROR_CMD_1116",this.getSeedError);
         PresentGoodsReq.req(type);
      }
      
      private function getSeedError(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getSeedSucc);
         GV.onlineSocket.removeEventListener("ERROR_CMD_1116",this.getSeedError);
      }
      
      private function getSeedSucc(evt:EventTaomee) : void
      {
         var msg:String = null;
         var url:String = null;
         var loadGame:LoadGame = null;
         GV.onlineSocket.removeEventListener(PresentGoodsRes.PRESENT_GOODS_SUCC,this.getSeedSucc);
         if(GoodsInfo.getType(evt.EventObj.ItemID) == 30)
         {
            if(evt.EventObj.Flag == 1)
            {
               if(evt.EventObj.ItemID == 1353212)
               {
                  loadGame = new LoadGame("resource/task/starsMC.swf","正在打開面板",MainManager.getAppLevel());
                  loadGame = null;
               }
               else
               {
                  msg = "    恭喜你獲得了" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "哦，已放入你的投擲欄中哦！";
                  url = "resource/effect/icon/" + evt.EventObj.ItemID + ".swf";
                  Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
               }
            }
            else if(evt.EventObj.ItemID == 1353212)
            {
               Alert.getIconByID_Alart(1270005,"　   今天你已經得到太多" + GoodsInfo.getItemNameByID(1270005) + "，明天再來看看吧！");
            }
            else
            {
               Alert.getIconByID_Alart(evt.EventObj.ItemID,"　   今天你已經得到太多" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，明天再來看看吧！");
            }
         }
         else if(GoodsInfo.getType(evt.EventObj.ItemID) == 3)
         {
            if(evt.EventObj.Flag == 1)
            {
               msg = "    恭喜你獲得了" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "哦，已放入你的投擲欄中哦！";
               url = "resource/effect/icon/" + evt.EventObj.ItemID + ".swf";
               Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            }
            else
            {
               msg = "    今天你已經得到太多" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，明天再來看看吧！";
               url = "resource/effect/icon/" + evt.EventObj.ItemID + ".swf";
               Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            }
         }
         else if(GoodsInfo.getType(evt.EventObj.ItemID) == 5)
         {
            if(evt.EventObj.Flag == 1)
            {
               msg = "    恭喜你獲得了" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "哦，已經放入你的小屋倉庫。";
               url = "resource/goods/icon/" + evt.EventObj.ItemID + ".swf";
               Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            }
            else
            {
               msg = "    今天你已經得到太多" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，明天再來看看吧！";
               url = "resource/goods/icon/" + evt.EventObj.ItemID + ".swf";
               Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            }
         }
         else if(GoodsInfo.getType(evt.EventObj.ItemID) == 7)
         {
            if(evt.EventObj.Flag == 1)
            {
               msg = "    恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，已經放入你的拉姆背包中！";
               url = "resource/pet/icon/" + evt.EventObj.ItemID + ".swf";
               Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            }
            else
            {
               msg = "    今天你已經得到太多" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，明天再來看看吧！";
               url = "resource/pet/icon/" + evt.EventObj.ItemID + ".swf";
               Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            }
         }
         else if(GoodsInfo.getType(evt.EventObj.ItemID) == 9)
         {
            if(evt.EventObj.Flag == 2)
            {
               if(evt.EventObj.ItemID == 190351)
               {
                  msg = "    恭喜你意外獲得1粒螢火草種子和" + evt.EventObj.count + "棵螢火草！";
                  Alert.smileAlart(msg);
               }
            }
            else if(evt.EventObj.Flag == 1)
            {
               if(evt.EventObj.count > 1)
               {
                  msg = "    恭喜你獲得" + evt.EventObj.count + "個" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，已放入你的百寶箱中！";
               }
               else
               {
                  msg = "    恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，已放入你的百寶箱中！";
               }
               url = "resource/allJob/icon/" + evt.EventObj.ItemID + ".swf";
               Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            }
            else
            {
               msg = "    今天你已經得到太多" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，明天再來看看吧！";
               url = "resource/allJob/icon/" + evt.EventObj.ItemID + ".swf";
               Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            }
         }
         else if(GoodsInfo.getType(evt.EventObj.ItemID) == 14)
         {
            if(evt.EventObj.Flag == 1)
            {
               Alert.getIconByID_Alart(evt.EventObj.ItemID,"　  恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，已經放進你的家園倉庫中！");
            }
            else
            {
               Alert.getIconByID_Alart(evt.EventObj.ItemID,"　   今天你已經得到太多" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，明天再來看看吧！");
            }
         }
         else if(GoodsInfo.getType(evt.EventObj.ItemID) == 18)
         {
            if(evt.EventObj.Flag == 1)
            {
               Alert.getIconByID_Alart(evt.EventObj.ItemID,"　  恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，已經放入你的牧場倉庫中了！");
            }
            else
            {
               Alert.getIconByID_Alart(evt.EventObj.ItemID,"　   今天你已經得到太多" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，明天再來看看吧！");
            }
         }
         else if(evt.EventObj.ItemID >= 1290001 && evt.EventObj.ItemID <= 1299999)
         {
            if(evt.EventObj.Flag == 1)
            {
               PeopleManageView(GV.MAN_PEOPLE).addEffect("sure_ef");
               GV.onlineClass.chating(0,"/wx");
               url = "resource/JJLcard/icon/" + evt.EventObj.ItemID + ".swf";
               msg = "    恭喜你獲得" + evt.EventObj.count + "張" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，已放入你的《吉吉樂卡片王手冊》中哦！";
               Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            }
            else
            {
               PeopleManageView(GV.MAN_PEOPLE).addEffect("fail_ef");
               GV.onlineClass.chating(0,"/fd");
               url = "resource/JJLcard/icon/" + evt.EventObj.ItemID + ".swf";
               msg = "    今天你已經得到太多" + GoodsInfo.getItemNameByID(evt.EventObj.ItemID) + "，明天再來看看吧！";
               Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            }
         }
      }
      
      public function FreeReceiveBy1117(type:int) : void
      {
         GV.onlineSocket.addEventListener("read_" + 1117,this.onRead1117);
         GetItemEveryDay.req_getItemEveryDay(type);
      }
      
      private function onRead1117(evt:EventTaomee) : void
      {
         var msg:String = null;
         var url:String = null;
         GV.onlineSocket.removeEventListener("read_" + 1117,this.onRead1117);
         if(evt.EventObj.type == 0)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("1117_0",evt.EventObj));
         }
         else if(evt.EventObj.type == 1)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("1117_1",evt.EventObj));
         }
         else if(evt.EventObj.type >= 6 && evt.EventObj.type <= 14)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("     這裡的元寶已經被你拿光了！明天再來看看吧！");
               return;
            }
            msg = "    恭喜你獲得" + evt.EventObj.itmeCount + "個" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + "，已放入你的百寶箱中！";
            url = "resource/allJob/icon/" + evt.EventObj.itemid + ".swf";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
         }
         else if(evt.EventObj.type == 24 || evt.EventObj.type == 25)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經得到太多的該物品了，明天再來看看吧！");
               return;
            }
            Alert.getIconByID_Alart(evt.EventObj.itemid,"　  恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + "，已經放進你的家園倉庫中！");
         }
         else if(evt.EventObj.type == 23)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經拿過小烏龜啦，給別人留一些吧！：）");
               return;
            }
            Alert.getIconByID_Alart(evt.EventObj.itemid,"　  恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + "，已經放進你的牧場倉庫中！");
         }
         else if(evt.EventObj.type == 22)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經得到太多的該物品了，明天再來看看吧！");
               return;
            }
            Alert.getIconByID_Alart(evt.EventObj.itemid,"　  恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + "，已經放進你的家園倉庫中！");
         }
         else if(evt.EventObj.type == 26)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經得到太多的該物品了，明天再來看看吧！");
               return;
            }
            msg = "    恭喜你順利通過了梅花樁！送你" + evt.EventObj.itmeCount + "個" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + "，大吉大利哦！";
            url = "resource/effect/icon/" + evt.EventObj.itemid + ".swf";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
         }
         else if(evt.EventObj.type == 27 || evt.EventObj.type == 28)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經得到太多的該物品了，明天再來看看吧！");
               return;
            }
            Alert.getIconByID_Alart(evt.EventObj.itemid,"　  恭喜你獲得" + evt.EventObj.itmeCount + "個" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + "，已放入你的百寶箱中！");
         }
         else if(evt.EventObj.type == 33)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經不能得到它了，明天再來看看吧！");
            }
            else
            {
               MT.pop(3);
            }
         }
         else if(evt.EventObj.type == 34)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經獲得太多傑克南瓜酥啦！明天才能再拿喲！");
            }
            else
            {
               Alert.getIconByID_Alart(evt.EventObj.itemid,"　  恭喜你獲得" + evt.EventObj.itmeCount + "個" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + "，已經放進你的拉姆背包中！");
            }
         }
         else if(evt.EventObj.type == 35 || evt.EventObj.type == 36 || evt.EventObj.type == 37)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經得到太多的該物品了，明天再來看看吧！");
            }
            else
            {
               Alert.smileAlart("    恭喜你獲得" + evt.EventObj.itmeCount + "個" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + "哦，已放入你的投擲欄中哦！");
            }
         }
         else if(evt.EventObj.type == 45 || evt.EventObj.type == 46 || evt.EventObj.type == 47)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經得到太多的該物品了，明天再來看看吧！");
            }
            else
            {
               Alert.getIconByID_Alart(evt.EventObj.itemid,"    恭喜你獲得" + evt.EventObj.itmeCount + "個" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + ",已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(evt.EventObj.itemid) + "中！");
            }
         }
         else if(evt.EventObj.type == 49)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經得到太多的該物品了，明天再來看看吧！");
            }
            else
            {
               Alert.smileAlart("　　恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + ",已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(evt.EventObj.itemid) + "中！");
            }
         }
         else if(evt.EventObj.type == 44)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經得到太多的該物品了，明天再來看看吧！");
            }
            else
            {
               Alert.smileAlart("　　恭喜你獲得" + evt.EventObj.itmeCount + "個" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + ",已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(evt.EventObj.itemid) + "中！");
            }
         }
         else if(evt.EventObj.type == 46)
         {
            if(evt.EventObj.itmeCount == 0)
            {
               Alert.smileAlart("    你今天已經領取過啦，請明天再過來領取吧！");
            }
            else
            {
               Alert.smileAlart("　　恭喜你獲得1顆向陽花種子，快去家園種植起來吧！明天可以繼續領取哦！");
            }
         }
         else if(evt.EventObj.itmeCount == 0)
         {
            Alert.smileAlart("    你今天已經得到太多的該物品了，明天再來看看吧！");
         }
         else
         {
            Alert.smileAlart("　　恭喜你獲得" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + ",已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(evt.EventObj.itemid) + "中！");
         }
      }
      
      public function celebrate10(_itemID:int, _count:int = 1) : void
      {
         BC.addEvent(this,GV.onlineSocket,exchange.CELEBRATE_INFO,this.celeHandler);
         exchange.celebrate(_itemID,_count);
      }
      
      private function celeHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.CELEBRATE_INFO,this.celeHandler);
         if(evt.EventObj.count != 0)
         {
            Alert.smileAlart("    恭喜你找到" + GoodsInfo.getItemNameByID(evt.EventObj.itemID) + "，莊園裡藏著好多東西！藏寶大行動的禮物等你拿哦！");
         }
         else
         {
            Alert.smileAlart("    你已經找到" + GoodsInfo.getItemNameByID(evt.EventObj.itemID) + "啦，再去找找莊園其他地方藏著的好東西吧！");
         }
      }
      
      public function rndSwap(typeID:uint, rndSwapFun:Function = null) : void
      {
         this._rndSwapFun = rndSwapFun;
         GV.onlineSocket.addEventListener("read_" + CommandID.TreasureBowl,this.onRndSwap);
         superlamuPartySocket.treasurebowl(typeID,0,1);
      }
      
      private function onRndSwap(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + CommandID.TreasureBowl,this.onRndSwap);
         var obj:Object = e.EventObj;
         var name:String = GoodsInfo.getItemNameByID(obj.itemId);
         Alert.getIconByID_Alart(obj.itemId,"　　恭喜你獲得" + obj.count + "個" + name + "！");
         if(obj.itemId == 0)
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + obj.count);
         }
         if(this._rndSwapFun != null)
         {
            this._rndSwapFun.apply(null,[obj.itemId,obj.count]);
            this._rndSwapFun = null;
         }
      }
      
      public function getItem8816(type:uint) : void
      {
         GV.onlineSocket.addEventListener(SummerSocket.PROP_FETCH,this.onGetItem8816);
         OnlineManager.addErrorListener(SummerSocket.PROP_FETCH_CMD,this.onGetItem8816Error);
         SummerSocket.propFetch(type);
      }
      
      private function onGetItem8816Error(e:SocketEvent) : void
      {
         GV.onlineSocket.removeEventListener(SummerSocket.PROP_FETCH,this.onGetItem8816);
         OnlineManager.removeErrorListener(SummerSocket.PROP_FETCH_CMD,this.onGetItem8816Error);
      }
      
      private function onGetItem8816(e:EventTaomee) : void
      {
         var msg:String = null;
         var i:uint = 0;
         GV.onlineSocket.removeEventListener(SummerSocket.PROP_FETCH,this.onGetItem8816);
         OnlineManager.removeErrorListener(SummerSocket.PROP_FETCH_CMD,this.onGetItem8816Error);
         var itemList:Array = e.EventObj.arr;
         if(Boolean(itemList) && itemList.length > 0)
         {
            msg = "　　恭喜你獲得";
            for(i = 0; i < itemList.length; i++)
            {
               msg += itemList[i].count + "個" + GoodsInfo.getItemNameByID(itemList[i].itemID) + ",";
            }
            msg = msg.substr(0,msg.length - 1);
            msg += "。";
         }
         else
         {
            msg = "　　你不能獲得此物品！";
         }
         Alert.smileAlart(msg);
      }
      
      public function celebrate1225(id:int, count:int = 1, flag:int = 1, okStr:String = "", noStr:String = "", okCallBack:Function = null) : void
      {
         this._exchangOkStr = okStr;
         this._okCallBack = okCallBack;
         this._exchangNoStr = noStr;
         BC.addOnceEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.socksHandler);
         exchange.exchange_goods(id,count,flag);
      }
      
      private function socksHandler(evt:EventTaomee) : void
      {
         var itemList:Array = null;
         var msg:String = null;
         var i:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.socksHandler);
         GV.onlineSocket.dispatchEvent(new EventTaomee(EXCHANGE_COMPLETE,evt.EventObj));
         if(evt.EventObj.Count != 0)
         {
            itemList = evt.EventObj.arr;
            msg = "    恭喜你獲得";
            for(i = 0; i < itemList.length; i++)
            {
               msg += itemList[i].count + "個" + GoodsInfo.getItemNameByID(itemList[i].itemID) + ",";
            }
            if(this._okCallBack != null)
            {
               this._okCallBack();
            }
            if(Boolean(this._exchangOkStr))
            {
               Alert.smileAlart(this._exchangOkStr);
            }
            else if(GoodsInfo.getType(evt.EventObj.arr[0].itemID) == 28)
            {
               msg = msg.substr(0,msg.length - 1);
               msg += "。";
               Alert.smileAlart(msg);
            }
            else
            {
               msg += "已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(itemList[0].itemID) + "中！";
               Alert.smileAlart(msg);
            }
         }
         else if(Boolean(this._exchangNoStr))
         {
            Alert.smileAlart(this._exchangNoStr);
         }
         else
         {
            Alert.smileAlart("  恭喜小摩爾捐獻成功了！");
         }
      }
      
      public function exchange1243(id:int, backFun:Function, count:int = 1, flag:int = 0) : void
      {
         this.callBackFun = backFun;
         BC.addOnceEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.socksExchangeHandler);
         exchange.exchange_goods(id,count,flag);
      }
      
      private function socksExchangeHandler(evt:EventTaomee) : void
      {
         var itemList:Array = null;
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.socksExchangeHandler);
         GV.onlineSocket.dispatchEvent(new EventTaomee(EXCHANGE_COMPLETE,evt.EventObj));
         if(evt.EventObj.Count != 0)
         {
            itemList = evt.EventObj.arr as Array;
            this.callBackFun.apply(null,[itemList]);
         }
         else
         {
            Alert.imagesAlert("你今天已經拿了太多這個物品了，請明天再來吧",Alert.FACE_ANGRY,function():void
            {
               ModuleManager.openPanel("WishingWellPanel");
            });
         }
      }
      
      public function FreeReceiveBy2012(type:int) : void
      {
         var msg:String = null;
         var myAle:* = undefined;
         if(TaskManager.getTaskState(111) == 0)
         {
            msg = "    找到麼麼公主的拉姆瑪麗接任務才能拿這裡的美食哦，現在過去嗎？";
            myAle = GF.showAlert(MainManager.getAppLevel(),msg,"",100,"sure,cancel",true,false,"E");
            myAle.addEventListener(Alert.CLICK_ + "1",this.next);
         }
         else
         {
            GV.onlineSocket.addEventListener("read_" + 2012,this.onRead2012);
            GetItemEveryDay.req_getSceneItemEvent(type);
         }
      }
      
      private function next(evt:*) : void
      {
         evt.target.removeEventListener(Alert.CLICK_ + "1",this.next);
         GF.switchMap(142,true);
      }
      
      private function onRead2012(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 2012,this.onRead2012);
         GV.onlineSocket.removeEventListener("read_" + 2012,this.onRead2012);
         Alert.getIconByID_Alart(evt.EventObj.itemid,"　  恭喜你獲得兩個" + GoodsInfo.getItemNameByID(evt.EventObj.itemid) + "，已經放進你的拉姆背包中！");
      }
      
      public function superlamuParty(type:int = 0, _i:int = 0, _m:int = 1) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1242,this.backItemHandler);
         superlamuPartySocket.treasurebowl(type,_i,_m);
      }
      
      private function backItemHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1242,this.backItemHandler);
         var itemObj:Object = evt.EventObj;
         Alert.smileAlart("　　恭喜你獲得" + itemObj.count + "個" + GoodsInfo.getItemNameByID(itemObj.itemId) + ",已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(itemObj.itemId) + "中！");
      }
      
      public function exChange1243ForNotAlert(id:int, count:int = 1, flag:int = 0) : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exChange1243ForNotAlertHandler);
         exchange.exchange_goods(id,count,flag);
      }
      
      private function exChange1243ForNotAlertHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exChange1243ForNotAlertHandler);
         GV.onlineSocket.dispatchEvent(new EventTaomee(EXCHANGE_COMPLETE,evt.EventObj));
      }
   }
}

