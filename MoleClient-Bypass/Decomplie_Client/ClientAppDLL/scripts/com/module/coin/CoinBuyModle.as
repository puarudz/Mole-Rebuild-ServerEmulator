package com.module.coin
{
   import com.common.Alert.Alert;
   import com.common.Alert.childAlert.SLBuyAlert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.newAlert.IAlert;
   import com.common.newAlert.MAlert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.IndexManager;
   import com.event.EventTaomee;
   import com.logic.socket.MoleShop.MoleShopSocket;
   import com.logic.socket.coinBuy.*;
   import com.module.activityModule.superPetLogin;
   import com.module.loadExtentPanel.LoadGame;
   import com.taomee.component.MButton;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class CoinBuyModle
   {
      
      public static var CLOSE_MIBI_EVENT:String = "CLOSE_MIBI_EVENT";
      
      private var SLAlerts:SLBuyAlert;
      
      private var good_id:uint;
      
      private var good_info:Object;
      
      private var count:uint;
      
      private var alt_mc:MovieClip;
      
      private var quantifierStr:String = "";
      
      public function CoinBuyModle()
      {
         super();
      }
      
      public function BuyModle(ID:uint, Count:uint, _str:String = "") : void
      {
         if(Boolean(_str))
         {
            this.quantifierStr = "<font color=\'#ff0000\'>" + Count + _str + "</font>";
         }
         else
         {
            this.quantifierStr = "";
         }
         this.alt_mc = new MovieClip();
         MainManager.getGameLevel().addChild(this.alt_mc);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeAll);
         this.good_id = ID;
         this.count = Count;
         this.SLAlerts = new SLBuyAlert();
         BC.addEvent(this,GV.onlineSocket,ISCoinRes.GETITEM_OK,this.isBackCoin);
         ISCoinReq.Info();
      }
      
      private function isBackCoin(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,ISCoinRes.GETITEM_OK,this.isBackCoin);
         if(event.EventObj.Bln == 0)
         {
            this.ISAltShow();
            return;
         }
         if(Boolean(CoinInfo.All_Info))
         {
            this.newAlertFun();
         }
         else
         {
            BC.addEvent(this,CoinInfo.getCoin(),CoinInfo.GET_INFO,this.newAlertFun);
            CoinInfo.getCoin().gerXML();
         }
      }
      
      public function newAlertFun(event:* = null) : void
      {
         this.bakeCoinParAsk();
      }
      
      private function bakeCoinParAsk() : void
      {
         var AddMC:* = this.alt_mc;
         var url:String = "";
         var info:String = "";
         this.good_info = CoinInfo.getCoin().getOneInfo(this.good_id);
         if(this.good_info.item_ID == 13625)
         {
            url = "resource/goods/icon/" + this.good_info.item_ID + ".swf";
         }
         else if(this.good_info.item_ID >= 1200001 && this.good_info.item_ID < 1209999)
         {
            url = "resource/petcloth/icon/" + this.good_info.item_ID + ".swf";
         }
         else if(this.good_info.item_ID > 160000 && this.good_info.item_ID < 9900000)
         {
            url = GoodsInfo.GetFullURLByItemId(this.good_info.item_ID);
         }
         else if(this.good_info.item_ID.indexOf("|") >= 0)
         {
            url = "resource/cloth/slicon/" + this.good_info.commodity_ID + ".swf";
         }
         else
         {
            url = "resource/cloth/icon/" + this.good_info.item_ID + ".swf";
         }
         if(LocalUserInfo.isVIP())
         {
            if(this.good_info.item_ID == 13625)
            {
               info = "    你選擇了<b>" + "吉娜時尚新禮包" + "</b>，需要花費<font color=\'#ff0000\'>" + "60" + "</font>米幣，若確認購買該物品，請輸入你的米幣帳戶密碼:";
            }
            else
            {
               info = "    你選擇了<b>" + this.quantifierStr + this.good_info.item_Name + "</b>，需要花費<font color=\'#ff0000\'>" + this.count * this.good_info.price_Vip + "</font>米幣，若確認購買該物品，請輸入你的米幣帳戶密碼:";
            }
         }
         else if(this.good_info.item_ID == 13625)
         {
            Alert.SLAlart("    只有擁有超級拉姆的小摩爾，才能購買吉娜的時尚新禮包哦！快來加入超級拉姆大家庭吧！");
         }
         else
         {
            info = "    你選擇了<b>" + this.quantifierStr + this.good_info.item_Name + "</b>，需要花費<font color=\'#ff0000\'>" + this.count * this.good_info.price + "</font>米幣，若確認購買該物品，請輸入你的米幣帳戶密碼:";
         }
         BC.addEvent(this,this.SLAlerts,SLBuyAlert.CLICK_EVENT_A,this.buyFun);
         this.SLAlerts.showUI(AddMC,url,info);
      }
      
      private function buyFun(event:EventTaomee) : void
      {
         BC.removeEvent(this,this.SLAlerts,SLBuyAlert.CLICK_EVENT_A,this.buyFun);
         var Passwd:String = event.EventObj.info;
         BC.addEvent(this,GV.onlineSocket,CoinApplyRes.GETITEM_OK,this.bakeCoinApply);
         BC.addEvent(this,GV.onlineSocket,"dis_coin_errorID",this.ErrorBuyFun);
         if(this.good_id == 100743)
         {
            BC.addEvent(this,GV.onlineSocket,CoinApplyRes.GETITEM_OK,this.bakeCoinApply);
            CoinApplyReq.Info(this.good_id,this.count,Passwd);
         }
         else if(this.good_id == 199900)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 2033,this.bakeCoinApply);
            MoleShopSocket.buyDou(this.good_id,Passwd,this.count);
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,CoinParApplyRes.GETITEM_OK,this.bakeCoinApply);
            CoinParApplyReq.Info(this.good_id,this.count,Passwd);
         }
      }
      
      private function bakeCoinApply(event:EventTaomee) : void
      {
         var loadGames:LoadGame = null;
         var goodsBox:String = null;
         BC.removeEvent(this,GV.onlineSocket,CoinApplyRes.GETITEM_OK,this.bakeCoinApply);
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2033,this.bakeCoinApply);
         var obj:Object = event.EventObj.obj;
         var url:String = "";
         var msg:String = "";
         if(this.good_info.item_ID == 1351054)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("ChineseZodiacGameBuy"));
         }
         else if(this.good_info.item_ID == 13625)
         {
            loadGames = new LoadGame("module/external/ginaBuySuccess.swf","正在打開......",MainManager.getAppLevel());
            loadGames = null;
         }
         else
         {
            if(this.good_info.item_ID == 1320001)
            {
               url = "resource/allJob/icon/" + this.good_info.item_ID + ".swf";
               msg = "    購買成功，阿七已經到你的家園中了，快回去看看吧！";
            }
            else if(this.good_info.item_ID == 190639)
            {
               url = "resource/allJob/icon/" + this.good_info.item_ID + ".swf";
               msg = "    購買成功！物品已放入你的百寶箱中！";
            }
            else if(this.good_info.item_ID == 199900)
            {
               url = GoodsInfo.GetFullURLByItemId(this.good_info.item_ID);
               msg = "    兌換成功！快去摩爾商城看看吧！";
            }
            if(this.good_info.item_ID == 190594)
            {
               url = "resource/allJob/icon/" + this.good_info.item_ID + ".swf";
               msg = "    購買成功！物品已放入你的百寶箱中！";
            }
            else if(this.good_info.item_ID > 160000 && this.good_info.item_ID < 9900000)
            {
               url = GoodsInfo.GetFullURLByItemId(this.good_info.item_ID);
               goodsBox = GoodsInfo.getItemCollectionBoxNameByID(this.good_info.item_ID);
               msg = "    購買成功！物品已放入你的" + goodsBox + "中！";
            }
            else if(this.good_info.item_ID.indexOf("|") >= 0)
            {
               url = "resource/cloth/slicon/" + this.good_info.commodity_ID + ".swf";
               msg = "    購買成功！物品已放入你的百寶箱！";
            }
            else
            {
               url = "resource/cloth/icon/" + this.good_info.item_ID + ".swf";
               msg = "    購買成功！物品已放入你的百寶箱！";
            }
            GF.showAlert(this.alt_mc,url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
         }
         this.removeAll();
      }
      
      private function ISAltShow() : void
      {
         var url:String = "";
         var msg:String = "    你的米幣帳戶還沒有設置密碼哦！為了你的帳戶安全，請先設置密碼。";
         var alert:IAlert = MAlert.showBuyAlert(msg,IndexManager.getInstance().getMovieClip("icon_sad"));
         alert.setMiniWidthEnabled(false);
         alert.getTextField().setPreferredWidth(260);
         alert.updateUI();
         var btn1:MButton = alert.getButtonPanel().getChildAt(0) as MButton;
         var btn2:MButton = alert.getButtonPanel().getChildAt(1) as MButton;
         btn1.setIcon(IndexManager.getInstance().getMovieClip("Button_mssz"));
         btn1.setColorMode(MButton.BLUE);
         btn2.setIcon(MButton.FLAG_nextTime);
         btn2.setColorMode(MButton.RED);
         alert.setApplyFun(this.setSLFun);
         this.alt_mc.addChild(DisplayObject(alert));
         GV.onlineSocket.dispatchEvent(new EventTaomee("clear_coinClothBookUI"));
         this.removeAll();
         GV.onlineSocket.dispatchEvent(new EventTaomee(CLOSE_MIBI_EVENT));
      }
      
      private function setSLFun() : void
      {
         superPetLogin.SatetyBoxReq();
         MainManager.getGameLevel().removeChild(this.alt_mc);
      }
      
      private function ErrorBuyFun(event:EventTaomee) : void
      {
         var msg:String = null;
         var alert:IAlert = null;
         var btn1:MButton = null;
         var btn2:MButton = null;
         var errAlt:IAlert = null;
         var errAlt_:IAlert = null;
         var errAlt_1:IAlert = null;
         var url:String = "";
         msg = "";
         switch(event.EventObj.ID)
         {
            case -50012:
               msg = "               對不起，密碼輸入錯誤。";
               alert = MAlert.showBuyAlert(msg,IndexManager.getInstance().getMovieClip("icon_sad"));
               btn1 = alert.getButtonPanel().getChildAt(0) as MButton;
               btn2 = alert.getButtonPanel().getChildAt(1) as MButton;
               btn1.setIcon(IndexManager.getInstance().getMovieClip("Button_cxsr"));
               btn1.setColorMode(MButton.BLUE);
               btn2.setIcon(MButton.FLAG_forgetPsw);
               btn2.setColorMode(MButton.RED);
               alert.setApplyFun(this.reShowBuyUI);
               alert.setCancelFun(this.forgetPassFun);
               this.alt_mc.addChild(DisplayObject(alert));
               return;
            case -50013:
               msg = "           很抱歉！目前該物品庫存不足！";
               MAlert.showEmotionAlert(msg,MAlert.SAD);
               this.alt_mc.addChild(DisplayObject(alert));
               break;
            case -50015:
               break;
            case -50016:
               msg = "     你已經擁有這件物品，不要浪費米幣哦！";
               errAlt = MAlert.showEmotionAlert(msg,MAlert.SAD);
               this.alt_mc.addChild(DisplayObject(errAlt));
               break;
            case -50017:
               msg = "     你已經擁有這件商品或這套商品某一部分，為避免重復，請重新選擇或單件購買！";
               errAlt_ = MAlert.showEmotionAlert(msg,MAlert.SMILE);
               this.alt_mc.addChild(DisplayObject(errAlt_));
               break;
            case -50105:
               msg = "         真可惜，你的米幣賬戶餘額不夠哦！";
               alert = MAlert.showBuyAlert(msg,IndexManager.getInstance().getMovieClip("icon_sad"));
               btn1 = alert.getButtonPanel().getChildAt(0) as MButton;
               btn2 = alert.getButtonPanel().getChildAt(1) as MButton;
               btn1.setIcon(IndexManager.getInstance().getMovieClip("Button_mbcz"));
               btn1.setColorMode(MButton.BLUE);
               btn2.setIcon(MButton.FLAG_nextTime);
               btn2.setColorMode(MButton.RED);
               alert.setApplyFun(this.getURLFun);
               this.alt_mc.addChild(DisplayObject(alert));
               break;
            case -50023:
               msg = "     真可惜，你沒足夠的淘淘樂購物券和米幣來購買這樣物品哦！";
               alert = MAlert.showBuyAlert(msg,IndexManager.getInstance().getMovieClip("icon_sad"));
               btn1 = alert.getButtonPanel().getChildAt(0) as MButton;
               btn2 = alert.getButtonPanel().getChildAt(1) as MButton;
               btn1.setIcon(IndexManager.getInstance().getMovieClip("Button_mbcz"));
               btn1.setColorMode(MButton.BLUE);
               btn2.setIcon(MButton.FLAG_nextTime);
               btn2.setColorMode(MButton.RED);
               alert.setApplyFun(this.getURLFun);
               this.alt_mc.addChild(DisplayObject(alert));
               break;
            case -50107:
               if(LocalUserInfo.getMapID() == 2)
               {
                  msg = "　  感謝您的愛心，您本月的消費已經達到最高限額,請下個月再來捐款吧!";
                  GF.showAlert(this.alt_mc,msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
               }
               else
               {
                  url = "resource/allJob/AlertPic/coin_money.swf";
                  msg = "     真遺憾，你本月累計消費已達到購買上限，無法購買該物品。";
                  GF.showAlert(this.alt_mc,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
               }
               break;
            case -50019:
               msg = "     你的小屋家具超過上限！";
               errAlt_1 = MAlert.showEmotionAlert(msg,MAlert.SMILE);
               this.alt_mc.addChild(DisplayObject(errAlt_1));
         }
         this.removeAll();
      }
      
      private function reShowBuyUI() : void
      {
         MainManager.getGameLevel().removeChild(this.alt_mc);
         this.alt_mc = null;
         this.alt_mc = new MovieClip();
         MainManager.getGameLevel().addChild(this.alt_mc);
         this.newAlertFun();
      }
      
      private function forgetPassFun() : void
      {
         superPetLogin.forgetPass();
         MainManager.getGameLevel().removeChild(this.alt_mc);
      }
      
      private function getURLFun() : void
      {
         superPetLogin.gameBuy();
         MainManager.getGameLevel().removeChild(this.alt_mc);
      }
      
      private function removeAll(event:* = null) : void
      {
         BC.removeEvent(this);
         this.SLAlerts = null;
         this.good_id = 0;
         this.good_info = null;
         this.count = 0;
      }
   }
}

