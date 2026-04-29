package com.module.bookItem
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.PageSandMsg.sandMsgReq;
   import com.logic.socket.PageSandMsg.sandMsgRes;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.logic.socket.traffic.trafficReq;
   import com.logic.socket.traffic.trafficRes;
   import com.module.activityModule.checkCloth;
   import com.module.activityModule.superPetLogin;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class chevalierClothBookView extends MovieClip
   {
      
      private static var allPage:int = 17;
      
      private static var other_icon:Array = [12298,12023,12024,12025,12026,12327,12328,12329];
      
      public var buyItem:BuyItemReq;
      
      public var tempLoader:Loader;
      
      public var tempMC:MovieClip;
      
      public var targetMC:MovieClip;
      
      public var buyNum:int;
      
      public var nowFrame:int;
      
      public var buyMach:*;
      
      public var halfPrice:int = 1;
      
      private var IsVIP:Boolean = false;
      
      private var IsHaveItm:Boolean = false;
      
      private var AddBtn:Boolean = false;
      
      public function chevalierClothBookView(obj:*)
      {
         super();
         this.targetMC = obj.main_mc;
         this.tempMC = new MovieClip();
         this.tempLoader = new Loader();
         this.buyItem = new BuyItemReq();
         this.targetMC.mc_1.visible = false;
         this.targetMC.mc_no.visible = false;
         this.targetMC.mc_3.visible = false;
         this.nowFrame = 1;
         BC.addEvent(this,GV.onlineSocket,trafficRes.TRAFFIC_OVER,this.halfHandler);
         trafficReq.trafficSend(5);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEvent);
      }
      
      private function halfHandler(evt:EventTaomee = null) : void
      {
         this.IsVIP = LocalUserInfo.isVIP();
         this.IsHaveItm = checkCloth.doAction(12202);
         BC.addEvent(this,GV.onlineSocket,"nowPage_clothbuybook",this.pageOneInit);
         BC.addEvent(this,GV.onlineSocket,"removeMC_clothbuybook",this.removeEvent);
      }
      
      private function chartBtnNum(num:int) : int
      {
         var btn_num:int = 0;
         switch(num)
         {
            case 2:
               btn_num = 1;
               this.AddBtn = true;
               break;
            case 3:
               btn_num = 4;
               this.AddBtn = true;
               break;
            case 4:
               this.chartVIP();
               this.makePageMCInfo();
               btn_num = 0;
               break;
            case 5:
               this.chartVIP();
               btn_num = 1;
         }
         return btn_num;
      }
      
      public function pageOneInit(e:*) : void
      {
         var i:int = 0;
         var tempMC:* = undefined;
         var buy_info:Object = null;
         var ip:int = 0;
         this.nowFrame = this.targetMC.currentFrame;
         var btn_num:int = this.chartBtnNum(this.nowFrame);
         if(this.nowFrame == 1 || this.nowFrame == allPage)
         {
            return;
         }
         if(this.AddBtn)
         {
            for(i = 1; i <= btn_num; i++)
            {
               tempMC = this.targetMC["buy_" + i];
               buy_info = GF.getPropData(tempMC.id);
               tempMC.visible = true;
               tempMC.money_txt.text = buy_info.price;
               BC.addEvent(this,tempMC.btn,MouseEvent.CLICK,this.buyAction);
            }
         }
         else
         {
            if(this.nowFrame == 9)
            {
               this.targetMC.show_btn.visible = false;
            }
            for(ip = 1; ip <= btn_num; ip++)
            {
               this.targetMC["buy_" + ip].visible = false;
            }
         }
      }
      
      public function chartVIP() : void
      {
         if(this.IsVIP && this.IsHaveItm)
         {
            this.AddBtn = true;
         }
         else
         {
            this.AddBtn = false;
         }
      }
      
      public function makePageMCInfo() : void
      {
         BC.addEvent(this,this.targetMC.pageMC.over_btn,MouseEvent.CLICK,this.overPageFun);
         BC.addEvent(this,this.targetMC.pageMC.getOne_btn,MouseEvent.CLICK,this.newInterFun);
      }
      
      public function overPageFun(event:MouseEvent) : void
      {
         BC.removeEvent(this,this.targetMC.pageMC.over_btn,MouseEvent.CLICK,this.overPageFun);
         BC.removeEvent(this,this.targetMC.pageMC.getOne_btn,MouseEvent.CLICK,this.newInterFun);
         this.targetMC.gotoAndStop(16);
      }
      
      public function newInterFun(event:MouseEvent) : void
      {
         superPetLogin.gotoPay();
      }
      
      public function buyAction(evt:MouseEvent) : void
      {
         var num:* = evt.target.parent.name.substr(4);
         var tempInfo:* = GF.getPropData(evt.target.parent.id);
         this.buyMach = tempInfo.price / this.halfPrice;
         this.buyNum = tempInfo.id;
         var buyName:* = tempInfo.name;
         if(LocalUserInfo.getYXQ() >= Number(this.buyMach))
         {
            this.targetMC.mc_1.visible = true;
            this.tempLoader.unload();
            if(other_icon.indexOf(this.buyNum) != -1)
            {
               this.tempLoader.load(VL.getURLRequest("resource/goods/icon/" + this.buyNum + ".swf"));
            }
            else
            {
               this.tempLoader.load(VL.getURLRequest("resource/goods/icon/" + this.buyNum + ".swf"));
            }
            this.targetMC.mc_1.addChild(this.tempMC);
            this.tempMC.addChild(this.tempLoader);
            this.tempMC.scaleX = 1.8;
            this.tempMC.scaleY = 1.8;
            this.tempMC.x = 135;
            this.tempMC.y = 40;
            if(this.halfPrice == 1)
            {
               this.targetMC.mc_1.info.text = buyName + "需花費" + this.buyMach + "摩爾豆，你現在擁有" + LocalUserInfo.getYXQ().toString() + "摩爾豆，要確認購買嗎？";
            }
            else
            {
               this.targetMC.mc_1.info.htmlText = buyName + "需花費" + this.buyMach * this.halfPrice + "摩爾豆<font color=\'#ff0000\'>(今日半價:" + this.buyMach + "摩爾豆)</font>，要確認購買嗎？";
            }
            BC.addEvent(this,this.targetMC.mc_1.enter_btn,MouseEvent.CLICK,this.pageOneHandler);
            BC.addEvent(this,this.targetMC.mc_1.cancel_btn,MouseEvent.CLICK,this.visibleFalse);
         }
         else
         {
            this.targetMC.mc_no.visible = true;
            BC.addEvent(this,this.targetMC.mc_no.enter_btn,MouseEvent.CLICK,this.visibleFalse);
            this.targetMC.mc_no.info.text = "你的摩爾豆不夠囉......";
         }
      }
      
      public function pageOneHandler(evt:MouseEvent) : void
      {
         evt.target.removeEventListener(MouseEvent.CLICK,this.pageOneHandler);
         this.targetMC.mc_1.visible = false;
         this.tempLoader.unload();
         this.tempMC.removeChild(this.tempLoader);
         var itemNum:int = 1;
         BC.addEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.onBuySuccess);
         GV.itemID = 8;
         this.buyItem.buyItems(int(this.buyNum),itemNum);
      }
      
      public function visibleFalse(evt:MouseEvent) : void
      {
         evt.target.removeEventListener(MouseEvent.CLICK,this.visibleFalse);
         this.buyMach = 0;
         this.targetMC.mc_1.visible = false;
         this.targetMC.mc_no.visible = false;
      }
      
      public function onBuySuccess(evt:*) : void
      {
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuySuccess);
         this.buyMach = 0;
         this.targetMC.mc_3.visible = true;
         this.targetMC.mc_3.info.text = "購買成功！\r物品已放入你的百寶箱中";
         BC.addEvent(this,this.targetMC.mc_3.enter_btn,MouseEvent.CLICK,this.removeMC_3);
      }
      
      public function removeMC_3(evt:MouseEvent) : void
      {
         this.targetMC.mc_3.enter_btn.removeEventListener(MouseEvent.CLICK,this.removeMC_3);
         this.targetMC.mc_3.visible = false;
      }
      
      public function removeEvent(event:* = null) : void
      {
         var tempObj:MovieClip = this.targetMC.mc_3.parent;
         BC.removeEvent(this);
         try
         {
            this.targetMC.parent.parent.parent.parent.removeChild(this.targetMC.parent.parent.parent);
         }
         catch(E:*)
         {
         }
         GC.clearAllChildren(tempObj);
      }
      
      private function showFramebtn(event:MouseEvent) : void
      {
         var ID:uint = 0;
         if(this.nowFrame == 2)
         {
            ID = 12376;
         }
         else if(this.nowFrame == 9)
         {
            ID = 12385;
         }
         var tempInfo:* = GF.getPropData(ID);
         this.buyMach = tempInfo.price / this.halfPrice;
         this.buyNum = tempInfo.id;
         var buyName:* = tempInfo.name;
         if(LocalUserInfo.getYXQ() >= Number(this.buyMach))
         {
            this.targetMC.mc_1.visible = true;
            this.tempLoader.unload();
            this.tempLoader.load(VL.getURLRequest("resource/cloth/icon/" + this.buyNum + ".swf"));
            this.targetMC.mc_1.addChild(this.tempMC);
            this.tempMC.addChild(this.tempLoader);
            this.tempMC.scaleX = 1.8;
            this.tempMC.scaleY = 1.8;
            this.tempMC.x = 135;
            this.tempMC.y = 40;
            if(this.halfPrice == 1)
            {
               this.targetMC.mc_1.info.text = buyName + "需花費" + this.buyMach + "摩爾豆，你現在擁有" + LocalUserInfo.getYXQ().toString() + "摩爾豆，要確認購買嗎？";
            }
            else
            {
               this.targetMC.mc_1.info.htmlText = buyName + "需花費" + this.buyMach * this.halfPrice + "摩爾豆<font color=\'#ff0000\'>(今日半價:" + this.buyMach + "摩爾豆)</font>，要確認購買嗎？";
            }
            BC.addEvent(this,this.targetMC.mc_1.enter_btn,MouseEvent.CLICK,this.pageOneHandler);
            BC.addEvent(this,this.targetMC.mc_1.cancel_btn,MouseEvent.CLICK,this.visibleFalse);
         }
         else
         {
            this.targetMC.mc_no.visible = true;
            BC.addEvent(this,this.targetMC.mc_no.enter_btn,MouseEvent.CLICK,this.visibleFalse);
            this.targetMC.mc_no.info.text = "你的摩爾豆不夠囉......";
         }
      }
      
      public function sandFun(event:MouseEvent) : void
      {
         var myAle:* = undefined;
         if(!MainManager.getGameLevel().getChildByName("changAlert_sandUIMC"))
         {
            myAle = Alert.showAlert(MainManager.getGameLevel(),"","",Alert.CHANG_ALERT,"sandmsg",true,true,"sandUI");
            BC.addEvent(this,myAle,Alert.CLICK_ + "1",this.next);
         }
      }
      
      private function next(e:*) : void
      {
         var info:String = null;
         var myAle:* = undefined;
         var pp:sandMsgReq = new sandMsgReq();
         var msg:* = Alert.back_msg;
         var tit:* = Alert.back_tit;
         if(msg != "" && tit != "")
         {
            pp.sandFun(1012,tit,msg);
            BC.addEvent(this,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
         }
         else
         {
            info = "一定要填寫標題和內容才可以哦~";
            myAle = Alert.showAlert(MainManager.getGameLevel(),info,"",Alert.CHANG_ALERT,"sure",true,false,"F");
         }
      }
      
      private function showsandTit(e:*) : void
      {
         var myAle:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
         var info:String = "謝謝你的參與!";
         myAle = Alert.showAlert(MainManager.getGameLevel(),info,"",Alert.CHANG_ALERT,"sure",true,false,"F");
      }
   }
}

