package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.ballot.NpcBallotSocket;
   import com.logic.socket.getItemEveryDay.GetItemEveryDay;
   import com.logic.socket.gotBigProp.GotPropOnlyOneTime;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.module.activityModule.checkItem;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.dialog.TalkEvent;
   import com.module.query.QueryImpl;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ModuleType;
   import com.view.mapView.activity.mapActivity.ElaineCharityPartyActivity;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BusinessCenter extends MapBase
   {
      
      public function BusinessCenter()
      {
         super();
      }
      
      private function get target_mc() : MovieClip
      {
         return _mapLevel.controlLevel as MovieClip;
      }
      
      private function get depth_mc() : MovieClip
      {
         return _mapLevel.depthLevel as MovieClip;
      }
      
      private function get topMC() : MovieClip
      {
         return _mapLevel.topLevel as MovieClip;
      }
      
      private function get botton_mc() : MovieClip
      {
         return _mapLevel.buttonLevel as MovieClip;
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,this.target_mc.atm_btn,MouseEvent.CLICK,this.openATM);
         tip.tipTailDisPlayObject(this.target_mc.atm_btn,"R5S自動取款機");
         BC.addEvent(this,this.target_mc.ttq_btn,MouseEvent.CLICK,this.GameStarFun);
         tip.tipTailDisPlayObject(this.target_mc.ttq_btn,"進入摩摩彈珠台");
         BC.addEvent(this,TalkEvent,"shElaine_playGame",this.GameStarFun2);
         ElaineCharityPartyActivity.instance.Init(this.botton_mc["party_mc"]);
         BC.addEvent(this,this.botton_mc.charityBook_btn,MouseEvent.CLICK,this.OpenCharityBook);
         BC.addEvent(this,this.topMC.charityBook_btn,MouseEvent.CLICK,this.OpenCharityBook);
         tip.tipTailDisPlayObject(this.botton_mc.charityBook_btn,"打開慈善記事薄");
         tip.tipTailDisPlayObject(this.topMC.charityBook_btn,"打開慈善記事薄");
         BC.addEvent(this,this.botton_mc.rank_btn,MouseEvent.CLICK,this.onOpenCharityRank);
         BC.addEvent(this,this.botton_mc.donate_btn,MouseEvent.CLICK,this.onOpenCharityDonate);
         BC.addEvent(this,this.botton_mc.charityExchange_btn,MouseEvent.CLICK,this.onOpenCharityExchange);
      }
      
      private function openATM(e:MouseEvent) : void
      {
         ModuleManager.openPanel("BlankATMPanel");
      }
      
      override public function init() : void
      {
         super.init();
         this.checkHasGetGift();
      }
      
      private function onOpenCharityExchange(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.CHARITY_EXCHANGE_PANEL);
      }
      
      private function onOpenCharityRank(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.CHARITY_RANK_PANEL);
      }
      
      private function onOpenCharityDonate(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.CHARITY_DONATE_PANEL);
      }
      
      private function OpenCharityBook(e:MouseEvent) : void
      {
         new LoadGame("module/external/BooksUI/CharityPartyBook.swf","正在打開......",MainManager.getAppLevel());
      }
      
      private function GameStarFun(evt:MouseEvent) : void
      {
         QueryImpl.getInstance().QueryItem([190671],this.onGetItemCount);
      }
      
      private function onGetItemCount(itemCountList:Array) : void
      {
         if(itemCountList[0].count <= 0)
         {
            Alert.smileAlart("    你百寶箱中的拉姆彈珠數目不夠哦，獲取更多的拉姆彈珠之後再過來吧。",null,"iknow",115);
            return;
         }
         GameframeLogic.stopMousicHandler();
         MapManager.clearMap();
         new LoadGame("module/game/SSpringBallGame.swf","正在打開.....",MainManager.getGameLevel());
         BC.addEvent(this,GV.onlineSocket,"SBallGameOver",this.getScrollFun);
      }
      
      private function GameStarFun2(evt:*) : void
      {
         this.target_mc.ttq_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function getScrollFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"SBallGameOver",this.getScrollFun);
         var scroll:int = int(e.EventObj.total);
         if(Boolean(int(e.EventObj.ball > 0)))
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1118,this.getItemsFun);
            GetItemEveryDay.req_getItemEveryDay2(scroll,int(e.EventObj.ball));
         }
         GV.map_ManagerChange.refreshMap();
      }
      
      private function getItemsFun(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1118,this.getItemsFun);
         var id:int = int(e.EventObj.itemid);
         if(Boolean(id))
         {
            msg = "    恭喜你！得到了" + e.EventObj.itmeCount + "" + GoodsInfo.getInfoById(id).name + "，已經放到你的" + GoodsInfo.getItemCollectionBoxNameByID(id) + "中啦！";
            Alert.getIconByID_Alart(id,msg);
         }
      }
      
      private function checkHasGetGift() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 2008,this.onRead102008Suc);
         BC.addEvent(this,GV.onlineSocket,"read_" + 2008,this.onRead102008Fail);
         BC.addEvent(this,this.target_mc.didingGift_mc,MouseEvent.CLICK,this.getGiftFun);
         SystemEventManager.addEventListener("eliane_cvipTalk",this.cvipTalk3);
         SystemEventManager.addEventListener("eliane_getSHZ",this.onGetSHZ);
         NpcBallotSocket.NpcBallotReq();
      }
      
      private function onGetSHZ(e:Event) : void
      {
         oneBigStreetSocket.houseCertificate();
         GV.onlineSocket.addEventListener("read_" + 997,this.getSHZBack);
         GV.onlineSocket.addEventListener("ERROR_CMD_-100171",this.ErrorFun);
         GV.onlineSocket.addEventListener("ERROR_CMD_-100173",this.ErrorFun);
         GV.onlineSocket.addEventListener("ERROR_CMD_-10015",this.ErrorFun);
         GV.onlineSocket.addEventListener("ERROR_CMD_-11117",this.ErrorFun);
      }
      
      private function ErrorFun(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 997,this.getSHZBack);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-100171",this.ErrorFun);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-100173",this.ErrorFun);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-10015",this.ErrorFun);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-11117",this.ErrorFun);
         switch(e.type)
         {
            case "ERROR_CMD_-100171":
            case "ERROR_CMD_-100173":
               mapSay(4);
               break;
            case "ERROR_CMD_-10015":
               mapSay(5);
               break;
            case "ERROR_CMD_-11117":
               mapSay(7);
         }
      }
      
      private function getSHZBack(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 997,this.getSHZBack);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-100171",this.ErrorFun);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-100173",this.ErrorFun);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-10015",this.ErrorFun);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-11117",this.ErrorFun);
         Alert.getIconByID_Alart(190658,"    一個摩摩土地卡已經放到你的百寶箱中。");
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - 500);
         mapSay(6);
      }
      
      private function cvipTalk3(e:Event) : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.tuciSucHandler3);
         checkItem.checkItemHandler(190658);
      }
      
      private function tuciSucHandler3(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.tuciSucHandler3);
         if(evt.EventObj.num <= 0)
         {
            mapSay(1);
         }
         else
         {
            mapSay(5);
         }
      }
      
      private function onRead102008Suc(E:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2008,this.onRead102008Suc);
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2008,this.onRead102008Fail);
         if(!GF.getBitBool(int(E.EventObj.type),7))
         {
            this.target_mc.didingGift_mc.visible = true;
            BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.tuciSucHandler2);
            checkItem.checkItemHandler(190658);
         }
         else
         {
            this.target_mc.didingGift_mc.visible = false;
         }
      }
      
      private function tuciSucHandler2(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.tuciSucHandler2);
         if(evt.EventObj.num > 0)
         {
            if(LocalUserInfo.hasDining())
            {
               mapSay(2);
            }
            else
            {
               Alert.smileAlart("　  你還沒有開設餐廳呢，去建設署找湯米看看吧。");
            }
         }
      }
      
      private function onRead102008Fail(E:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2008,this.onRead102008Suc);
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2008,this.onRead102008Fail);
      }
      
      private function getGiftFun(E:*) : void
      {
         this.cvipTalk();
      }
      
      private function cvipTalk() : void
      {
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.tuciSucHandler);
         checkItem.checkItemHandler(190658);
      }
      
      private function tuciSucHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.tuciSucHandler);
         if(evt.EventObj.num <= 0)
         {
            Alert.smileAlart("    你還沒有摩摩土地卡哦，快去伊蓮那裡領取吧。");
         }
         else if(LocalUserInfo.hasDining())
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1994,this.getGiftSucFun);
            GotPropOnlyOneTime.getChosenNpcRequest(7);
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 5000);
            this.target_mc.dining_gift2_pan_mc.x = 0;
         }
         else
         {
            this.target_mc.dining_gift_pan_mc.x = 0;
         }
      }
      
      private function getGiftSucFun(E:EventTaomee) : void
      {
         this.target_mc.didingGift_mc.visible = false;
         BC.removeEvent(this,this.target_mc.didingGift_mc,MouseEvent.CLICK,this.getGiftFun);
      }
      
      override public function destroy() : void
      {
         GV.onlineSocket.removeEventListener("read_" + 997,this.getSHZBack);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-100171",this.ErrorFun);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-100173",this.ErrorFun);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-10015",this.ErrorFun);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-11117",this.ErrorFun);
         SystemEventManager.removeEventListener("eliane_cvipTalk",this.cvipTalk3);
         SystemEventManager.removeEventListener("eliane_getSHZ",this.onGetSHZ);
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.tuciSucHandler3);
         tip.delTipTailDisPlayObject(this.target_mc.atm_btn);
         BC.removeEvent(this);
         super.destroy();
      }
   }
}

